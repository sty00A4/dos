require("deepslate.ext")
local lib = {}
lib.gui = require("deepslate.gui")
lib.event = require("deepslate.event")
lib.prompt = require("deepslate.prompt")
return setmetatable(lib, {
    __name = "deepslate", __newindex = function(self, k, v)
        local immutable = { "gui", "event", "prompt" }
        if table.contains(immutable, k) then immutableError(k, 2) end
        rawset(self, k, v)
    end,
})