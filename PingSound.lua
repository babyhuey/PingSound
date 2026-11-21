-- PingSound: play a chosen sound when a ping arrives (CHAT_MSG_PING).
-- Keep WoW's own ping sound off: /console Sound_EnablePingSounds 0

local SOUNDS = {
    { id = 3175,  name = "Minimap ping (classic)" },
    { id = 3081,  name = "Whisper" },
    { id = 880,   name = "Group invite" },
    { id = 18019, name = "Battle.net toast" },
    { id = 8960,  name = "Ready check" },
    { id = 8959,  name = "Raid warning" },
    { id = 12867, name = "Alarm clock" },
}

local lastPlayed = 0

local function say(msg)
    print("|cff66ccffPingSound:|r " .. msg)
end

local function currentName()
    local id = PingSoundDB.sound
    for i, s in ipairs(SOUNDS) do
        if s.id == id then return i .. ". " .. s.name .. " (" .. id .. ")" end
    end
    return "custom sound " .. tostring(id)
end

local function play()
    if not PingSoundDB.on then return end
    local now = GetTime()
    if now - lastPlayed < 0.3 then return end -- one sound per burst of pings
    lastPlayed = now
    PlaySound(PingSoundDB.sound, "Master")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_PING")
f:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "PingSound" then
            PingSoundDB = PingSoundDB or {}
            if PingSoundDB.on == nil then PingSoundDB.on = true end
            PingSoundDB.sound = PingSoundDB.sound or SOUNDS[1].id
        end
    else
        play()
    end
end)

SLASH_PINGSOUND1 = "/pingsound"
SlashCmdList.PINGSOUND = function(msg)
    msg = strtrim(string.lower(msg or ""))
    local n = tonumber(msg)
    if msg == "on" or msg == "off" then
        PingSoundDB.on = (msg == "on")
        say(PingSoundDB.on and "on" or "off")
    elseif msg == "test" then
        PlaySound(PingSoundDB.sound, "Master")
        say("playing " .. currentName())
    elseif msg == "next" then
        local idx = 0
        for i, s in ipairs(SOUNDS) do if s.id == PingSoundDB.sound then idx = i end end
        PingSoundDB.sound = SOUNDS[idx % #SOUNDS + 1].id
        PlaySound(PingSoundDB.sound, "Master")
        say("now using " .. currentName())
    elseif n and SOUNDS[n] then
        PingSoundDB.sound = SOUNDS[n].id
        PlaySound(PingSoundDB.sound, "Master")
        say("now using " .. currentName())
    elseif n then
        PingSoundDB.sound = n -- any SoundKit ID
        PlaySound(PingSoundDB.sound, "Master")
        say("now using " .. currentName())
    else
        say((PingSoundDB.on and "on" or "off") .. ", using " .. currentName())
        for i, s in ipairs(SOUNDS) do print("  " .. i .. ". " .. s.name) end
        print("  /pingsound <1-" .. #SOUNDS .. "> | next | test | on | off | <SoundKit ID>")
    end
end
