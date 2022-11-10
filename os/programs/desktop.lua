return function()
    local dos = require("dos")
    local W, H = term.getSize()
    local buttons = {
        home = dos.gui.button {
            x = 1, y = H, text = "#",
            bg = dos.theme.bg, fg = dos.theme.fg, bracketColor = dos.theme.bg2,
            onClick = function()
                return true
            end
        }
    }
    while true do
        term.reset()
        term.setCursorPos(1, H)
        for _, button in pairs(buttons) do
            button:draw(term)
        end
        local event = dos.event.new(os.pullEventsRaw({ "mouse_click", "mouse_drag", "mouse_scroll", "key", "terminate" }))
        if event.type == "terminate" then error("terminated") end
        for name, button in pairs(buttons) do
            button:event(event, term)
        end
    end
end