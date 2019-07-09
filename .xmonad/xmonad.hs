--
-- xmonad
--

import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import qualified XMonad.StackSet as W

import XMonad.Util.EZConfig
import XMonad.Util.Run

myWorkSpaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

main = do
	barproc <- spawnPipe myXmonad
	xmonad $ docks  defaultConfig
		{ normalBorderColor = "#111111"
		, focusedBorderColor = "#89b6e2"
		, modMask = mod4Mask
		, terminal = "alacritty"
		, borderWidth = 2
		, layoutHook = myLayoutHook
		, startupHook = myStartupHook
		, manageHook = myManageHook
		, logHook = myLogHook barproc
		, workspaces = myWorkSpaces
		}
		----------------------------------------------
		--            windows operation             --
		----------------------------------------------
		`additionalKeysP`
		[ ("M4-l", nextWS)
		, ("M4-h", prevWS)
		, ("M4-S-l", shiftToNext)
		, ("M4-S-h", shiftToPrev)
		]
		----------------------------------------------
		--         workspace operataion             --
		----------------------------------------------
		`additionalKeys`
		[ ((m .|. mod4Mask, k), windows $ f i)
			| (i, k) <- zip myWorkSpaces [xK_1 ..]
			, (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask), (copy, controlMask)]
		]
		----------------------------------------------
		--          desktop operation               --
		----------------------------------------------
		`additionalKeysP`
		[ ("M4-<Return>", spawn "alacritty")
		, ("M4-<Print>", spawn "sleep 0.2; scrot -s")
		, ("M4-d", spawn "rofi -show run")
		]

myLayoutHook = avoidStruts $ layoutHook defaultConfig

-- Start up applications
myStartupHook = do
	spawn "feh --bg-fill $HOME/Pictures/wallpaper.jpg"
	spawn "xcompmgr"

myManageHook = manageDocks <+> manageHook defaultConfig
myLogHook h = dynamicLogWithPP xmobarPP {
	ppOutput = hPutStrLn h,
	ppCurrent = xmobarColor "#ffc123" "" . wrap "[" "]",
	ppTitle = xmobarColor "#c8e7a8" "" . shorten 80
}		

myXmonad = "xmobar $HOME/.xmonad/xmobarrc"
