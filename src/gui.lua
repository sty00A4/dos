require("dos.src.ext")
return setmetatable({
    ---@param win table
    drawBox = function(win, color)
        expect("win", win, "table", "gui.page")
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
    page = function(opts)
        local W, H = term.getSize()
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.w = default(opts.w, W) expect("w", opts.w, "number")
        opts.h = default(opts.h, H) expect("h", opts.h, "number")
        opts.elements = default(opts.elements, {}) expect("elements", opts.elements, "table")
        opts.parent = default(opts.parent, term.current()) expect("parent", opts.parent, "table", "gui.page")
        for k, e in pairs(opts.elements) do expect(k, e, "gui") end
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            self.win.setBackgroundColor(self.bg)
            self.win.setTextColor(self.fg)
            for k, e in pairs(self.elements) do
                if type(e.draw) == "function" then
                    e:draw(self.win, self)
                end
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            for k, e in pairs(self.elements) do
                if type(e.update) == "function" then
                    e:update(self.win, self)
                end
            end
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            for k, e in pairs(self.elements) do
                if type(e.event) == "function" then
                    e:event(event, self.win, self)
                end
            end
            if type(self.event2) == "function" then return self:event2(win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        opts.win = window.create(metatype(opts.parent) == "gui.page" and opts.parent.win or opts.parent, opts.x, opts.y, opts.w, opts.h)
        return setmetatable(opts, { __name = "gui.page" })
    end,
    ---@param opts table
    ---@return gui.button
    button = function(opts)
        opts.x = default(math.floor(opts.x), 1) expect("x", opts.x, "number")
        opts.y = default(math.floor(opts.y), 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.text = default(opts.text, "button") expect("text", opts.text, "string")
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.bracketColor = default(opts.bracketColor, colors.gray) expect("bracketColor", opts.bracketColor, "number")
        opts.brackets = default(opts.brackets, "[]") expect("brackets", opts.brackets, "string") expect_min("brackets length", #opts.brackets, 2)
        opts.draw = default(opts.draw, function(self, win, parent)
            local x, y = win.getCursorPos()
            local fg, bg = win.getTextColor(), win.getBackgroundColor()
            win.setCursorPos(self.x, self.y)
            win.setBackgroundColor(self.bg)
            win.setTextColor(self.bracketColor) win.write(self.brackets:sub(1,1))
            win.setTextColor(self.fg)           win.write(self.text)
            win.setTextColor(self.bracketColor) win.write(self.brackets:sub(2,2))
            win.setBackgroundColor(bg) win.setTextColor(fg)
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            if self.onClick then
                if event.type == "mouse_click" then
                    if event.button == 1 then
                        local wx, wy = 1, 1
                        if win.getPosition then
                            wx, wy = win.getPosition()
                        end
                        if (event.x - wx + 1 >= self.x and event.x - wx + 1 <= self.x + #self.text + 1) and (event.y - wy + 1 == self.y) then
                            return self.onClick(self, event, parent)
                        end
                    end
                end
            end
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("onClick", opts.onClick, "function", "nil")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        return setmetatable(opts, { __name = "gui.button" })
    end,
    ---@param opts table
    ---@return gui.text
    text = function(opts)
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.center = default(opts.center, false) expect("center", opts.center, "boolean")
        opts.content = default(opts.content, "empty text") expect("content", opts.content, "string")
        opts.w = default(opts.w, #opts.content) expect("w", opts.w, "number")
        opts.h = default(opts.h, 1) expect("h", opts.h, "number")
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
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
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        opts.event = default(opts.event, function(self, event, win, parent)
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        return setmetatable(opts, { __name = "gui.text" })
    end,
    ---@param opts table
    ---@return gui.textField
    textField = function(opts)
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.default = default(opts.default, "") expect("default", opts.default, "string")
        expect("hideChar", opts.hideChar, "string", "nil")
        opts.content = default(opts.content, opts.default) expect("content", opts.content, "string")
        opts.selected = default(opts.selected, false) expect("selected", opts.selected, "boolean")
        opts.w = default(opts.w, 12) expect("w", opts.w, "number")
        opts.fg = default(opts.fg, term.getTextColor()) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, term.getBackgroundColor()) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
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
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            if term.isCursorVisible() and self.selected then
                win.setCursorBlink(false)
            end
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
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
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        return setmetatable(opts, { __name = "gui.textField" })
    end,
    run = function(page)
        local dos = require "dos"
        while not page.__CLOSE do
            term.reset()
            page:draw(term)
            local event = dos.event.new(os.pullEventRaw())
            page:event(event, term)
            page:update(term)
        end
    end
}, {
    __name = "dos.gui", __newindex = function(self, k, v)
        local immutable = { "drawBox", "page", "button", "text", "textField", "run" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end
})