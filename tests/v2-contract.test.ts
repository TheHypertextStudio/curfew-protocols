import { readFile, readdir } from "node:fs/promises"
import { join } from "node:path"
import {
  createCipheriv,
  createECDH,
  createHash,
  createHmac,
  createPublicKey,
  hkdfSync,
  verify,
} from "node:crypto"
import { describe, expect, it } from "vitest"
import {
  definitionValidator,
  readSchema,
  repoRoot,
} from "./schema-validator"

const ids = {
  alarm: "018f4f45-4d34-7d98-a6c5-4de1bd63a21c",
  campaign: "018f4f45-7a98-7f53-89af-a4805f705d20",
  device: "018f4f45-a055-7502-8b0c-7276bfe16c8f",
  template: "018f4f45-badc-71ef-bd8e-87cb745aac4d",
  callback: "018f4f45-cafe-7f00-9a82-e47805fb4d34",
}

const fixedRelease = {
  kind: "fixed_unlock",
  timeZone: "America/Los_Angeles",
  localUnlockTime: "07:00",
  dstResolution: {
    gap: "first_valid_instant",
    overlap: "first_occurrence",
  },
}

const wakeRelease = {
  kind: "wake_campaign",
  campaignTemplateId: ids.template,
  timeZone: "America/Los_Angeles",
  localStartTime: "07:00",
  dstResolution: {
    gap: "first_valid_instant",
    overlap: "first_occurrence",
  },
}

const defaultAlarmConfiguration = {
  ringDurationSeconds: 120,
  quietIntervalSeconds: 60,
  selectedDeviceIds: [ids.device],
}

describe("Curfew protocol v2 release authority", () => {
  it("publishes the complete v2 schema surface", async () => {
    const entries = await readdir(join(repoRoot, "schemas"))

    expect(entries).toEqual(
      expect.arrayContaining([
        "account.json",
        "alarm.json",
        "callback.json",
        "e2ee.json",
        "schedule.json",
      ]),
    )
  })

  it("makes fixed unlock and wake campaign mutually exclusive", async () => {
    const validate = await definitionValidator("schedule.json", "ReleasePolicy")

    expect(validate(fixedRelease), JSON.stringify(validate.errors)).toBe(true)
    expect(validate(wakeRelease), JSON.stringify(validate.errors)).toBe(true)
    expect(
      validate({
        ...fixedRelease,
        campaignTemplateId: ids.template,
        localStartTime: "07:00",
      }),
    ).toBe(false)
  })

  it("encodes Curfew's executable anti-bypass timing without contradictory prose", async () => {
    const validate = await definitionValidator(
      "schedule.json",
      "ScheduleChangeApplicationPolicy",
    )

    expect(
      validate({
        strictness: "strengthening",
        applyAt: "next_local_midnight",
        mustNotApplyDuringActiveLockout: false,
      }),
      JSON.stringify(validate.errors),
    ).toBe(true)
    expect(
      validate({
        strictness: "weakening",
        applyAt: "after_24_hours",
        mustNotApplyDuringActiveLockout: true,
      }),
      JSON.stringify(validate.errors),
    ).toBe(true)
    expect(
      validate({
        strictness: "weakening",
        applyAt: "next_local_midnight",
        mustNotApplyDuringActiveLockout: false,
      }),
    ).toBe(false)

    const schema = await readSchema("schedule.json")
    expect(schema.description).toContain(
      "Stricter changes apply at the next local midnight",
    )
    expect(schema.description).toContain(
      "weaker changes wait 24 hours and cannot apply during an active lockout",
    )
  })
})

