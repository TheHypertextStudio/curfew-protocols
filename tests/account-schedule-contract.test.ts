import { describe, expect, it } from 'vitest';
import { definitionValidator, readSchema } from './schema-validator';

const timeDay = {
  isDayOff: false,
  lockTime: '22:00',
  unlockTime: '05:00',
  mode: 'time',
  hoursLimitMinutes: null,
  exception: null,
};

const schedule = {
  schemaVersion: 1,
  days: {
    monday: timeDay,
    tuesday: { ...timeDay, mode: 'hours', hoursLimitMinutes: 480 },
    wednesday: { ...timeDay, mode: 'combined', hoursLimitMinutes: 600 },
    thursday: { ...timeDay, mode: 'hours', hoursLimitMinutes: null },
    friday: { ...timeDay, mode: 'time', hoursLimitMinutes: 720 },
    saturday: { ...timeDay, isDayOff: true, exception: {} },
    sunday: timeDay,
  },
};

describe('account schedule payload', () => {
  it('defines a versioned weekly schedule that preserves all day-rule fields', async () => {
    const schema = await readSchema('schedule.json');
    expect(schema.definitions.AccountScheduleV1).toBeDefined();
    const validate = await definitionValidator('schedule.json', 'AccountScheduleV1');
    expect(validate(schedule), JSON.stringify(validate.errors)).toBe(true);
    const { hoursLimitMinutes: _limit, exception: _exception, ...omitted } = timeDay;
    expect(validate({ ...schedule, days: { ...schedule.days, monday: omitted } })).toBe(true);
  });

  it('rejects missing days, device state, malformed times and unsupported exceptions', async () => {
    const schema = await readSchema('schedule.json');
    expect(schema.definitions.AccountScheduleV1).toBeDefined();
    const validate = await definitionValidator('schedule.json', 'AccountScheduleV1');
    const { sunday: _sunday, ...sixDays } = schedule.days;
    expect(validate({ ...schedule, days: sixDays })).toBe(false);
    expect(validate({ ...schedule, deviceId: 'device' })).toBe(false);
    expect(validate({ ...schedule, schemaVersion: 2 })).toBe(false);
    expect(
      validate({
        ...schedule,
        days: { ...schedule.days, monday: { ...timeDay, lockTime: '24:00' } },
      }),
    ).toBe(false);
    expect(
      validate({
        ...schedule,
        days: { ...schedule.days, monday: { ...timeDay, hoursLimitMinutes: 0 } },
      }),
    ).toBe(false);
    expect(
      validate({
        ...schedule,
        days: { ...schedule.days, monday: { ...timeDay, exception: { label: 'Holiday' } } },
      }),
    ).toBe(false);
  });
});
