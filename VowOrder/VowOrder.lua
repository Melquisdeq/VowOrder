-- ============================================================================
-- VowOrder
-- Reorders the Sun Cleric stance bar into a fixed custom visual order.
--
-- How it works:
-- DragonUI's stance module (modules/actionbars/stance.lua) positions
-- ShapeshiftButton1..N left-to-right strictly by form index (1,2,3,4,5...)
-- every time it refreshes the bar (addon.RefreshStance, exposed globally as
-- _G.DragonUI.RefreshStance). Each ShapeshiftButtonN keeps its own default
-- Blizzard binding to form N (that's handled by protected game code, not
-- DragonUI or this addon) -- we ONLY change where each button is anchored
-- on screen, never what it casts.
--
-- We hook DragonUI.RefreshStance with hooksecurefunc so our reorder always
-- runs right after DragonUI finishes its own (default-order) positioning.
-- ============================================================================

local InCombatLockdown = InCombatLockdown
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame

-- ----------------------------------------------------------------------
-- EDIT THIS TABLE TO CHANGE THE ORDER
-- Index = visual slot (1st, 2nd, 3rd... position on the bar)
-- Value = form index as returned by GetShapeshiftFormInfo (i.e. which
--         ShapeshiftButtonN to place there)
--
-- Current form indices (from /run GetShapeshiftFormInfo scan):
--   1 = Vow of Light
--   2 = Vow of Dawn
--   3 = Vow of Radiance
--   4 = Vow of Grace
--   5 = Vow of the Eclipse
--
-- Desired final order: Radiance, Grace, Dawn, Light, Eclipse
-- ----------------------------------------------------------------------
local ORDER = { 3, 4, 2, 1, 5 }

local function GetSpacing()
    local DragonUI = _G.DragonUI
    if DragonUI and DragonUI.db and DragonUI.db.profile
        and DragonUI.db.profile.additional and DragonUI.db.profile.additional.stance then
        return DragonUI.db.profile.additional.stance.button_spacing or 6
    end
    return 6
end

local function ReorderStanceBar()
    if InCombatLockdown() then return end

    local anchor = _G.pUiStanceHolder
    if not anchor then return end

    local space = GetSpacing()
    local prevButton

    for _, formIndex in ipairs(ORDER) do
        local button = _G["ShapeshiftButton" .. formIndex]
        if button then
            button:ClearAllPoints()
            if not prevButton then
                button:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT", 0, 0)
            else
                button:SetPoint("LEFT", prevButton, "RIGHT", space, 0)
            end
            prevButton = button
        end
    end
end

-- ----------------------------------------------------------------------
-- Hook setup
-- ----------------------------------------------------------------------
local hooked = false
local function TryHook()
    if hooked then return end
    local DragonUI = _G.DragonUI
    if DragonUI and DragonUI.RefreshStance then
        hooksecurefunc(DragonUI, "RefreshStance", ReorderStanceBar)
        hooked = true
    end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "DragonUI" then
            TryHook()
        end
        return
    end

    if event == "PLAYER_LOGIN" then
        TryHook() -- fallback in case load order was different than expected
    end

    ReorderStanceBar()
end)
