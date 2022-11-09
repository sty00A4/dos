require("deepslate.src.ext")
local lib = {}
lib.gui = require("deepslate.src.gui")
lib.event = require("deepslate.src.event")
lib.prompt = require("deepslate.src.prompt")
lib.permit = require("deepslate.src.permit")

local SHELL_RUN = shell.run
local SHELL_EXECUTE = shell.execute
local SHELL_RESOLVE = shell.resolve
local OS_RUN = os.run
local OS_SHUTDOWN = os.shutdown
local OS_REBOOT = os.reboot
local OS_SET_COMPUTER_LABEL = os.setComputerLabel
shell.run = function(...)
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.run")
    local success, res, err = pcall(SHELL_RUN, ...) if err ~= nil then error(err, 2) end
    return res
end
shell.execute = function(command, ...)
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.execute")
    local success, res, err = pcall(SHELL_EXECUTE, command, ...) if err ~= nil then error(err, 2) end
    return res
end
shell.resolve = function(path)
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.resolve")
    local success, res, err = pcall(SHELL_RESOLVE, path) if err ~= nil then error(err, 2) end
    return res
end
os.run = function(env, path, ...)
    lib.permit.checkPermission(shell.getRunningProgram(), "os.run")
    local success, res, err = pcall(OS_RUN, env, path, ...) if err ~= nil then error(err, 2) end
    return res
end
os.shutdown = function()
    lib.permit.checkPermission(shell.getRunningProgram(), "os.shutdown")
    local success, res, err = pcall(OS_SHUTDOWN) if err ~= nil then error(err, 2) end
    return res
end
os.reboot = function()
    lib.permit.checkPermission(shell.getRunningProgram(), "os.reboot")
    local success, res, err = pcall(OS_REBOOT) if err ~= nil then error(err, 2) end
    return res
end
os.setComputerLabel = function(label)
    lib.permit.checkPermission(shell.getRunningProgram(), "os.setComputerLabel")
    local success, res, err = pcall(OS_SET_COMPUTER_LABEL, label) if err ~= nil then error(err, 2) end
    return res
end

return setmetatable(lib, {
    __name = "deepslate", __newindex = function(self, k, v)
        local immutable = { "gui", "event", "prompt" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end,
})