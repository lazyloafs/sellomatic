-- File: SellOMatic.lua

-- This function sells items of a specific quality.
-- Update the SellItems function to check against the blacklist
local function SellItems(quality)
    if not MerchantFrame or not MerchantFrame:IsVisible() then return end

    local blacklist = SellOMatic_Settings["blacklist"] or {}

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local itemName, _, itemQuality, _, _, itemType, _, _, _, _, _ = GetItemInfo(link)
                if itemQuality == quality and not blacklist[itemType] then
                    UseContainerItem(bag, slot)
                end
            end
        end
    end
end



-- Creates the sell buttons and attaches them to the MerchantFrame.
function CreateSellButtons()
    if SellomaticSellGreenItemsButton and SellomaticSellBlueItemsButton and SellomaticSellWhiteItemsButton and SellomaticSellEpicItemsButton then
        return -- Buttons already exist, ensure they are not recreated
    end

    local buttonWidth = 100
    local buttonHeight = 16
    local spacing = 10

    -- Determine the frame level of the merchant frame to place our buttons above it
    local merchantFrameLevel = MerchantFrame:GetFrameLevel()

    -- Create 'Sell Green Items' button
    SellomaticSellGreenItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellGreenItemsButton:SetText("Sell Blues")
    SellomaticSellGreenItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellGreenItemsButton:SetPoint("BOTTOMLEFT", MerchantFrame, "TOPLEFT", 80, -73) -- Adjust the offset as needed
    SellomaticSellGreenItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellGreenItemsButton:SetScript("OnClick", function() SellItems(3) end)

    -- Create 'Sell Blue Items' button
    SellomaticSellBlueItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellBlueItemsButton:SetText("Sell Epics")
    SellomaticSellBlueItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellBlueItemsButton:SetPoint("LEFT", SellomaticSellGreenItemsButton, "RIGHT", spacing, 0)
    SellomaticSellBlueItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellBlueItemsButton:SetScript("OnClick", function() SellItems(4) end)
        
    -- Updated point assignment for button positions
    -- Create 'Sell White Items' button
    local SellomaticSellWhiteItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellWhiteItemsButton:SetText("Sell Whites")
    SellomaticSellWhiteItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellWhiteItemsButton:SetPoint("BOTTOMLEFT", SellomaticSellGreenItemsButton, "TOPLEFT", 0, 1.5, spacing) -- Fixed this line
    SellomaticSellWhiteItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellWhiteItemsButton:SetScript("OnClick", function() SellItems(1) end)
       
    -- Create 'Sell Epic Items' button
    local SellomaticSellEpicItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellEpicItemsButton:SetText("Sell Greens")
    SellomaticSellEpicItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellEpicItemsButton:SetPoint("BOTTOMLEFT", SellomaticSellBlueItemsButton, "TOPLEFT", 0, 1.5, spacing) -- Fixed this line
    SellomaticSellEpicItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellEpicItemsButton:SetScript("OnClick", function() SellItems(2) end)
end 

-- Main event frame.
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        CreateSellButtons()
    end
end)


-- Slash command setup
SLASH_SELLOMATIC1 = "/sellomatic"
SlashCmdList["SELLOMATIC"] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(SellOMatic_InterfacePanel)
end

-- Function to create checkboxes
local function CreateCheckbox(parent, id, labelText, tooltipText)
    local checkbox = CreateFrame("CheckButton", "SellOMatic_Checkbox"..id, parent, "UICheckButtonTemplate")
    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(labelText)
    checkbox.label:ClearAllPoints()
    checkbox.label:SetPoint("LEFT", checkbox, "RIGHT", 0, 0) -- Position the label to the right of the checkbox
    checkbox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(tooltipText, nil, nil, nil, nil, true)
    end)
    checkbox:SetScript("OnLeave", GameTooltip_Hide)
    return checkbox
end

-- Interface panel
SellOMatic_InterfacePanel = CreateFrame("Frame", "SellOMatic_InterfacePanel", InterfaceOptionsFramePanelContainer)
SellOMatic_InterfacePanel.name = "Sell-O-Matic"
InterfaceOptions_AddCategory(SellOMatic_InterfacePanel)

-- Panel title
SellOMatic_InterfacePanel.title = SellOMatic_InterfacePanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
SellOMatic_InterfacePanel.title:SetPoint("TOPLEFT", 16, -16)
SellOMatic_InterfacePanel.title:SetText("Sell-O-Matic Options")

-- Checkboxes
local itemsToBlacklist = {"Cloth", "Righteous Orbs", "Ore", "Gems"}
local prevCheckbox -- For positioning checkboxes below one another
for i, item in ipairs(itemsToBlacklist) do
    local checkbox = CreateCheckbox(SellOMatic_InterfacePanel, i, "Blacklist "..item, "Prevents selling of "..item.." if checked")
    if not prevCheckbox then
        checkbox:SetPoint("TOPLEFT", SellOMatic_InterfacePanel.title, "BOTTOMLEFT", 0, -10)
    else
        checkbox:SetPoint("TOPLEFT", prevCheckbox, "BOTTOMLEFT", 0, -5)
    end
    prevCheckbox = checkbox
end

-- Save and restore functionality
SellOMatic_InterfacePanel.default = function() -- Set defaults
    SellOMatic_Settings = SellOMatic_Settings or {}
    for _, item in ipairs(itemsToSell) do
        SellOMatic_Settings[item] = true -- Default to all checked
    end
end

SellOMatic_InterfacePanel.okay = function() -- Save settings
    for i, item in ipairs(itemsToSell) do
        local checkbox = _G["SellOMatic_Checkbox"..i]
        SellOMatic_Settings[item] = checkbox:GetChecked()
    end
end

SellOMatic_InterfacePanel.refresh = function() -- Refresh UI from saved settings
    for i, item in ipairs(itemsToSell) do
        local checkbox = _G["SellOMatic_Checkbox"..i]
        checkbox:SetChecked(SellOMatic_Settings[item])
    end
end

SellOMatic_InterfacePanel.cancel = SellOMatic_InterfacePanel.default -- Revert to last saved

-- Register for events to save/load settings
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "SellOMatic" then
        SellOMatic_Settings = SellOMatic_Settings or {}
        for _, item in ipairs(itemsToSell) do
            if SellOMatic_Settings[item] == nil then
                SellOMatic_Settings[item] = true -- Default to true
            end
        end
    end
end)