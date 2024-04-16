//! Random number generator (RNG) using the Ascon CSPRNG

const std = @import("std");
const assert = std.debug.assert;
const Random = std.rand.Random;

pub const chip = @import("nrf52/registers.zig");
pub const regs = chip.registers;

/// Wrapper around the Ascon CSPRNG
///
/// The rng collects its entropy from the ROSC.
///
/// ## Usage
///
/// ```zig
/// var ascon = Ascon.init();
/// var rng = ascon.random();
/// ```
pub const Ascon = struct {
    state: std.rand.Ascon,

    const secret_seed_length = std.rand.Ascon.secret_seed_length;

    pub fn init() @This() {
        // We seed the RNG with random bits
        var b: [secret_seed_length]u8 = undefined;
        for (0..secret_seed_length) |index| {
            b[index] = randomByte();
        }

        return @This(){ .state = std.rand.Ascon.init(b) };
    }

    /// Returns a `std.rand.Random` structure backed by the current RNG
    pub fn random(self: *@This()) Random {
        return Random.init(self, fill);
    }

    /// Fills the buffer with random bytes
    pub fn fill(self: *@This(), buf: []u8) void {
        // fill the buffer with random bytes
        self.state.fill(buf);

        var b: [secret_seed_length]u8 = undefined;
        for (0..secret_seed_length) |index| {
            b[index] = randomByte();
        }
        self.state.addEntropy(&b);
    }
};

pub fn randomByte() u8 {
    regs.RNG.EVENTS_VALRDY.* = 0;
    regs.RNG.CONFIG.modify(.{ .DERCEN = 1 });
    regs.RNG.TASKS_START.* = 1;
    while (regs.RNG.EVENTS_VALRDY.* == 0) {
        // wait for new random number being generated
    }
    regs.RNG.TASKS_STOP.* = 1;
    return regs.RNG.VALUE.read();
}
