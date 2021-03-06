#############################################
#           _    _____ _________            #
#          | |  |  _  \  _   _  |           #
#          | |  | | | | | | | | |           #
#          | |  | | | | | | | | |           #
#          | |__| |_| | | | | | |           #
#          |____|____/|_| |_| |_|           #
#                                           #
#   site: https://link-does-mods.github.io/ #
# github: https://github.com/link-does-mods #
#############################################

#######################################################
# Import Libraries
#######################################################

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

#######################################################
# Autostart
#######################################################

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

#######################################################
# Variables
#######################################################

# Mod key
mod = "mod4"

# Terminal
terminal = "alacritty"

# Nord color scheme             # nord[#]
nord = [["#2e3440", "#2e3440"], # 0
        ["#3b4252", "#3b4252"], # 1
        ["#434c5e", "#434c5e"], # 2
        ["#4c566a", "#4c566a"], # 3
        ["#546076", "#546076"], # 4
        ["#5c6a82", "#5c6a82"], # 5
        ["#d8dee9", "#d8dee9"], # 6
        ["#e5e9f0", "#e5e9f0"], # 7
        ["#eceff4", "#eceff4"], # 8
        ["#8fbcbb", "#8fbcbb"], # 9
        ["#88c0d0", "#88c0d0"], # 10
        ["#81a1c1", "#81a1c1"], # 11
        ["#5e81ac", "#5e81ac"], # 12
        ["#bf616a", "#bf616a"], # 13
        ["#d08770", "#d08770"], # 14
        ["#ebcb8b", "#ebcb8b"], # 15
        ["#a3bebc", "#a3bebc"], # 16
        ["#b48ead", "#b48ead"]] # 17

# Layout theme
def init_layout_theme():
    return {"margin":10,
            "border_width":4,
            "border_focus": "#5e81ac",
            "border_normal": "#3b526e"
            }
layout_theme = init_layout_theme()

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

#######################################################
# Key Bindings
#######################################################

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
        lazy.spawn("amixer -q set Master 2%+")
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("amixer -q set Master 2%-")
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

#######################################################
# Panel
#######################################################

# Monitor 1 (primary)
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(
                         foreground=nord[7],
                         background=nord[4]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[4],
                         background=nord[5]
                         ),
                widget.GroupBox(
                         highlight_method='line',
                         this_current_screen_border=nord[12],
                         this_screen_border='#3b526e',
                         other_screen_border=nord[5],
                         other_current_screen_border=nord[5],
                         highlight_color=nord[5],
                         foreground=nord[7],
                         background=nord[5]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[5]
                         ),
                widget.WindowName(
                         foreground=nord[7]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[2]
                         ),
                widget.Memory(
                         format=' {MemUsed}M',
                         foreground=nord[7],
                         background=nord[2]
                         ),
                widget.CPU(
                         format=' {load_percent}%',
                         foreground=nord[7],
                         background=nord[2]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[1],
                         background=nord[2]
                         ),
                widget.Pacman(
                         fmt='Updates: {}',
                         update_interval=1,
                         foreground=nord[7],
                         background=nord[1]
                         ),
                widget.Wlan(
                         format=' {essid}',
                         interface='wlp2s0',
                         foreground=nord[7],
                         background=nord[1]
                         ),
                widget.TextBox(
                         fmt='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[0],
                         background=nord[1]
                         ),
                widget.Volume(
                         fmt='🔊 {}',
                         foreground=nord[7],
                         background=nord[0]
                         ),
                widget.Battery(
                         format='{char} {percent:2.0%}',
                         charge_char='',
                         discharge_char='',
                         full_char=' ',
                         empty_char=' ',
                         update_interval=1,
                         foreground=nord[7],
                         background=nord[0]
                         ),
                widget.TextBox(
                         fmt='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[12],
                         background=nord[0]
                         ),
                widget.Clock(
                         format='%b %d %Y - %H:%M',
                         foreground=nord[7],
                         background=nord[12]
                         )
            ],
            24,
            background=nord[0]
        ),
    ),
    # Monitor 2
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(
                         foreground=nord[7],
                         background=nord[4]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[4],
                         background=nord[5]
                         ),
                widget.GroupBox(
                         highlight_method='line',
                         this_current_screen_border=nord[12],
                         this_screen_border='#3b526e',
                         other_screen_border=nord[5],
                         other_current_screen_border=nord[5],
                         highlight_color=nord[5],
                         foreground=nord[7],
                         background=nord[5]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[5]
                         ),
                widget.WindowName(
                         foreground=nord[7]
                         ),
                widget.TextBox(
                         text='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[1],
                         background=nord[0]
                         ),
                widget.Pacman(
                         fmt='Updates: {}',
                         update_interval=1,
                         foreground=nord[7],
                         background=nord[1]
                         ),
                widget.TextBox(
                         fmt='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[0],
                         background=nord[1]
                         ),
                widget.Net(
                         format=' {up}   {down}',
                         foreground=nord[7],
                         background=nord[0]
                         ),
                widget.TextBox(
                         fmt='',
                         padding=-0.01,
                         fontsize=23,
                         foreground=nord[12],
                         background=nord[0]
                         ),
                widget.Clock(
                         format='%b %d %Y - %H:%M',
                         foreground=nord[7],
                         background=nord[12]
                         )
            ],
            24,
            background=nord[0]
        ),
    ),
]

#######################################################
# Layouts
#######################################################

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
