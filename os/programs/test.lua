return function()
    local dos = require "dos"
    local W, H = term.getSize()
    local page = dos.gui.page { elements = {
        dos.gui.button {
            x = W-2, y = 1, text = "X",
            fg = dos.theme.bg, bg = dos.theme.fail,
            bracketColor = dos.theme.bg,
            onClick = function (self, _, page)
                page.__CLOSE = true
            end,
        },
        -- dos.gui.text {
        --     x = 1, y = 2, content = "home", center = true,
        --     w = W, h = 3, bg = dos.theme.bg2,
        -- },
        -- dos.gui.checkbox {
        --     x = 1, y = 3, fg = dos.theme.ok
        -- },
        -- dos.gui.slider {
        --     x = 1, y = 4, length = 20,
        --     bg = dos.theme.bg2,
        --     update2 = function(self, win, page)
        --         local scale = { colors.red, colors.orange, colors.yellow, colors.lime }
        --         self.bg = scale[math.floor(self.value * (#scale - 1)) + 1]
        --     end,
        -- },
        -- dos.gui.textField {
        --     x = 1, y = 6, w = 12,
        --     bg = dos.theme.bg2,
        --     chars = "0123456789"
        -- },
        dos.gui.menuTree {
            elements = {
                dos.gui.menu.head("file", {
                    dos.gui.menu.selection("new", function(self, win, page) error(self.label) end),
                    dos.gui.menu.selection("open", function(self, win, page) error(self.label) end),
                    dos.gui.menu.seperator(),
                    dos.gui.menu.selection("save", function(self, win, page) error(self.label) end),
                }),
                dos.gui.menu.head("edit", {
                    dos.gui.menu.selection("undo", function(self, win, page) error(self.label) end),
                    dos.gui.menu.selection("redo", function(self, win, page) error(self.label) end),
                    dos.gui.menu.seperator(),
                    dos.gui.menu.selection("cut", function(self, win, page) error(self.label) end),
                    dos.gui.menu.selection("copy", function(self, win, page) error(self.label) end),
                    dos.gui.menu.selection("paste", function(self, win, page) error(self.label) end),
                }),
                dos.gui.menu.head("run", {
                    dos.gui.menu.selection("lua", function(self, win, page) error(self.label) end),
                    dos.gui.menu.selection("craftscript", function(self, win, page) error(self.label) end),
                }),
            }
        },
    }}
    return dos.gui.run(page)
end