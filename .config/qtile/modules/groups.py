from libqtile.config import Key, Group
from libqtile.command import lazy
from libqtile.lazy import lazy
from .keys import keys, mod

@lazy.function
def window_to_prev_group(qtile):
    i = qtile.groups.index(qtile.current_group)
    if qtile.current_window is not None and i != 0:
        qtile.current_window.togroup(qtile.groups[i - 1].name)
        qtile.current_screen.toggle_group(qtile.groups[i - 1])

@lazy.function
def window_to_next_group(qtile):
    i = qtile.groups.index(qtile.current_group)
    if qtile.current_window is not None and i != 6:
        qtile.current_window.togroup(qtile.groups[i + 1].name)
        qtile.current_screen.toggle_group(qtile.groups[i + 1])

groups = [Group(i) for i in "123456789"]

keys.extend([
    Key([mod], "h", lazy.screen.prev_group(), desc="Switch to previous group"),
    Key([mod], "l", lazy.screen.next_group(), desc="Switch to next group"),
    Key([mod, "shift"], "h", window_to_prev_group(), desc="Move focused window to previous group"),
    Key([mod, "shift"], "l", window_to_next_group(), desc="Move focused window to next group")
    ])

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod],
            i.name,
            lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        Key([mod], "Right", lazy.screen.next_group(),
            desc="Switch to next group"),

        Key([mod], "Left", lazy.screen.prev_group(),
            desc="Switch to previous group"),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"],
            i.name,
            lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])
