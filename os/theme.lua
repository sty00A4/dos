local lib = {}
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/themes.txt") then
    local FILE = fs.open(".data/themes.txt", "w") FILE.write("{}") FILE.close()
end
local FPERMIT = fs.open(".data/themes.txt", "r")
lib.themes = textutils.unserialize(FPERMIT.readAll())
FPERMIT.close()
lib.themes.std = {
    bg = colors.black,
    bg2 = colors.gray,
    mark = colors.lightGray,
    fg = colors.white,
    ok = colors.green,
    fail = colors.red,
}
lib.update = function()
    local file = fs.open(".data/themes.txt", "w")
    file.write(textutils.serialize(lib.themes))
    file.close()
end
lib.change = function(name)
    local theme = lib.themes[name] or lib.themes.std
    if not theme then return end
    lib.bg = theme.bg
    lib.bg2 = theme.bg2
    lib.mark = theme.mark
    lib.fg = theme.fg
    lib.ok = theme.ok
    lib.fail = theme.fail
    lib.update()
end
lib.change("std")
return lib