describe("alarms and wake campaigns", () => {
  it("models a no-deadline campaign that can end only by verified release or override", async () => {
    const configuration = await definitionValidator(
      "alarm.json",
      "AlarmConfiguration",
    )
    const campaign = await definitionValidator("alarm.json", "WakeCampaign")
    const outcome = await definitionValidator("alarm.json", "WakeOutcome")

    expect(
      configuration({
        ringDurationSeconds: 120,
        quietIntervalSeconds: 60,
        selectedDeviceIds: [ids.device],
      }),
      JSON.stringify(configuration.errors),
    ).toBe(true)
    expect(
      configuration({
        maximumAttempts: 3,
        ringDurationSeconds: 120,
        quietIntervalSeconds: 60,
        campaignDurationSeconds: 960,
        selectedDeviceIds: [ids.device],
      }),
    ).toBe(false)
    expect(
      campaign({
        campaignId: ids.campaign,
        alarmId: ids.alarm,
        timeZone: "America/Los_Angeles",
        scheduledAt: "2026-03-08T15:00:00Z",
        state: "ringing_attempt",
        attemptNumber: 25,
        selectedDeviceIds: [ids.device],
        recordVersion: 1,
        writerCounter: 1,
      }),
      JSON.stringify(campaign.errors),
    ).toBe(true)
    expect(
      campaign({
        campaignId: ids.campaign,
        alarmId: ids.alarm,
        timeZone: "America/Los_Angeles",
        scheduledAt: "2026-03-08T15:00:00Z",
        finalDeadlineAt: "2026-03-08T15:16:00Z",
        state: "exhausted",
        attemptNumber: 3,
        selectedDeviceIds: [ids.device],
        recordVersion: 1,
        writerCounter: 1,
      }),
    ).toBe(false)
    expect(
      outcome({
        campaignId: ids.campaign,
        result: "exhausted",
        releasedAt: "2026-03-08T15:16:00Z",
      }),
    ).toBe(false)
  })

  it("declares the no-deadline two-minute ringing and one-minute quiet defaults", async () => {
    const schema = await readSchema("alarm.json")
    const properties = schema.definitions.AlarmConfiguration.properties

    expect(properties.ringDurationSeconds.default).toBe(120)
    expect(properties.quietIntervalSeconds.default).toBe(60)
    expect(properties.maximumAttempts).toBeUndefined()
    expect(properties.campaignDurationSeconds).toBeUndefined()

    const validate = await definitionValidator(
      "alarm.json",
      "AlarmConfiguration",
    )
    expect(
      validate(defaultAlarmConfiguration),
      JSON.stringify(validate.errors),
    ).toBe(true)
    expect(
      validate({
        ...defaultAlarmConfiguration,
        ringDurationSeconds: 29,
      }),
    ).toBe(false)
  })

  it("represents recurrence, selected devices, persisted attempts, and terminal outcomes", async () => {
    const alarm = await readSchema("alarm.json")
    expect(alarm.definitions).toEqual(
      expect.objectContaining({
        AlarmDefinition: expect.any(Object),
        AlarmRecurrence: expect.any(Object),
        WakeCampaign: expect.any(Object),
        WakeAttempt: expect.any(Object),
        WakeOutcome: expect.any(Object),
      }),
    )

    const validate = await definitionValidator("alarm.json", "WakeCampaign")
    expect(
      validate({
        campaignId: ids.campaign,
        alarmId: ids.alarm,
        timeZone: "America/Los_Angeles",
        scheduledAt: "2026-03-08T15:00:00Z",
        state: "ringing_attempt",
        attemptNumber: 1,
        selectedDeviceIds: [ids.device],
        recordVersion: 1,
        writerCounter: 1,
      }),
      JSON.stringify(validate.errors),
    ).toBe(true)
  })
})

describe("generic callback conditions", () => {
  it("requires HTTPS and the bounded polling defaults", async () => {
    const schema = await readSchema("callback.json")
    const callback = schema.definitions.CallbackDefinition
    const poll = schema.definitions.CallbackPollPolicy.properties

    expect(callback.properties.endpoint.pattern).toBe("^https://")
    expect(poll.intervalSeconds.default).toBe(15)
    expect(poll.requestTimeoutSeconds.default).toBe(5)
    expect(poll.maximumBackoffSeconds.maximum).toBe(60)

    const validate = await definitionValidator(
      "callback.json",
      "CallbackDefinition",
    )
    const valid = {
      callbackId: ids.callback,
      displayLabel: "Start working",
      endpoint: "https://callback.example.test/condition",
      secret: "A".repeat(43),
      pollPolicy: {
        intervalSeconds: 15,
        requestTimeoutSeconds: 5,
        maximumBackoffSeconds: 60,
      },
      actionUrl: "https://work.example.test/today",
    }
    expect(validate(valid), JSON.stringify(validate.errors)).toBe(true)
    expect(validate({ ...valid, endpoint: "http://127.0.0.1/condition" })).toBe(
      false,
    )
  })

  it("binds challenges and receipts to campaign and nonce with separate MAC purposes", async () => {
    const schema = await readSchema("callback.json")
    expect(schema.definitions.CallbackChallenge.required).toEqual(
      expect.arrayContaining([
        "campaignId",
        "campaignStartedAt",
        "nonce",
        "challengedAt",
        "expiresAt",
        "mac",
      ]),
    )
    expect(schema.definitions.CallbackReceipt.required).toEqual(
      expect.arrayContaining([
        "campaignId",
        "nonce",
        "status",
        "observedAt",
        "expiresAt",
        "mac",
      ]),
    )
    expect(schema.definitions.CallbackChallenge.description).toContain(
      "curfew-callback-request-v1",
    )
    expect(schema.definitions.CallbackReceipt.description).toContain(
      "curfew-callback-response-v1",
    )
  })
})

