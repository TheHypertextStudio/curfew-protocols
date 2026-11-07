import { describe, expect, it } from 'vitest';
import { definitionValidator } from './schema-validator';

const occurrence = {
  occurrenceId: '018f4f45-4d34-7d98-a6c5-4de1bd63a21c',
  commitmentId: '018f4f45-7a98-7f53-89af-a4805f705d20',
  policyVersion: 1,
  startsAt: '2026-11-06T15:00:00Z',
  endsAt: '2026-11-07T07:00:00Z',
};

const result = {
  occurrenceId: occurrence.occurrenceId,
  conditionId: '018f4f45-7a98-7f53-89af-a4805f705d21',
  policyVersion: 1,
  status: 'pending',
  observedAt: '2026-11-06T16:00:00Z',
  expiresAt: '2026-11-06T16:05:00Z',
};

describe('commitment condition contract', () => {
  it('offers one bounded occurrence to selected devices without exposing app choices', async () => {
    const check = await definitionValidator('commitment.json', 'CommitmentDeviceOffer');
    const offer = {
      occurrence,
      title: 'Focused time',
      conditionId: result.conditionId,
      verifierDeviceId: '018f4f45-7a98-7f53-89af-a4805f705d23',
      targetDeviceIds: ['018f4f45-7a98-7f53-89af-a4805f705d24'],
      trigger: 'untilSatisfied',
      restrictWhenUnavailable: true,
    };
    expect(check(offer), JSON.stringify(check.errors)).toBe(true);
    expect(check({ ...offer, targetDeviceIds: [] })).toBe(false);
    expect(
      check({ ...offer, targetDeviceIds: [offer.targetDeviceIds[0], offer.targetDeviceIds[0]] }),
    ).toBe(false);
    expect(check({ ...offer, verifierDeviceId: undefined })).toBe(false);
    expect(check({ ...offer, trigger: 'blockAlways' })).toBe(false);
    expect(check({ ...offer, selectedApps: ['private.app'] })).toBe(false);
  });

  it('identifies each bounded occurrence independently of platform and provider', async () => {
    const check = await definitionValidator('commitment.json', 'CommitmentOccurrence');
    expect(check(occurrence), JSON.stringify(check.errors)).toBe(true);
    expect(check({ ...occurrence, endsAt: undefined })).toBe(false);
    expect(check({ ...occurrence, policyVersion: 0 })).toBe(false);
    expect(check({ ...occurrence, operatingSystem: 'android' })).toBe(false);
  });

  it('distinguishes satisfaction from unavailable evidence and rejects unbounded results', async () => {
    const check = await definitionValidator('commitment.json', 'CommitmentConditionResult');
    for (const status of ['pending', 'satisfied', 'unavailable']) {
      expect(check({ ...result, status }), JSON.stringify(check.errors)).toBe(true);
    }
    expect(check({ ...result, status: 'overridden' })).toBe(false);
    expect(check({ ...result, expiresAt: undefined })).toBe(false);
    expect(check({ ...result, occurrenceId: 'another-day' })).toBe(false);
    expect(check({ ...result, evidence: 'private workout data' })).toBe(false);
  });
});

describe('commitment exception and device reports', () => {
  it('records a bounded exception separately from a condition result', async () => {
    const check = await definitionValidator('commitment.json', 'CommitmentException');
    const exception = {
      exceptionId: '018f4f45-7a98-7f53-89af-a4805f705d22',
      occurrenceId: occurrence.occurrenceId,
      policyVersion: 1,
      reason: 'illness',
      startsAt: '2026-11-06T16:00:00Z',
      endsAt: '2026-11-06T17:00:00Z',
    };
    expect(check(exception), JSON.stringify(check.errors)).toBe(true);
    expect(check({ ...exception, reason: 'satisfied' })).toBe(false);
    expect(check({ ...exception, endsAt: undefined })).toBe(false);
    expect(check({ ...exception, privateDetails: 'diagnosis' })).toBe(false);
  });

  it("reports a device's bounded status without claiming account-wide enforcement", async () => {
    const check = await definitionValidator('commitment.json', 'CommitmentDeviceAcknowledgement');
    const acknowledgement = {
      occurrenceId: occurrence.occurrenceId,
      policyVersion: 1,
      deviceId: '018f4f45-7a98-7f53-89af-a4805f705d23',
      state: 'enforcing',
      observedAt: '2026-11-06T16:00:00Z',
      expiresAt: '2026-11-06T16:05:00Z',
    };
    for (const state of ['enforcing', 'notEnforcing', 'unavailable']) {
      expect(check({ ...acknowledgement, state }), JSON.stringify(check.errors)).toBe(true);
    }
    expect(check({ ...acknowledgement, state: 'complete' })).toBe(false);
    expect(check({ ...acknowledgement, deviceId: undefined })).toBe(false);
    expect(check({ ...acknowledgement, extra: true })).toBe(false);
  });
});
