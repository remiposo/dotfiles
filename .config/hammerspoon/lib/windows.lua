return function()
  hs.hotkey.bind('alt', 'left', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      local unitRect = hs.geometry.rect(0, 0, 0.5, 1)
      win:moveToUnit(unitRect)
    end
  end)
  hs.hotkey.bind('alt', 'down', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      win:minimize()
    end
  end)
  hs.hotkey.bind('alt', 'up', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      win:maximize()
    end
  end)
  hs.hotkey.bind('alt', 'right', function()
    local win = hs.window.focusedWindow()
    if win and not(win:isFullScreen()) then
      local unitRect = hs.geometry.rect(0.5, 0, 0.5, 1)
      win:moveToUnit(unitRect)
    end
  end)
end
