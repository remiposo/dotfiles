return function()
  hs.hotkey.bind('alt', 'h', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      local unitRect = hs.geometry.rect(0, 0, 0.5, 1)
      win:moveToUnit(unitRect)
    end
  end)
  hs.hotkey.bind('alt', 'j', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      win:minimize()
    end
  end)
  hs.hotkey.bind('alt', 'k', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      win:maximize()
    end
  end)
  hs.hotkey.bind('alt', 'l', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      local unitRect = hs.geometry.rect(0.5, 0, 0.5, 1)
      win:moveToUnit(unitRect)
    end
  end)
end
