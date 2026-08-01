using System.Text.Json;
using System.Text.Json.Serialization;

var options = new JsonSerializerOptions
{
    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    PropertyNameCaseInsensitive = false,
    UnmappedMemberHandling = JsonUnmappedMemberHandling.Disallow,
};

var fixturePath = Path.GetFullPath(
    Path.Combine(AppContext.BaseDirectory, "../../../../fixtures/remote-command.json")
);
var command = JsonSerializer.Deserialize<RemoteLockCommand>(
    File.ReadAllText(fixturePath),
    options
) ?? throw new InvalidOperationException("remote command fixture decoded to null");

if (command.Kind != "lock_device" || command.Sequence != 42)
{
    throw new InvalidOperationException("remote command semantics changed");
}
if (command.DeadlinePolicy.Kind != "fixed_duration" || command.DeadlinePolicy.DurationSeconds != 1800)
{
    throw new InvalidOperationException("deadline policy did not survive .NET decoding");
}

const string windowsDevice = """
{
  "deviceId":"018f4f45-7a98-7f53-89af-a4805f705d20",
  "displayName":"Office PC",
  "platform":"windows",
  "appVersion":"1.0.0",
  "capabilities":["durable_lock","status","tpm_key"],
  "remoteLockEligible":true,
  "allDevicesEligible":true
}
""";
var device = JsonSerializer.Deserialize<DeviceDescriptor>(windowsDevice, options)
    ?? throw new InvalidOperationException("Windows descriptor decoded to null");
if (device.Platform != "windows" || !device.Capabilities.Contains("tpm_key"))
{
    throw new InvalidOperationException("unknown platform or capability was not retained");
}

Console.WriteLine("Curfew protocol fixtures decode on .NET");

internal sealed record RemoteLockCommand(
    string CommandId,
    string IdempotencyKey,
    string UserId,
    string DeviceId,
    long Sequence,
    string Kind,
    RemoteDeadlinePolicy DeadlinePolicy,
    DateTimeOffset IssuedAt,
    DateTimeOffset ExpiresAt,
    string Nonce,
    string CoordinatorAudience,
    long StatusVersion,
    string ScheduleDigest
);

internal sealed record RemoteDeadlinePolicy(string Kind, long? DurationSeconds);

internal sealed record DeviceDescriptor(
    string DeviceId,
    string DisplayName,
    string Platform,
    string AppVersion,
    IReadOnlyList<string> Capabilities,
    bool RemoteLockEligible,
    bool AllDevicesEligible
);
