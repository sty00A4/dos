term.clear()
term.setCursorPos(1, 1)
shell.setDir("")
print("installing dos module")
local success = shell.execute("wget", "https://github.com/sty00A4/dos", "dos")
if not success then error("'wget https://github.com/sty00A4/dos dos' failed") end
local dos = require("dos")
dos.permit.grandPermisstion(shell.getRunningProgram(), "os.reboot")
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/permits.txt") then local FILE = fs.open(".data/permits.txt", "w") FILE.write("{}") FILE.close() end
local FILE
local rootPassword = "" 
repeat
    rootPassword = dos.prompt.input("root user password", "", "*", 20)
until #rootPassword > 0
term.clear()
dos.users.new("root", rootPassword, true)
if fs.exists("startup.lua") then fs.delete("startup.lua") end
fs.copy("dos/startup.lua", "startup.lua")
dos.permit.grandPermisstion("startup.lua", "shell")
--fs.delete(shell.getRunningProgram())
os.reboot()