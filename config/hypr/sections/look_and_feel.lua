-- Refer to https://wiki.hypr.land/configuring/core/config-options/

local setupAnimations = function()
    -- Default curves and animations, see
    -- https://wiki.hypr.land/configuring/core/animations/
    hl.curve("easeOutQuint", {
        type = "bezier",
        points = { { 0.23, 1 }, { 0.32, 1 } }
    })

    hl.curve("easeInOutCubic", {
        type = "bezier",
        points = { { 0.65, 0.05 }, { 0.36, 1 } }
    })

    hl.curve("linear", {
        type = "bezier",
        points = { { 0, 0 }, { 1, 1 } }
    })

    hl.curve("almostLinear", {
        type = "bezier",
        points = { { 0.5, 0.5 }, { 0.75, 1 } }
    })

    hl.curve("quick", {
        type = "bezier",
        points = { { 0.15, 0 }, { 0.1, 1 } }
    })

    -- Default springs
    -- hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

    hl.animation({
        leaf = "global",
        enabled = true,
        speed = 10,
        bezier = "default"
    })

    hl.animation({
        leaf = "border",
        enabled = true,
        speed = 5.39,
        bezier = "easeOutQuint"
    })

    hl.animation({
        leaf = "windows",
        enabled = true,
        speed = 4.79,
        -- spring = "easy"
        bezier = "easeOutQuint"
    })

    hl.animation({
        leaf = "windowsIn",
        enabled = true,
        speed = 4.1,
        -- spring = "easy",
        bezier = "easeOutQuint",
        style = "popin 87%"
    })

    hl.animation({
        leaf = "windowsOut",
        enabled = true,
        speed = 1.49,
        bezier = "linear",
        style = "popin 87%"
    })

    hl.animation({
        leaf = "fadeIn",
        enabled = true,
        speed = 1.73,
        bezier = "almostLinear"
    })

    hl.animation({
        leaf = "fadeOut",
        enabled = true,
        speed = 1.46,
        bezier = "almostLinear"
    })

    hl.animation({
        leaf = "fade",
        enabled = true,
        speed = 3.03,
        bezier = "quick"
    })

    hl.animation({
        leaf = "layers",
        enabled = true,
        speed = 3.81,
        bezier = "easeOutQuint"
    })

    hl.animation({
        leaf = "layersIn",
        enabled = true,
        speed = 4,
        bezier = "easeOutQuint",
        style = "fade"
    })

    hl.animation({
        leaf = "layersOut",
        enabled = true,
        speed = 1.5,
        bezier = "linear",
        style = "fade"
    })

    hl.animation({
        leaf = "fadeLayersIn",
        enabled = true,
        speed = 1.79,
        bezier = "almostLinear"
    })

    hl.animation({
        leaf = "fadeLayersOut",
        enabled = true,
        speed = 1.39,
        bezier = "almostLinear"
    })

    hl.animation({
        leaf = "workspaces",
        enabled = true,
        speed = 1.94,
        bezier = "almostLinear",
        style = "fade"
    })

    hl.animation({
        leaf = "workspacesIn",
        enabled = true,
        speed = 1.21,
        bezier = "almostLinear",
        style = "fade"
    })

    hl.animation({
        leaf = "workspacesOut",
        enabled = true,
        speed = 1.94,
        bezier = "almostLinear",
        style = "fade"
    })

    hl.animation({
        leaf = "zoomFactor",
        enabled = true,
        speed = 7,
        bezier = "quick"
    })
end

local general = {
    -- Gaps between windows
    gaps_in = 2,
    -- Gaps between windows and monitor edges
    gaps_out = 0,
    border_size = 2,

    -- Border colors
    col = {
        -- For the active window
        active_border = {
            colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
            angle = 45
        },
        -- For the inactive window
        inactive_border = "rgba(595959aa)",
    },

    -- Set to true to enable resizing windows by clicking and dragging on
    -- borders and gaps
    resize_on_border = true,
    -- Show a cursor icon when hovering over borders (only used when
    -- general.resize_on_border is on)
    hover_icon_on_border = true,

    -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before
    -- you turn this on
    allow_tearing = false,

    -- Default layout
    layout = "master",

    -- Enable snapping for floating windows.
    snap = {
        enabled = true
    },
}

local decoration = {
    -- Rounded corner radius (px)
    rounding = 10,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 0.85,

    shadow = {
        enabled = true,
        range = 4,
        render_power = 3,
        color = "0xee1a1a1a",
    },

    blur = {
        enabled = false,
        size = 3,
        passes = 1,
        vibrancy = 0.1696,
    },
}

local animations = {
    enabled = true,
}

-- See https://wiki.hypr.land/configuring/core/config-options/#misc
local misc = {
    -- -- Set to 0 or 1 to disable the anime mascot wallpapers.
    -- -- -1 : random
    -- --  0 : hyprland logo
    -- --  1 : blue diamonds
    -- --  2 : anime girl
    -- force_default_wallpaper = 1

    -- Set to 0 or 1 to disable the anime mascot wallpapers.
    -- -1 : random
    --  0 : hyprland logo
    --  1 : blue diamonds
    --  2 : anime girl
    force_default_wallpaper = 1,

    -- I see no change in behavior
    -- animate_manual_resizes = true,
    -- animate_mouse_windowdragging = true,

    -- If true disables the random hyprland logo / anime girl background
    disable_hyprland_logo = false,

    -- Disable the splash rendering. The splash is a text that's rendered on top
    -- of the wallpaper, behind the windows.
    disable_splash_rendering = true,

    -- Don't reload this config when changed. To reload:
    -- $ hyprctl reload
    disable_autoreload = true,

    -- If DPMS is set to off, wake up the monitors if the mouse moves
    mouse_move_enables_dpms = true,

    -- If DPMS is set to off, wake up the monitors if a key is pressed
    key_press_enables_dpms = true,

    -- If there's a fullscreen (or maximized) window, decide whether a new tiled
    -- window should replace it, stay behind or disable the fullscreen
    -- on_focus_under_fullscreen = 2

    -- Whether closing a fullscreen window makes the next focused window
    -- fullscreen.
    exit_window_retains_fullscreen = 1,

    --animate_manual_resizes = true,
    --animate_mouse_windowdragging = true,
}

hl.config({
    general = general,
    decoration = decoration,
    animations = animations,
    misc = misc,
    -- See https://wiki.hypr.land/configuring/layouts/dwindle-layout
    dwindle = {
        -- You probably want this
        preserve_split = true,
    },
    -- See https://wiki.hypr.land/configuring/layouts/master-layout
    master = {
        -- Newly created windows are slave.
        new_status = "slave",
        -- Where to place new windows relative to the current one.
        new_on_active = "after",
        -- The size as a percentage of the master window
        mfact = 0.5,
    },
    -- See https://wiki.hypr.land/configuring/layouts/scrolling-layout/ for more
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

if animations.enabled
then
    setupAnimations()
end


-- Ref https://wiki.hypr.land/configuring/core/rules/workspace-rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
