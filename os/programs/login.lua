return function()
    local dos = require("dos")
    local W, H = term.getSize()
    local userButtons = {}
    for name, user in pairs(dos.users.users) do
        table.insert(userButtons, dos.gui.button {
            x = W/2 - #("["..name.."]")/2, y = H/2 - #dos.users.users/2,
            text = name,
            onClick = function(self)
                local password
                repeat
                    password = dos.prompt.input(self.text.." password", "", "*", 20)
                    term.reset()
                    if #password == 0 then break end
                    if password ~= user.password then
                        dos.prompt.info("wrong password")
                        term.reset()
                    end
                until password == user.password
                term.reset()
                if password == user.password then
                    return true
                end
            end
        })
    end
    local run = true
    while run do
        term.reset()
        for _, button in ipairs(userButtons) do
            button:draw(term)
        end
        local event = dos.event.new(os.pullEventsRaw({ "mouse_click", "key", "terminate" }))
        if event.type == "terminate" then os.shutdown() end
        for _, button in ipairs(userButtons) do
            run = not button:event(event, term)
        end
    end
end