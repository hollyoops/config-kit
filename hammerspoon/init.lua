local hyper = {"shift", "alt", "cmd", "ctrl"}
-- hs.hotkey.alertDuration = 0
-- hs.hints.showTitleThresh = 0
-- hs.window.animationDuration = 0.1
-- Load and install the Hyper key extension. Binding to F18
local window = {"cmd", "alt", "ctrl"}
local app = require('hyper')

app.install('F18')
-- Quick Reloading of Hammerspoon
app.bindKey('r', hs.reload)

---------------------------------------

-- 屏幕左半部分
hs.hotkey.bind(window, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f, 0)
end)

-- 屏幕右半部分
hs.hotkey.bind(window, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 2
    f.h = max.h
    f.x = max.w / 2
    f.y = max.y
    win:setFrame(f, 0)
end)

-- 屏幕上半部分
hs.hotkey.bind(window, "Up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    f.h = max.h / 2
    f.x = max.x
    f.y = max.y
    win:setFrame(f, 0)
end)

-- 屏幕下半部分
hs.hotkey.bind(window, "Down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    f.h = max.h / 2
    f.x = max.x
    f.y = max.h / 2
    win:setFrame(f, 0)
end)

-- 居中
hs.hotkey.bind(window, "C", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w * 0.75
    f.h = max.h * 0.75
    f.x = max.x + max.w * (0.25 / 2)
    f.y = max.y + max.h * (0.25 / 2)
    win:setFrame(f, 0)
end)

-- 屏幕全屏，保留 menu bar
hs.hotkey.bind(window, "M", function()
    local win = hs.window.focusedWindow()
    win:maximize(0)
end)

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
    enter = {hyper, 'j'}
})

mic_ui = {
    includeNonVisible = false, -- 不显示后台应用窗口
    includeOtherSpaces = false, -- 不显示其它桌面窗口

    -- 颜色格式为 RGB，最后一位是透明度A
    highlightThumbnailStrokeWidth = 0, -- 取消橙色的边宽
    backgroundColor = {0, 0, 0, 0.1}, -- ui 的背景颜色，这里改为透明
    showTitles = false -- 隐藏标题
}

-- 拆分代码，提升响应速度
mic_expose = hs.expose.new(nil, mic_ui)

-- 当按下快捷键时，首先执会执行 F11，显示桌面
app.bindKey('tab', function()
    hs.eventtap.keyStroke("fn", "F11")
    mic_expose:toggleShow()
end)

-- Toggle an application between being the frontmost app, and being hidden
function toggle_application(_app)
    return function()
        -- finds a running applications
        local app = hs.application.find(_app)
        if not app then
            -- application not running, launch app
            hs.application.launchOrFocus(_app)
            return
        end
        -- application running, toggle hide/unhide
        local mainwin = app:mainWindow()
        if mainwin then
            if true == app:isFrontmost() then
                mainwin:application():hide()
            else
                mainwin:application():activate(true)
                mainwin:application():unhide()
                mainwin:focus()
            end
        else
            -- no windows, maybe hide
            if true == app:hide() then
                -- focus app
                hs.application.launchOrFocus(_app)
            end
        end
    end
end

app.bindKey('T', toggle_application("iTerm"))
app.bindKey('W', toggle_application("WeChat"))
app.bindKey('C', toggle_application("Google Chrome"))
app.bindKey('S', toggle_application("Slack"))
app.bindKey('I', toggle_application("IntelliJ IDEA"))
app.bindKey('A', toggle_application("AppCode"))
app.bindKey('X', toggle_application("Xcode"))
app.bindKey('V', toggle_application("Visual Studio Code"))
app.bindKey('Z', toggle_application("zoom.us"))
----------------------------------------------------------------------------------------------------

-- Move Mouse to center of next Monitor
function move_mouse_to_next_monitor()
    return function()
        local screen = hs.mouse.getCurrentScreen()
        local nextScreen = screen:next()
        local rect = nextScreen:fullFrame()
        local center = hs.geometry.rectMidPoint(rect)
        -- hs.mouse.setRelativePosition(center, nextScreen)
        hs.mouse.setAbsolutePosition(center)
    end
end
hs.hotkey.bind({"alt"}, '`', move_mouse_to_next_monitor())
----------------------------------------------------------------------------------------------------
-- Register MiroWindowsManager
-- spoon.MiroWindowsManager:bindHotkeys({
--     up = {hyper, "up"},
--     right = {hyper, "right"},
--     down = {hyper, "down"},
--     left = {hyper, "left"},
--     fullscreen = {hyper, "f"}
-- })
----------------------------------------------------------------------------------------------------
-- move application to next window
function move_window_to_next_monitor()
    return function()
        -- get the focused window
        local win = hs.window.focusedWindow()
        -- get the screen where the focused window is displayed, a.k.a. current screen
        local screen = win:screen()
        -- compute the unitRect of the focused window relative to the current screen
        -- and move the window to the next screen setting the same unitRect
        win:move(win:frame():toUnitRect(screen:frame()), screen:next(), true, 0)
    end
end
-- bind hotkey
hs.hotkey.bind({"alt"}, 'tab', move_window_to_next_monitor())
hs.hotkey.bind(window, 'n', move_window_to_next_monitor())
----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
