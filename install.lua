term.clear()
term.setCursorPos(1, 1)
shell.setDir("")
shell.execute("wget", "https://github.com/sty00A4/dos", "dos")
local dos = require("dos")
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/permits.txt") then local FILE = fs.open(".data/permits.txt", "w") FILE.write("{}") FILE.close() end
local FILE
local rootPassword = dos.prompt.input("root user password", "", "*", 20)
FILE = fs.open(".data/users.txt", "w")
FILE.write(("{\n  root = {\n    password = %s, permits = true\n  }\n}"):format(rootPassword))
FILE.close()
if fs.exists("startup.lua") then fs.delete("startup.lua") end
fs.copy("dos/startup.lua", "startup.lua")