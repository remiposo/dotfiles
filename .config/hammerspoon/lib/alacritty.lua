return function()
  hs.hotkey.bind('alt', 'Space', function()
    local appName = "Alacritty"
    local app = hs.application.get(appName)

    if app == nil or app:isHidden() then
      hs.application.launchOrFocus(appName)
    else
      app:hide()
    end
  end)
end
