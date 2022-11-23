require("dos.src.ext")
local status, theme = pcall(require, "dos.os.theme")
if not status then theme = {
    bg = colors.black,
    bg2 = colors.gray,
    mark = colors.lightGray,
    fg = colors.white,
    ok = colors.green,
    fail = colors.red,
} end
local __ERRORS = 0
local function error_count(count, message, level)
    if __ERRORS > count then error(message, (level or 1) + 1) end
    __ERRORS = __ERRORS + 1
end
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
    ---@return gui.page
    page = function(opts)
        local W, H = term.getSize()
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.w = default(opts.w, W) expect("w", opts.w, "number")
        opts.h = default(opts.h, H) expect("h", opts.h, "number")
        opts.elements = default(opts.elements, {}) expect("elements", opts.elements, "table")
        opts.parent = default(opts.parent, term.current()) expect("parent", opts.parent, "table", "gui.page")
        for k, e in pairs(opts.elements) do expect(k, e, "gui") end
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            self.win.setBackgroundColor(self.bg)
            self.win.setTextColor(self.fg)
            local res = {}
            if self.active then
                for k, e in pairs(self.elements) do
                    if type(e.draw) == "function" then
                        res[k] = e:draw(self.win, self)
                    end
                end
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
            return res
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            local res = {}
            if self.active then
                for k, e in pairs(self.elements) do
                    if type(e.update) == "function" then
                        res[k] = e:update(self.win, self)
                    end
                end
            end
            if type(self.update2) == "function" then return self:update2(win, parent) end
            return res
        end) expect("update", opts.update, "function")
        opts.init = default(opts.init, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            local res = {}
            for k, e in pairs(self.elements) do
                if type(e.init) == "function" then
                    res[k] = e:init(self.win, self)
                end
            end
            if type(self.init2) == "function" then return self:init2(win, parent) end
            return res
        end) expect("init", opts.init, "function")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            local res = {}
            if self.active then
                for k, e in pairs(self.elements) do
                    if type(e.event) == "function" then
                        res[k] = e:event(event, self.win, self)
                    end
                end
            end
            if type(self.event2) == "function" then return self:event2(win, parent) end
            return res
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("init2", opts.init2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        opts.win = window.create(metatype(opts.parent) == "gui.page" and opts.parent.win or opts.parent, opts.x, opts.y, opts.w, opts.h)
        return setmetatable(opts, { __name = "gui.page" })
    end,
    ---@param opts table
    ---@return gui.button
    button = function(opts)
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.text = default(opts.text, "button") expect("text", opts.text, "string")
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.bracketColor = default(opts.bracketColor, colors.gray) expect("bracketColor", opts.bracketColor, "number")
        opts.brackets = default(opts.brackets, "[]") expect("brackets", opts.brackets, "string") expect_min("brackets length", #opts.brackets, 2)
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.visible then
                local fg, bg = win.getTextColor(), win.getBackgroundColor()
                win.setCursorPos(self.x, self.y)
                win.setBackgroundColor(self.bg)
                win.setTextColor(self.bracketColor) win.write(self.brackets:sub(1,1))
                win.setTextColor(self.fg)           win.write(self.text)
                win.setTextColor(self.bracketColor) win.write(self.brackets:sub(2,2))
                win.setBackgroundColor(bg) win.setTextColor(fg)
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        expect("init", opts.init, "function", "nil")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.active then
                if self.onClick then
                    if event.type == "mouse_click" then
                        if event.button == 1 then
                            local wx, wy = 1, 1
                            if win.getPosition then
                                wx, wy = win.getPosition()
                            end
                            if self:_mouseTouch(event.x - wx + 1, event.y - wy + 1) then
                                return self.onClick(self, event, parent)
                            end
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
        opts._mouseTouch = function(self, x, y)
            return (x >= self.x and x <= self.x + #self.text + 1) and (y == self.y)
        end
        return setmetatable(opts, { __name = "gui.button" })
    end,
    ---@param opts table
    ---@return gui.text
    text = function(opts)
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.center = default(opts.center, false) expect("center", opts.center, "boolean")
        opts.content = default(opts.content, "empty text") expect("content", opts.content, "string")
        opts.w = default(opts.w, #opts.content) expect("w", opts.w, "number")
        opts.h = default(opts.h, 1) expect("h", opts.h, "number")
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.visible then
                local fg, bg = win.getTextColor(), win.getBackgroundColor()
                win.setBackgroundColor(self.bg) win.setTextColor(self.fg)
                for i, line in ipairs(self.content:linesFromWidth(self.w)) do
                    if i > self.h then break end
                    win.setCursorPos(self.x, self.y+i-1)
                    win.write((" "):rep(self.w))
                    if self.center then
                        win.setCursorPos(self.x+self.w/2-#line/2, self.y+i-1)
                    else
                        win.setCursorPos(self.x, self.y+i-1)
                    end
                    win.write(line)
                end
                win.setBackgroundColor(bg) win.setTextColor(fg)
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        expect("init", opts.init, "function", "nil")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        opts._mouseTouch = function(self, x, y)
            return (x >= self.x and x <= self.x + self.w - 1) and (y >= self.y and y <= self.y + self.h - 1)
        end
        return setmetatable(opts, { __name = "gui.text" })
    end,
    ---@param opts table
    ---@return gui.textField
    textField = function(opts)
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.default = default(opts.default, "") expect("default", opts.default, "string")
        expect("hideChar", opts.hideChar, "string", "nil")
        expect("chars", opts.chars, "string", "nil")
        opts.content = default(opts.content, opts.default) expect("content", opts.content, "string")
        opts.selected = default(opts.selected, false) expect("selected", opts.selected, "boolean")
        opts.w = default(opts.w, 12) expect("w", opts.w, "number")
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.visible then
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
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if term.isCursorVisible() and self.selected then
                win.setCursorBlink(false)
            end
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        expect("init", opts.init, "function", "nil")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.active then
                if event.type == "mouse_click" then
                    if event.button == 1 then
                        local wx, wy = 1, 1
                        if metatype(win.getPosition) == "function" then
                            wx, wy = win.getPosition()
                        end
                        self.selected = self:_mouseTouch(event.x - wx + 1, event.y - wy + 1)
                    end
                end
                if self.selected then
                    if event.type == "char" then
                        if self.chars then
                            if not self.chars:find(event.char) then
                                return false
                            end
                        end
                        self.content = self.content .. event.char
                    end
                    if event.type == "key" then
                        if event.key == keys.backspace then
                            self.content = self.content:sub(0, math.max(0, #self.content-1))
                        end
                        if event.key == keys.enter then
                            self.selected = false
                        end
                    end
                end
            end
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        opts._mouseTouch = function(self, x, y)
            return (x >= self.x and x <= self.x + self.w - 1) and (y == self.y)
        end
        return setmetatable(opts, { __name = "gui.textField" })
    end,
    ---@param opts table
    ---@return gui.checkbox
    checkbox = function(opts)
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.bracketColor = default(opts.bracketColor, colors.gray) expect("bracketColor", opts.bracketColor, "number")
        opts.brackets = default(opts.brackets, "()") expect("brackets", opts.brackets, "string") expect_min("brackets length", #opts.brackets, 2)
        opts.symbol = default(opts.symbol, "O") expect("symbol", opts.symbol, "string")
        opts.checked = default(opts.checked, false) expect("checked", opts.checked, "boolean")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.visible then
                local fg, bg = win.getTextColor(), win.getBackgroundColor()
                win.setCursorPos(self.x, self.y)
                win.setBackgroundColor(self.bg)
                win.setTextColor(self.bracketColor) win.write(self.brackets:sub(1,1))
                win.setTextColor(self.fg)           win.write(self.checked and self.symbol or " ")
                win.setTextColor(self.bracketColor) win.write(self.brackets:sub(2,2))
                win.setBackgroundColor(bg) win.setTextColor(fg)
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        expect("init", opts.init, "function", "nil")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.active then
                if event.type == "mouse_click" then
                    if event.button == 1 then
                        local wx, wy = 1, 1
                        if win.getPosition then
                            wx, wy = win.getPosition()
                        end
                        if self:_mouseTouch(event.x - wx + 1, event.y - wy + 1) then
                            self.checked = not self.checked
                        end
                    end
                end
            end
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        opts._mouseTouch = function(self, x, y)
            return (x >= self.x and x <= self.x + 2) and (y == self.y)
        end
        return setmetatable(opts, { __name = "gui.checkbox" })
    end,
    ---@param opts table
    ---@return gui.slider
    slider = function(opts)
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.length = default(opts.length, 2) expect("length", opts.length, "number") expect_min("length", opts.length, 2)
        opts.length = math.floor(opts.length)
        opts.current = default(opts.current, 0) expect("current", opts.current, "number") expect_min("current", opts.current, 0)
        opts.current = math.floor(opts.current)
        opts.value = opts.current / opts.length
        opts.symbol = default(opts.symbol, " ") expect("symbol", opts.symbol, "string") expect_min("symbol length", #opts.symbol, 1)
        opts.selected = default(opts.selected, false) expect("selected", opts.selected, "boolean")
        opts.draw = default(opts.draw, function(self, win, parent)
            if self.visible then
                local fg, bg = win.getTextColor(), win.getBackgroundColor()
                win.setCursorPos(self.x, self.y)
                win.setBackgroundColor(self.bg)
                win.write((" "):rep(self.length))
                win.setBackgroundColor(self.fg)
                win.setCursorPos(self.x + self.current, self.y) win.write(self.symbol)
                win.setBackgroundColor(bg) win.setTextColor(fg)
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        expect("init", opts.init, "function", "nil")
        opts.update = default(opts.update, function(self, win, parent)
            if self.active then
                self.current = math.min(math.max(self.current, 0), self.length)
                self.value = self.current / (self.length - 1)
            end
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            if self.active then
                if event.type == "mouse_click" then
                    if event.button == 1 then
                        local wx, wy = 1, 1
                        if win.getPosition then
                            wx, wy = win.getPosition()
                        end
                        if self:_mouseTouch(event.x - wx + 1, event.y - wy + 1) then
                            self.selected = true
                            self.current = math.min(math.max(event.x - wx + 1 - self.x, 0), self.length - 1)
                        end
                    end
                end
                if self.selected then
                    if event.type == "mouse_drag" then
                        if event.button == 1 then
                            local wx, wy = 1, 1
                            if win.getPosition then
                                wx, wy = win.getPosition()
                            end
                            self.current = math.min(math.max(event.x - wx + 1 - self.x, 0), self.length - 1)
                        end
                    end
                    if event.type == "mouse_up" then
                        if event.button == 1 then
                            local wx, wy = 1, 1
                            if win.getPosition then
                                wx, wy = win.getPosition()
                            end
                            self.selected = false
                            self.current = math.min(math.max(event.x - wx + 1 - self.x, 0), self.length - 1)
                        end
                    end
                end
            end
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        expect("draw2", opts.draw2, "function", "nil")
        expect("update2", opts.update2, "function", "nil")
        expect("event2", opts.event2, "function", "nil")
        opts._mouseTouch = function(self, x, y)
            return (x >= self.x and x <= self.x + self.length - 1) and (y == self.y)
        end
        return setmetatable(opts, { __name = "gui.slider" })
    end,
    ---@param opts table
    ---@return gui.nav
    nav = function(opts)
        opts.active = default(opts.active, true) expect("active", opts.active, "boolean")
        opts.visible = default(opts.visible, true) expect("visible", opts.visible, "boolean")
        opts.x = default(opts.x, 1) expect("x", opts.x, "number")
        opts.y = default(opts.y, 1) expect("y", opts.y, "number")
        opts.x = math.floor(opts.x)
        opts.y = math.floor(opts.y)
        opts.buttons = default(opts.buttons, {}) expect("buttons", opts.buttons, "table")
        for k, e in ipairs(opts.buttons) do expect("buttons."..k, e, "string") end
        opts._offsets = {}
        local _x = 0 for k, e in ipairs(opts.buttons) do opts._offsets[k] = _x  _x = _x + #e + 2 end
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.bracketColor = default(opts.bracketColor, colors.gray) expect("bracketColor", opts.bracketColor, "number")
        opts.brackets = default(opts.brackets, "[]") expect("brackets", opts.brackets, "string") expect_min("brackets length", #opts.brackets, 2)
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.visible then
                local fg, bg = win.getTextColor(), win.getBackgroundColor()
                win.setCursorPos(self.x, self.y)
                for _, name in ipairs(self.buttons) do
                    win.setBackgroundColor(self.bg)
                    win.setTextColor(self.bracketColor) win.write(self.brackets:sub(1,1))
                    win.setTextColor(self.fg)           win.write(name)
                    win.setTextColor(self.bracketColor) win.write(self.brackets:sub(2,2))
                end
                win.setBackgroundColor(bg) win.setTextColor(fg)
            end
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        expect("init", opts.init, "function", "nil")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if self.active then
                if self.onClick then
                    if event.type == "mouse_click" then
                        if event.button == 1 then
                            local i = 1
                            while i <= #self.buttons do
                                local wx, wy = 1, 1
                                if win.getPosition then
                                    wx, wy = win.getPosition()
                                end
                                if self:_mouseTouch(event.x - wx + 1, event.y - wy + 1, i) then
                                    return self.onClick(self, i, event, parent)
                                end
                                i = i + 1
                            end
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
        opts._mouseTouch = function(self, x, y, i)
            return (x >= self._offsets[i] + self.x and x <= self._offsets[i] + self.x + #self.buttons[i] + 1) and (y == self.y)
        end
        return setmetatable(opts, { __name = "gui.button" })
    end,
    menu = {
        head = function(label, elements)
            local _y = 2
            local w = #label + 2
            for k, e in pairs(elements) do
                expect("elements."..k, e, "gui.menu.selection", "gui.menu.seperator")
                if e.w > w then w = e.w end
                e.y = _y
                e.x = 1
                _y = _y + 1
            end
            for _, e in pairs(elements) do e.w = w end
            return setmetatable({
                elements = elements,
                x = 1, y = 1, w = #label, label = label,
                _mouseTouch = function(self, x, y)
                    return (x >= self.x and x <= self.x + self.w + 1) and (y == self.y)
                end
            }, {
                __name = "gui.menu.head"
            })
        end,
        selection = function(label, onClick)
            return setmetatable({
                label = label, onClick = onClick,
                x = 1, w = #label, y = 1,
                _mouseTouch = function(self, x, y)
                    return (x >= self.x and x <= self.x + self.w - 1) and (y == self.y)
                end
            }, { __name = "gui.menu.selection" })
        end,
        seperator = function()
            return setmetatable({x = 1, y = 1, w = 1 }, { __name = "gui.menu.seperator" })
        end,
    },
    ---@param opts table
    ---@return gui.menuTree
    menuTree = function(opts)
        opts.fg = default(opts.fg, theme.fg) expect("fg", opts.fg, "number")
        opts.bg = default(opts.bg, theme.bg) expect("bg", opts.bg, "number")
        opts.bg2 = default(opts.bg2, theme.bg2) expect("bg2", opts.bg2, "number")
        opts.bracketColor = default(opts.bracketColor, colors.gray) expect("bracketColor", opts.bracketColor, "number")
        opts.brackets = default(opts.brackets, "<>") expect("brackets", opts.brackets, "string") expect_min("brackets length", #opts.brackets, 2)
        opts.elements = default(opts.elements, {}) expect("elements", opts.elements, "table")
        expect("selected", opts.selected, "number", "nil")
        local _x = 1
        for i, e in ipairs(opts.elements) do
            expect("elements."..i, e, "gui.menu.head")
            e.x = _x
            for _, sub in pairs(e.elements) do
                sub.x = _x
            end
            _x = _x + #e.label + 2
        end
        expect("selected", opts.selected, "string", "nil")
        opts.draw = default(opts.draw, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            local fg, bg = win.getTextColor(), win.getBackgroundColor()
            win.setCursorPos(1, 1)
            for i, element in ipairs(self.elements) do
                local x, y = win.getCursorPos()
                win.setBackgroundColor(self.bg)
                win.setTextColor(self.bracketColor) win.write(self.brackets:sub(1,1))
                win.setTextColor(self.fg)           win.write(element.label)
                win.setTextColor(self.bracketColor) win.write(self.brackets:sub(2,2))
                win.setCursorPos(x + #element.label + 2, y)
            end
            if self.selected then
                win.setBackgroundColor(self.bg2)
                local head = self.elements[self.selected]
                win.setTextColor(self.fg)
                for j, sub in ipairs(head.elements) do
                    win.setCursorPos(head.x, 1 + j)
                    if metatype(sub) == "gui.menu.selection" then
                        win.write((" "):rep(sub.w))
                        win.setCursorPos(head.x, 1 + j)
                        win.write(sub.label)
                    else
                        win.write(("-"):rep(sub.w))
                    end
                end
            end
            win.setBackgroundColor(bg) win.setTextColor(fg)
            if type(self.draw2) == "function" then return self:draw2(win, parent) end
        end) expect("draw", opts.draw, "function")
        opts.update = default(opts.update, function(self, win, parent)
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if type(self.update2) == "function" then return self:update2(win, parent) end
        end) expect("update", opts.update, "function")
        expect("init", opts.init, "function", "nil")
        opts.event = default(opts.event, function(self, event, win, parent)
            expect("event", event, "event")
            expect("win", win, "table", "gui.page")
            expect("parent", parent, "gui.page", "nil")
            if event.type == "mouse_click" and event.button == 1 then
                local wx, wy = 1, 1
                if win.getPosition then
                    wx, wy = win.getPosition()
                end
                if type(self.selected) == "number" then
                    for y, sub in ipairs(self.elements[self.selected].elements) do
                        if metatype(sub) == "gui.menu.selection" then
                            if sub:_mouseTouch(event.x - wx + 1, event.y - wy + 1) then
                                self.selected = nil
                                return sub:onClick(win, parent)
                            end
                        end
                    end
                    if self.elements[self.selected]:_mouseTouch(event.x - wx + 1, event.y - wy + 1) then
                        self.selected = nil
                        return
                    end
                end
                for i, head in ipairs(self.elements) do
                    if head:_mouseTouch(event.x - wx + 1, event.y - wy + 1) then
                        self.selected = i
                        return
                    end
                end
                self.selected = nil
            end
            if type(self.event2) == "function" then return self:event2(event, win, parent) end
        end) expect("event", opts.event, "function")
        return setmetatable(opts, { __name = "gui.menuTree" })
    end,
    run = function(page)
        local dos = require "dos"
        page:init(term)
        while not page.__CLOSE do
            page.win.clear()
            page:update(term)
            page:draw(term)
            local event = dos.event.new(os.pullEventRaw())
            term.setCursorPos(1, 1)
            page:event(event, term)
        end
    end
}, {
    __name = "dos.gui", __newindex = function(self, k, v)
        local immutable = { "drawBox", "page", "button", "text", "textField", "run" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end
})