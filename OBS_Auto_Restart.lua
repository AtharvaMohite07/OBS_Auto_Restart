obs = obslua

auto_restart = true
restart_delay = 2000
restart_pending = false
hotkey_id = obs.OBS_INVALID_HOTKEY_ID

function script_description()
    return "Automatically restarts recording after Output Timer stops it."
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_bool(props, "auto_restart", "Enable Auto Restart")
    return props
end

function script_defaults(settings)
    obs.obs_data_set_default_bool(settings, "auto_restart", true)
end

function script_update(settings)
    auto_restart = obs.obs_data_get_bool(settings, "auto_restart")
end

function do_restart()
    obs.timer_remove(do_restart)

    if auto_restart and restart_pending then
        restart_pending = false
        obs.obs_frontend_recording_start()
        print("Recording restarted")
    end
end

function on_event(event)
    if event == 7 then
        print("Recording stopped")

        if auto_restart then
            restart_pending = true
            obs.timer_remove(do_restart)
            obs.timer_add(do_restart, restart_delay)
        end
    end
end

function toggle_restart(pressed)
    if not pressed then
        return
    end

    auto_restart = not auto_restart

    if auto_restart then
        print("Auto Restart ENABLED")
    else
        print("Auto Restart DISABLED")
        restart_pending = false
        obs.timer_remove(do_restart)
    end
end

function script_load(settings)
    obs.obs_frontend_add_event_callback(on_event)

    hotkey_id = obs.obs_hotkey_register_frontend(
        "toggle_restart",
        "Toggle Auto Restart",
        toggle_restart
    )

    local hotkey_save_array = obs.obs_data_get_array(settings, "toggle_restart")
    obs.obs_hotkey_load(hotkey_id, hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
    local hotkey_save_array = obs.obs_hotkey_save(hotkey_id)
    obs.obs_data_set_array(settings, "toggle_restart", hotkey_save_array)
    obs.obs_data_array_release(hotkey_save_array)
end