local GuildRoster_EventFrame = CreateFrame("Frame")
local InspectPlayer_EventFrame = CreateFrame("Frame")
local GuildAddonMessage_EventFrame = CreateFrame("Frame")

GuildRoster_EventFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
InspectPlayer_EventFrame:RegisterEvent("READY_CHECK_CONFIRM")
GuildAddonMessage_EventFrame:RegisterEvent("CHAT_MSG_ADDON")

GuildRoster_EventFrame:SetScript("OnEvent", function(self, event, ...)
    local arg1 = ...

    local numGuildMembers = GetNumGuildMembers()

    if (numGuildMembers ~= 0) then
        for i = 0, numGuildMembers do
            name, rank, rankIndex, level, class, zone, note, officernote, online, status =
                GetGuildRosterInfo(i)
        end
    end
end)

InspectPlayer_EventFrame:SetScript("OnEvent", function(self, event, ...)
    local arg1, arg2 = ...
    guildName, guildRankName, guildRankIndex = GetGuildInfo(arg1)

    if (CheckInteractDistance(arg1, 1)) then
        if (guildName == "Brawl Gaming") then

            characterName = GetUnitName(arg1)

            NotifyInspect(arg1)
            ammo = GetInventoryItemID(arg1, 0)
            head = GetInventoryItemID(arg1, 1)
            neck = GetInventoryItemID(arg1, 2)
            shoulder = GetInventoryItemID(arg1, 3)
            shirt = GetInventoryItemID(arg1, 4)
            chest = GetInventoryItemID(arg1, 5)
            waist = GetInventoryItemID(arg1, 6)
            legs = GetInventoryItemID(arg1, 7)
            feet = GetInventoryItemID(arg1, 8)
            wrist = GetInventoryItemID(arg1, 9)
            hands = GetInventoryItemID(arg1, 10)
            ring1 = GetInventoryItemID(arg1, 11)
            ring2 = GetInventoryItemID(arg1, 12)
            trinket1 = GetInventoryItemID(arg1, 13)
            trinket2 = GetInventoryItemID(arg1, 14)
            back = GetInventoryItemID(arg1, 15)
            mainhand = GetInventoryItemID(arg1, 16)
            offhand = GetInventoryItemID(arg1, 17)
            ranged = GetInventoryItemID(arg1, 18)
            tabard = GetInventoryItemID(arg1, 19)

        end
    end
end)

function createItemTable(itemList)
    map = {}
    for item in itemList:gmatch("([^,]+)") do
        i = 0
        slot = ""
        for splitItem in item:gmatch("([^:]+)") do
            if (i == 0) then
                slot = splitItem
            else
                map[slot] = splitItem
            end
            i = i + 1
        end
    end
    return map
end

GuildAddonMessage_EventFrame:SetScript("OnEvent",
                                       function(self, event, prefix, msg,
                                                channel, sender)
    if (prefix == "Brawl") then
        map = createItemTable(msg)

        for key, value in pairs(map) do
            _G["MyModelFrame"]:TryOn("item:"..value..":0:0:0")
        end
    end
    BrawlGamingDB = sender .. ":" .. msg
end)

