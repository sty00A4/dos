require("deepslate.src.ext")
local lib = {}
lib.gui = require("deepslate.src.gui")
lib.event = require("deepslate.src.event")
lib.prompt = require("deepslate.src.prompt")
lib.permit = require("deepslate.src.permit")

local RUN = shell.run
local EXECUTE = shell.execute
local RESOLVE = shell.resolve
shell.run = function(...)
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.run")
    return RUN(...)
end
shell.execute = function(command, ...)
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.execute")
    return EXECUTE(command, ...)
end
shell.resolve = function(path)
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.resolve")
    return RESOLVE(path)
end

return setmetatable(lib, {
    __name = "deepslate", __newindex = function(self, k, v)
        local immutable = { "gui", "event", "prompt" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end,
})