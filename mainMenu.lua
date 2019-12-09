local frameWidth = 750
local frameHeight = 500
local buttonWidth = frameWidth / 4

local MainFrame =
    CreateFrame("Frame", MainFrame, UIParent, "BasicFrameTemplate")
MainFrame:SetSize(frameWidth, frameHeight)
MainFrame:SetMovable(true)
MainFrame:SetPoint("CENTER")
MainFrame:EnableMouse(true)
MainFrame:SetFrameStrata("TOOLTIP")
MainFrame:SetFrameLevel(3)
MainFrame:SetClampedToScreen(true)
MainFrame.Bg:SetAlpha(0)
-- MainFrame:Hide()

local InnerMainFrame = CreateFrame("Frame", InnerMainFrame, MainFrame,
                                   "InsetFrameTemplate")
InnerMainFrame:SetSize(frameWidth - 6, frameHeight - 24)
InnerMainFrame:SetPoint("CENTER", -1, -10)
InnerMainFrame:SetFrameLevel(1)

local dragFrame = CreateFrame("Frame", DragFrame, MainFrame)
dragFrame:EnableMouse(true)
dragFrame:RegisterForDrag("LeftButton")
dragFrame:SetSize(frameWidth - 26, 18)
dragFrame:SetPoint("TOP", -13, -2)
dragFrame:SetScript("OnDragStart",
                    function(self, button) MainFrame:StartMoving() end)
dragFrame:SetScript("OnDragStop",
                    function(self, button) MainFrame:StopMovingOrSizing() end)

local BottomFrame = CreateFrame("Frame", BottomFrame, MainFrame,
                                "HorizontalBarTemplate")
BottomFrame:SetSize(frameWidth - 8, 20)
BottomFrame:SetPoint("BOTTOM", 0, 4)
BottomFrame:SetFrameLevel(2)

local function ScrollFrame_OnMouseWheel(self, delta)
    local newValue = self:GetVerticalScroll() - (delta * 20)
    if (newValue < 0) then
        newValue = 0
    elseif (newValue > self:GetVerticalScrollRange()) then
        newValue = self:GetVerticalScrollRange()
    end

    self:SetVerticalScroll(newValue)
end

local ScrollFrame = CreateFrame("ScrollFrame", nil, InnerMainFrame,
                                "UIPanelScrollFrameTemplate")
ScrollFrame:SetPoint("BOTTOM", 0, 25)
ScrollFrame:SetSize(frameWidth, frameHeight - 40)

ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel)

ScrollFrame.ScrollBar:ClearAllPoints()
ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ScrollFrame, "TOPRIGHT", -23, -28)
ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ScrollFrame, "BOTTOMRIGHT", -7, 18)

local RaidRollButton = CreateFrame("Button", RaidRoll, BottomFrame,
                                   "GameMenuButtonTemplate")
RaidRollButton:SetPoint("LEFT")
RaidRollButton:SetSize(100, 22)
RaidRollButton:SetText("Raid Roll")
RaidRollButton:SetNormalFontObject("GameFontNormalSmall")
RaidRollButton:SetFrameLevel(11)

local ReadyCheckButton = CreateFrame("Button", ReadyCheck, BottomFrame,
                                     "GameMenuButtonTemplate")
ReadyCheckButton:SetPoint("LEFT", 100 + 2, 0)
ReadyCheckButton:SetSize(100, 22)
ReadyCheckButton:SetText("Ready Check")
ReadyCheckButton:SetNormalFontObject("GameFontNormalSmall")
ReadyCheckButton:SetFrameLevel(11)

local TryOnButton = CreateFrame("Button", TryOn, BottomFrame,
                                "GameMenuButtonTemplate")
TryOnButton:SetPoint("LEFT")
TryOnButton:SetSize(100, 22)
TryOnButton:SetText("Try On")
TryOnButton:SetNormalFontObject("GameFontNormalSmall")
TryOnButton:SetFrameLevel(11)

-- Tabs
local function HideNonFocusedTabs(NumOfTabs, CurrentTab)
    for i = 1, NumOfTabs do
        if (_G["Tab" .. i] ~= CurrentTab) then
            _G["Tab" .. i].content:Hide()
        end
    end
end

local function Tab_OnClick(self)
    HideNonFocusedTabs(4, self)
    local scrollChild = CreateFrame("ScrollFrame", nil, ScrollFrame,
                                    "UIPanelScrollFrameTemplate")

    if (scrollChild) then scrollChild:Hide() end
    ScrollFrame:SetScrollChild(self.content)

    if (self:GetID() == 2) then
        ReadyCheckButton:Show()
        RaidRollButton:Show()
        TryOnButton:Hide()
    else
        ReadyCheckButton:Hide()
        RaidRollButton:Hide()
        TryOnButton:Hide()
    end

    if (self:GetID() == 4) then
        TryOnButton:Show()
        RaidRollButton:Hide()
        ReadyCheckButton:Hide()
    end

    self.content:Show()
end

