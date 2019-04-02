--
-- xmonad
--

import XMonad
import XMonad.Actions.CycleWS

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import XMonad.Util.Run
import XMonad.Util.EZConfig

main = do
	barproc <- spawnPipe "xmobar"
	xmonad $ docks  defaultConfig
		{ normalBorderColor = "#111111"
		, focusedBorderColor = "#89b6e2"
		, modMask = mod4Mask
		, terminal = "urxvt"
		, borderWidth = 2
		, layoutHook = myLayoutHook
		, startupHook = myStartupHook
		, manageHook = myManageHook
		, logHook = myLogHook barproc
		} `additionalKeys`
		[ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
		, ((0, xK_Print), spawn "scrot")
		, ((mod4Mask, xK_Return), spawn "urxvt")
		, ((mod4Mask, xK_d), spawn "rofi -show run")
		, ((mod4Mask, xK_l), nextWS)
		, ((mod4Mask, xK_h), prevWS)
		, ((mod4Mask .|. shiftMask, xK_l), shiftToNext)
		, ((mod4Mask .|. shiftMask, xK_h), shiftToPrev)
		]

myLayoutHook = avoidStruts $ layoutHook defaultConfig

-- Start up applications
myStartupHook = do
	spawn "nm-applet"
	spawn "feh --bg-fill $HOME/Pictures/wallpaper.jpg"
	spawn "xcompmgr"

myManageHook = manageDocks <+> manageHook defaultConfig
myLogHook h = dynamicLogWithPP xmobarPP {
	ppOutput = hPutStrLn h,
	ppCurrent = xmobarColor "#ffc123" "" . wrap "[" "]",
	ppTitle = xmobarColor "#c8e7a8" "" . shorten 80
}		
