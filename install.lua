term.clear()
term.setCursorPos(1, 1)
shell.setDir("")
print("installing dos module")
local success = shell.execute("wget", "https://github.com/sty00A4/dos", "dos")
if not success then error("'wget https://github.com/sty00A4/dos dos' failed") end
local dos = require("dos")
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/permits.txt") then local FILE = fs.open(".data/permits.txt", "w") FILE.write("{}") FILE.close() end
local FILE
local rootPassword = dos.prompt.input("root user password", "", "*", 20)
FILE = fs.open(".data/users.txt", "w")
FILE.write(("{\n  root = {\n    password = \"%\", permits = true\n  }\n}"):format(rootPassword))
FILE.close()
if fs.exists("startup.lua") then fs.delete("startup.lua") end
fs.copy("dos/startup.lua", "startup.lua")
dos.users.startUser("root")