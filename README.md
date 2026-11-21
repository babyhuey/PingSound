# PingSound

A tiny World of Warcraft addon that plays a sound of your choice when someone pings, instead of the default ping sound.

## Setup

1. Install the addon and `/reload`.
2. Turn off WoW's own ping sound so you don't hear both: `/console Sound_EnablePingSounds 0`
3. Pick a sound with `/pingsound`.

## Commands

| Command | What it does |
|---|---|
| `/pingsound` | Show the current sound and the list |
| `/pingsound next` | Switch to the next sound and play it |
| `/pingsound <1-7>` | Pick a sound from the list |
| `/pingsound <id>` | Use any SoundKit ID |
| `/pingsound test` | Play the current sound |
| `/pingsound on` / `off` | Turn it on or off |

Built-in sounds: classic minimap ping, whisper, group invite, Battle.net toast, ready check, raid warning, alarm clock.

When several pings arrive at once, it plays one sound for the burst (0.3s window).

## How it works

It listens for `CHAT_MSG_PING` and plays the chosen sound with `PlaySound`. Your choice is saved in `PingSoundDB`.