describe("E2EE account synchronization", () => {
  it("uses versioned AES-256-GCM records signed by monotonic device writers", async () => {
    const schema = await readSchema("e2ee.json")
    const record = schema.definitions.EncryptedRecord

    expect(record.properties.cipherSuite.const).toBe("AES-256-GCM")
    expect(record.required).toEqual(
      expect.arrayContaining([
        "version",
        "writerDeviceId",
        "writerCounter",
        "keyEpoch",
        "nonce",
        "ciphertext",
        "signature",
      ]),
    )

    const validateConflict = await definitionValidator(
      "e2ee.json",
      "EncryptedRecordConflict",
    )
    expect(
      validateConflict({
        recordId: ids.alarm,
        attemptedVersion: 1,
        currentVersion: 2,
        attemptedWriterCounter: 4,
        currentWriterCounter: 5,
      }),
      JSON.stringify(validateConflict.errors),
    ).toBe(true)
  })

  it("defines HPKE device envelopes, recovery wrapping, enrollment, and revocation", async () => {
    const e2ee = await readSchema("e2ee.json")
    const account = await readSchema("account.json")
    const deviceSession = await readSchema("device-session.json")

    expect(e2ee.definitions.RootKeyEnvelope.properties.kem.const).toBe(
      "DHKEM(P-256,HKDF-SHA256)",
    )
    expect(e2ee.definitions.RecoveryKeyEnvelope.description).toContain(
      "Curfew Recovery Key",
    )
    expect(account.definitions).toEqual(
      expect.objectContaining({
        AccountDeviceEnrollment: expect.any(Object),
        DeviceRevocation: expect.any(Object),
        Entitlement: expect.any(Object),
        AuditRecord: expect.any(Object),
      }),
    )
    expect(account.definitions.EnrollmentRootKeyEnvelope).toBeUndefined()
    expect(
      account.definitions.AccountDeviceEnrollment.properties.displayName,
    ).toBeUndefined()
    expect(
      account.definitions.AccountDeviceEnrollment.properties.rootKeyEnvelope,
    ).toBeUndefined()
    const authorizationEnrollment =
      deviceSession.definitions.DeviceEnrollmentRequest
    expect(authorizationEnrollment.required).toEqual(
      expect.arrayContaining([
        "deviceId",
        "encryptionPublicKeyJwk",
        "signingPublicKeyJwk",
        "keyEpoch",
        "enrolledAt",
      ]),
    )
    expect(authorizationEnrollment.properties.displayName).toBeUndefined()
    expect(authorizationEnrollment.properties.platform).toBeUndefined()
    expect(authorizationEnrollment.properties.appVersion).toBeUndefined()
    expect(authorizationEnrollment.properties.devicePublicKeyJwk).toBeUndefined()
    expect(deviceSession.description).toContain("top-level deviceProof member is omitted")
    expect(deviceSession.definitions.DeviceProofClaims.properties.bodyDigest.description).toContain(
      "RFC 8785 JCS",
    )
  })

  it("pins canonical encrypted-record, HPKE, and recovery wrapping inputs", async () => {
    const e2ee = await readSchema("e2ee.json")
    const record = e2ee.definitions.EncryptedRecord
    const rootEnvelope = e2ee.definitions.RootKeyEnvelope
    const recoveryEnvelope = e2ee.definitions.RecoveryKeyEnvelope

    expect(record.required).toContain("signatureAlgorithm")
    expect(record.properties.signatureAlgorithm.const).toBe(
      "ES256-P1363-SHA256",
    )
    expect(record.description).toContain("RFC 8785 JCS")
    expect(record.description).toContain("r || s")
    expect(rootEnvelope.description).toContain("curfew-root-key-envelope-v2")
    expect(rootEnvelope.description).toContain("RFC 9180")
    expect(recoveryEnvelope.description).toContain("curfew-recovery-wrap-v2")
    expect(recoveryEnvelope.description).toContain("RFC 8785 JCS")
  })

  it("publishes minimal wake/device status and bounded direct-unlock authorization", async () => {
    const account = await readSchema("account.json")
    expect(account.definitions).toEqual(
      expect.objectContaining({
        WakeStatus: expect.any(Object),
        DeviceStatus: expect.any(Object),
        DirectUnlockAuthorization: expect.any(Object),
      }),
    )

    const validate = await definitionValidator(
      "account.json",
      "DirectUnlockAuthorization",
    )
    const authorization = {
      authorizationId: ids.callback,
      oauthClientId: "cello-personal-adapter",
      targetDeviceIds: [ids.device],
      maximumOverrideMinutes: 15,
      validitySeconds: 86400,
      grantedAt: "2026-08-10T19:00:00Z",
      status: "active",
    }
    expect(validate(authorization), JSON.stringify(validate.errors)).toBe(true)
    expect(validate({ ...authorization, maximumOverrideMinutes: 61 })).toBe(false)
    expect(validate({ ...authorization, validitySeconds: 2592001 })).toBe(false)
  })

  it("requires a protocol capability when an account enrolls a device", async () => {
    const validate = await definitionValidator(
      "account.json",
      "AccountDeviceEnrollment",
    )
    const enrollment = {
      deviceId: ids.device,
      encryptionPublicKeyJwk: {
        crv: "P-256",
        kty: "EC",
        x: "A".repeat(43),
        y: "B".repeat(43),
      },
      signingPublicKeyJwk: {
        crv: "P-256",
        kty: "EC",
        x: "C".repeat(43),
        y: "D".repeat(43),
      },
      keyEpoch: 1,
      enrolledAt: "2026-08-10T19:00:00Z",
      protocolVersion: "0.3",
    }

    expect(validate(enrollment), JSON.stringify(validate.errors)).toBe(true)
    expect(validate({ ...enrollment, protocolVersion: undefined })).toBe(false)

    const request = await definitionValidator(
      "device-session.json",
      "DeviceEnrollmentRequest",
    )
    const enrollmentRequest = {
      deviceId: ids.device,
      encryptionPublicKeyJwk: enrollment.encryptionPublicKeyJwk,
      signingPublicKeyJwk: enrollment.signingPublicKeyJwk,
      keyEpoch: 1,
      enrolledAt: "2026-08-10T19:00:00Z",
      protocolVersion: "0.3",
      pkceChallenge: "A".repeat(43),
      state: "B".repeat(43),
      coordinatorNonce: "C".repeat(43),
      deviceProof: { compactJws: `A.B.${"C".repeat(86)}` },
      remoteControlEnabled: false,
    }
    expect(
      request(enrollmentRequest),
      JSON.stringify(request.errors),
    ).toBe(true)
    expect(request({ ...enrollmentRequest, protocolVersion: undefined })).toBe(false)
  })

  it("bounds every remote override to 5 through 60 minutes", async () => {
    const validate = await definitionValidator(
      "account.json",
      "RemoteOverrideRequest",
    )
    const base = {
      requestId: ids.campaign,
      targetDeviceIds: [ids.device],
      reason: "Urgent access needed for an incident",
      durationMinutes: 5,
      requestedAt: "2026-08-10T19:00:00Z",
      approvalMode: "approval_required",
    }

    expect(validate(base), JSON.stringify(validate.errors)).toBe(true)
    expect(validate({ ...base, durationMinutes: 4 })).toBe(false)
    expect(validate({ ...base, durationMinutes: 61 })).toBe(false)

    const validateApplied = await definitionValidator(
      "account.json",
      "RemoteOverride",
    )
    const applied = {
      overrideId: ids.callback,
      requestId: ids.campaign,
      targetDeviceIds: [ids.device],
      reason: "Urgent access needed for an incident",
      durationMinutes: 5,
      startsAt: "2026-08-10T19:00:00Z",
      authorizedBy: "mcp_user_approval",
      status: "active",
    }
    expect(validateApplied(applied), JSON.stringify(validateApplied.errors)).toBe(
      true,
    )
    expect(validateApplied({ ...applied, durationMinutes: 61 })).toBe(false)
  })
})

