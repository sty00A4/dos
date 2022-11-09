local lib = {}
lib.prompt = require("deepslate.src.prompt")
if not fs.exists(".data") then fs.makeDir(".data") end
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
    if path:sub(1, #"rom") then return true end
    if lib.permits[path] then
        if type(lib.permits[path]) == "boolean" then return true end
        if table.contains(lib.permits[path], f) then
            return true
        end
    end
    return false
end
lib.checkPermission = function(path, f)
    if not path then return end
    expect("path", path, "string")
    expect("f", f, "string")
    if not lib.hasPermisstion(path, f) then
        local allow, once = lib.prompt.permit(path.." wants permission to: "..f, 30)
        if not allow then error("no permission for "..f, 2) end
        if not once then lib.grandPermisstion(path, f) end
        term.clear()
    end
end

return lib