from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args: list[str]) -> None:
    del args # unused
    pass


@result_handler(no_ui=True)
def handle_result(args: list[str], answer: str, target_win_id: int, boss: Boss) -> None:
    del args           # unused
    del answer         # unused
    del target_win_id  # unused

    tab = boss.active_tab
    if not tab:
        return

    if tab.current_layout.name == "stack":
        tab.last_used_layout()
        tab.current_layout.must_draw_borders = False
        tab.relayout()
    else:
        try:
            tab.goto_layout("stack")
            tab.current_layout.must_draw_borders = False
            tab.relayout()
        except Exception:
            pass

    return

    # next_layout_name = 'stack'
    # draw_borders = True
    #
    # current_layout_name = tab.current_layout.name
    # if current_layout_name == 'stack':
    #     # NOTE: Is it ever possible that last_used_layout is None? (meaning
    #     # this function is invoked on the first used layout?
    #     last_layout = tab.last_used_layout()
    #     next_layout_name = last_layout.name if last_layout else 'splits'
    #     draw_borders = False
    #
    # tab.goto_layout(next_layout_name)
    # tab.current_layout.must_draw_borders = True
    # #tab.relayout()
    # return
