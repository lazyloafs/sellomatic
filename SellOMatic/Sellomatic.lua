-- File: SellOMatic.lua

-- This function sells items of a specific quality.
-- Update the SellItems function to check against the blacklist
local categories = {"Cloth", "OresAndBars", "Righteous Orbs", "Herbs", "Highrisk"} -- Use this for consistency
local blacklist = {}

local itemsToSellByCategory = {
  Cloth = {
      "Runecloth",
      "Netherweave Cloth",
      "Frostweave Cloth",
      "Mageweave Cloth",
      "Silk Cloth",
      "Wool Cloth",
      "Linen Cloth",
      "Felcloth",
      "Shadow Silk",
      "Ebonweave",
      "Moonshroud",
      "Spellweave",
      "Iceweb Spider Silk",
      "Primal Mooncloth",
      "Shadoweave Cloth",
      "Spellfire Cloth",
      "Spellcloth",
      "Shadowcloth",
      "Soucloth",
      "Netherweb Spider Silk",
      "Mooncloth",
      "Ironweb Spider Silk"
  },
  OresAndBars = {
      "Titanium Ore",
      "Froststeel Bar",
      "Titansteel Bar",
      "Titanium Bar",
      "Saronite Bar",
      "Hardened Saronite Bar",
      "Saronite Ore",
      "Azurite Bar",
      "Cobalt Ore",
      "Cobalt Bar",
      "Khorium Ore",
      "Eternium Ore",
      "Eternium Bar",
      "Khorium Bar",
      "Hardened Khorium",
      "Adamantite Ore",
      "Adamantite Bar",
      "Hardened Adamantite Bar",
      "Elementium Bar",
      "Sulfuron Ingot",
      "Elementium Ore",
      "Guardian Stone",
      "Felsteel Bar",
      "Elemental Flux",
      "Fel Iron Ore",
      "Fel Iron Bar",
      "Arcanite Bar",
      "Enchanted Thorium Bar",
      "Truesilver Bar",
      "Dark Iron Ore",
      "Dark Iron Bar",
      "Thorium Bar",
      "Dense Stone",
      "Dense Grinding Stone",
      "Truesilver Ore",
      "Mithril Ore",
      "Mithril Bar",
      "Thorium Ore",
      "Steel Bar",
      "Solid Grinding Stone",
      "Gold Bar",
      "Iron Ore",
      "Iron Bar",
      "Coal",
      "Gold Ore",
      "Heavy Stone",
      "Heavy Grinding Stone",
      "Tin Ore",
      "Bronze Bar"
  },
      RighteousOrbs = { 
          "Righteous Orb" 
  },  -- This list contains only one item for the example
      Herbs = {
          "Peacebloom",
          "Silverleaf",
          "Earthroot",
          "Frost Lotus",
          "Lichbloom",
          "Icethorn",
          "Adder's Tongue",
          "Constrictor Grass",
          "Goldclover",
          "Tiger Lily",
          "Talandra's Rose",
          "Deadnettle",
          "Fel Lotus",
          "Netherbloom",
          "Nightmare Vine",
          "Mana Thistle",
          "Nightmare Seed",
          "Ancient Lichen",
          "Flame Cap",
          "Ragveil",
          "Blood Scythe",
          "Black Lotus",
          "Bloodvine",
          "Felweed",
          "Dreaming Glory",
          "Terocone",
          "Icecap",
          "Plaguebloom",
          "Mountain Silversage",
          "Dreamfoil",
          "Golden Sansam",
          "Gromsblood",
          "Blindweed",
          "Ghost Mushroom",
          "Sungrass",
          "Arthas' Tears",
          "Purple Lotus",
          "Firebloom",
          "Wildvine",
          "Wintersbite",
          "Khadgar's Whisker",
          "Goldthorn",
          "Fadeleaf",
          "Liferoot",
          "Kingsblood",
          "Wild Steelbloom",
          "Grave Moss",
          "Bruiseweed",
          "Stranglekelp",
          "Briarthorn",
          "Swiftthistle",
          "Mageroyal"
      },
      Highrisk = {
          "Scourge Tinged Meaty Limb",
          "Scourge Tinged Meat Chunks",
          "Sanguine Tinged Meat Chunks",
          "Nether Tinged Meat Chunks",
          "Dread Tinged Meaty Limb",
          "Dread Tinged Meat Chunks",
          "Demon Tinged Meaty Limb",
          "Demon Tinged Meat Chunks",
          "Core Tinged Meaty Limb",
          "Core Tinged Meat Chunks",
          "Void Tinged Trinket",
          "Twisted Tinged Trinket",
          "Scourge Tinged Trinket",
          "Dread Tinged Trinket",
          "Demon Tinged Trinket",
          "Core Tinged Trinket",
          "Frayed Winterweave",
          "Frayed Void Weave",
          "Frayed Twisted Weave",
          "Frayed Twilight Cloth",
          "Frayed Scourge Weave",
          "Frayed Scarlet Cloth",
          "Frayed Sanguine Weave",
          "Frayed Profane Cloth",
          "Frayed Plagueweave",
          "Frayed Nether Weave",
          "Frayed Infused Deadwind Cloth",
          "Frayed Dread Weave",
          "Frayed Dragonweave Cloth",
          "Frayed Demon Weave",
          "Frayed Core Weave",
          "Tainted Wintersteel",
          "Tainted Star Metal",
          "Tainted Plague Iron",
          "Tainted Meteorite Shards",
          "Tainted Living Irontree Bark",
          "Tainted Living Iron",
          "Tainted Fused Silithid Carapace",
          "Tainted Dragonsteel",
          "Tainted Chitin Alloy",
          "Tainted Beating Frostmaul Heart",
          "Tainted Abomination Chains",
          "Overwhelming Void Effigy",
          "Overwhelming Twisted Effigy",
          "Overwhelming Scourge Effigy",
          "Overwhelming Dread Effigy",
          "Overwhelming Demon Effigy",
          "Overwhelming Core Effigy"
      }
      }

