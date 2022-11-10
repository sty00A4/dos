return function()
    local dos = require("dos")
    local W, H = term.getSize()
    local selected = "home"
    local buttons = {
        home = dos.gui.button {
            x = 1, y = H, text = "#",
            bg = dos.theme.bg, fg = dos.theme.fg, bracketColor = dos.theme.bg2,
            onClick = function()
                selected = "home"
            end
        }
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
        local event = dos.event.new(os.pullEventsRaw({
            "mouse_click", "mouse_drag", "mouse_scroll",
            "key", "terminate",
            "term_resize"
        }))
        if event.type == "terminate" then error("terminated") end
        if event.type == "term_resize" then
            W, H = term.getSize()
            buttons.home.y = H
        end
        for _, button in pairs(buttons) do
            button:event(event, term)
        end
    end
end