local function SetTabs(frame, numTabs, ...)
    frame.numTabs = numTabs

    local contents = {}

    for i = 1, numTabs do

        local tab = CreateFrame("Button", "Tab" .. i, frame,
                                "CharacterFrameTabButtonTemplate")

        tab:SetID(i)
        tab:SetText(select(i, ...))
        tab:SetFrameLevel(0)
        tab:SetScript("OnClick", Tab_OnClick)

        tab.content = CreateFrame("Frame", nil, ScrollFrame)
        tab.content:SetSize(frameWidth, frameHeight - 40)
        tab.content:Hide()

        if (select(i, ...) == "DKP") then
            Test = CreateFrame("Frame", nil, tab.content, "InsetFrameTemplate")
            Test:SetSize(100, 100)
            Test:SetPoint("RIGHT")

        elseif (select(i, ...) == "Raids") then
            ReadyCheckButton:Hide()
            RaidRollButton:Hide()

        elseif (select(i, ...) == "Dungeons") then
            Test = CreateFrame("Frame", nil, tab.content, "InsetFrameTemplate")
            Test:SetSize(200, 200)
            Test:SetPoint("CENTER")

        elseif (select(i, ...) == "Gear") then
            ModelFrame = CreateFrame("Frame", nil, tab.content)
            ModelFrame:SetSize(325, 450)
            ModelFrame:SetPoint("LEFT", 0, 0)
            ModelFrame:SetFrameLevel(10)
            f = CreateFrame("DressUpModel", "MyModelFrame", ModelFrame,
                            "ModelWithControlsTemplate")
            f:SetFrameLevel(55)
            f:SetPoint("LEFT", 50, 0)
            f:SetSize(250, 400)
            f:SetUnit("player")
            f:SetPosition(0,0,0)
            f:Show()
        else
            error("invalid route")
        end

        table.insert(contents, tab.content)

        if (i == 1) then
            tab:SetPoint("TOPLEFT", InnerMainFrame, "BOTTOMLEFT", 5, 0)
        else
            tab:SetPoint("TOPLEFT", _G["Tab" .. (i - 1)], "TOPRIGHT", -14, 0)
        end
    end

    Tab_OnClick(_G["Tab1"])
    return unpack(contents)
end

local content1, content2, content3, content4 =
    SetTabs(InnerMainFrame, 4, "DKP", "Raids", "Dungeons", "Gear")

-- Minimap

local minibtn = CreateFrame("Button", nil, Minimap)
minibtn:SetFrameLevel(8)
minibtn:SetSize(32, 32)
minibtn:SetMovable(true)

minibtn:SetNormalTexture("Interface/COMMON/Indicator-Yellow.png")
minibtn:SetPushedTexture("Interface/COMMON/Indicator-Yellow.png")
minibtn:SetHighlightTexture("Interface/COMMON/Indicator-Yellow.png")
local myIconPos = 0

local function UpdateMapBtn()
    local Xpoa, Ypoa = GetCursorPosition()
    local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
    Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
    Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
    myIconPos = math.deg(math.atan2(Ypoa, Xpoa))
    minibtn:ClearAllPoints()
    minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)),
                     (80 * sin(myIconPos)) - 52)
end

minibtn:RegisterForDrag("LeftButton")
minibtn:SetScript("OnDragStart", function()
    minibtn:StartMoving()
    minibtn:SetScript("OnUpdate", UpdateMapBtn)
end)

minibtn:SetScript("OnDragStop", function()
    minibtn:StopMovingOrSizing()
    minibtn:SetScript("OnUpdate", nil)
    UpdateMapBtn()
end)

-- Set position
minibtn:ClearAllPoints()
minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)),
                 (80 * sin(myIconPos)) - 52)

-- Control clicksMainFrame
minibtn:SetScript("OnClick", function()
    if (MainFrame:IsShown()) then
        MainFrame:Hide()
        content1:Hide()
        content2:Hide()
        content3:Hide()
        content4:Hide()
    else
        MainFrame:Show()
        content1:Show()
        content2:Show()
        content3:Show()
        content4:Show()
    end
end)

-- BUTTON HANDLING ---------------------------------------------

local ExitButton, child2, child3, child4 = MainFrame:GetChildren()

-- Control clicksMainFrame
ExitButton:SetScript("OnClick", function()
    if (MainFrame:IsShown()) then
        MainFrame:Hide()
        content1:Hide()
        content2:Hide()
        content3:Hide()
        content4:Hide()
    else
        MainFrame:Show()
        content1:Show()
        content2:Show()
        content3:Show()
        content4:Show()
    end
end)

local assistant = UnitIsGroupAssistant("player")
local leader = UnitIsGroupLeader("player")

if (leader or assistant) then
    print("YES")
else
    print("no")
end

ReadyCheckButton:SetScript("OnClick", function() DoReadyCheck() end)

RaidRollButton:SetScript("OnClick", function()
    successfulRequest = C_ChatInfo.RegisterAddonMessagePrefix("Brawl")

    ammount, ammo = GetInventoryItemID("player", 0)
    array = ""
    for i = 1, 19, 1 do
        itemid = GetInventoryItemID("player", i)
        if (itemid ~= nil) then
            if (i < 19) then
                array = array .. i .. ":" .. GetInventoryItemID("player", i) ..
                            ","
            else
                array = array .. i .. ":" .. GetInventoryItemID("player", i)
            end
        else
            if (i < 19) then
                array = array .. i .. ":" .. "empty" .. ","
            else
                array = array .. i .. ":" .. "empty"
            end
        end
    end

    if (successfulRequest) then
        C_ChatInfo.SendAddonMessage("Brawl", array, "GUILD")
    else
        print("Could not send information")
    end

    local members = GetNumGroupMembers()
    local winner = math.random(1, members)
    local winnerName = GetRaidRosterInfo(winner)
    if (UnitInRaid(winnerName)) then
        SendChatMessage("Congratulations " .. winnerName, "RAID", "COMMON")
    else
        SendChatMessage("Congratulations " .. winnerName, "PARTY", "COMMON")
    end
end)
