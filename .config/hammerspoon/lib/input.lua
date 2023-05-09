local function switchWithCmd()
  local keyWithCmd = false
  local leftCmd    = 0x37
  local rightCmd   = 0x36

  return function (event)
    local t = event:getType()
    local c = event:getKeyCode()
    local isCmd = event:getFlags()['cmd']

    if t == hs.eventtap.event.types.keyDown then
      if isCmd then
        keyWithCmd = true
      end
    elseif t == hs.eventtap.event.types.flagsChanged then
      if isCmd then return end
      if not(keyWithCmd) then
        if c == leftCmd then
          hs.keycodes.setMethod('Alphanumeric (Google)')
        elseif c == rightCmd then
          hs.keycodes.setMethod('Hiragana (Google)')
        end
      end
      keyWithCmd = false
    end
  end
end

local function switchWithEsc()
  local leftBracket = 0x21

  return function (event)
    local c = event:getKeyCode()
    local isCtrl = event:getFlags()['ctrl']

    if isCtrl and c == leftBracket then
      hs.keycodes.setMethod('Alphanumeric (Google)')
    end
  end
end

return {
  switchWithCmd = switchWithCmd(),
  switchWithEsc = switchWithEsc(),
}