-- add a print statement for how much gold you earned later

local itemsToBlacklist = {"Cloth", "OresAndBars", "Righteous Orbs", "Herbs", "Highrisk"}

local function UpdateBlacklist()
  blacklist = {} -- Reset the blacklist
  for _, category in ipairs(categories) do
      local checkbox = _G["SellOMatic_Checkbox" .. category]
      if checkbox and checkbox:GetChecked() then
          for _, item in ipairs(itemsToSellByCategory[category]) do
              blacklist[item] = true
          end
      end
  end
end


-- Function to check if an item is blacklisted
local function IsBlacklisted(itemName)
  return blacklist[itemName]
end

-- Updated SellItems function to sell items of a specific quality from the inventory to the vendor, excluding those in the blacklist.
local function SellItems(quality)
  if not MerchantFrame or not MerchantFrame:IsVisible() then return end

  for bag = 0, 4 do
      for slot = 1, GetContainerNumSlots(bag) do
          local link = GetContainerItemLink(bag, slot)
          if link then
              local itemName, _, itemQuality = GetItemInfo(link)
              if itemQuality == quality and not IsBlacklisted(itemName) then
                  UseContainerItem(bag, slot)
              end
          end
      end
  end
end
  




-- Creates the sell buttons and attaches them to the MerchantFrame.
function CreateSellButtons()
    if SellomaticSellWhiteItemsButton and SellomaticSellGreenItemsButton and SellomaticSellBlueItemsButton and SellomaticSellEpicItemsButton then
        return -- Buttons already exist, ensure they are not recreated
    end

    local buttonWidth = 100
    local buttonHeight = 16
    local spacing = 10

    local merchantFrameLevel = MerchantFrame:GetFrameLevel()

    -- Create 'Sell White Items' button
    local SellomaticSellWhiteItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellWhiteItemsButton:SetText("Sell Whites")
    SellomaticSellWhiteItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellWhiteItemsButton:SetPoint("TOPLEFT", MerchantFrame, "TOPLEFT", 80, -37.5)
    SellomaticSellWhiteItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellWhiteItemsButton:SetScript("OnClick", function() SellItems(1) end)

    -- Create 'Sell Green Items' button
    local SellomaticSellGreenItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellGreenItemsButton:SetText("Sell Greens")
    SellomaticSellGreenItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellGreenItemsButton:SetPoint("LEFT", SellomaticSellWhiteItemsButton, "RIGHT", spacing, 0)
    SellomaticSellGreenItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellGreenItemsButton:SetScript("OnClick", function() SellItems(2) end)

    -- Create 'Sell Blue Items' button
    local SellomaticSellBlueItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellBlueItemsButton:SetText("Sell Blues")
    SellomaticSellBlueItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellBlueItemsButton:SetPoint("TOPLEFT", SellomaticSellWhiteItemsButton, "BOTTOMLEFT", 0, -1.5, -spacing)
    SellomaticSellBlueItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellBlueItemsButton:SetScript("OnClick", function() SellItems(3) end)

    -- Create 'Sell Epic Items' button
    local SellomaticSellEpicItemsButton = CreateFrame("Button", nil, MerchantFrame, "OptionsButtonTemplate")
    SellomaticSellEpicItemsButton:SetText("Sell Epics")
    SellomaticSellEpicItemsButton:SetSize(buttonWidth, buttonHeight)
    SellomaticSellEpicItemsButton:SetPoint("LEFT", SellomaticSellBlueItemsButton, "RIGHT", spacing, 0, -1.5)
    SellomaticSellEpicItemsButton:SetFrameLevel(merchantFrameLevel + 1)
    SellomaticSellEpicItemsButton:SetScript("OnClick", function() SellItems(4) end)

