return function()
    local dos = require "dos"
    local W, H = term.getSize()
    local page = dos.gui.page { elements = {
        dos.gui.button {
            x = 1, y = 1, text = "X",
            fg = dos.theme.bg, bg = dos.theme.fail,
            bracketColor = dos.theme.bg,
            onClick = function (self, _, page)
                page.__CLOSE = true
            end,
        },
        dos.gui.checkbox {
            x = 1, y = 2, fg = dos.theme.ok
        },
        dos.gui.textField {
            x = 1, y = 3,
            w = 12, bg = dos.theme.bg2,
        },
        dos.gui.text {
            x = 1, y = 4, content = "powjrepwioebnrfigjwbenirug", center = true,
            w = 12, h = 3, bg = dos.theme.bg2,
        },
        dos.gui.slider {
            x = 4, y = 7, length = 10,
            bg = dos.theme.bg2,
        },
    }}
    return dos.gui.run(page)
end