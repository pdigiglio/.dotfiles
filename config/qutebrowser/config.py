#!/usr/bin/env python3

#
# Configuration file for qutebrowser.
#


def set_config_py_opts():
    c.auto_save.session = True

    # I keep hitting "co" by mistake. Unbind it and explicity use :tab-only if
    # and when I need it. (Which is rare).
    config.unbind('co')


def set_opts():
    # Set low-priority custom options.
    set_config_py_opts()

    # Customization via UI (:set, :bind and :unbind) is stored in autoconfig.yml.
    # If config.py exists, autoconfig.yml is not loaded automatically. Load it here
    # to override the settings in set_config_py_opts:
    config.load_autoconfig()


set_opts()
