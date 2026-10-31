-- See https://wiki.hypr.land/configuring/core/environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Selects Electron's preferred platform backend used on Linux. Options:
--  * auto (selects Wayland if possible, X11 otherwise)
--  * wayland
--  * x11 [default]
--
-- Note: this was removed in Electron 39
-- https://github.com/electron/electron/issues/48001
--
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
