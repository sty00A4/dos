local lib = {}
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/users.txt") then
    local FILE = fs.open(".data/users.txt", "w") FILE.write("{}") FILE.close()
end
local FUSERS = fs.open(".data/users.txt", "r")
lib.users = textutils.unserialise(FUSERS.readAll())
FUSERS.close()

lib.startUser = function(name)
    expect("name", name, "string")
    if not table.containsKey(lib.users, name) then error("user '"..name.."' is not registered", 2) end
    if name == "root" then
        lib.current = name
        shell.setDir("")
        return
    end
    if not fs.exists("users") then fs.makeDir("users") end
    if not fs.exists("users/"..name) then fs.makeDir("users/"..name) end
    lib.current = name
    shell.setDir("users/"..name)
end
lib.newBasic = function(name, password)
    expect("name", name, "string")
    expect("password", password, "string")
    lib.users[name] = {
        password = password,
        permits = { "gps", "http", "io", "turtle" }
    }
    lib.update()
end
lib.new = function(name, password, permits)
    expect("name", name, "string")
    expect("password", password, "string")
    lib.users[name] = {
        password = password,
        permits = permits
    }
    lib.update()
end
lib.update = function()
    local file = fs.open(".data/users.txt", "w")
    file.write(textutils.serialize(lib.users))
    file.close()
end
lib.getUser = function(name)
    expect("name", name, "string", "nil")
    return lib.users[name or 0]
end
lib.getCurrentUser = function()
    return lib.users[lib.current or 0]
end

return lib