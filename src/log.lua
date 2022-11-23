require "dos.src.ext"
local lib = {
    typeDisplay = {
        ["log.info"]  = "INFO",
        ["log.debug"] = "DEBUG",
        ["log.error"] = "ERROR",
    },
    LOGS = {}
}
lib.info = function(msg)
    table.insert(lib.LOGS, setmetatable({ msg = tostring(msg), time = os.time() }, { __name = "log.info" }))
end
lib.debug = function(msg)
    table.insert(lib.LOGS, setmetatable({ msg = tostring(msg), time = os.time() }, { __name = "log.debug" }))
end
lib.error = function(msg)
    table.insert(lib.LOGS, setmetatable({ msg = tostring(msg), time = os.time() }, { __name = "log.error" }))
end
lib.display = function(filter)
    local s = ""
    for log in ipairs(lib.LOGS) do
        if table.contains(type(filter) == "table" and filter or { filter }, metatype(log)) then
            s = s .. "[" .. (lib.typeDisplay[metatype(log)] or "?") .. "] "
            term.setTextColor(metatype(log) == "log.error" and colors.red or colors.white)
            s = s .. tostring(os.date("%c", log.time)) .. tostring(log.msg) .. "\n"
        end
    end
    return s
end
lib.infos = function() return lib.display("log.info") end
lib.debugs = function() return lib.display("log.debug") end
lib.errors = function() return lib.display("log.error") end
lib.show = function(filter)
    print("LOGS:")
    print(lib.display(filter))
    os.pullEventsRaw({ "terminate", "key" })
end
return lib