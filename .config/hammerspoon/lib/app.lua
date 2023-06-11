return function()
  local setAppShortcut = function(bundleID, key)
    hs.hotkey.bind('alt', key, function()
      local app = hs.application.get(bundleID)
      if app and app:isFrontmost() then
        app:hide()
      else
        hs.application.launchOrFocusByBundleID(bundleID)
      end
    end)
  end
  setAppShortcut('org.alacritty', 'Space')
  setAppShortcut('com.google.Chrome', 'h')
  setAppShortcut('com.microsoft.VSCode', 'j')
end
