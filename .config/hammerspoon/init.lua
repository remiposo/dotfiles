local input = require "lib/input"

switchInputEvent = hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged}, input.switchWithCmd)
switchInputEvent:start()

switchWithEsc = hs.eventtap.new({hs.eventtap.event.types.keyDown}, input.switchWithEsc)
switchWithEsc:start()
