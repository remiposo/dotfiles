local input = require "lib/input"
local windows = require "lib/windows"
local alacritty = require "lib/alacritty"

switchInputEvent = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged}, input.switchWithCmd)
switchInputEvent:start()

switchWithEsc = hs.eventtap.new({hs.eventtap.event.types.keyDown}, input.switchWithEsc)
switchWithEsc:start()

windows()
alacritty()
