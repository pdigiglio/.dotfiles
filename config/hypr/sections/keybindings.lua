-- require("my_programs")

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Take screenshots
local setScreenshotBindings = function()
    local xdg_config_home = os.getenv("XDG_CONFIG_HOME") or "~/.config"
    local screenshot_script = xdg_config_home .. "/hypr/take_screenshot.sh"
    local cmd = "sh " .. screenshot_script

    local setBindings = function()
        -- Hide help notification (and stay in the submode).
        hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(cmd .. " -x"))

        -- Select the area to screenshot and exit the submode.
        hl.bind(mainMod .. " + S",
            function()
                hl.dispatch(hl.dsp.exec_cmd(cmd .. " -s"))
                hl.dispatch(hl.dsp.submap("reset"))
            end)

        -- Take a screenshot of the active window and exit the submode.
        hl.bind(mainMod .. " + W",
            function()
                hl.dispatch(hl.dsp.exec_cmd(cmd .. " -w"))
                hl.dispatch(hl.dsp.submap("reset"))
            end)

        -- Hide help notification and exit the "screenshot" mode.
        hl.bind("escape",
            function()
                hl.dispatch(hl.dsp.exec_cmd(cmd .. " -x"))
                hl.dispatch(hl.dsp.submap("reset"))
            end)
    end

    local submap = "screenshot"
    hl.bind(mainMod .. " + P",
        function()
            -- Open a notification to remind the shortcuts.
            hl.dispatch(hl.dsp.exec_cmd(cmd .. " -n"))
            -- Enter the "screenshot" submode.
            hl.dispatch(hl.dsp.submap(submap))
        end)

    hl.define_submap(submap, setBindings)
end

local setMultimediaBindings = function()
    -- Multimedia keys (require playerctl)
    for key, func in pairs {
        XF86AudioNext = "next",
        XF86AudioPause = "play-pause",
        XF86AudioPlay = "play-pause",
        XF86AudioPrev = "previous"
    }
    do
        hl.bind(key, hl.dsp.exec_cmd("playerctl " .. func), { locked = true })
    end

    -- -- Laptop multimedia keys for volume and LCD brightness
    -- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
    -- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
    -- hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
    -- hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
    -- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
    -- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
end

-- code:61 is /
-- bind = $mainMod, code:61, exec, [float; center; size 800 600] kitty "$XDG_CONFIG_HOME/hypr/scripts/focus_window"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Shut hyprland down.  I use a lot of modifiers so that I don't do it by accident.
hl.bind(mainMod .. " + SHIFT + CTRL + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Maximize window (keep waybar visible)
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({
    action = "toggle",
    mode = "maximized",
}))

-- Make fullscreen (waybar not visible: window fills the whole screen space).
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({
    action = "toggle",
    mode = "fullscreen",
}))

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Workspace bindings
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0

    -- Switch workspaces with mainMod + [0-9]
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- The keys below are inspired by Vim
for key, dir in pairs { h = "left", j = "down", k = "up", l = "right" } do
    local bindFocus = function()
        local keybind = mainMod .. " + " .. key
        hl.bind(keybind, hl.dsp.focus({ direction = dir }))
    end

    -- Move focus
    bindFocus()
    local bindMove = function()
        local keybind = mainMod .. " + CTRL + " .. key
        hl.bind(keybind, hl.dsp.window.move({ direction = dir }))
    end

    -- Move windows around
    bindMove()

    local bindChangeMasterLayoutOrientation = function()
        local orientations = {
            left  = "orientationleft",
            down  = "orientationbottom",
            up    = "orientationtop",
            right = "orientationright"
        }

        -- Only works for "master" layout
        local keybind = mainMod .. " + SHIFT + " .. key
        hl.bind(keybind, hl.dsp.layout(orientations[dir]))
    end

    -- Change layout orientation
    bindChangeMasterLayoutOrientation()
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize windows (master layout only)
for key, val in pairs {
    ["SHIFT + code:21"] = "+0.1", -- plus (somehow, I need SHIFT)
    ["code:20"] = "-0.1",         -- minus
    ["code:21"] = "exact 0.5"     -- equals
}
do
    local keybind = mainMod .. " + " .. key
    hl.bind(keybind, hl.dsp.layout("mfact " .. val))
end

setMultimediaBindings()
setScreenshotBindings()

-- See: https://flarexes.com/hyprland-getting-started-configure-screen-lock-brightness-volume-authentication-and-more
-- bind = $mainMod, Z, exec, hyprlock
--
-- --bind = $mainMod, E, exec, $fileManager
-- -- bind = $mainMod, P, pseudo, -- dwindle
-- -- bind = $mainMod SHIFT, J, togglesplit, -- dwindle
--
--
-- -- Example special workspace (scratchpad)
-- bind = $mainMod, S, togglespecialworkspace, magic
-- bind = $mainMod SHIFT, S, movetoworkspace, special:magic
--
--
-- -- NOTE: These are present on Alienware m16 R1 AMD but don't work (I checked
-- -- with `wev`). See also: https://bbs.archlinux.org/viewtopic.php?id=291375
-- --
--

-- -- Example binds, see https://wiki.hypr.land/configuring/core/binds/ for more
-- hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- -- closeWindowBind:set_enabled(false)
-- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
--
-- -- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
