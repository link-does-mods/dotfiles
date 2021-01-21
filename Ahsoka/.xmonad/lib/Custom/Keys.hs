-----------------------------------------------
--           _    _____ _________            --
--          | |  |  _  \  _   _  |           --
--          | |  | | | | | | | | |           --
--          | |  | | | | | | | | |           --
--          | |__| |_| | | | | | |           --
--          |____|____/|_| |_| |_|           --
--                                           --
--   site: https://link-does-mods.github.io/ -- 
-- github: https://github.com/link-does-mods -- 
-----------------------------------------------

module Custom.Keys where

----------------------------------
-- Import Libraries
----------------------------------

-- Custom
import Custom.TreeMenu

-- Base
import XMonad
import System.IO
import System.Exit

-- Actions
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS

-- Data
import qualified Data.Map as M

-- Layout modifiers
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

-- Misc
import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W

----------------------------------
-- Key bindings
----------------------------------

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

  -- <super> + <key>
  [ ((modMask, xK_d ), spawn $ "rofi -show drun")
  , ((modMask, xK_f), sendMessage $ Toggle NBFULL)
  , ((modMask, xK_q), kill )
  , ((modMask, xK_r), spawn $ "xmonad --restart" )
  , ((modMask, xK_Return), spawn $ "alacritty" )

  -- Fn keys

  -- Super + shift keys
  , ((modMask .|. shiftMask , xK_d), spawn $ "rofi-theme-selector" )
  , ((modMask .|. shiftMask , xK_e ), spawn $ "arcolinux-logout")
  , ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")

  -- Screenshots
  , ((modMask, xK_Print), spawn $ "flameshot gui")

  -- Tree select
  , ((modMask, xK_t), treeselectAction tsDefaultConfig)

  -- Multimedia keys
  , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")      -- Mute volume
  , ((0, xF86XK_AudioLowerVolume), spawn $ "amixer -q set Master 5%-")  -- Lower volume
  , ((0, xF86XK_AudioRaiseVolume), spawn $ "amixer -q set Master 5%+")  -- Raise volume
  , ((0, xF86XK_AudioPlay), spawn $ "playerctl play-pause")             -- Play song
  , ((0, xF86XK_AudioNext), spawn $ "playerctl next")                   -- Next song
  , ((0, xF86XK_AudioPrev), spawn $ "playerctl previous")               -- Previous song
  , ((0, xF86XK_AudioStop), spawn $ "playerctl stop")                   -- Stop song
  , ((0, xF86XK_MonBrightnessUp),  spawn $ "xbacklight -inc 15")        -- Raise brightness
  , ((0, xF86XK_MonBrightnessDown), spawn $ "xbacklight -dec 15")       -- Lower brightness

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)

  --  Reset the layouts on the current workspace to default.
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_Down), windows W.focusDown)
  , ((modMask, xK_j), windows W.focusDown)

  -- Move focus to the previous window.
  , ((modMask, xK_Up), windows W.focusUp  )
  , ((modMask, xK_k), windows W.focusUp  )  

  -- Move focus to the master window.
  , ((modMask .|. shiftMask, xK_m), windows W.focusMaster  )

  -- Swap the focused window with the next window.
  , ((modMask .|. shiftMask, xK_Down), windows W.swapDown  )
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown  )

  -- Swap the focused window with the previous window.
  , ((modMask .|. shiftMask, xK_Up), windows W.swapUp  )
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp  )

  -- Shrink the master area.
  , ((controlMask .|. shiftMask , xK_Left), sendMessage Shrink)
  , ((controlMask .|. shiftMask , xK_h), sendMessage Shrink)

  -- Expand the master area.
  , ((controlMask .|. shiftMask , xK_Right), sendMessage Expand)
  , ((controlMask .|. shiftMask , xK_l), sendMessage Expand)

  -- Push window back into tiling.
  , ((controlMask .|. shiftMask , xK_t), withFocused $ windows . W.sink)

  -- Increment the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Left), sendMessage (IncMasterN 1))
  , ((controlMask .|. modMask, xK_h), sendMessage (IncMasterN 1))

  -- Decrement the number of windows in the master area.
  , ((controlMask .|. modMask, xK_Right), sendMessage (IncMasterN (-1)))
  , ((controlMask .|. modMask, xK_l), sendMessage (IncMasterN (-1)))

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

  ++

  -- mod-{left,right}, Switch to physical/Xinerama screens 1, or 2
  -- mod-shift-{left,right}, Move client to screen 1, or 2
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_Left, xK_Right] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

----------------------------------
-- Mouse Bindings
----------------------------------

-- Floating mode
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]