describe("cross-language golden vectors", () => {
  it("pins DST gap and overlap resolution without deriving a wake release deadline", async () => {
    const vectors = JSON.parse(
      await readFile(join(repoRoot, "tests", "vectors", "v2-golden.json"), "utf8"),
    ) as {
      timeResolution?: Array<
        | {
            id: string
            kind: "local_time"
            timeZone: string
            localDateTime: string
            expectedInstant: string
          }
      >
    }
    expect(vectors.timeResolution?.map((entry) => entry.id)).toEqual([
      "dst-gap-first-valid-instant",
      "dst-overlap-first-occurrence",
    ])

    for (const vector of vectors.timeResolution ?? []) {
      const actual = resolveLocalTime(vector.localDateTime, vector.timeZone)
      expect(actual, vector.id).toBe(vector.expectedInstant)
    }
  })

  it("validates the shared valid/invalid v2 corpus through the schemas", async () => {
    const vectors = JSON.parse(
      await readFile(join(repoRoot, "tests", "vectors", "v2-golden.json"), "utf8"),
    ) as {
      cases: Array<{
        id: string
        schema: string
        definition: string
        valid: boolean
        payload: unknown
      }>
    }

    expect(vectors.cases.length).toBeGreaterThanOrEqual(12)
    expect(vectors.cases.map((entry) => entry.id)).toEqual(
      expect.arrayContaining([
        "legacy-schedule-migration",
        "release-policy-mutual-exclusion",
        "stale-writer-version",
        "malformed-callback",
        "callback-replay",
        "dst-gap",
        "dst-overlap",
        "remote-override-too-short",
        "remote-override-too-long",
      ]),
    )

    for (const entry of vectors.cases) {
      const validate = await definitionValidator(entry.schema, entry.definition)
      expect(
        validate(entry.payload),
        `${entry.id}: ${JSON.stringify(validate.errors)}`,
      ).toBe(entry.valid)
    }
  }, 30_000)

  it("fails closed for deterministic unknown-field mutations of valid vectors", async () => {
    const vectors = JSON.parse(
      await readFile(join(repoRoot, "tests", "vectors", "v2-golden.json"), "utf8"),
    ) as {
      cases: Array<{
        id: string
        schema: string
        definition: string
        valid: boolean
        payload: Record<string, unknown>
      }>
    }

    for (const entry of vectors.cases.filter((candidate) => candidate.valid)) {
      const validate = await definitionValidator(entry.schema, entry.definition)
      const mutated = structuredClone(entry.payload)
      mutated.__unknownFuzzField = `mutation-${entry.id}`
      expect(
        validate(mutated),
        `${entry.id} accepted an unknown top-level mutation`,
      ).toBe(false)
    }
  }, 30_000)

  it("pins callback canonical bytes, derived purpose keys, and HMAC outputs", async () => {
    const vectors = JSON.parse(
      await readFile(join(repoRoot, "tests", "vectors", "v2-golden.json"), "utf8"),
    ) as {
      cryptography?: {
        secret: string
        callbackId: string
        challengeUnsigned: Record<string, unknown>
        challengeCanonical: string
        requestKey: string
        challengeMac: string
        receiptUnsigned: Record<string, unknown>
        receiptCanonical: string
        responseKey: string
        receiptMac: string
      }
    }
    expect(vectors.cryptography).toBeDefined()
    const vector = vectors.cryptography!
    const secret = Buffer.from(vector.secret, "base64url")
    const salt = Buffer.from(vector.callbackId, "utf8")
    const derive = (purpose: string) =>
      Buffer.from(hkdfSync("sha256", secret, salt, Buffer.from(purpose), 32))
    const requestKey = derive("curfew-callback-request-v1")
    const responseKey = derive("curfew-callback-response-v1")

    expect(canonicalJSON(vector.challengeUnsigned)).toBe(vector.challengeCanonical)
    expect(requestKey.toString("base64url")).toBe(vector.requestKey)
    expect(
      createHmac("sha256", requestKey)
        .update(Buffer.from(vector.challengeCanonical, "utf8"))
        .digest("base64url"),
    ).toBe(vector.challengeMac)
    expect(canonicalJSON(vector.receiptUnsigned)).toBe(vector.receiptCanonical)
    expect(responseKey.toString("base64url")).toBe(vector.responseKey)
    expect(
      createHmac("sha256", responseKey)
        .update(Buffer.from(vector.receiptCanonical, "utf8"))
        .digest("base64url"),
    ).toBe(vector.receiptMac)
    expect(vector.requestKey).not.toBe(vector.responseKey)
  })

  it("pins the canonical remote-command result digest", async () => {
    const vectors = JSON.parse(
      await readFile(join(repoRoot, "tests", "vectors", "v2-golden.json"), "utf8"),
    ) as {
      cryptography?: {
        remoteCommandResult?: {
          resultUnsigned: Record<string, unknown>
          resultCanonical: string
          resultDigest: string
        }
      }
    }
    const vector = vectors.cryptography?.remoteCommandResult
    expect(vector).toBeDefined()
    expect(canonicalJSON(vector!.resultUnsigned)).toBe(vector!.resultCanonical)
    expect(
      createHash("sha256")
        .update(Buffer.from(vector!.resultCanonical, "utf8"))
        .digest("base64url"),
    ).toBe(vector!.resultDigest)
  })

  it("pins encrypted-record, HPKE, and recovery cryptographic bytes", async () => {
    const vectors = JSON.parse(
      await readFile(join(repoRoot, "tests", "vectors", "v2-golden.json"), "utf8"),
    ) as {
      cryptography?: {
        encryptedRecord?: Record<string, any>
        hpkeEnvelope?: Record<string, any>
        recoveryEnvelope?: Record<string, any>
      }
    }

    expect(vectors.cryptography?.encryptedRecord).toEqual(
      expect.objectContaining({
        aadCanonical: expect.any(String),
        signatureCanonical: expect.any(String),
        signature: expect.stringMatching(/^[A-Za-z0-9_-]{86}$/),
      }),
    )
    expect(vectors.cryptography?.hpkeEnvelope).toEqual(
      expect.objectContaining({
        info: "curfew-root-key-envelope-v2",
        aadCanonical: expect.any(String),
        ciphertext: expect.any(String),
      }),
    )
    expect(vectors.cryptography?.recoveryEnvelope).toEqual(
      expect.objectContaining({
        info: "curfew-recovery-wrap-v2",
        aadCanonical: expect.any(String),
        ciphertext: expect.any(String),
      }),
    )

    const record = vectors.cryptography!.encryptedRecord!
    const rootKey = Buffer.from(record.rootKey, "base64url")
    const namespaceKey = Buffer.from(
      hkdfSync(
        "sha256",
        rootKey,
        Buffer.from(record.namespaceKeySalt, "utf8"),
        Buffer.from(record.namespaceKeyInfo, "utf8"),
        32,
      ),
    )
    expect(namespaceKey.toString("base64url")).toBe(record.namespaceKey)
    expect(canonicalJSON(record.aadUnsigned)).toBe(record.aadCanonical)
    expect(
      createHash("sha256")
        .update(Buffer.from(record.aadCanonical, "utf8"))
        .digest("base64url"),
    ).toBe(record.aadDigest)
    expect(
      aesGcmSeal(
        namespaceKey,
        Buffer.from(record.nonce, "base64url"),
        Buffer.from(record.aadCanonical, "utf8"),
        Buffer.from(record.plaintextCanonical, "utf8"),
      ).toString("base64url"),
    ).toBe(record.ciphertext)
    expect(canonicalJSON(record.signatureUnsigned)).toBe(record.signatureCanonical)
    const publicKey = createPublicKey({
      key: record.signingPublicKeyJwk,
      format: "jwk",
    })
    const signature = Buffer.from(record.signature, "base64url")
    expect(
      verify(
        "sha256",
        Buffer.from(record.signatureCanonical, "utf8"),
        { key: publicKey, dsaEncoding: "ieee-p1363" },
        signature,
      ),
    ).toBe(true)
    const p256Order = BigInt(
      "0xffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc632551",
    )
    expect(BigInt(`0x${signature.subarray(32).toString("hex")}`)).toBeLessThanOrEqual(
      p256Order / 2n,
    )

    const hpke = vectors.cryptography!.hpkeEnvelope!
    const hpkeResult = hpkeSealVector(
      Buffer.from(hpke.recipientPrivateKey, "base64url"),
      Buffer.from(hpke.ephemeralPrivateKey, "base64url"),
      Buffer.from(hpke.info, "utf8"),
      Buffer.from(hpke.aadCanonical, "utf8"),
      rootKey,
    )
    expect(canonicalJSON(hpke.aadUnsigned)).toBe(hpke.aadCanonical)
    expect(hpkeResult.recipientPublicKey.toString("base64url")).toBe(
      hpke.recipientPublicKey,
    )
    expect(hpkeResult.encapsulatedKey.toString("base64url")).toBe(
      hpke.encapsulatedKey,
    )
    expect(hpkeResult.sharedSecret.toString("base64url")).toBe(hpke.sharedSecret)
    expect(hpkeResult.key.toString("base64url")).toBe(hpke.key)
    expect(hpkeResult.baseNonce.toString("base64url")).toBe(hpke.baseNonce)
    expect(hpkeResult.ciphertext.toString("base64url")).toBe(hpke.ciphertext)

    const recovery = vectors.cryptography!.recoveryEnvelope!
    const wrappingKey = Buffer.from(
      hkdfSync(
        "sha256",
        Buffer.from(recovery.recoveryKey, "base64url"),
        Buffer.from(recovery.salt, "base64url"),
        Buffer.from(recovery.info, "utf8"),
        32,
      ),
    )
    expect(canonicalJSON(recovery.aadUnsigned)).toBe(recovery.aadCanonical)
    expect(wrappingKey.toString("base64url")).toBe(recovery.wrappingKey)
    expect(
      aesGcmSeal(
        wrappingKey,
        Buffer.from(recovery.nonce, "base64url"),
        Buffer.from(recovery.aadCanonical, "utf8"),
        rootKey,
      ).toString("base64url"),
    ).toBe(recovery.ciphertext)
  })
})

