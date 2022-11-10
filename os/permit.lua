local lib = {}
lib.prompt = require("dos.os.prompt")
lib.users = require("dos.os.users")
if not fs.exists(".data") then fs.makeDir(".data") end
if not fs.exists(".data/permits.txt") then
    local FILE = fs.open(".data/permits.txt", "w") FILE.write("{}") FILE.close()
end
local FPERMIT = fs.open(".data/permits.txt", "r")
lib.permits = textutils.unserialize(FPERMIT.readAll())
FPERMIT.close()

lib.grandPermission = function(path, f)
    expect("path", path, "string")
    expect("f", f, "string")
    if lib.permits[path] then
        if type(lib.permits[path]) == "boolean" then return end
        if not table.contains(lib.permits[path], f) then
            table.insert(lib.permits[path], f)
        end
    else
        lib.permits[path] = { f }
    end
    if not fs.exists(".data") then fs.makeDir(".data") end
    local fPermit = fs.open(".data/permits.txt", "w")
    fPermit.write(textutils.serialize(lib.permits))
    fPermit.close()
end
lib.grandAllPermission = function(path)
    expect("path", path, "string")
    lib.permits[path] = true
    if not fs.exists(".data") then fs.makeDir(".data") end
    local fPermit = fs.open(".data/permits.txt", "w")
    fPermit.write(textutils.serialize(lib.permits))
    fPermit.close()
end
lib.hasPermission = function(path, f)
    expect("path", path, "string")
    expect("f", f, "string")
    if path:sub(1, #"rom") == "rom" then return true end
    for path_, _ in pairs(lib.permits) do
        if path:startsWith(path_) and path ~= path_ then
            return lib.hasPermission(path_, f)
        end
    end
    if lib.permits[path] then
        if type(lib.permits[path]) == "boolean" then return true end
        return table.containsStart(lib.permits[path], f)
    end
    return false
end
lib.hasUserPermission = function(name, f)
    expect("name", name, "string")
    expect("f", f, "string")
    if type(lib.users.getUser(name).permits) == "boolean" and lib.users.getUser(name).permits then
        return true
    end
    return table.containsStart(lib.users.getUser(name).permits, f)
end
lib.checkPermission = function(path, f)
    if not path then return end
    expect("path", path, "string")
    expect("f", f, "string")
    if not lib.hasPermission(path, f) then
        local allow, once = lib.prompt.permit(path.." wants permission to: "..f, 30)
        if not allow then
            error("no permission for "..f, 3)
            if settings.get("permit.exit", true) then os.exit() end
        end
        if not once then lib.grandPermission(path, f) end
        term.clear()
    end
end
lib.checkPathPermission = function(name, path)
    if not name then return end
    if not path then error("no permission for "..path, 3) end
    expect("name", name, "string")
    expect("path", path, "string")
    if lib.hasUserPermission(name, "rootFiles") then return end
    if not fs.exists("users/"..name) then error("no permission for "..path) end
    if not path:startsWith("users/"..name) then
        local password
        repeat password = lib.prompt.input("root password", "", "*")
            if #password == 0 then break end
        until password == lib.users.root.password
        if password ~= lib.users.root.password then
            error("no permission for "..path, 3)
        end
    end
end
lib.checkUserPermission = function(name, f)
    if name == nil then return end
    expect("name", name, "string")
    expect("f", f, "string")
    if not lib.hasUserPermission(name, f) then
        local password
        repeat password = lib.prompt.input("root password", "", "*")
            if #password == 0 then break end
        until password == lib.users.root.password
        if password ~= lib.users.root.password then
            error("no permission for "..f, 3)
        end
        term.clear()
    end
end

return lib