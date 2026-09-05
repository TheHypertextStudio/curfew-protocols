import Ajv, { type ValidateFunction } from "ajv"
import addFormats from "ajv-formats"
import { readFile, readdir } from "node:fs/promises"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"
import { addCurfewProtocolKeywords } from "../generated/typescript/validation.js"

export const repoRoot = join(dirname(fileURLToPath(import.meta.url)), "..")

export async function readSchema(name: string): Promise<Record<string, any>> {
  return JSON.parse(await readFile(join(repoRoot, "schemas", name), "utf8"))
}

export async function validator(name: string): Promise<ValidateFunction> {
  const ajv = curfewAjv()
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
  const ajv = curfewAjv()
  const names = (await readdir(join(repoRoot, "schemas"))).filter((entry) =>
    entry.endsWith(".json"),
  )
  for (const entry of names) {
    ajv.addSchema(await readSchema(entry))
  }
  const target = await readSchema(name)
  return ajv.compile({ $ref: `${target.$id}#/definitions/${definition}` })
}

export async function mcpToolOutputValidator(
  toolName: string,
): Promise<ValidateFunction> {
  const registry = await readSchema("mcp-tools.json")
  const remoteTools = (registry.const as { remoteTools?: unknown }).remoteTools
  if (!Array.isArray(remoteTools)) {
    throw new Error("MCP tool registry has no remoteTools array")
  }
  const tool = remoteTools.find(
    (candidate): candidate is { name: string; outputSchema: unknown } =>
      typeof candidate === "object" &&
      candidate !== null &&
      (candidate as { name?: unknown }).name === toolName &&
      "outputSchema" in candidate,
  )
  if (tool === undefined) throw new Error(`Unknown remote MCP tool: ${toolName}`)

  const ajv = curfewAjv()
  const names = (await readdir(join(repoRoot, "schemas"))).filter((entry) =>
    entry.endsWith(".json"),
  )
  for (const entry of names) {
    ajv.addSchema(await readSchema(entry))
  }
  return ajv.compile(structuredClone(tool.outputSchema as Record<string, unknown>))
}

export async function mcpToolInputValidator(
  toolName: string,
): Promise<ValidateFunction> {
  const registry = await readSchema("mcp-tools.json")
  const remoteTools = (registry.const as { remoteTools?: unknown }).remoteTools
  if (!Array.isArray(remoteTools)) {
    throw new Error("MCP tool registry has no remoteTools array")
  }
  const tool = remoteTools.find(
    (candidate): candidate is { name: string; inputSchema: unknown } =>
      typeof candidate === "object" &&
      candidate !== null &&
      (candidate as { name?: unknown }).name === toolName &&
      "inputSchema" in candidate,
  )
  if (tool === undefined) throw new Error(`Unknown remote MCP tool: ${toolName}`)

  return curfewAjv().compile(
    structuredClone(tool.inputSchema as Record<string, unknown>),
  )
}

function curfewAjv(): Ajv {
  const ajv = new Ajv({ allErrors: true, strict: true })
  addFormats(ajv)
  return addCurfewProtocolKeywords(ajv)
}