function canonicalJSON(value: unknown): string {
  if (Array.isArray(value)) return `[${value.map(canonicalJSON).join(",")}]`
  if (value !== null && typeof value === "object") {
    return `{${Object.entries(value as Record<string, unknown>)
      .sort(([left], [right]) => (left < right ? -1 : left > right ? 1 : 0))
      .map(([key, child]) => `${JSON.stringify(key)}:${canonicalJSON(child)}`)
      .join(",")}}`
  }
  return JSON.stringify(value)
}

function aesGcmSeal(
  key: Buffer,
  nonce: Buffer,
  aad: Buffer,
  plaintext: Buffer,
): Buffer {
  const cipher = createCipheriv("aes-256-gcm", key, nonce)
  cipher.setAAD(aad)
  return Buffer.concat([cipher.update(plaintext), cipher.final(), cipher.getAuthTag()])
}

function hpkeSealVector(
  recipientPrivateKey: Buffer,
  ephemeralPrivateKey: Buffer,
  info: Buffer,
  aad: Buffer,
  plaintext: Buffer,
): {
  recipientPublicKey: Buffer
  encapsulatedKey: Buffer
  sharedSecret: Buffer
  key: Buffer
  baseNonce: Buffer
  ciphertext: Buffer
} {
  const kemSuite = Buffer.concat([Buffer.from("KEM"), i2osp(0x10, 2)])
  const hpkeSuite = Buffer.concat([
    Buffer.from("HPKE"),
    i2osp(0x10, 2),
    i2osp(0x01, 2),
    i2osp(0x02, 2),
  ])
  const recipient = createECDH("prime256v1")
  recipient.setPrivateKey(recipientPrivateKey)
  const recipientPublicKey = recipient.getPublicKey(undefined, "uncompressed")
  const ephemeral = createECDH("prime256v1")
  ephemeral.setPrivateKey(ephemeralPrivateKey)
  const encapsulatedKey = ephemeral.getPublicKey(undefined, "uncompressed")
  const dh = ephemeral.computeSecret(recipientPublicKey)
  const eaePrk = labeledExtract(kemSuite, Buffer.alloc(0), "eae_prk", dh)
  const sharedSecret = labeledExpand(
    kemSuite,
    eaePrk,
    "shared_secret",
    Buffer.concat([encapsulatedKey, recipientPublicKey]),
    32,
  )
  const pskIdHash = labeledExtract(
    hpkeSuite,
    Buffer.alloc(0),
    "psk_id_hash",
    Buffer.alloc(0),
  )
  const infoHash = labeledExtract(
    hpkeSuite,
    Buffer.alloc(0),
    "info_hash",
    info,
  )
  const context = Buffer.concat([Buffer.from([0]), pskIdHash, infoHash])
  const secret = labeledExtract(
    hpkeSuite,
    sharedSecret,
    "secret",
    Buffer.alloc(0),
  )
  const key = labeledExpand(hpkeSuite, secret, "key", context, 32)
  const baseNonce = labeledExpand(hpkeSuite, secret, "base_nonce", context, 12)
  return {
    recipientPublicKey,
    encapsulatedKey,
    sharedSecret,
    key,
    baseNonce,
    ciphertext: aesGcmSeal(key, baseNonce, aad, plaintext),
  }
}

