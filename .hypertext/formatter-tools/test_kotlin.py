import shutil
import subprocess
import runpy
import sys
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("kotlin.py")
ROOT = SCRIPT.resolve().parents[2]


class KotlinPathTests(unittest.TestCase):
    def test_non_utf8_jvm_stdout_preserves_unicode_source(self):
        native = runpy.run_path(str(SCRIPT))
        source = 'val message = "café"\n'.encode("utf-8")
        with tempfile.TemporaryDirectory() as directory:
            bridge = Path(directory) / "KtlintStdin.java"
            bridge.write_text(native["KTLINT_STDIN"], encoding="utf-8")
            command = native["java_command"]()[:2] + [
                "-Dstdout.encoding=US-ASCII",
                "-Dsun.stdout.encoding=US-ASCII",
                "--class-path",
                str(native["JAR"]),
                str(bridge),
                str(SCRIPT.resolve().parents[2] / "sample.gradle.kts"),
            ]
            result = subprocess.run(command, input=source, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr.decode())
        self.assertEqual(result.stdout, source)

    def test_literal_percent_and_modulo_preserve_bytes(self):
        command = [sys.executable, str(SCRIPT), "ktlint", "sample.gradle.kts"]
        source = b'val pattern = "%m %% %s %n"\nval remainder = 7 % 3\n'
        result = subprocess.run(command, input=source, capture_output=True)
        self.assertEqual(result.returncode, 0, result.stderr.decode())
        self.assertEqual(result.stdout, source)

    def test_root_gradle_script_formats_without_reading_or_writing_source(self):
        original = (ROOT / "build.gradle.kts").read_bytes()
        with tempfile.TemporaryDirectory() as folder:
            result = subprocess.run(
                [sys.executable, str(SCRIPT), "ktlint", "build.gradle.kts"],
                input=original,
                cwd=folder,
                capture_output=True,
            )
        self.assertEqual(result.returncode, 0, result.stderr.decode())
        self.assertEqual((ROOT / "build.gradle.kts").read_bytes(), original)
        again = subprocess.run(
            [sys.executable, str(SCRIPT), "ktlint", "build.gradle.kts"],
            input=result.stdout,
            capture_output=True,
        )
        self.assertEqual(again.returncode, 0, again.stderr.decode())
        self.assertEqual(again.stdout, result.stdout)

    def test_syntax_failure_keeps_actual_source_unchanged(self):
        path = ROOT / "build.gradle.kts"
        original = path.read_bytes()
        result = subprocess.run(
            [sys.executable, str(SCRIPT), "ktlint", "build.gradle.kts"],
            input=b"fun broken( {",
            capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(path.read_bytes(), original)

    def test_native_editorconfig_discovery_controls_indentation(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / ".editorconfig").write_text(
                "root = true\n[*.{kt,kts}]\nindent_size = 2\nktlint_code_style = intellij_idea\n"
            )
            helper = root / ".hypertext/formatter-tools/kotlin.py"
            helper.parent.mkdir(parents=True)
            shutil.copyfile(SCRIPT, helper)
            (root / "src").mkdir()
            result = subprocess.run(
                [sys.executable, str(helper), "ktlint", "src/Sample.kt"],
                cwd=root.parent,
                input=b"fun main() {\nprintln(1)\n}\n",
                capture_output=True,
            )
            self.assertEqual(result.returncode, 0, result.stderr.decode())
            self.assertIn(b"\n  println(1)\n", result.stdout)


if __name__ == "__main__":
    unittest.main()
