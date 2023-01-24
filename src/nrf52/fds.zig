pub const RetCode = enum(u32) {
    NRF_SUCCESS = 0,
    NRF_ERROR_SVC_HANDLER_MISSING = 1,
    NRF_ERROR_SOFTDEVICE_NOT_ENABLED = 2,
    NRF_ERROR_INTERNAL = 3,
    NRF_ERROR_NO_MEM = 4,
    NRF_ERROR_NOT_FOUND = 5,
    NRF_ERROR_NOT_SUPPORTED = 6,
    NRF_ERROR_INVALID_PARAM = 7,
    NRF_ERROR_INVALID_STATE = 8,
    NRF_ERROR_INVALID_LENGTH = 9,
    NRF_ERROR_INVALID_FLAGS = 10,
    NRF_ERROR_INVALID_DATA = 11,
    NRF_ERROR_DATA_SIZE = 12,
    NRF_ERROR_TIMEOUT = 13,
    NRF_ERROR_NULL = 14,
    NRF_ERROR_FORBIDDEN = 15,
    NRF_ERROR_INVALID_ADDR = 16,
    NRF_ERROR_BUSY = 17,
};

pub const ret_code_t = u32;

pub const FdsEvtId = enum(c_uint) {
    FDS_EVT_INIT,
    FDS_EVT_WRITE,
    FDS_EVT_UPDATE,
    FDS_EVT_DEL_RECORD,
    FDS_EVT_DEL_FILE,
    FDS_EVT_GC,
};

pub const fds_evt_id_t = c_uint;

/// An FDS event.
pub const fds_evt_t = extern struct {
    id: fds_evt_id_t,
    result: ret_code_t,
    unnamed_0: extern union {
        write: extern struct {
            record_id: u32,
            file_id: u16,
            record_key: u16,
            is_record_updated: bool,
        },
        del: extern struct {
            record_id: u32,
            file_id: u16,
            record_key: u16,
        },
    },
};

/// FDS event handler function prototype.
///
/// p_evt       The event.
pub const fds_cb_t = *const fn (p_evt: *const fds_evt_t) void;

pub extern fn fds_register(cb: fds_cb_t) ret_code_t;

/// Function for initializing the FDS module.
///
/// This function initializes the module and installs the file system (unless it is installed
/// already).
///
/// This function is asynchronous. Completion is reported through the @ref FDS_EVT_INIT event.
/// Make sure to call @ref fds_register before calling @ref fds_init so that you receive
/// FDS_EVT_INIT.
///
/// NRF_SUCCESS         If the operation was queued successfully.
/// FDS_ERR_NO_PAGES    If there is no space available in flash memory to install the file system.
pub extern fn fds_init() ret_code_t;