function labeledExtract(
  suite: Buffer,
  salt: Buffer,
  label: string,
  ikm: Buffer,
): Buffer {
  return hkdfExtract(
    salt,
    Buffer.concat([Buffer.from("HPKE-v1"), suite, Buffer.from(label), ikm]),
  )
}

function labeledExpand(
  suite: Buffer,
  pseudorandomKey: Buffer,
  label: string,
  info: Buffer,
  length: number,
): Buffer {
  return hkdfExpand(
    pseudorandomKey,
    Buffer.concat([
      i2osp(length, 2),
      Buffer.from("HPKE-v1"),
      suite,
      Buffer.from(label),
      info,
    ]),
    length,
  )
}

function hkdfExtract(salt: Buffer, ikm: Buffer): Buffer {
  return createHmac("sha256", salt.length === 0 ? Buffer.alloc(32) : salt)
    .update(ikm)
    .digest()
}

function hkdfExpand(
  pseudorandomKey: Buffer,
  info: Buffer,
  length: number,
): Buffer {
  let output = Buffer.alloc(0)
  let previous = Buffer.alloc(0)
  for (let counter = 1; output.length < length; counter += 1) {
    previous = createHmac("sha256", pseudorandomKey)
      .update(Buffer.concat([previous, info, Buffer.from([counter])]))
      .digest()
    output = Buffer.concat([output, previous])
  }
  return output.subarray(0, length)
}

