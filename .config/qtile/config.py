# Generic
import os
import re
import time
import socket
import subprocess

# Libqtile
from libqtile.config import KeyChord, Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# Typing
from typing import List  # noqa: F401

@hook.subscribe.startup_once
def autostart():
    processes = [
        ['autorandr', '--change'], # Set screen layout
        ['nitrogen', '--restore']  # Set wallpaper
    ]

    # Run each command with a 1 second delay between each one
    for p in processes:
        subprocess.Popen(p)
        time.sleep(1)

mod = "mod4"
terminal = guess_terminal()

keys = [
    # Switch between windows in current stack pane
    Key([mod], "Down", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "Up", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Move windows up or down in current stack
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "j", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),
    Key([mod], "k", lazy.layout.previous(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Swap focus to other screen
    Key([mod], "Left",
             lazy.prev_screen(),
             desc='Switch focus to monitor 1'
             ),
    Key([mod], "Right",
             lazy.next_screen(),
             desc='Switch focus to monitor 2'
             ),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "d", lazy.spawn("rofi -show drun"),
        desc="Run launcher"),

    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("amixer -q set Master 5%+")
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("amixer -q set Master 5%-")
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("amixer -q set Master toggle")
    )
]

groups = [Group(i) for i in "12"] # Workspace names are monitor numbers

for i in groups:
    keys.extend([
        # mod1 + monitor number = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# Layouts
def init_layout_theme():
    return {"margin":10,
            "border_width":4,
            "border_focus": "#7aa2f7",
            "border_normal": "#485e8c"
            }
layout_theme = init_layout_theme()

# Panel
colors = [["#24283b", "#24283b"], # Background
          ["#a9b1d6", "#a9b1d6"], # Foreground
          ["#32344a", "#32344a"], # Black
          ["#f7768e", "#f7768e"], # Red
          ["#9ece6a", "#9ece6a"], # Green
          ["#e0af68", "#e0af68"], # Yellow
          ["#7aa2f7", "#7aa2f7"], # Blue
          ["#ad8ee6", "#ad8ee6"], # Magenta
          ["#449dab", "#449dab"], # Cyan
          ["#787c99", "#787c99"]] # White

# Panel widgets
widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

layouts = [
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    layout.MonadTall(**layout_theme),           # Master and stack (similar to Xmonad)
    layout.Stack(**layout_theme, num_stacks=1), # Tabbed without tabs
    layout.Max()                                # Almost fullscreen (no borders)
]

screens = [
    # Monitor 1 (primary)
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(foreground=colors[3]),
                widget.GroupBox(),
                widget.WindowName(foreground=colors[4]),
                widget.CPU(format=' {load_percent}%', foreground=colors[5]),
                widget.Sep(padding=20),
                widget.Memory(format=' {MemUsed}M', foreground=colors[5]),
                widget.Sep(padding=20),
                widget.Wlan(interface='wlp2s0', format=' {essid}', foreground=colors[6]),
                widget.Sep(padding=20),
                widget.PulseVolume(foreground=colors[7]),
                widget.Sep(padding=20),
                widget.CheckUpdates(custom_command='~/.config/polybar/scripts/check-all-updates.sh'),
                widget.Sep(padding=20),
                widget.Systray(),
                widget.Sep(padding=20),
                widget.Clock(format='  %a %m %Y - %I:%M %p', foreground=colors[8]),
            ],
            24,
        ),
    ),
    # Monitor 2
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(foreground=colors[3]),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(foreground=colors[4]),
                widget.Net(inteerface='wlp2s0', format=' {down}   {up}', foreground=colors[7]),
                widget.Sep(padding=20),
                widget.Clock(format='  %a %m %Y - %I:%M %p', foreground=colors[8]),
            ],
            24,
        ),
    ),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'}, # gitk
    {'wmclass': 'makebranch'},   # gitk
    {'wmclass': 'maketag'},      # gitk
    {'wname': 'branchdialog'},   # gitk
    {'wname': 'pinentry'},       # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"
