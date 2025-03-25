#!/usr/bin/env python3

#
# Configuration file for qutebrowser.
#
# Reload with 
#  :config-source
#
# Generate a default template with (it will try and override this file: make
# sure you have a backup before using --force):
#  :config-write-py --defaults
#

# TODO:
#  
#  * Check if file picker installed, otherwise use default.
#  * Check if mpv installed, otherwise display a message on ',v' and ',a'
#  * Fetch login data from `pass`
#

leader = ','
terminal = 'kitty'
editor   = 'nvim'
editor_command     = [terminal, editor, '-f', '{file}', '-c', 'normal {line}G{column0}l']
single_file_picker = [terminal, 'yazi', '--chooser-file', '{}']
multi_file_picker  = single_file_picker


def set_bindingd():
    # I keep hitting "co" by mistake. Unbind it and explicity use :tab-only if
    # and when I need it. (Which is rare).
    config.unbind('co')

    # Play a video with mpv.
    # See also:  https://www.reddit.com/r/archlinux/comments/5m2os3/mpv_is_it_possible_to_change_video_quality_while
    mpv_video = 'mpv --ytdl-format="bestvideo[ext=mp4][height<=?1080]+bestaudio[ext=m4a]"'
    config.bind(f'{leader}v', f'spawn {mpv_video} {{url}}')
    config.bind(f';v', f'hint links spawn --detach {mpv_video} {{hint-url}}')

    # Play audio-only with mpv. 
    # You can also force a window with `--force-window`
    mpv_audio = 'kitty mpv --ytdl-format="bestaudio"'
    config.bind(f'{leader}a', f'spawn {mpv_audio} {{url}}')
    config.bind(f';a', f'hint links spawn --detach {mpv_audio} {{hint-url}}')


def set_config_py_opts():
    set_bindingd()

    c.auto_save.session = True

    # Require a confirmation before quitting the application.
    # Type: ConfirmQuit
    # Valid values:
    #   - always: Always show a confirmation.
    #   - multiple-tabs: Show a confirmation if multiple tabs are opened.
    #   - downloads: Show a confirmation if downloads are running
    #   - never: Never show a confirmation.
    c.confirm_quit = ['downloads']

    # Automatically start playing `<video>` elements.
    # Type: Bool
    c.content.autoplay = False

    # Display PDF files via PDF.js in the browser without showing a download
    # prompt. Note that the files can still be downloaded by clicking the
    # download button in the pdf.js viewer. With this set to `false`, the
    # `:prompt-open-download --pdfjs` command (bound to `<Ctrl-p>` by
    # default) can be used in the download prompt.
    # Type: Bool
    c.content.pdfjs = True

    # Editor (and arguments) to use for the `edit-*` commands. The following
    # placeholders are defined:  * `{file}`: Filename of the file to be
    # edited. * `{line}`: Line in which the caret is found in the text. *
    # `{column}`: Column in which the caret is found in the text. *
    # `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
    # Same as `{column}`, but starting from index 0.
    # Type: ShellCommand
    c.editor.command = editor_command

    # Handler for selecting file(s) in forms. If `external`, then the
    # commands specified by `fileselect.single_file.command`,
    # `fileselect.multiple_files.command` and `fileselect.folder.command`
    # are used to select one file, multiple files, and folders,
    # respectively.
    # Type: String
    # Valid values:
    #   - default: Use the default file selector.
    #   - external: Use an external command.
    c.fileselect.handler = 'external'

    # Command (and arguments) to use for selecting multiple files in forms.
    # The command should write the selected file paths to the specified file
    # or to stdout, separated by newlines. The following placeholders are
    # defined: * `{}`: Filename of the file to be written to. If not
    # contained in any argument, the   standard output of the command is
    # read instead.
    # Type: ShellCommand
    c.fileselect.multiple_files.command = multi_file_picker

    # Command (and arguments) to use for selecting a single file in forms.
    # The command should write the selected file path to the specified file
    # or stdout. The following placeholders are defined: * `{}`: Filename of
    # the file to be written to. If not contained in any argument, the
    # standard output of the command is read instead.
    # Type: ShellCommand
    c.fileselect.single_file.command = single_file_picker

    ## Search engines which can be used via the address bar.  Maps a search
    ## engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
    ## placeholder. The placeholder will be replaced by the search term, use
    ## `{{` and `}}` for literal `{`/`}` braces.  The following further
    ## placeholds are defined to configure how special characters in the
    ## search terms are replaced by safe characters (called 'quoting'):  *
    ## `{}` and `{semiquoted}` quote everything except slashes; this is the
    ## most   sensible choice for almost all search engines (for the search
    ## term   `slash/and&amp` this placeholder expands to `slash/and%26amp`).
    ## * `{quoted}` quotes all characters (for `slash/and&amp` this
    ## placeholder   expands to `slash%2Fand%26amp`). * `{unquoted}` quotes
    ## nothing (for `slash/and&amp` this placeholder   expands to
    ## `slash/and&amp`). * `{0}` means the same as `{}`, but can be used
    ## multiple times.  The search engine named `DEFAULT` is used when
    ## `url.auto_search` is turned on and something else than a URL was
    ## entered to be opened. Other search engines can be used by prepending
    ## the search engine name to the search term, e.g. `:open google
    ## qutebrowser`.
    ## Type: Dict
    # c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}'}

    ## Page(s) to open at the start.
    ## Type: List of FuzzyUrl, or FuzzyUrl
    # c.url.start_pages = ['https://start.duckduckgo.com']


def set_opts():
    # Set low-priority custom options.
    set_config_py_opts()

    # Customization via UI (:set, :bind and :unbind) is stored in autoconfig.yml.
    # If config.py exists, autoconfig.yml is not loaded automatically. Load it here
    # to override the settings in set_config_py_opts:
    config.load_autoconfig()


set_opts()
