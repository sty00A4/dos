return function()
    local dos = require("dos")
    local W, H = term.getSize()
    local page = dos.gui.page { elements = {
        menu = dos.gui.menuTree { elements = {
            dos.gui.menu.head("#", {
                dos.gui.menu.selection("shutdown", function() os.shutdown() end),
                dos.gui.menu.selection("reboot", function() os.reboot() end),
            })
        } }
    } }
    return dos.gui.run(page)
end