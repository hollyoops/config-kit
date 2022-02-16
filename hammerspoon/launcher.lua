local This = {}
local app = require('hyper')

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

-- 当按下快捷键时，首先执会执行 F11，显示桌面
function show_all_windows()
    hs.eventtap.keyStroke("fn", "F11")
    mic_expose:toggleShow()
end

function This.setup()
    app.install('F18')

    -- Quick Reloading of Hammerspoon
    app.bindKey('r', hs.reload)

    app.bindKey('tab', show_all_windows)

    -- bind launchers
    app.bindKey('T', toggle_application("iTerm"))
    app.bindKey('W', toggle_application("WeChat"))
    app.bindKey('C', toggle_application("Google Chrome"))
    app.bindKey('S', toggle_application("Slack"))
    app.bindKey('I', toggle_application("IntelliJ IDEA"))
    app.bindKey('A', toggle_application("AppCode"))
    app.bindKey('X', toggle_application("Xcode"))
    app.bindKey('V', toggle_application("Visual Studio Code"))
    app.bindKey('Z', toggle_application("zoom.us"))
    app.bindKey('N', toggle_application("Notion"))
end

return This
