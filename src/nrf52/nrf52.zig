pub const chip = @import("registers.zig");
pub const regs = chip.registers;

pub const fstorage = @import("fstorage.zig");

pub fn getRandom() u8 {
    regs.RNG.EVENTS_VALRDY.* = 0;
    regs.RNG.CONFIG.modify(.{ .DERCEN = 1 });
    regs.RNG.TASKS_START.* = 1;
    while (regs.RNG.EVENTS_VALRDY.* == 0) {
        // wait for new random number being generated
    }
    regs.RNG.TASKS_STOP.* = 1;
    return regs.RNG.VALUE.read();
}
