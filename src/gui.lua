require("dos.src.ext")
return setmetatable({
    ---@param win table
    drawBox = function(win, color)
        expect("win", win, "table")
        color = color or colors.gray expect("color", color, "number")
        local fg = win.getTextColor()
        local W, H = win.getSize()
        win.setCursorPos(1, 1)
        win.setTextColor(color)
        win.write(" ") win.write(("-"):rep(W-2)) win.write(" ")
        for y = 2, H-1 do
            win.setCursorPos(1, y)
            win.write("|") win.write((" "):rep(W-2)) win.write("|")
        end
        win.setCursorPos(1, H)
        win.write(" ") win.write(("-"):rep(W-2)) win.write(" ")
        win.setTextColor(fg)
    end,
    ---@param opts table
    ---@return gui.button
    button = function(opts)
        opts.x = default(math.floor(opts.x), 1) expect("x", opts.x, "number")
        opts.y = default(math.floor(opts.y), 1) expect("y", opts.y, "number")
        opts.text = default(opts.text, "button") expect("text", opts.text, "string")
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.bracketColor = default(opts.bracketColor, colors.gray) expect("bracketColor", opts.bracketColor, "number")
        opts.brackets = default(opts.brackets, "[]") expect("brackets", opts.brackets, "string") expect_min("brackets length", #opts.brackets, 2)
        opts.draw = default(opts.draw, function(self, win)
            local x, y = win.getCursorPos()
            local fg, bg = win.getTextColor(), win.getBackgroundColor()
            win.setCursorPos(self.x, self.y)
            win.setBackgroundColor(self.bg)
            win.setTextColor(self.bracketColor) win.write(self.brackets:sub(1,1))
            win.setTextColor(self.fg)           win.write(self.text)
            win.setTextColor(self.bracketColor) win.write(self.brackets:sub(2,2))
            win.setBackgroundColor(bg) win.setTextColor(fg)
        end) expect("draw", opts.draw, "function")
        opts.event = default(opts.event, function(self, event, win)
            expect("event", event, "event")
            expect("win", win, "table")
            if self.onClick then
                if event.type == "mouse_click" then
                    if event.button == 1 then
                        local wx, wy = win.getPosition()
                        if (event.x - wx + 1 >= self.x and event.x - wx + 1 <= self.x + #self.text + 1) and (event.y - wy + 1 == self.y) then
                            return self.onClick(self, event)
                        end
                    end
                end
            end
        end) expect("event", opts.event, "function")
        expect("onClick", opts.onClick, "function", "nil")
        return setmetatable(opts, { __name = "gui.button" })
    end,
    ---@param opts table
    ---@return gui.text
    text = function(opts)
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.center = default(opts.center, false) expect("center", opts.center, "boolean")
        opts.content = default(opts.content, "empty text") expect("content", opts.content, "string")
        opts.w = default(opts.w, #opts.content) expect("w", opts.w, "number")
        opts.h = default(opts.h, 1) expect("h", opts.h, "number")
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win)
            expect("win", win, "table")
            local x, y = win.getCursorPos()
            local fg, bg = win.getTextColor(), win.getBackgroundColor()
            win.setBackgroundColor(self.bg) win.setTextColor(self.fg)
            for i, line in ipairs(self.content:linesFromWidth(self.w)) do
                if self.center then
                    win.setCursorPos(self.x+self.w/2-#line/2, self.y+i-1)
                else
                    win.setCursorPos(self.x, self.y+i-1)
                end
                win.write(line)
            end
            win.setBackgroundColor(bg) win.setTextColor(fg)
        end) expect("draw", opts.draw, "function")
        opts.event = default(opts.event, function() end) expect("event", opts.event, "function")
        return setmetatable(opts, { __name = "gui.text" })
    end,
    ---@param opts table
    ---@return gui.textField
    textField = function(opts)
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.default = default(opts.default, "") expect("default", opts.default, "string")
        expect("hideChar", opts.hideChar, "string", "nil")
        opts.content = default(opts.content, opts.default) expect("content", opts.content, "string")
        opts.selected = default(opts.selected, false) expect("selected", opts.selected, "boolean")
        opts.w = default(opts.w, 12) expect("w", opts.w, "number")
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win)
            expect("win", win, "table")
            local x, y = win.getCursorPos()
            local fg, bg = win.getTextColor(), win.getBackgroundColor()
            win.setBackgroundColor(self.bg) win.setTextColor(self.fg)
            win.setCursorPos(self.x, self.y)
            win.write((" "):rep(self.w))
            win.setCursorPos(self.x, self.y)
            if self.hideChar then
                win.write(self.hideChar:rep(#self.content:sub(#self.content - math.min(#self.content - 1, self.w - 2), #self.content)))
            else
                win.write(self.content:sub(#self.content - math.min(#self.content - 1, self.w - 2), #self.content))
            end
            win.setCursorBlink(self.selected)
            win.setBackgroundColor(bg) win.setTextColor(fg)
        end) expect("draw", opts.draw, "function")
        opts.event = default(opts.event, function(self, event, win)
            expect("event", event, "event")
            expect("win", win, "table")
            if event.type == "mouse_click" then
                if event.button == 1 then
                    local wx, wy = 1, 1
                    if metatype(win.getPosition) == "function" then
                        wx, wy = win.getPosition()
                    end
                    self.selected = (event.x - wx + 1 >= self.x and event.x - wx + 1 <= self.x + self.w - 1) and (event.y - wy + 1 == self.y)
                end
            end
            if self.selected then
                if event.type == "char" then
                    self.content = self.content .. event.char
                end
                if event.type == "key" then
                    if event.key == keys.backspace then
                        self.content = self.content:sub(0, math.max(0, #self.content-1))
                    end
                end
            end
        end) expect("event", opts.event, "function")
        return setmetatable(opts, { __name = "gui.textField" })
    end,
}, {
    __name = "gui", __newindex = function(self, k, v)
        local immutable = { "button", "text", "textField" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end
})