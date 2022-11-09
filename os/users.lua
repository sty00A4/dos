local lib = {}
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/users.txt") then
    local FILE = fs.open(".data/users.txt", "w") FILE.write("{}") FILE.close()
end
local FUSERS = fs.open(".data/users.txt", "r")
lib.users = textutils.unserialize(FUSERS.readAll())
FUSERS.close()

lib.startUser = function(name)
    expect("name", name, "string")
    if not table.contains(lib.users, name) then error("user '"..name.."' is not registered", 2) end
    if not fs.exists("users") then fs.makeDir("users") end
    if not fs.exists("users/"..name) then fs.makeDir("users/"..name) end
    lib.current = name
    shell.setDir("users/"..name)
end
lib.new = function(name, password)
    expect("name", name, "string")
    expect("password", password, "string")
    lib.users[name] = {
        password = password,
        permits = { "gps", "http", "io", "turtle" }
    }
end
lib.getUser = function(name)
    expect("name", name, "string")
    return lib.users[name]
end
lib.getCurrentUser = function()
    return lib.users[lib.current or 0]
end

return lib