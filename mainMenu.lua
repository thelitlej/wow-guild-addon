local frameWidth = 750
local frameHeight = 500
local buttonWidth = frameWidth / 4


local MainFrame = CreateFrame("Frame", MainFrame, UIParent, "BasicFrameTemplate")
    MainFrame:SetSize(frameWidth, frameHeight)
    MainFrame:SetMovable(true)
    MainFrame:SetPoint("CENTER")
    MainFrame:EnableMouse(true)
    MainFrame:SetFrameStrata("TOOLTIP")
    MainFrame:SetFrameLevel(3)
    MainFrame:SetClampedToScreen(true)
    MainFrame.Bg:SetAlpha(0)
    --MainFrame:Hide()

local InnerMainFrame = CreateFrame("Frame", InnerMainFrame, MainFrame, "InsetFrameTemplate")
    InnerMainFrame:SetSize(frameWidth-6, frameHeight-24)
    InnerMainFrame:SetPoint("CENTER", -1, -10)
    InnerMainFrame:SetFrameLevel(1)

local dragFrame = CreateFrame("Frame", DragFrame, MainFrame)
    dragFrame:EnableMouse(true)
    dragFrame:RegisterForDrag("LeftButton")
    dragFrame:SetSize(frameWidth-26, 18)
    dragFrame:SetPoint("TOP", -13, -2)
    dragFrame:SetScript("OnDragStart", function(self, button) MainFrame:StartMoving() end)
    dragFrame:SetScript("OnDragStop", function(self, button) MainFrame:StopMovingOrSizing() end)

    

local bottomFrame = CreateFrame("Frame", BottomFrame, MainFrame, "HorizontalBarTemplate")
    bottomFrame:SetSize(frameWidth - 8, 20)
    bottomFrame:SetPoint("BOTTOM", 0, 4)
    bottomFrame:SetFrameLevel(2)

local function ScrollFrame_OnMouseWheel(self, delta)
	local newValue = self:GetVerticalScroll() - (delta * 20);
	if (newValue < 0) then
		newValue = 0;
	elseif (newValue > self:GetVerticalScrollRange()) then
		newValue = self:GetVerticalScrollRange();
	end
	
	self:SetVerticalScroll(newValue);
end


local ScrollFrame = CreateFrame("ScrollFrame", nil, InnerMainFrame, "UIPanelScrollFrameTemplate");
    ScrollFrame:SetPoint("BOTTOM", 0, 25)
    ScrollFrame:SetSize(frameWidth, frameHeight - 40)

    ScrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);

    ScrollFrame.ScrollBar:ClearAllPoints();
    ScrollFrame.ScrollBar:SetPoint("TOPLEFT", ScrollFrame, "TOPRIGHT", -23, -28);
    ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", ScrollFrame, "BOTTOMRIGHT", -7, 18);
 

-- Tabs

local function Tab_OnClick(self)

    local scrollChild = CreateFrame("ScrollFrame", nil, ScrollFrame, "UIPanelScrollFrameTemplate");
    
	if (scrollChild) then
		scrollChild:Hide();
	end
    ScrollFrame:SetScrollChild(self.content);
    
	self.content:Show();	
end

local function SetTabs(frame, numTabs, ...)
    frame.numTabs = numTabs;

	local contents = {};

    for i = 1, numTabs do
        
        local tab = CreateFrame("Button", "Tab"..i, frame, "CharacterFrameTabButtonTemplate");

		tab:SetID(i);
        tab:SetText(select(i, ...));
        tab:SetFrameLevel(0)
        tab:SetScript("OnClick", Tab_OnClick);
        
        tab.content = CreateFrame("Frame", nil, ScrollFrame);
        tab.content:SetSize(frameWidth, frameHeight-40);
        tab.content:Hide();
       
        if (select(i, ...) == "DKP") then
            Test = CreateFrame("Frame", nil, tab.content, "InsetFrameTemplate")
            Test:SetSize(100, 100)
            Test:SetPoint("CENTER")
     
        elseif (select(i, ...) == "Raid") then
            Test = CreateFrame("Frame", nil, tab.content, "InsetFrameTemplate")
            Test:SetSize(10, 10)
            Test:SetPoint("CENTER")
        
        elseif (select(i, ...) == "Gear") then
            Test = CreateFrame("Frame", nil, tab.content, "InsetFrameTemplate")
            Test:SetSize(50, 50)
            Test:SetPoint("CENTER")
           
        else 
            error("invalid route")
        end

		table.insert(contents, tab.content);
		
		if (i == 1) then
            tab:SetPoint("TOPLEFT", InnerMainFrame, "BOTTOMLEFT", 5, 0);
		else
            tab:SetPoint("TOPLEFT", _G["Tab"..(i - 1)], "TOPRIGHT", -14, 0);
		end	
	end
    
    Tab_OnClick(_G["Tab1"]);
    
	return unpack(contents);
end


local content1, content2, content3 = SetTabs(InnerMainFrame, 3, "DKP", "Raid", "Gear");


-- Minimap

local minibtn = CreateFrame("Button", nil, Minimap)
minibtn:SetFrameLevel(8)
minibtn:SetSize(32,32)
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
    minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)), (80 * sin(myIconPos)) - 52)
end
 
minibtn:RegisterForDrag("LeftButton")
minibtn:SetScript("OnDragStart", function()
    minibtn:StartMoving()
    minibtn:SetScript("OnUpdate", UpdateMapBtn)
end)
 
minibtn:SetScript("OnDragStop", function()
    minibtn:StopMovingOrSizing();
    minibtn:SetScript("OnUpdate", nil)
    UpdateMapBtn();
end)
 
-- Set position
minibtn:ClearAllPoints();
minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(myIconPos)),(80 * sin(myIconPos)) - 52)
 
-- Control clicks
minibtn:SetScript("OnClick", function()
    if (MainFrame:IsShown()) then
        MainFrame:Hide()
    else
        MainFrame:Show()
    end
end)



--local DKPbutton = CreateFrame("Button", nil, MainFrame, "TabButtonTemplate")
--DKPbutton:SetPoint("BOTTOMLEFT", 2, 2)
--DKPbutton:SetSize(buttonWidth, 22)
--DKPbutton:SetText("DKP")
--DKPbutton:SetNormalFontObject("GameFontNormalSmall")

--local calendarButton = CreateFrame("Button", nil, MainFrame, "GameMenuButtonTemplate")
--calendarButton:SetPoint("BOTTOMLEFT", buttonWidth + 2, 2)
--calendarButton:SetSize(buttonWidth, 22)
--calendarButton:SetText("Calendar")
--calendarButton:SetNormalFontObject("GameFontNormalSmall")

--local calendarButton = CreateFrame("Button", nil, MainFrame, "UIServiceButtonTemplate")
--calendarButton:SetPoint("BOTTOMLEFT", buttonWidth*2, 2)
--calendarButton:SetSize(buttonWidth, 22)
--calendarButton:SetText("Gear")
--calendarButton:SetNormalFontObject("GameFontNormalSmall")

--local calendarButton = CreateFrame("Button", nil, MainFrame, "UIPanelButtonGrayTemplate")
--calendarButton:SetPoint("BOTTOMLEFT", buttonWidth*3, 2)
--calendarButton:SetSize(buttonWidth, 22)
--calendarButton:SetText("Raid Utils")
--calendarButton:SetNormalFontObject("GameFontNormalSmall")