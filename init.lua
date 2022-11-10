require("dos.src.ext")
local lib = {}
lib.gui = require("dos.src.gui")
lib.event = require("dos.src.event")
lib.prompt = require("dos.os.prompt")
lib.permit = require("dos.os.permit")
lib.users = require("dos.os.users")
lib.theme = require("dos.os.theme")
lib.programs = {
    login = require("dos.os.programs.login"),
    desktop = require("dos.os.programs.desktop"),
}

local SHELL_RUN = shell.run
local SHELL_EXECUTE = shell.execute
local SHELL_RESOLVE = shell.resolve
local SHELL_PATH = shell.path
local SHELL_SET_PATH = shell.setPath
local SHELL_RESOLVE_PROGRAM = shell.resolveProgram
local SHELL_CLEAR_ALIAS = shell.clearAlias
local SHELL_SWITCH_TAB = shell.switchTab
local OS_RUN = os.run
local OS_SHUTDOWN = os.shutdown
local OS_REBOOT = os.reboot
local OS_SET_COMPUTER_LABEL = os.setComputerLabel
local SETTINGS_DEFINE = settings.define
local SETTINGS_UNDEFINE = settings.undefine
local SETTINGS_SET = settings.set
local SETTINGS_UNSET = settings.unset
local SETTINGS_CLEAR = settings.clear
local SETTINGS_LOAD = settings.load
local FS_MAKE_DIR = fs.makeDir
local FS_MOVE = fs.move
local FS_COPY = fs.copy
local FS_DELETE = fs.delete
local FS_OPEN = fs.open
-- http, io, turtle
shell.run = function(...)
    lib.permit.checkUserPermission(lib.users.current, "shell.run")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.run")
    local success, res, err = pcall(SHELL_RUN, ...) if err ~= nil then error(err, 2) end
    return res
end
shell.execute = function(command, ...)
    lib.permit.checkUserPermission(lib.users.current, "shell.execute")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.execute")
    local success, res, err = pcall(SHELL_EXECUTE, command, ...) if err ~= nil then error(err, 2) end
    return res
end
shell.resolve = function(path)
    lib.permit.checkUserPermission(lib.users.current, "shell.resolve")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.resolve")
    local success, res, err = pcall(SHELL_RESOLVE, path) if err ~= nil then error(err, 2) end
    return res
end
shell.path = function()
    lib.permit.checkUserPermission(lib.users.current, "shell.path")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.path")
    local success, res, err = pcall(SHELL_PATH) if err ~= nil then error(err, 2) end
    return res
end
shell.setPath = function(path)
    lib.permit.checkUserPermission(lib.users.current, "shell.setPath")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.setPath")
    local success, res, err = pcall(SHELL_SET_PATH, path) if err ~= nil then error(err, 2) end
    return res
end
shell.resolveProgram = function(command)
    lib.permit.checkUserPermission(lib.users.current, "shell.resolveProgram")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.resolveProgram")
    local success, res, err = pcall(SHELL_RESOLVE_PROGRAM, command) if err ~= nil then error(err, 2) end
    return res
end
shell.clearAlias = function(command)
    lib.permit.checkUserPermission(lib.users.current, "shell.clearAlias")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.clearAlias")
    local success, res, err = pcall(SHELL_CLEAR_ALIAS, command) if err ~= nil then error(err, 2) end
    return res
end
shell.switchTab = function(id)
    lib.permit.checkUserPermission(lib.users.current, "shell.switchTab")
    lib.permit.checkPermission(shell.getRunningProgram(), "shell.switchTab")
    local success, res, err = pcall(SHELL_SWITCH_TAB, id) if err ~= nil then error(err, 2) end
    return res
end
os.run = function(env, path, ...)
    lib.permit.checkUserPermission(lib.users.current, "os.run")
    lib.permit.checkPermission(shell.getRunningProgram(), "os.run")
    local success, res, err = pcall(OS_RUN, env, path, ...) if err ~= nil then error(err, 2) end
    return res
end
os.shutdown = function()
    lib.permit.checkUserPermission(lib.users.current, "os.shutdown")
    lib.permit.checkPermission(shell.getRunningProgram(), "os.shutdown")
    local success, res, err = pcall(OS_SHUTDOWN) if err ~= nil then error(err, 2) end
    return res
