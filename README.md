# OBS Auto Restart

A small OBS Lua script that automatically restarts recording after the recording session is stopped.

## What it does

This script listens for OBS frontend events. When recording stops, it waits for a short delay and then starts recording again automatically.

It also adds a hotkey action that lets you toggle the auto-restart behavior on or off while OBS is running.

## Current behavior

Based on the current script in `OBS_Auto_Restart.lua`:

- Auto restart is enabled by default.
- The restart delay is hardcoded to 2000 ms.
- When OBS reports that recording has stopped, the script marks a restart as pending.
- After the delay expires, it starts recording again.
- A frontend hotkey is registered to toggle the feature on and off.
- The toggle state is saved with OBS script settings.

## How it works

### 1. Script startup

When OBS loads the script, it:

- Registers a frontend event callback.
- Registers a hotkey named `Toggle Auto Restart`.
- Restores the saved hotkey binding from OBS settings.

### 2. When recording stops

If OBS sends the stop-recording event, the script:

- Prints `Recording stopped` to the OBS log.
- Sets `restart_pending` to `true`.
- Removes any existing restart timer.
- Starts a new timer using `restart_delay`.

### 3. When the timer fires

When the timer runs:

- It clears the timer.
- If auto restart is still enabled and a restart is pending, it starts recording again.
- It prints `Recording restarted` to the OBS log.

### 4. Toggling the feature

The hotkey switches `auto_restart` between enabled and disabled.

- When enabled, it logs `Auto Restart ENABLED`.
- When disabled, it logs `Auto Restart DISABLED`, clears any pending restart, and removes the timer.

## Installation

1. Open OBS Studio.
2. Go to `Tools` > `Scripts`.
3. Add the `OBS_Auto_Restart.lua` file.
4. Make sure scripting is enabled in OBS.
5. Use the script properties and hotkey settings as needed.

## Usage

1. Load the script in OBS.
2. Start recording.
3. Stop recording.
4. The script waits 2 seconds and starts recording again automatically.

To disable the behavior temporarily, use the hotkey bound to `Toggle Auto Restart`.

### Example workflow

You can set up your hotkeys like this in OBS:

- `F8` - Toggle Auto Restart on or off.
- `F9` - Start Recording.
- `F10` - Stop Recording.

Suggested flow:

1. Press `F8` to enable auto restart and start listening for the stop-recording event.
2. Press `F9` to start recording.
3. Let OBS record until your timer or target length is reached, for example 10 minutes.
4. When recording stops, the script will wait for the configured delay and then start recording again.
5. If you want to stop the auto-restart behavior before ending the current session, press `F8` first.
6. If a recording is already in progress and you want to stop it manually, press `F10`.

If you want to confirm what is happening, check the OBS logs for messages like `Recording stopped`, `Recording restarted`, `Auto Restart ENABLED`, and `Auto Restart DISABLED`.

## Configuration

### Available setting

- `Enable Auto Restart`

### Hardcoded value in the current script

- `restart_delay = 2000`

That means the script restarts recording after 2 seconds.

## What can be changed

These are the most useful improvements you can make next:

- Expose `restart_delay` as a script property so it can be changed from the OBS UI.
- Add a dropdown or checkbox to choose whether the script should restart recording, streaming, or both.
- Add a safety check so it only restarts if OBS is not already recording.
- Replace the numeric event check with a named OBS frontend event constant if you want the script to be easier to read.
- Add a log message when the timer is canceled before restart.
- Persist the enabled/disabled state separately from the hotkey if you want the feature to survive restarts more clearly.

## Script overview

File: `OBS_Auto_Restart.lua`

Key functions:

- `script_description()` returns the script description shown in OBS.
- `script_properties()` defines the OBS script UI.
- `script_defaults()` sets the default enabled state.
- `script_update()` reads UI values back into script state.
- `on_event(event)` listens for OBS frontend events.
- `do_restart()` runs the delayed restart.
- `toggle_restart(pressed)` toggles the feature from the hotkey.
- `script_load(settings)` registers callbacks and hotkeys.
- `script_save(settings)` stores hotkey bindings.

## Notes and limitations

- The restart delay is currently fixed at 2000 ms.
- The script depends on the OBS Lua scripting API.
- The event check currently uses the raw event value `7`, so the meaning depends on the OBS frontend event enum.

## Suggested next version

A cleaner next version would include:

- a `Restart Delay (ms)` field in the OBS script settings,
- a named constant for the stop-recording event,
- better state handling so the behavior is easier to maintain.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Also known as

If you come back to this later, you may also see this project described as:

- OBS recording auto restart
- OBS Lua auto restart helper
- auto resume recording in OBS
- output timer restart helper
- OBS restart after stop recording
