import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
  xmobarProcess <- spawnPipe "start-xmobar"
  trayerProcess <- spawnPipe "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tine 0x191970 --height 12"
  xmonad $ defaultConfig {
             manageHook = manageDocks <+> manageHook defaultConfig
           , layoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig
           , handleEventHook = docksEventHook <+> handleEventHook defaultConfig
           , logHook = dynamicLogWithPP xmobarPP {
                                          ppOutput = hPutStrLn xmobarProcess
                                        , ppTitle = xmobarColor "green" "" . shorten 50
                                        }
           , modMask = mod4Mask
           } `additionalKeys` [
             ((mod4Mask, xK_b), sendMessage ToggleStruts)
           ]
