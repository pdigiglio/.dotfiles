import os
from pathlib import Path

from lldb import SBDebugger


def source_if_exists(debugger: SBDebugger, file_path: Path) -> None:
    """Import a lldbinit file if it exists.  This is useful to insert hooks in a main lldbfile.

       Parameters
       ----------
       debugger : SBDebugger
            The debugger instance.

       file_path : Path
            The file to try and load.
    """

    if not file_path.is_file():
        # print(f"Cannot import: '{file_path}'. No such file.")
        return

    # TODO: import 'source' or 'script import' based on file name or extension
    cmd: str = f"command source '{file_path}'"
    print(f"Executing: {cmd}")
    debugger.HandleCommand(cmd)


def __lldb_init_module(debugger: SBDebugger, internal_dict: dict) -> None:
    config_home: Path = Path(os.getenv("XDG_CONFIG_HOME", "~/.config"))
    source_if_exists(debugger, config_home / "lldb" / "private" / "lldbinit")
