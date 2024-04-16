const std = @import("std");
/// Zig version. When writing code that supports multiple versions of Zig, prefer
/// feature detection (i.e. with `@hasDecl` or `@hasField`) over version checks.
pub const zig_version = std.SemanticVersion.parse(zig_version_string) catch unreachable;
pub const zig_version_string = "0.11.0";
pub const zig_backend = std.builtin.CompilerBackend.stage2_llvm;

pub const output_mode = std.builtin.OutputMode.Lib;
pub const link_mode = std.builtin.LinkMode.Static;
pub const is_test = false;
pub const single_threaded = false;
pub const abi = std.Target.Abi.eabihf;
pub const cpu: std.Target.Cpu = .{
    .arch = .thumb,
    .model = &std.Target.arm.cpu.cortex_m4,
    .features = std.Target.arm.featureSet(&[_]std.Target.arm.Feature{
        .db,
        .dsp,
        .fp16,
        .fpregs,
        .has_v4t,
        .has_v5t,
        .has_v5te,
        .has_v6,
        .has_v6k,
        .has_v6m,
        .has_v6t2,
        .has_v7,
        .has_v7clrex,
        .has_v8m,
        .hwdiv,
        .loop_align,
        .mclass,
        .no_branch_predictor,
        .noarm,
        .slowfpvfmx,
        .slowfpvmlx,
        .thumb2,
        .thumb_mode,
        .use_misched,
        .v7em,
        .vfp2sp,
        .vfp3d16sp,
        .vfp4d16sp,
    }),
};
pub const os = std.Target.Os{
    .tag = .freestanding,
    .version_range = .{ .none = {} },
};
pub const target = std.Target{
    .cpu = cpu,
    .os = os,
    .abi = abi,
    .ofmt = object_format,
};
pub const object_format = std.Target.ObjectFormat.elf;
pub const mode = std.builtin.Mode.ReleaseSmall;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = false;
pub const valgrind_support = false;
pub const sanitize_thread = false;
pub const position_independent_code = false;
pub const position_independent_executable = false;
pub const strip_debug_info = true;
pub const code_model = std.builtin.CodeModel.default;
pub const omit_frame_pointer = true;
