local This = {}

function move_window_to_next_monitor()
    local app = hs.window.focusedWindow()
    app:moveToScreen(app:screen():next(), true, true)
end

function focus_top_most_window()
    local app = hs.window.frontmostWindow()
    app:focus()
end

-- Move Mouse to center of next Monitor
function move_mouse_to_next_monitor()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    -- hs.mouse.setRelativePosition(center, nextScreen)
    hs.mouse.setAbsolutePosition(center)
end

-- Move Mouse to center of next Monitor
function move_mouse_to_next_monitor()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    -- hs.mouse.setRelativePosition(center, nextScreen)
    hs.mouse.setAbsolutePosition(center)
end

function move_window_center()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w * 0.75
    f.h = max.h * 0.75
    f.x = max.x + max.w * (0.25 / 2)
    f.y = max.y + max.h * (0.25 / 2)
    win:setFrame(f, 0)
end

function move_window_left()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f, 0)
end

function move_window_right()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 2
    f.h = max.h
    f.x = max.w / 2
    f.y = max.y
    win:setFrame(f, 0)
end

function move_window_up()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    f.h = max.h / 2
    f.x = max.x
    f.y = max.y
    win:setFrame(f, 0)
end

function move_window_down()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    f.h = max.h / 2
    f.x = max.x
    f.y = max.h / 2
    win:setFrame(f, 0)
end

function maximize_window()
    local win = hs.window.focusedWindow()
    win:maximize(0)
end

function This.setup()
    local window = {"cmd", "alt", "ctrl"}
    hs.hotkey.bind(window, 'n', move_window_to_next_monitor)
    hs.hotkey.bind(window, 'f', focus_top_most_window)
    hs.hotkey.bind({"alt"}, '`', move_mouse_to_next_monitor)
    hs.hotkey.bind(window, "Left", move_window_left)
    -- 屏幕右半部分
    hs.hotkey.bind(window, "Right", move_window_right)
    -- 屏幕上半部分
    hs.hotkey.bind(window, "Up", move_window_up)

    -- 屏幕下半部分
    hs.hotkey.bind(window, "Down", move_window_down)

    -- 居中
    hs.hotkey.bind(window, "C", move_window_center)

    -- 屏幕全屏，保留 menu bar
    hs.hotkey.bind(window, "M", maximize_window)
end

return This
