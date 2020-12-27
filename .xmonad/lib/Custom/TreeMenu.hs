module Custom.TreeMenu where

----------------------------------
-- Import Modules
----------------------------------

-- Base
import XMonad
import qualified XMonad.StackSet as W

-- Actions
import qualified XMonad.Actions.TreeSelect as TS

-- Data
import qualified Data.Map as M
import Data.Tree

----------------------------------
-- Tree Select
----------------------------------

-- Menu
treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
    [ Node (TS.TSNode "+  Configs"    "Programs and Xmonad" (return ()))
        [ Node (TS.TSNode "+ Xmonad" "" (return ()))
            [ Node (TS.TSNode "+ Main" "" (return()))
                [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.xmonad/xmonad.hs"))  []
                , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.xmonad/xmonad.hs"))  []
                ]
            , Node (TS.TSNode "+ Keys" "" (return()))
                [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.xmonad/lib/Custom/Keys.hs"))  []
                , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.xmonad/lib/Custom/Keys.hs"))  []
                ]
            , Node (TS.TSNode "+ Tree Select" "" (return()))
                [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.xmonad/lib/Custom/TreeMenu.hs"))  []
                , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.xmonad/lib/Custom/TreeMenu.hs"))  []
                ] 
            , Node (TS.TSNode "+ Autostart" "" (return()))
                [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.xmonad/scripts/autostart.sh"))  []
                , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.xmonad/scripts/autostart.sh"))  []
                ]
            ]
        , Node (TS.TSNode "+ Editors" "" (return ()))
            [ Node (TS.TSNode "+ Neovim" "" (return()))
                [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.config/nvim/init.vim"))  []
                , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.config/nvim/init.vim"))  []
                ]
            , Node (TS.TSNode "+ Doom Emacs" "" (return()))  
                [ Node (TS.TSNode "+ Config" "" (return()))  
                    [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.doom.d/config.el"))  []
                    , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.doom.d/config.el"))  []
                    ]
                , Node (TS.TSNode "+ Init" "" (return()))  
                    [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.doom.d/init.el"))  []
                    , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.doom.d/init.el"))  []
                    ]
                ]
            ]
        , Node (TS.TSNode "+ Alacritty" "" (return()))
                [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.config/alacritty/alacritty.yml"))  []
                , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.config/alacritty/alacritty.yml"))  []
                ]    
        , Node (TS.TSNode "+ Polybar"    "" (return ()))
            [ Node (TS.TSNode "Open" "Open in VScode" (spawn "code ~/.config/polybar/config"))  []
            , Node (TS.TSNode "Directory" "Open in file manager" (spawn "nemo ~/.config/polybar/config"))  []
            ]
        ]
    , Node (TS.TSNode "+ Bookmarks" "" (return ()))  
        [ Node (TS.TSNode "+ Keybindings" "" (return()))
            [ Node (TS.TSNode "Xmonad" "" (spawn "brave https://gist.github.com/micrub/aeebe7eb4d2df9e5e203e76a0fd89542"))  []
            , Node (TS.TSNode "Neovim" "" (spawn "brave https://vim.rtorr.com/"))  []
            , Node (TS.TSNode "Doom Emacs" "" (spawn "brave https://gist.github.com/hjertnes/9e14416e8962ff5f03c6b9871945b165"))  []
            ]
        , Node (TS.TSNode "+ Repositories" "Github and Gitlab" (return()))
            [ Node (TS.TSNode "My Page" "" (spawn "brave https://github.com/link-does-mods"))  []
            , Node (TS.TSNode "Distrotube" "" (spawn "brave https://gitlab.com/dwt1"))  []
            ]
        ]
    ]

-- Config
tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0x1a924283b
                              , TS.ts_font         = "xft:Sans-16"
                              , TS.ts_node         = (0xffa9b1d6, 0xff24283b)
                              , TS.ts_nodealt      = (0xffa9b1d6, 0xff2f3863)
                              , TS.ts_highlight    = (0xffffffff, 0xff7aa2f7)
                              , TS.ts_extra        = 0xffa9b1d6
                              , TS.ts_node_width   = 180
                              , TS.ts_node_height  = 30
                              , TS.ts_originX      = 0
                              , TS.ts_originY      = 0
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

-- Key Bindings
myTreeNavigation = M.fromList
    [ ((0, xK_Escape), TS.cancel)
    , ((0, xK_Return), TS.select)
    , ((0, xK_space),  TS.select)

    -- Arrow keys
    , ((0, xK_Up),     TS.movePrev)
    , ((0, xK_Down),   TS.moveNext)
    , ((0, xK_Left),   TS.moveParent)
    , ((0, xK_Right),  TS.moveChild)
    
    -- Vim keys
    , ((0, xK_k),      TS.movePrev)
    , ((0, xK_j),      TS.moveNext)
    , ((0, xK_h),      TS.moveParent)
    , ((0, xK_l),      TS.moveChild)
    , ((0, xK_o),      TS.moveHistBack)
    , ((0, xK_i),      TS.moveHistForward)
    ]