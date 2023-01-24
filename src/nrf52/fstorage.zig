const std = @import("std");
const NrfxError = @import("nrfx_error.zig").NrfxError;

extern fn nrfx_nvmc_flash_page_size_get() u32;
extern fn nrfx_nvmc_page_erase(addr: u32) NrfxError;
extern fn nrfx_nvmc_bytes_write(addr: u32, src: *const anyopaque, num_bytes: u32) void;

pub const Flash = struct {
    base_address: usize,
    PAGE_SIZE: usize = 4096,
    PAGE_START: usize = 0,
    PAGE_END: usize = 4,

    pub fn new(comptime addr: usize) @This() {
        if (@mod(addr, 4096) != 0) @compileError("Base address must be 32-bit aligned");

        return .{
            .base_address = addr,
        };
    }

    pub fn init(self: *@This()) void {
        self.PAGE_SIZE = @intCast(usize, nrfx_nvmc_flash_page_size_get());
    }

    pub fn read(self: *const @This(), data: []u8, offset: usize) !void {
        if (@mod(self.base_address + offset, 4) != 0) return error.Alignment;
        // TODO: add further bound checks

        const p = @intToPtr([*]u8, self.base_address + offset);
        std.mem.copy(u8, data[0..], p[0..data.len]);
    }

    /// Erase `len` pages starting from `page`.
    pub fn erase(self: *const @This(), page: usize, len: usize) !void {
        var i: usize = 0;
        while (i < len) : (i += 1) {
            const addr: u32 = @intCast(u32, self.base_address + ((page + i) * self.PAGE_SIZE));
            _ = nrfx_nvmc_page_erase(addr);
        }
    }

    pub fn write(self: *const @This(), offset: usize, data: []const u8) !void {
        const addr: u32 = @intCast(u32, self.base_address + offset);
        nrfx_nvmc_bytes_write(addr, @ptrCast(*const anyopaque, data.ptr), data.len);
    }
};
