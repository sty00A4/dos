return function()
    local dos = require("dos")
    local W, H = term.getSize()
    local selected = nil
    local debug = dos.gui.text {
        x = 1, y = 1, content = "",
        w = W, h = H, center = true
    }
    local buttons = {
        home = dos.gui.button {
            x = 1, y = H, text = "#",
            bg = dos.theme.bg, fg = dos.theme.fg, bracketColor = dos.theme.bg2,
            onClick = function() selected = selected == "home" and "" or "home" end
        },
    }
    local homeButtons = {
        shutdown = dos.gui.button {
            x = 1, y = H-1, text = "shutdown",
            bg = dos.theme.bg, fg = dos.theme.fg, bracketColor = dos.theme.bg2,
            onClick = function() os.shutdown() end
        },
        reboot = dos.gui.button {
            x = 1, y = H-2, text = "reboot",
            bg = dos.theme.bg, fg = dos.theme.fg, bracketColor = dos.theme.bg2,
            onClick = function() os.reboot() end
        },
    }
    while true do
        term.reset()
        term.setCursorPos(1, H)
        for name, button in pairs(buttons) do
            if name == selected then
                button.bracketColor = dos.theme.fg
            else
                button.bracketColor = dos.theme.bg2
            end
            button:draw(term)
        end
        if selected == "home" then
            for name, button in pairs(homeButtons) do
                button:draw(term)
            end
        end
        debug:draw(term)
        local event = dos.event.new(os.pullEventsRaw({
            "mouse_click", "mouse_drag", "mouse_scroll",
            "key", "terminate",
            "term_resize"
        }))
        if event.type == "terminate" then error("terminated") end
        if event.type == "key" then
            debug.content = keys.getName(event.key)
            func = ({
                home = function() buttons.home:onClick() end
            })[keys.getName(event.key)]
            if func then func() end
        end
        for _, button in pairs(buttons) do
            button:event(event, term)
        end
        if selected == "home" then
            for _, button in pairs(homeButtons) do
                button:event(event, term)
            end
        end
    end
end