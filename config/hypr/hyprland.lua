-- This is Hyprland Lua config file.  Refer to the wiki for more information:
-- https://wiki.hypr.land/configuring/

-- If you want to reload the configuration after changing any config file:
--
--  $ hyprctl reload
--

-- You may also want to install:
--  * dunst
--  * waybar
--  * uwsm (unversal wayland session manager)
--  * ssdm / ly (a session manager)

------------------
---- MONITORS ----
------------------

require("sections.monitors")


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
-- NOTE: these are not local because I want them to be available everywhere.
terminal    = "kitty"
fileManager = "dolphin"
menu        = "wofi --show drun"
-- menu        = "hyprlauncher"


-------------------
---- AUTOSTART ----
-------------------

require("sections.autostart")


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

require("sections.environment_variables")


-----------------------
----- PERMISSIONS -----
-----------------------

require("sections.permissions")


-----------------------
---- LOOK AND FEEL ----
-----------------------

require("sections.look_and_feel")


----------------
---- LAYERS ----
----------------

-- hl.config({
--     layers = {
--         allow_new_top_layers_over_existing_fullscreen = true, -- Set to false to make newly mapped top layers render below existing covering fullscreen window
--     },
-- })


---------------
---- INPUT ----
---------------

require("sections.input")

---------------------
---- KEYBINDINGS ----
---------------------

require("sections.keybindings")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

require("sections.windows_and_workspaces")
