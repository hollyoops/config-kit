local This = {}

function This.setup()
    local hyper = {"shift", "alt", "cmd", "ctrl"}
    local VimMode = hs.loadSpoon('VimMode')
    local vim = VimMode:new()

    vim:disableForApp('Code')
    vim:disableForApp('MacVim')
    vim:disableForApp('zoom.us')
    vim:disableForApp('Xcode')
    vim:disableForApp('AppCode')
    vim:disableForApp('Visual Studio Code')

    -- vim:enterWithSequence('jk')
    vim:bindHotKeys({
        enter = {hyper, 'v'}
    })
end

return This
