return function()
    local dos = require "dos"
    local W, H = term.getSize()
    local page = dos.gui.page { elements = {
        button = dos.gui.button {
            x = 1, y = 1, text = "X",
            fg = dos.theme.bg, bg = dos.theme.fail,
            bracketColor = dos.theme.bg,
            onClick = function (self, _, page)
                page.__CLOSE = true
            end,
        },
    }}
    return dos.gui.run(page)
end