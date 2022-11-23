local dos = require("dos")
term.reset()
local success, err = true
if success then
    dos.log.info "dos.programs.login"
    success, err = pcall(dos.programs.login)
end
if success then
    dos.log.info "dos.programs.desktop"
    success, err = pcall(dos.programs.desktop)
end
if not success then
    term.reset()
    if err then term.setTextColor(colors.red) print(err) term.setTextColor(colors.white) end
    dos.log.show()
end
os.shutdown()