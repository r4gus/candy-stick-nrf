const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const keylib_dep = b.dependency("keylib", .{
        .target = target,
        .optimize = optimize,
    });

    const obj = b.addStaticLibrary(.{
        .name = "candy-stick",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    obj.addModule("keylib", keylib_dep.module("keylib"));
    obj.addModule("zbor", keylib_dep.module("zbor"));

    b.installArtifact(obj);
}