end

  
  


  
  

-- Main event frame.
local frame = CreateFrame("Frame")
frame:RegisterEvent("MERCHANT_SHOW")
frame:SetScript("OnEvent", function(self, event)
  if event == "MERCHANT_SHOW" then
      CreateSellButtons()
      UpdateBlacklist() -- Ensure the blacklist is up-to-date
      print("Merchant show: Blacklist refreshed.") -- Debugging statement
  end
end)


-- Slash command setup
SLASH_SELLOMATIC1 = "/sellomatic"
SlashCmdList["SELLOMATIC"] = function(msg)
    InterfaceOptionsFrame_OpenToCategory(SellOMatic_InterfacePanel)
end

-- Interface panel
SellOMatic_InterfacePanel = CreateFrame("Frame", "SellOMatic_InterfacePanel", InterfaceOptionsFramePanelContainer)
SellOMatic_InterfacePanel.name = "Sell-O-Matic"
InterfaceOptions_AddCategory(SellOMatic_InterfacePanel)

-- Panel title
SellOMatic_InterfacePanel.title = SellOMatic_InterfacePanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
SellOMatic_InterfacePanel.title:SetPoint("TOPLEFT", 16, -16)
SellOMatic_InterfacePanel.title:SetText("Sell-O-Matic Options")

-- Function to create checkboxes
local function CreateCheckbox(parent, id, labelText, tooltipText)
  local checkbox = CreateFrame("CheckButton", "SellOMatic_Checkbox" .. category, SellOMatic_InterfacePanel, "UICheckButtonTemplate")
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

-- Checkboxes
local itemsToBlacklist = {"Cloth", "Righteous Orbs", "OresAndBars", "Herbs", "Highrisk"} -- Corrected category names

local function CreateCheckboxesForBlacklist()
  local prevCheckbox -- For positioning checkboxes below one another
  for i, category in ipairs(categories) do
      local checkbox = CreateFrame("CheckButton", "SellOMatic_Checkbox" .. category, SellOMatic_InterfacePanel, "UICheckButtonTemplate")
      checkbox:SetPoint("TOPLEFT", prevCheckbox or SellOMatic_InterfacePanel.title, "BOTTOMLEFT", 0, prevCheckbox and -30 or -10)
      local checkboxLabel = _G[checkbox:GetName() .. "Text"] or checkbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
      checkboxLabel:SetPoint("LEFT", checkbox, "RIGHT", 0, 0)
      checkboxLabel:SetText("Blacklist " .. category)
      checkbox.tooltipText = "Prevents selling of " .. category .. " if checked"
      checkbox:SetScript("OnClick", function()
          UpdateBlacklist()
          -- Optionally, sync with selling logic here if immediate action is required
      end)
      prevCheckbox = checkbox
  end
