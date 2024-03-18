-- File: SellOMatic.lua

-- This function sells items of a specific quality.
local function SellItems(quality)
    if not MerchantFrame or not MerchantFrame:IsVisible() then return end

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, _, itemQuality = GetItemInfo(link)
                if itemQuality == quality then
                    UseContainerItem(bag, slot)
                end
            end
        end
    end
end

-- Creates the sell buttons and attaches them to the MerchantFrame.
local function CreateSellButtons()
    if SellomaticSellGreenItemsButton or SellomaticSellBlueItemsButton then
        return -- Buttons already exist, do not recreate them
    end

    local buttonWidth = 120
    local buttonHeight = 22
    local spacing = 10

    -- Determine the frame level of the merchant frame to place our buttons above it
    local merchantFrameLevel = MerchantFrame:GetFrameLevel()

    -- Create 'Sell Green Items' button
    SellomaticSellGreenItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellGreenItemsButton:SetText("Sell Greens")
    SellomaticSellGreenItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellGreenItemsButton:SetPoint("BOTTOMLEFT", MerchantFrame, "TOPLEFT", 80, -70) -- Adjust the offset as needed
    SellomaticSellGreenItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellGreenItemsButton:SetScript("OnClick", function() SellItems(2) end)

    -- Create 'Sell Blue Items' button
    SellomaticSellBlueItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellBlueItemsButton:SetText("Sell Blues")
    SellomaticSellBlueItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellBlueItemsButton:SetPoint("LEFT", SellomaticSellGreenItemsButton, "RIGHT", spacing, 0)
    SellomaticSellBlueItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellBlueItemsButton:SetScript("OnClick", function() SellItems(3) end)
end

-- Main event frame.
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event)
    if event == "MERCHANT_SHOW" then
        CreateSellButtons()
    end
end)
