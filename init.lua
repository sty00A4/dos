require("dos.src.ext")
local lib = {}
lib.gui = require("dos.src.gui")
lib.event = require("dos.src.event")
lib.prompt = require("dos.os.prompt")
lib.permit = require("dos.os.permit")

local SHELL_RUN = shell.run
local SHELL_EXECUTE = shell.execute
local SHELL_RESOLVE = shell.resolve
local SHELL_PATH = shell.path
-- setPath(path), resolvePogram(command), clearAlias(command), switchTab(id)
local OS_RUN = os.run
local OS_SHUTDOWN = os.shutdown
local OS_REBOOT = os.reboot
local OS_SET_COMPUTER_LABEL = os.setComputerLabel
local SETTINGS_DEFINE = settings.define
local SETTINGS_UNDEFINE = settings.undefine
local SETTINGS_SET = settings.set
local SETTINGS_GET = settings.get
local SETTINGS_UNSET = settings.unset
local SETTINGS_CLEAR = settings.clear
local SETTINGS_LOAD = settings.load
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
shell.path = function()
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.path")
    local success, res, err = pcall(SHELL_PATH) if err ~= nil then error(err, 2) end
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
settings.define = function(name, options)
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.define")
    local success, res, err = pcall(SETTINGS_DEFINE, name, options) if err ~= nil then error(err, 2) end
    return res
end
settings.undefine = function(name)
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.undefine")
    local success, res, err = pcall(SETTINGS_UNDEFINE, name) if err ~= nil then error(err, 2) end
    return res
end
settings.set = function(name, value)
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.set")
    local success, res, err = pcall(SETTINGS_SET, name, value) if err ~= nil then error(err, 2) end
    return res
end
settings.get = function(name, default)
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.get")
    local success, res, err = pcall(SETTINGS_GET, name, default) if err ~= nil then error(err, 2) end
    return res
end
settings.unset = function(name)
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.unset")
    local success, res, err = pcall(SETTINGS_UNSET, name) if err ~= nil then error(err, 2) end
    return res
end
settings.clear = function()
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.clear")
    local success, res, err = pcall(SETTINGS_CLEAR) if err ~= nil then error(err, 2) end
    return res
end
settings.load = function(sPath)
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.load")
    local success, res, err = pcall(SETTINGS_LOAD, sPath) if err ~= nil then error(err, 2) end
    return res
end

return setmetatable(lib, {
    __name = "dos", __newindex = function(self, k, v)
        local immutable = { "gui", "event", "prompt", "permit" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end,
})