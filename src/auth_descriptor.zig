const fido = @import("fido");
const nrf = @import("nrf52/nrf52.zig");
const flash = @import("atsame51j20a/flash_storage.zig");

const User = fido.User;
const RelyingParty = fido.RelyingParty;

pub fn init() void {
    //enableTrng();
    //flash_storage.init(); // without init the next command will stall the app
    //auth.initData();
}

pub fn enableTrng() void {
    // Enable the TRNG bus clock.
    //regs.MCLK.APBCMASK.modify(.{ .TRNG_ = 1 });
}

const data_len: usize = fido.data_len;
const base_addr: usize = 524288; // 512 KiB
pub var flash_storage = flash.Flash.new(base_addr, data_len);

pub const Impl = struct {
    // TODO: data to be stored in flash (securely)
    // MASTER_SECRET || PIN || SIGN_COUNTER || RETRIES

    pub fn rand() u32 {
        var x: u32 = @intCast(u32, nrf.getRandom());
        x |= @intCast(u32, nrf.getRandom()) << 8;
        x |= @intCast(u32, nrf.getRandom()) << 16;
        x |= @intCast(u32, nrf.getRandom()) << 24;
        return x;
    }

    pub fn load() [data_len]u8 {
        //var x: [data_len]u8 = undefined;
        //flash_storage.read(x[0..]);
        //return x;
        return "\xF1\x11\x25\xdc\xed\x00\x72\x95\xa2\x98\x63\x68\x2d\x7b\x1c\xc3\x83\x58\x38\xcf\x7a\x19\x62\xe0\x90\x5a\x36\xb2\xed\xa6\x07\x3e\xe1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00".*;
    }

    pub fn store(data: [data_len]u8) void {
        _ = data;
        //flash_storage.erase();
        //flash_storage.write(data[0..]);
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

var versions = [_]fido.Versions{fido.Versions.FIDO_2_0};
const Authenticator = fido.Auth(Impl);

pub const auth = Authenticator.initDefault(&versions, [_]u8{ 0xFA, 0x2B, 0x99, 0xDC, 0x9E, 0x39, 0x42, 0x57, 0x8F, 0x92, 0x4A, 0x30, 0xD2, 0x3C, 0x41, 0x18 });
