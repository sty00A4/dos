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

lib.grandPermisstion = function(path, f)
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
lib.hasPermisstion = function(path, f)
    expect("path", path, "string")
    expect("f", f, "string")
    if path:sub(1, #"rom") == "rom" then return true end
    if lib.permits[path] then
        if type(lib.permits[path]) == "boolean" then return true end
        return table.containsStart(lib.permits[path], f)
    end
    return false
end
lib.hasUserPermisstion = function(name, f)
    expect("name", name, "string")
    expect("f", f, "string")
    return table.containsStart(lib.users.getUser(name).permits, f)
end
lib.checkPermission = function(path, f)
    if not path then return end
    expect("path", path, "string")
    expect("f", f, "string")
    if not lib.hasPermisstion(path, f) then
        local allow, once = lib.prompt.permit(path.." wants permission to: "..f, 30)
        if not allow then
            error("no permission for "..f, 2)
            if settings.get("permit.exit", true) then os.exit() end
        end
        if not once then lib.grandPermisstion(path, f) end
        term.clear()
    end
end
lib.checkUserPermission = function(name, f)
    if name == nil then return end
    expect("name", name, "string")
    expect("f", f, "string")
    if not lib.hasUserPermisstion(name, f) then
        local password
        repeat
            password = lib.prompt.input("root password", "", "*")
            if #password == 0 then break end
        until password == lib.users.root.password
        if password ~= lib.users.root.password then
            error("no permission for "..f, 2)
        end
        term.clear()
    end
end

return lib