function i2osp(value: number, length: number): Buffer {
  const output = Buffer.alloc(length)
  output.writeUIntBE(value, 0, length)
  return output
}

function resolveLocalTime(localDateTime: string, timeZone: string): string {
  const formatter = new Intl.DateTimeFormat("en-CA-u-ca-gregory-nu-latn", {
    timeZone,
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hourCycle: "h23",
  })
  const target = localDateTime.replace(/[-:T]/g, "")
  const approximate = Date.parse(`${localDateTime}Z`)
  const candidates: Array<{ instant: number; local: string }> = []
  for (
    let instant = approximate - 16 * 60 * 60 * 1000;
    instant <= approximate + 16 * 60 * 60 * 1000;
    instant += 60 * 1000
  ) {
    const parts = Object.fromEntries(
      formatter
        .formatToParts(new Date(instant))
        .filter((part) => part.type !== "literal")
        .map((part) => [part.type, part.value]),
    )
    const local = `${parts.year}${parts.month}${parts.day}${parts.hour}${parts.minute}${parts.second}`
    if (local === target) {
      return new Date(instant).toISOString().replace(".000Z", "Z")
    }
    if (local > target && local.slice(0, 8) === target.slice(0, 8)) {
      candidates.push({ instant, local })
    }
  }
  candidates.sort((left, right) =>
    left.local === right.local
      ? left.instant - right.instant
      : left.local < right.local
        ? -1
        : 1,
  )
  const firstValid = candidates[0]
  if (firstValid === undefined) throw new Error(`Unable to resolve ${localDateTime}`)
  return new Date(firstValid.instant).toISOString().replace(".000Z", "Z")
}
