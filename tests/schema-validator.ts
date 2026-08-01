import Ajv, { type ValidateFunction } from "ajv"
import addFormats from "ajv-formats"
import { readFile, readdir } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

export const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..")

export async function readSchema(name: string): Promise<Record<string, any>> {
  return JSON.parse(await readFile(join(repoRoot, "schemas", name), "utf8"))
}

export async function validator(name: string): Promise<ValidateFunction> {
  const ajv = new Ajv({ allErrors: true, strict: true })
  addFormats(ajv)
  const names = (await readdir(join(repoRoot, "schemas"))).filter((entry) =>
    entry.endsWith(".json"),
  )
  for (const entry of names) {
    ajv.addSchema(await readSchema(entry))
  }
  const target = await readSchema(name)
  return ajv.getSchema(target.$id) ?? ajv.compile(target)
}

export async function definitionValidator(
  name: string,
  definition: string,
): Promise<ValidateFunction> {
  const ajv = new Ajv({ allErrors: true, strict: true })
  addFormats(ajv)
  const names = (await readdir(join(repoRoot, "schemas"))).filter((entry) =>
    entry.endsWith(".json"),
  )
  for (const entry of names) {
    ajv.addSchema(await readSchema(entry))
  }
  const target = await readSchema(name)
  return ajv.compile({ $ref: `${target.$id}#/definitions/${definition}` })
}
