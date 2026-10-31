-- See https://wiki.hypr.land/configuring/core/autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    -- Notification daemon
    hl.exec_cmd("dunst")

    -- Bar
    hl.exec_cmd("waybar")

    hl.exec_cmd("kitty --session session.conf", { workspace = "1 silent" })
    hl.exec_cmd("chromium", { workspace = "6 silent" })
    hl.exec_cmd("qutebrowser", { workspace = "5 silent" })

    -- Background
    -- exec-once = hyprpaper
    --
    -- exec-once = nm-applet &
    -- exec-once = waybar & hyprpaper & firefox

    -- hl.exec_cmd(terminal)
    -- hl.exec_cmd("nm-applet")
    -- hl.exec_cmd("waybar & hyprpaper & firefox")
end)
