local _G                    = _G
local A                     = _G.Action
local Player                = A.Player
local TMW                   = _G.TMW
local GetToggle             = A.GetToggle
local Unit                  = A.Unit

local playerGUID = UnitGUID("player")
local targetGUID = UnitGUID("target")
local swingCount = 0
local finalityTimestamp = nil
local finalityApplied = false


local f = CreateFrame("Frame")

f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

f:SetScript("OnEvent", function(self, event)
        self:COMBAT_LOG_EVENT_UNFILTERED(CombatLogGetCurrentEventInfo())
    end
)

_G['RuptureDB'] = {}

function f:COMBAT_LOG_EVENT_UNFILTERED(...)
    --finalityUp = Unit("player"):HasBuffs(340601) ~= 0
    --local _, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName _, _, spellID, _, _, _, _, _, _, _, _, _, _, _ = ...
    local timestamp, subEvent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName = ...
    
    if sourceGUID ~= UnitGUID("player") then return end


    --if (subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH") then print(sourceGUID, playerGUID, sourceGUID ~= playerGUID) end
    if subEvent == "SWING_DAMAGE" then
        swingCount = swingCount + 1

    elseif subEvent == "SPELL_ENERGIZE" and spellID == 196911 then
        swingCount = 0
    end
    
    if (subEvent == "SPELL_AURA_APPLIED") and spellID == 340601 then 
        finalityApplied = true
    end

    if (subEvent == "SPELL_AURA_REMOVED") and spellID == 340601 then 
        --print(timestamp)
        finalityTimestamp = timestamp
        --finalityApplied = false
    end

    if (subEvent == "SPELL_CAST_SUCCESS" or subEvent == "SPELL_AURA_REMOVED") and spellID == 1943 then
            --print(finalityTimestamp, timestamp, finalityTimestamp == timestamp)
            _G['RuptureDB'][destGUID] = finalityTimestamp == timestamp
    end

end

function Player:SwingCounter()
    return swingCount
end

function Player:FinalityBuffed(destGUID)
    return _G['RuptureDB'][destGUID]
end