end
os.reboot = function()
    lib.permit.checkUserPermission(lib.users.current, "os.reboot")
    lib.permit.checkPermission(shell.getRunningProgram(), "os.reboot")
    local success, res, err = pcall(OS_REBOOT) if err ~= nil then error(err, 2) end
    return res
end
os.setComputerLabel = function(label)
    lib.permit.checkUserPermission(lib.users.current, "os.setComputerLabel")
    lib.permit.checkPermission(shell.getRunningProgram(), "os.setComputerLabel")
    local success, res, err = pcall(OS_SET_COMPUTER_LABEL, label) if err ~= nil then error(err, 2) end
    return res
end
settings.define = function(name, options)
    lib.permit.checkUserPermission(lib.users.current, "settings.define")
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.define")
    local success, res, err = pcall(SETTINGS_DEFINE, name, options) if err ~= nil then error(err, 2) end
    return res
end
settings.undefine = function(name)
    lib.permit.checkUserPermission(lib.users.current, "settings.undefine")
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.undefine")
    local success, res, err = pcall(SETTINGS_UNDEFINE, name) if err ~= nil then error(err, 2) end
    return res
end
settings.set = function(name, value)
    lib.permit.checkUserPermission(lib.users.current, "settings.set")
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.set")
    local success, res, err = pcall(SETTINGS_SET, name, value) if err ~= nil then error(err, 2) end
    return res
end
settings.unset = function(name)
    lib.permit.checkUserPermission(lib.users.current, "settings.unset")
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.unset")
    local success, res, err = pcall(SETTINGS_UNSET, name) if err ~= nil then error(err, 2) end
    return res
end
settings.clear = function()
    lib.permit.checkUserPermission(lib.users.current, "settings.clear")
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.clear")
    local success, res, err = pcall(SETTINGS_CLEAR) if err ~= nil then error(err, 2) end
    return res
end
settings.load = function(sPath)
    lib.permit.checkUserPermission(lib.users.current, "settings.load")
    lib.permit.checkPermission(shell.getRunningProgram(), "settings.load")
    local success, res, err = pcall(SETTINGS_LOAD, sPath) if err ~= nil then error(err, 2) end
    return res
end
fs.makeDir = function(path)
    lib.permit.checkUserPermission(lib.users.current, "fs.makeDir")
    lib.permit.checkPathPermission(lib.users.current, path)
    lib.permit.checkPermission(shell.getRunningProgram(), "fs.makeDir")
    local success, res, err = pcall(FS_MAKE_DIR, path) if err ~= nil then error(err, 2) end
    return res
end
fs.move = function(path, dest)
    lib.permit.checkUserPermission(lib.users.current, "fs.move")
    lib.permit.checkPathPermission(lib.users.current, path)
    lib.permit.checkPathPermission(lib.users.current, dest)
    lib.permit.checkPermission(shell.getRunningProgram(), "fs.move")
    local success, res, err = pcall(FS_MOVE, path, dest) if err ~= nil then error(err, 2) end
    return res
end
fs.copy = function(path, dest)
    lib.permit.checkUserPermission(lib.users.current, "fs.copy")
    lib.permit.checkPathPermission(lib.users.current, path)
    lib.permit.checkPathPermission(lib.users.current, dest)
    lib.permit.checkPermission(shell.getRunningProgram(), "fs.copy")
    local success, res, err = pcall(FS_COPY, path, dest) if err ~= nil then error(err, 2) end
    return res
end
fs.delete = function(path)
    lib.permit.checkUserPermission(lib.users.current, "fs.delete")
    lib.permit.checkPathPermission(lib.users.current, path)
    lib.permit.checkPermission(shell.getRunningProgram(), "fs.delete")
    local success, res, err = pcall(FS_DELETE, path) if err ~= nil then error(err, 2) end
    return res
end
fs.open = function(path, mode)
    lib.permit.checkUserPermission(lib.users.current, "fs.open")
    lib.permit.checkPathPermission(lib.users.current, path)
    lib.permit.checkPermission(shell.getRunningProgram(), "fs.open")
    local success, res, err = pcall(FS_OPEN, path, mode) if err ~= nil then error(err, 2) end
    return res
end

return setmetatable(lib, {
    __name = "dos", __newindex = function(self, k, v)
        local immutable = { "gui", "event", "prompt", "permit" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end,
})