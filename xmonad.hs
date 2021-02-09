-------------------------------------------------------------------------------
--
--  Arquio de configuração do Xmonad 
--
--      By Gabriel Grechuk.
--
-------------------------------------------------------------------------------

module Main (main) where



import System.Exit

import XMonad

import XMonad.Config.Desktop

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.Monitor
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.DecorationMadness
import XMonad.Layout.NoBorders (noBorders, smartBorders)

import XMonad.Util.EZConfig

--------------------------------------------------------------------------------
main = do
  xmonad  $ ewmh desktopConfig
    { modMask            = mod1Mask 
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = smartBorders $ desktopLayoutModifiers $ myLayouts
    , logHook            = dynamicLogString def >>= xmonadPropLog
    , handleEventHook    = handleEventHook def <+> fullscreenEventHook 
    , terminal           = "alacritty"
    , normalBorderColor  = "#dddddd" 
    , focusedBorderColor = "#ff0000"  
    }


    `additionalKeys` -- Add some extra key bindings:
    [     ((0, xK_Print), spawn "gnome-screenshot -i")
--      , ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
--      , ("M-p",     shellPrompt myXPConfig)
--      , ("M-<Esc>", sendMessage (Toggle "Full"))
    ]



myLayouts = noBorders tiled ||| noBorders (Mirror tiled) ||| noBorders Full ||| noBorders Circle ||| noBorders Grid
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     
     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100



--------------------------------------------------------------------------------
-- | Manipulate windows as they are created.  The list given to
-- @composeOne@ is processed from top to bottom.  The first matching
-- rule wins.
--
-- Use the `xprop' tool to get the info you need for these matches.
-- For className, use the second value that xprop gives you.
myManageHook = composeAll
    [ className =? "Gimp"           --> doFloat
    , (className =? "Firefox" <&&> resource =? "Dialog") --> doFloat
    , className =? "Cairo-dock"     --> doIgnore
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , className =? "Steam"          --> doFloat
    , className =? "steam"          --> doFullFloat -- bigpicture-mode
    , className =? "MPlayer"        --> doFloat
    , (isFullscreen --> doFullFloat) 
    ]

--myManageHook = composeOne
--  [ className =? "Pidgin" -?> doFloat
--  , className =? "XCalc"  -?> doFloat
--  , className =? "mpv"    -?> doFloat
--  , isDialog              -?> doCenterFloat

    -- Move transient windows to their parent:
--  , transience
--  ]
