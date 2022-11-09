return {
    new = function(type, ...)
        local args = {...}
        local t = { type = type }
        if t.type == "alarm" then t.id = args[1] end
        if t.type == "char" then t.char = args[1] end
        if t.type == "computer_command" then t.args = args end
        if t.type == "char" then t.char = args[1] end
        if t.type == "disk" then t.side = args[1] end
        if t.type == "disk_eject" then t.side = args[1] end
        if t.type == "file_transfer" then t.files = args[1] end
        if t.type == "http_check" then t.url, t.success, t.reason = args[1], args[2], args[3] end
        if t.type == "http_failure" then t.url, t.error, t.handle = args[1], args[2], args[3] end
        if t.type == "http_success" then t.url, t.handle = args[1], args[2] end
        if t.type == "key" then t.key, t.holding = args[1], args[2] end
        if t.type == "key_up" then t.key = args[1] end
        if t.type == "modem_message" then t.side, t.channel, t.reply_channel, t.msg, t.distance = args[1], args[2], args[3], args[4], args[5] end
        if t.type == "monitor_resize" then t.id = args[1] end
        if t.type == "monitor_touch" then t.id, t.x, t.y = args[1], args[2], args[3] end
        if t.type == "mouse_click" then t.button, t.x, t.y = args[1], args[2], args[3] end
        if t.type == "mouse_drag" then t.button, t.x, t.y = args[1], args[2], args[3] end
        if t.type == "mouse_scroll" then t.direction, t.x, t.y = args[1], args[2], args[3] end
        if t.type == "mouse_up" then t.button, t.x, t.y = args[1], args[2], args[3] end
        if t.type == "paste" then t.text = args[1] end
        if t.type == "peripheral" then t.side = args[1] end
        if t.type == "peripheral_detach" then t.side = args[1] end
        if t.type == "rednet_message" then t.id, t.msg, t.protocol = args[1], args[2], args[3] end
        if t.type == "speaker_audio_empty" then t.name = args[1] end
        if t.type == "task_complete" then t.id, t.success, t.error = args[1], args[2], args[3] end
        if t.type == "timer" then t.id = args[1] end
        if t.type == "websocket_closed" then t.url = args[1] end
        if t.type == "websocket_failure" then t.url, t.error = args[1], args[2] end
        if t.type == "websocket_message" then t.url, t.content, t.binary = args[1], args[2], args[3] end
        if t.type == "websocket_success" then t.url, t.handle = args[1], args[2] end
        return setmetatable(t, {
            __name = "event", __newindex = function() error("event is immutable", 2) end
        })
    end
}