end



-- Function to update the blacklist based on checkbox selections
local function UpdateBlacklist()
  blacklist = {} -- Reset the blacklist
  for _, category in ipairs(categories) do
      local checkbox = _G["SellOMatic_Checkbox" .. category]
      if checkbox and checkbox:GetChecked() then
          for _, item in ipairs(itemsToSellByCategory[category]) do
              blacklist[item] = true
          end
      end
  end
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
        local checkbox = _G["SellOMatic_Checkbox".. category]
        SellOMatic_Settings[item] = checkbox:GetChecked()
    end
end

SellOMatic_InterfacePanel.refresh = function() -- Refresh UI from saved settings
    for i, item in ipairs(itemsToSell) do
        local checkbox = _G["SellOMatic_Checkbox".. category]
        checkbox:SetChecked(SellOMatic_Settings[item])
    end
end

-- Function to save checkbox states
local function SaveCheckboxStates()
  for i, category in ipairs(categories) do
      local checkbox = _G["SellOMatic_Checkbox".. category]
      SellOMatic_Settings[category] = checkbox:GetChecked()
  end
end

-- Function to load checkbox states
local function LoadCheckboxStates()
  SellOMatic_Settings = SellOMatic_Settings or {}
  for i, category in ipairs(categories) do
      local checkbox = _G["SellOMatic_Checkbox".. category]
      checkbox:SetChecked(SellOMatic_Settings[category] or false)
  end
  UpdateBlacklist() -- Ensure blacklist is updated based on loaded settings
end

SellOMatic_InterfacePanel:SetScript("OnShow", function()
  CreateCheckboxesForBlacklist()
  LoadCheckboxStates() -- Assuming this adjusts checkbox states based on saved settings
end)

local function SyncCheckboxesWithBlacklist()
  for _, category in ipairs(categories) do
    local isCategoryBlacklisted = false
    for _, item in ipairs(itemsToSellByCategory[category]) do
      if blacklist[item] then
        isCategoryBlacklisted = true
        break -- If any item in the category is blacklisted, mark the category as blacklisted and stop checking further
      end
    end
    local checkbox = _G["SellOMatic_Checkbox" .. category]
    if checkbox then
      checkbox:SetChecked(isCategoryBlacklisted)
    end
  end
end

-- Add saving functionality to the interface panel's okay button
SellOMatic_InterfacePanel.okay = function()
    SaveCheckboxStates()
end

SellOMatic_InterfacePanel.cancel = SellOMatic_InterfacePanel.default -- Revert to last saved

for i = 1, #categories do
  local checkbox = _G["SellOMatic_Checkbox".. category]
  checkbox:SetScript("OnClick", UpdateBlacklist)
end

-- Example snippet for checkbox creation and event binding
local prevCheckbox
for i, category in ipairs(categories) do
    local checkbox = CreateFrame("CheckButton", "SellOMatic_Checkbox" .. category, parentFrame, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", 10, -30 * i)
    checkbox:SetScript("OnClick", UpdateBlacklist)
    _G[checkbox:GetName() .. "Text"]:SetText("Prevents selling of " .. category .. " if checked")
    prevCheckbox = checkbox
end


-- Combined event handler frame
local eventHandler = CreateFrame("Frame")

-- Register for both ADDON_LOADED and CHECKBOX_CLICK events
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("CHECKBOX_CLICK")

-- Register only the ADDON_LOADED event
eventHandler:SetScript("OnEvent", function(self, event, SellOMatic)
  if event == "ADDON_LOADED" and SellOMatic then -- Replace with your actual addon name
    CreateCheckboxesForBlacklist() -- Call your checkbox creation function
    LoadCheckboxStates() -- Load saved checkbox states if any
    eventHandler:UnregisterEvent("ADDON_LOADED") -- Unregister to avoid repeated calls
  end
end)