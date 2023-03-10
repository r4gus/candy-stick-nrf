const std = @import("std");
const fido = @import("fido");
const nrf = @import("nrf52/nrf52.zig");

const User = fido.data.User;
const RelyingParty = fido.data.RelyingParty;

pub var auth: ?fido.Authenticator = null;

pub fn init() void {
    flash_storage.init();

    auth = fido.Authenticator.new_default(
        [_]u8{
            0xFA,
            0x2B,
            0x99,
            0xDC,
            0x9E,
            0x39,
            0x42,
            0x57,
            0x8F,
            0x92,
            0x4A,
            0x30,
            0xD2,
            0x3C,
            0x41,
            0x18,
        },
        .{
            .rand = Impl.rand,
            .millis = Impl.millis,
            .load = Impl.load,
            .store = Impl.store,
            .request_permission = Impl.requestPermission,
        },
    );
}

const data_len: usize = fido.data_len;
const base_addr: usize = 524288; // 512 KiB
pub var flash_storage = nrf.fstorage.Flash.new(base_addr);

extern fn board_millis() u32;

pub const Impl = struct {
    // TODO: data to be stored in flash (securely)
    // MASTER_SECRET || PIN || SIGN_COUNTER || RETRIES

    pub fn rand(d: []u8) void {
        var j: usize = 0;
        while (j < d.len) : (j += 1) {
            d[j] = nrf.getRandom();
        }
    }

    pub fn millis() u32 {
        return board_millis();
    }

    pub fn load(allocator: std.mem.Allocator) []u8 {
        var len_raw: [4]u8 = undefined;
        flash_storage.read(len_raw[0..], 0) catch unreachable;
        var len = @intCast(usize, std.mem.readIntSliceLittle(u32, len_raw[0..]));

        var x = allocator.alloc(u8, len) catch unreachable;
        flash_storage.read(x[0..], 4) catch unreachable;
        return x;
    }

    pub fn store(data: []const u8) void {
        flash_storage.erase(0, 1) catch {};
        flash_storage.write(0, data[0..]) catch {};
    }

    pub fn requestPermission(user: ?*const User, rp: ?*const RelyingParty) bool {
        _ = user;
        _ = rp;

        //var i: usize = 0;
        //while (i < 10000000) : (i += 1) {
        //    @import("std").mem.doNotOptimizeAway(i);
        //}
        return true;
    }
};
