-- See https://wiki.hypr.land/configuring/core/monitors/

-- Quick help
-- ----------
--
-- To list all available monitors:
--   hyprctl monitors all
-- 

-- This will be the default rule for any monitor that does not match any specific rule.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- NOTE: I may want to bind workspaces 2,5,8 to the screen on the right.  See:
-- https://wiki.hypr.land/configuring/core/rules/workspace-rules/#rules
