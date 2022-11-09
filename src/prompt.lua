require("deepslate.src.ext")
local gui = require("deepslate.src.gui")
local event = require("deepslate.src.event")
return setmetatable({
    ---a confirm prompt
    ---@param text string
    ---@param w number|nil
    ---@param h number|nil
    ---@param fg number|nil
    ---@param bg number|nil
    ---@return boolean
    confirm = function(text, w, h, fg, bg, bracketColor)
        local W, H = term.getSize()
        expect("argument #1", text, "string")
        if w then
            expect("argument #2", w, "number") expect_min("argument #2", w, 1)
            w = w + 2
        end
        w = w or math.min(#text + 2, W)
        expect("argument #2", w, "number") expect_min("argument #2", w, 1)
        if h then
            expect("argument #3", h, "number") expect_min("argument #3", h, 12)
            h = h + 3
        end
        h = h or math.min(#text:linesFromWidth(w) + 3, H)
        expect("argument #3", h, "number") expect_min("argument #3", h, 1)
        expect("argument #4", fg, "number", "nil")
        expect("argument #5", bg, "number", "nil")
        expect("argument #6", bracketColor, "number", "nil")
        local TERM = term.current()
        local win = window.create(TERM, math.floor(W/2 - w/2), math.floor(H/2 - h/2), w, h)
        term.redirect(win)
        local gText = gui.text{ x=1, y=2, w=w, h=h, content=text, fg = fg, bg = bg or colors.gray, center = true }
        local cancelButton = gui.button {
            text="CANCEL", x=w-#"CANCEL"-1, y=h,
            fg=colors.red, bg=bg or colors.gray, bracketColor=bracketColor or colors.lightGray,
            onClick = function() return true end
        }
        local okButton = gui.button {
            text="OK", x=w-#cancelButton.text-5, y=h,
            fg=colors.green, bg=bg or colors.gray, bracketColor=bracketColor or colors.lightGray,
            onClick = function() return true end
        }
        term.redirect(TERM)
        local res = false
        while true do
            win.setTextColor(fg or colors.white)
            win.setBackgroundColor(bg or colors.gray)
            win.clear()
            gText:draw(win)
            okButton:draw(win) cancelButton:draw(win)
            local e = event.new(os.pullEvents({ "mouse_click", "key" }))
            if e.type == "key" then if e.key == keys.enter then res = true break end end
            local okRes = okButton:event(e, win) if okRes then res = true break end
            local cancelRes = cancelButton:event(e, win) if cancelRes then break end
        end
        win.setVisible(false)
        return res
    end,
    info = function(text, w, h, fg, bg, bracketColor)
        local W, H = term.getSize()
        expect("argument #1", text, "string")
        if w then
            expect("argument #2", w, "number") expect_min("argument #2", w, 1)
            w = w + 2
        end
        w = w or math.min(#text + 2, W)
        expect("argument #2", w, "number") expect_min("argument #2", w, 1)
        if h then
            expect("argument #3", h, "number") expect_min("argument #3", h, 12)
            h = h + 3
        end
        h = h or math.min(#text:linesFromWidth(w) + 3, H)
        expect("argument #3", h, "number") expect_min("argument #3", h, 1)
        expect("argument #4", fg, "number", "nil")
        expect("argument #5", bg, "number", "nil")
        expect("argument #6", bracketColor, "number", "nil")
        local TERM = term.current()
        local win = window.create(TERM, math.floor(W/2 - w/2), math.floor(H/2 - h/2), w, h)
        term.redirect(win)
        local gText = gui.text{ x=1, y=2, w=w, h=h, content=text, fg = fg, bg = bg or colors.gray, center = true }
        local okButton = gui.button {
            text="OK", x=w-#"OK"-1, y=h,
            fg=colors.green, bg=bg or colors.gray, bracketColor=bracketColor or colors.lightGray,
            onClick = function() return true end
        }
        term.redirect(TERM)
        local res = false
        while true do
            win.setTextColor(fg or colors.white)
            win.setBackgroundColor(bg or colors.gray)
            win.clear()
            gText:draw(win)
            okButton:draw(win)
            local e = event.new(os.pullEvents({ "mouse_click", "key" }))
            if e.type == "key" then if e.key == keys.enter then res = true break end end
            local okRes = okButton:event(e, win) if okRes then res = true break end
        end
        win.setVisible(false)
        return res
    end,
    input = function(text, default, w, h, fg, bg, bracketColor)
        local W, H = term.getSize()
        expect("argument #1", text, "string")
        if w then
            expect("argument #2", w, "number") expect_min("argument #2", w, 1)
            w = w + 2
        end
        w = w or math.min(#text + 2, W)
        expect("argument #2", w, "number") expect_min("argument #2", w, 1)
        if h then
            expect("argument #3", h, "number") expect_min("argument #3", h, 12)
            h = h + 4
        end
        h = h or math.min(#text:linesFromWidth(w) + 4, H)
        expect("argument #3", h, "number") expect_min("argument #3", h, 1)
        expect("argument #4", fg, "number", "nil")
        expect("argument #5", bg, "number", "nil")
        expect("argument #6", bracketColor, "number", "nil")
        local TERM = term.current()
        local win = window.create(TERM, math.floor(W/2 - w/2), math.floor(H/2 - h/2), w, h)
        term.redirect(win)
        local gText = gui.text{ x=1, y=2, w=w, h=h, content=text, fg = fg, bg = bg or colors.gray, center = true }
        local inputText = gui.textField{ x=2, y=h-1, w=w-2, default=default, fg = fg }
        local okButton = gui.button {
            text="OK", x=w-#"OK"-1, y=h,
            fg=colors.green, bg=bg or colors.gray, bracketColor=bracketColor or colors.lightGray,
            onClick = function() return true end
        }
        term.redirect(TERM)
        while true do
            win.setTextColor(fg or colors.white)
            win.setBackgroundColor(bg or colors.gray)
            win.clear()
            gText:draw(win)
            okButton:draw(win)
            inputText:draw(win)
            local e = event.new(os.pullEvents({ "mouse_click", "char", "key" }))
            win.setCursorBlink(false)
            inputText:event(e, win)
            if e.type == "key" then if e.key == keys.enter then break end end
            local okRes = okButton:event(e, win) if okRes then break end
        end
        win.setVisible(false)
        return inputText.content
    end,
}, {
    __name = "prompt", __newindex = function (self, k, v)
        local immutable = { "confirm", "info", "input", "number" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end
})