local _G, setmetatable, pairs, type, math, error, table =
      _G, setmetatable, pairs, type, math, error, table
--local huge = math.huge
local TMW = _G.TMW
local Action = _G.Action
local CONST = Action.Const
local Listener = Action.Listener
local Create = Action.Create
local tremove = table.remove
local GetToggle = Action.GetToggle
--local GetLatency = Action.GetLatency
local GetGCD = Action.GetGCD
local GetCurrentGCD = Action.GetCurrentGCD
--local ShouldStop = Action.ShouldStop
local BurstIsON = Action.BurstIsON
local AuraIsValid = Action.AuraIsValid
local InterruptIsValid = Action.InterruptIsValid
--local DetermineUsableObject = Action.DetermineUsableObject
--local Utils = Action.Utils
local BossMods = Action.BossMods
local TeamCache = Action.TeamCache
--local EnemyTeam = Action.EnemyTeam
--local FriendlyTeam = Action.FriendlyTeam
--local LoC = Action.LossOfControl
local Player = Action.Player
local MultiUnits = Action.MultiUnits
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local UnitCooldown = Action.UnitCooldown
local Unit = Action.Unit
--local Covenant = _G.LibStub("Covenant")
local IsUnitEnemy = Action.IsUnitEnemy
--local IsUnitFriendly = Action.IsUnitFriendly
--local Combat = Action.Combat
--local DisarmIsReady = Action.DisarmIsReady
local LastPlayerCastID = Action.LastPlayerCastID
--local Azerite = LibStub("AzeriteTraits")
local ACTION_CONST_ROGUE_ASSASSINATION = CONST.ROGUE_ASSASSINATION
local ACTION_CONST_AUTOTARGET = CONST.AUTOTARGET
--local ACTION_CONST_SPELLID_FREEZING_TRAP = CONST.SPELLID_FREEZING_TRAP
local IsIndoors, UnitIsUnit, IsMounted, UnitThreatSituation, UnitCanAttack, IsInRaid = _G.IsIndoors, _G.UnitIsUnit, _G.IsMounted, _G.UnitThreatSituation, _G.UnitCanAttack, _G.IsInRaid
local finterrupt = Action.StdUi.Factory[4]["RyanInterrupts"][_G.GetLocale()] --interrupt table as loaded by snippet, uses SpellID index
local dbInterrupt = TMW.db.profile.ActionDB[4]["RyanInterrupts"][_G.GetLocale()] --interrupt table as parsed by Action and modified by user, uses Spell Name index
local CombatLogGetCurrentEventInfo 	= _G.CombatLogGetCurrentEventInfo
local 	 UnitGUID, 	  GetSpellInfo 	= 
	  _G.UnitGUID, _G.GetSpellInfo



Action[ACTION_CONST_ROGUE_ASSASSINATION] = {
    -- Racial
    ArcaneTorrent = Create({ Type = "Spell", ID = 25046}),
    BloodFury = Create({ Type = "Spell", ID = 20572}),
    Fireblood = Create({ Type = "Spell", ID = 265221}),
    AncestralCall = Create({ Type = "Spell", ID = 274738}),
    Berserking = Create({ Type = "Spell", ID = 26297}),
    ArcanePulse = Create({ Type = "Spell", ID = 260364}),
    QuakingPalm = Create({ Type = "Spell", ID = 107079}),
    Haymaker = Create({ Type = "Spell", ID = 287712}),
    WarStomp = Create({ Type = "Spell", ID = 20549}),
    BullRush = Create({ Type = "Spell", ID = 255654}),
    BagofTricks = Create({ Type = "Spell", ID = 312411}),
    GiftofNaaru = Create({ Type = "Spell", ID = 59544 }),
    LightsJudgment = Create({ Type = "Spell", ID = 255647}),
    Shadowmeld = Create({ Type = "Spell", ID = 58984}), -- usable in Action Core
    Stoneform = Create({ Type = "Spell", ID = 20594}),
    WilloftheForsaken = Create({ Type = "Spell", ID = 7744}), -- usable in Action Core
    EscapeArtist = Create({ Type = "Spell", ID = 20589}), -- usable in Action Core
    EveryManforHimself = Create({ Type = "Spell", ID = 59752}), -- usable in Action Core
    Regeneratin = Create({ Type = "Spell", ID = 291944}), -- not usable in APL but user can Queue it
    --Talents
	Subterfuge = Create({ Type = "Spell", ID = 108208, isTalent = true}),
    SubterfugeBuff  = Create({ Type = "Spell", ID = 115192, isTalent = true, Hidden = true}),
	Nightstalker = Create({ Type = "Spell", ID = 14062, isTalent = true}),
	Exsanguinate = Create({ Type = "Spell", ID = 200806, isTalent = true}),
	CrimsonTempest = Create({ Type = "Spell", ID = 121411, isTalent = true}),
	MasterAssassin = Create({ Type = "Spell", ID = 255989, isTalent = true}),
    Blindside = Create({ Type = "Spell", ID = 328085, isTalent = true, Hidden = true}),
    HiddenBlades = Create({ Type = "Spell", ID = 270061, isTalent = true, Hidden = true}),
    -- general
    Stealth = Create({ Type = "Spell", ID = 1784}),
    DeadlyPoison = Create({ Type = "Spell", ID = 2823}),
    CripplingPoison = Create({ Type = "Spell", ID = 3408}),
    NumbingPoison = Create({ Type = "Spell", ID = 5761}),
    WoundPoison = Create({ Type = "Spell", ID = 8679}),
    CrimsonVial = Create({ Type = "Spell", ID = 185311}),
    TricksOfTheTrade = Create({ Type = "Spell", ID = 57934}),
    PoolResource = Create({ Type = "Spell", ID = 97238, Hidden = true}),
    ShroudOfConcealment = Create({ Type = "Spell", ID = 114018}),
	Sap = Create({ Type = "Spell", ID = 6770}),
    Shiv = Create({ Type = "Spell", ID = 5938}),
    ShivDebuff = Create({ Type = "Spell", ID = 319504}),
    Ambush = Create({ Type = "Spell", ID = 8676}),
    CheapShot = Create({ Type = "Spell", ID = 1833}),
    Blind = Create({ Type = "Spell", ID = 2094}),
    Feint = Create({ Type = "Spell", ID = 1966}),
    KidneyShot = Create({ Type = "Spell", ID = 408}),
    Evasion = Create({ Type = "Spell", ID = 5277}),
    CloakofShadows = Create({ Type = "Spell", ID = 31224}),
    Distract = Create({ Type = "Spell", ID = 1725}),
    PickPocket = Create({ Type = "Spell", ID = 921}),
	-- CDS
	Vendetta = Create({ Type = "Spell", ID = 79140}),
    --Covenants
    Sepsis = Create({ Type = "Spell", ID = 328305}),
    SerratedBoneSpike = Create({ Type = "Spell", ID = 328547}),
    EchoingReprimand = Create({ Type = "Spell", ID = 323547}),
    Flagellation = Create({ Type = "Spell", ID = 323654}),
    FlagellationBuff = Create({ Type = "Spell", ID = 345569}),
    --PhialofSerenity = Create({ Type = "Spell", ID = 177278}),
	SummonSteward = Create({ Type = "Spell", ID = 324739}),
    --Conduits
    TripleThreat = Create({ Type = "Spell", ID = 341540}),
	--Legendary
	Celerity = Create({ Type = "Spell", ID = 340087,Hidden = true}),
	MarkoftheMasterAssassin = Create({ Type = "Spell", ID = 340076,Hidden = true}),
	TinyToxicBlade = Create({ Type = "Spell", ID = 340078,Hidden = true}),
    Doomblade  = Create({ Type = "Spell", ID = 340082,Hidden = true}),
    DashingScoundrel = Create({ Type = "Spell", ID = 340081,Hidden = true}),
    DeathlyShadows = Create({ Type = "Spell", ID = 340092,Hidden = true}),
    DuskwalkersPatch = Create({ Type = "Spell", ID = 340084,Hidden = true}),
    Obedience = Create({ Type = "Spell", ID = 354703,Hidden = true}),
    --Buffs
    SliceAndDice = Create({ Type = "Spell", ID = 145418}),
    DeeperStratagem = Create({ Type = "Spell", ID = 193531}),
    MarkedForDeath = Create({ Type = "Spell", ID = 137619}),
    FlayedwingToxin = Create({ Type = "Spell", ID = 345545,Hidden = true}),
    Soulshape = Create({ Type = "Spell", ID = 310143}),
    Vanish = Create({ Type = "Spell", ID = 1856}),
    VanishStealth = Create({ Type = "Spell", ID = 11327,Hidden = true}),
    SepsisStealth = Create({ Type = "Spell", ID = 347037,Hidden = true}),
    Elusiveness = Create({ Type = "Spell", ID = 79008}),
    EchoingReprimandBuff = Create({ Type = "Spell", ID = 323558,Hidden = true}),
    MasterAssassinsMark = Create({ Type = "Spell", ID = 340094,Hidden = true}),
	StolenShadehound = Create({ Type = "Spell", ID = 338659,Hidden = true}),
	Sanguine = Create({ Type = "Spell", ID = 226510,Hidden = true}),
	Inspired = Create({ Type = "Spell", ID = 343503,Hidden = true}),
    MarrowedGemstoneEnhancement = Create({ Type = "Spell", ID = 327069,Hidden = true}),
   	--Debuffs
	GluttonousMiasma= Create({ Type = "Spell", ID = 329298,Hidden = true}),
   --kick
    Kick = Create({ Type = "Spell", ID = 1766}),
    KickGreen = Create({ Type = "SpellSingleColor",ID = 1766,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    BlindGreen = Create({ Type = "SpellSingleColor",ID = 2094,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    KidneyShotGreen = Create({ Type = "SpellSingleColor",ID = 408,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    CheapShotGreen = Create({ Type = "SpellSingleColor",ID = 1833,Hidden = true,Color = "GREEN",QueueForbidden = true}),
	-- Rotation
	Garrote = Create({ Type = "Spell", ID = 703}),
    GarroteDebuff = Create({ Type = "Spell", ID = 1330}),
	Rupture = Create({ Type = "Spell", ID = 1943}),
	PoisonedKnife = Create({ Type = "Spell", ID = 185565}),
	FanofKnives = Create({ Type = "Spell", ID = 51723}),
	Envenom = Create({ Type = "Spell", ID = 32645}),
	Mutilate = Create({ Type = "Spell", ID = 1329}),
    -- Items
    PotionofUnbridledFury = Create({ Type = "Potion", ID = 169299}),
    BottledFlayedwingToxin = Create({ Type = "Trinket", ID = 178742,Hidden = true}),
    InscrutableQuantumDevice = Create({ Type = "Trinket", ID = 179350,Hidden = true}),
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion = Create({ Type = "Trinket", ID = 161674}),
    DreadCombatantsInsignia = Create({ Type = "Trinket", ID = 161676}),
    DreadCombatantsMedallion = Create({ Type = "Trinket", ID = 161811,Hidden = true}), -- Game has something incorrect with displaying this
    DreadGladiatorsBadge = Create({ Type = "Trinket", ID = 161902}),
    DreadAspirantsMedallion = Create({ Type = "Trinket", ID = 162897}),
    DreadAspirantsBadge = Create({ Type = "Trinket", ID = 162966}),
    SinisterGladiatorsMedallion = Create({ Type = "Trinket", ID = 165055}),
    SinisterGladiatorsBadge = Create({ Type = "Trinket", ID = 165058}),
    SinisterAspirantsMedallion = Create({ Type = "Trinket", ID = 165220}),
    SinisterAspirantsBadge = Create({ Type = "Trinket", ID = 165223}),
    NotoriousGladiatorsMedallion = Create({ Type = "Trinket", ID = 167377}),
    NotoriousGladiatorsBadge = Create({ Type = "Trinket", ID = 167380}),
    NotoriousAspirantsMedallion = Create({ Type = "Trinket", ID = 167525}),
    NotoriousAspirantsBadge = Create({ Type = "Trinket", ID = 167528}),
}

ListenedSpells 				= {}
local ListenedAuras 				= {}
local ListenedLastCast 				= {}	

local A = setmetatable(Action[ACTION_CONST_ROGUE_ASSASSINATION], { __index = Action })

local player= "player"
local Temp = {
    TotalAndPhys = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    BerserkerRageLoC = {"FEAR", "INCAPACITATE"},
    CastStartTime = {},
    IsSlotTrinketBlocked = {
        [A.BottledFlayedwingToxin.ID] = true,
        [A.InscrutableQuantumDevice.ID] = true,

    },
}; do
    -- Push IsSlotTrinketBlocked
    for key, val in pairs(Action[ACTION_CONST_ROGUE_ASSASSINATION]) do
        if type(val) == "table" and val.Type == "Trinket" then
            Temp.IsSlotTrinketBlocked[val.ID] = true
        end
    end
end

local DefensiveCasts = { --This table is used to identify Target casts should be feinted in the last 4 seconds. 
    [328177] = A.Feint, --Fungistorm, PF, Trash
    [330423] = A.Feint, --Fungistorm, PF, Trash
    [328176] = A.Feint, --Fungistorm, PF, Trash
    [330422] = A.Feint, --Fungistorm, PF, Trash
    [340481] = A.Feint, --Fungistorm, PF, Trash
    [340633] = A.Feint, --Fungistorm, PF, Trash
    [325360] = A.Feint, --Rite of Supremacy, SD, Third Boss
    [342135] = A.Feint, --Interrupting Roar, Top, Trash
    [325877] = A.Feint, --Ember Blast, CN, Shade of Kael'thas
    [326409] = A.Feint, --Thrash, HoA
    [330716] = A.Feint, --Soulstorm, Top
    [324909] = A.Feint, --Furious Thrashing, Mists
    [322554] = A.Feint, --Castigate, SD
    [334625] = A.Feint, --Abyssal Detonation, SOA
    [322895] = A.Feint, --Gloom Squall, SD
    [324527] = A.Feint, --Plaguestomp, PF
    [323195] = A.Feint, --Purifying Blast, SOA
    [333827] = A.Feint, --Seismic Stomp, ToP
    [322232] = A.Feint, --Infectious Rain, PF
    [319685] = A.Feint, --Severing Smash, SD
    [335305] = A.CloakofShadows, --Barbed Shackles - SD
    [358971] = A.Feint, --Wave of Terror - Varruth
    [356925] = A.Evasion, --Carnage - Varruth 
    [355806] = A.Evasion, --Massive Smash - Soggodon
    [322486] = A.CloakofShadows, --Overgrowth, Mists
}

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Locals 
-------------------------------------------------------------------------------	
-- PMultiplier Calculator
local function ComputePMultiplier(ListenedSpell)
    local PMultiplier = 1
    for j = 1, #ListenedSpell.Buffs do
        local Buff = ListenedSpell.Buffs[j]
        local Spell = Buff[1]
        local Modifier = Buff[2]
        -- Check if we did registered a Buff to check + a modifier (as a number or through a function).
        if Modifier then
            if Unit("player"):HasBuffs(Spell, true) > 0 or (ListenedLastCast[SpellID] and TMW.time - ListenedLastCast[SpellID] < 0.1)  then
                local ModifierType = type(Modifier)
                if ModifierType == "number" then
                    PMultiplier = PMultiplier * Modifier
                elseif ModifierType == "function" then
                    PMultiplier = PMultiplier * Modifier()
                end
            end
        else
            -- If there is only one element, then check if it's an AIO function and call it.
            if type(Spell) == "function" then
                PMultiplier = PMultiplier * Spell()
            end
        end
    end
    return PMultiplier
end

local function PMultiplierLaunch(...)
	--Assassination
	if Unit("player"):HasSpec(259) then 
		Listener:Add("ACTION_EVENT_PMULTIPLIER", "COMBAT_LOG_EVENT_UNFILTERED", function(...)
			local _, EVENT, _, SourceGUID, _,_,_, DestGUID, _, _, _, SpellID  = CombatLogGetCurrentEventInfo()
			
			-- PMultiplier OnCast Listener
			if EVENT == "SPELL_CAST_SUCCESS" then 
				local ListenedSpell = ListenedSpells[SpellID]
				if ListenedSpell then
					local PMultiplier = ComputePMultiplier(ListenedSpell)
					ListenedSpell.PMultiplier[DestGUID] = { PMultiplier = PMultiplier, Time = TMW.time, Applied = false }					
				end    
			-- PMultiplier OnApply/OnRefresh Listener
			elseif EVENT == "SPELL_AURA_APPLIED" or EVENT == "SPELL_AURA_REFRESH" then 
				local ListenedAura = ListenedAuras[SpellID]
				if ListenedAura then
					local ListenedSpell = ListenedSpells[ListenedAura]
					if ListenedSpell and ListenedSpell.PMultiplier[DestGUID] then
						ListenedSpell.PMultiplier[DestGUID].Applied = true
					end
				end    
			elseif EVENT == "SPELL_AURA_REMOVED" then 
				local ListenedAura = ListenedAuras[SpellID]				
				if ListenedAura then					
					local ListenedSpell = ListenedSpells[ListenedAura]
					if ListenedSpell and ListenedSpell.PMultiplier[DestGUID] then
						ListenedLastCast[SpellID] = TMW.time
						ListenedSpell.PMultiplier[DestGUID].Applied = false
					end
				end    
			-- PMultiplier OnRemove & OnUnitDeath Listener    
			elseif EVENT == "UNIT_DIED" or EVENT == "UNIT_DESTROYED" then         
				for SpellID, Spell in pairs(ListenedSpells) do
					if Spell.PMultiplier[DestGUID] then
						Spell.PMultiplier[DestGUID] = nil
					end
				end            
			end 		
		end)
	else 
		Listener:Remove("ACTION_EVENT_PMULTIPLIER", "COMBAT_LOG_EVENT_UNFILTERED")
	end
end

local function SpellRegisterError(Spell)
    local SpellName = GetSpellInfo(Spell)
    if SpellName then
        return "You forgot to register the spell: " .. SpellName .. " in PMultiplier handler."
    else
        return "You forgot to register the spell object."
    end
end

local function CheckWillWasteCooldown(ThisCooldownLength, OtherCooldownRemains, EffectDuration)
    local FightRemains = Unit("target"):TimeToDie()
    if not A.Utils.BossFightRemainsIsNotValid() then
      FightRemains = A.Utils.BossFightRemains()
    elseif FightRemains < EffectDuration then
      return false -- Bail out if we are not in a boss encounter and fighting a low-HP target
    end
    -- e.g. if=floor((fight_remains-30)%cooldown)>floor((fight_remains-30-cooldown.vendetta.remains)%cooldown)
    if math.floor((FightRemains - EffectDuration) / ThisCooldownLength) >
      math.floor((FightRemains - EffectDuration - OtherCooldownRemains) / ThisCooldownLength) then
      return true
    end
    return false
  end

-------------------------------------------------------------------------------
-- API
-------------------------------------------------------------------------------	
function A.RegisterPMultiplier(...)
    local Args = { ... }
    local SelfSpellID = Args[1]
    -- Get the SpellID to check on AURA_APPLIED/AURA_REFRESH, should be specified as first arg or it'll take the current spell object.
    local SpellAura = SelfSpellID
    if type(Args[2]) == "number" then
        SpellAura = Args[2]
        tremove(Args, 2)
    end
    tremove(Args, 1)
    ListenedAuras[SpellAura] = SelfSpellID
    ListenedSpells[SelfSpellID] = { Buffs = Args, PMultiplier = {} }
end
-- dot.foo.pmultiplier
function A.PMultiplier(unitID, SpellID)
    if ListenedSpells[SpellID].PMultiplier then
        local UnitDot = ListenedSpells[SpellID].PMultiplier[UnitGUID(unitID)]
        return UnitDot and UnitDot.Applied and UnitDot.PMultiplier or 0
    else
        error(SpellRegisterError(SpellID))
    end
end
-- action.foo.persistent_multiplier
-- Player:PMultiplier
function A.Persistent_PMultiplier(SpellID)
    local ListenedSpell = ListenedSpells[SpellID]
    if ListenedSpell then
        return ComputePMultiplier(ListenedSpell)
    else
        error(SpellRegisterError(SpellID))
    end
end
-------------------------------------------------------------------------------
-- Register  
-------------------------------------------------------------------------------	
if A.PlayerClass == "ROGUE" then 
	Listener:Add("ACTION_EVENT_PMULTIPLIER", "PLAYER_SPECIALIZATION_CHANGED", PMultiplierLaunch)
	PMultiplierLaunch()
end












------------------------------------------------------------------------------------


















local function boolnumber(value)
  return value and 1 or 0
end
local function InscrutableQuantumDeviceCheck(unitID)
    --@boolean true -- Trinket will DPS or give stat buff. false - Trinket will heal or restore mana
    if Unit(unitID):HealthPercent() < 20 then return true end
    for _, val in pairs(TeamCache.Friendly.GUIDs) do
        if Unit(val):HealthPercent() <= 30 then
            return false
        end
        if Unit(val):PowerType() == "MANA" then
            if Unit(val):PowerPercent() <= 20 then
                return false
            end
        end
    end
    return true
end
-- Use Items (function call includes stealth prevention)
local function UseItems(unitID)
    if A.InscrutableQuantumDevice:IsReady(unitID) and InscrutableQuantumDeviceCheck(unitID) then
        return A.InscrutableQuantumDevice
    end
    if A.Trinket1:IsReady(unitID) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then
        return A.Trinket1
    end
    if A.Trinket2:IsReady(unitID) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then
        return A.Trinket2
    end
    -- use BottledFlayedwingToxin if Brez'd or Buff drops in fight
    if A.BottledFlayedwingToxin:IsReady(unitID, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 then
        return A.BottledFlayedwingToxin
    end
end
local function EchoingBuffMatch()
    local EchoingBuffs = {
    [2] = Unit(player):HasBuffs(323558,_,true) > 0,
    [3] = Unit(player):HasBuffs(323559,_,true) > 0,
    [4] = Unit(player):HasBuffs(323560,_,true) > 0,
    [5] = Unit(player):HasBuffs(354838,_,true) > 0,
    }
    if EchoingBuffs[Player:ComboPoints()]
        then
            return true end
    end
    
--This is also stolen from Taste/Trip (i love thoose guys)
    local SelfCombatEvents = {} -- Combat Log Unfiltered with SourceGUID == PlayerGUID filter
    local tableinsert  = table.insert
    local function RegisterForSelfCombatEvent(Handler, ...)
        local EventsTable = { ... }
        for i = 1, #EventsTable do
            local Event = EventsTable[i]
            if not SelfCombatEvents[Event] then
                SelfCombatEvents[Event] = { Handler }
            else
                tableinsert(SelfCombatEvents[Event], Handler)
            end
        end
    end


    local CombatEvents = {} -- Combat Log Unfiltered

    local function RegisterForCombatEvent(Handler, ...)
        local EventsTable = { ... }
        for i = 1, #EventsTable do
            local Event = EventsTable[i]
            if not CombatEvents[Event] then
                CombatEvents[Event] = { Handler }
            else
                tableinsert(CombatEvents[Event], Handler)
            end
        end
    end



-------------------------------
---- CUSTOM ROGUE FCT ---------
-------------------------------
-- TODO: Register/Unregister Events on SpecChange
Action.BleedTable = {
    Assassination = {
        Garrote = {},
        Rupture = {},
		CrimsonTempest = {}
    },
    --Subtlety = {
    --  Nightblade = {},
    --}
}

local BleedGUID
-- Exsanguinated Handler
-- Exsanguinate Expression
local BleedDuration, BleedExpires
local function Exsanguinated(unit, SpellName)
    BleedGUID = UnitGUID(unit)
    if BleedGUID then
        if SpellName == "Garrote" then
            if Action.BleedTable.Assassination.Garrote[BleedGUID] then
                return Action.BleedTable.Assassination.Garrote[BleedGUID][3]
            end
        elseif SpellName == "Rupture" then
            if Action.BleedTable.Assassination.Rupture[BleedGUID] then
                return Action.BleedTable.Assassination.Rupture[BleedGUID][3]
            end
        elseif SpellName == "CrimsonTempest" then
            if Action.BleedTable.Assassination.CrimsonTempest[BleedGUID] then
                return Action.BleedTable.Assassination.CrimsonTempest[BleedGUID][3]
            end
        end
    end
    return false
end


-- Exsanguinate OnCast Listener
RegisterForSelfCombatEvent(function (...)
        DestGUID, _, _, _, SpellID = select(8, ...)

        -- Exsanguinate
        if SpellID == 200806 then
            for Key, _ in pairs(Action.BleedTable.Assassination) do
                for Key2, _ in pairs(Action.BleedTable.Assassination[Key]) do
                    if Key2 == DestGUID then
                        -- Change the Exsanguinate info to true
                        Action.BleedTable.Assassination[Key][Key2][3] = true
                    end
                end
            end
        end
    end
    , "SPELL_CAST_SUCCESS"
)

-- Bleed infos
local function GetBleedInfos(GUID, SpellID)
    -- Core API is not used since we don't want cached informations
    for i = 1, 40 do
        local auraInfo = {UnitAura(GUID, i, "HARMFUL|PLAYER")}
        if auraInfo[10] == SpellID then
            return auraInfo[5]
        end
    end
    return nil
end

-- Bleed OnApply/OnRefresh Listener
RegisterForSelfCombatEvent(function (...)
        DestGUID, _, _, _, SpellID = select(8, ...)

        --- Record the Bleed Target and its Infos
        -- Garrote
        if SpellID == 703 then
            BleedDuration, BleedExpires = GetBleedInfos(DestGUID, SpellID)
            Action.BleedTable.Assassination.Garrote[DestGUID] = {BleedDuration, BleedExpires, false}
            -- Rupture
        elseif SpellID == 1943 then
            BleedDuration, BleedExpires = GetBleedInfos(DestGUID, SpellID)
            Action.BleedTable.Assassination.Rupture[DestGUID] = {BleedDuration, BleedExpires, false}
        end
    end
    , "SPELL_AURA_APPLIED"
    , "SPELL_AURA_REFRESH"
)
-- Bleed OnRemove Listener
RegisterForSelfCombatEvent(function (...)
        DestGUID, _, _, _, SpellID = select(8, ...)

        -- Removes the Unit from Garrote Table
        if SpellID == 703 then
            if Action.BleedTable.Assassination.Garrote[DestGUID] then
                Action.BleedTable.Assassination.Garrote[DestGUID] = nil
            end
            -- Removes the Unit from Rupture Table
        elseif SpellID == 1943 then
            if Action.BleedTable.Assassination.Rupture[DestGUID] then
                Action.BleedTable.Assassination.Rupture[DestGUID] = nil
            end
        end
    end
    , "SPELL_AURA_REMOVED"
)
-- Bleed OnUnitDeath Listener
RegisterForCombatEvent(function (...)
        DestGUID = select(8, ...)

        -- Removes the Unit from Garrote Table
        if Action.BleedTable.Assassination.Garrote[DestGUID] then
            Action.BleedTable.Assassination.Garrote[DestGUID] = nil
        end
        -- Removes the Unit from Rupture Table
        if Action.BleedTable.Assassination.Rupture[DestGUID] then
            Action.BleedTable.Assassination.Rupture[DestGUID] = nil
        end
    end
    , "UNIT_DIED"
    , "UNIT_DESTROYED"
)
A.RegisterPMultiplier(
    A.Garrote.ID,    -- Garrote action
    -- SubterfugeBuff
    -- i couldnt figure out how to add both a buff check with ID and a function for Talent learned, so i wrote a shitty function to do it all
    {function () 
        if Unit("player"):HasBuffs(A.Subterfuge.ID) ~= 0 or (A.Subterfuge:IsTalentLearned() and Player:IsStealthed())
            then return 1.8 end
        if A.Nightstalker:IsTalentLearned() and Player:IsStealthed()
        then return 1.5 end
        return 1
    end}

)
A.RegisterPMultiplier( -- Garrote action
    A.Rupture.ID,    -- Garrote action
    {function ()
            return (A.Nightstalker:IsTalentLearned() and Player:IsStealthed() and 1.5) or 1
    end}
)




A[1] = function(icon)
    -- if A.StormBoltGreen:IsReady(nil, true, nil, true) and AntiFakeStun("target")
    -- then
    -- return A.StormBoltGreen:Show(icon)
    -- end
    local useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid("target")
    if useKick or useCC or useRacial then
        -- useCC / useRacial
        if not useKick or notKickAble or A.Kick:GetCooldown() > 0 then
            if useCC
            and (Player:GetStance() >=1) and A.CheapShot:IsReady("target") and A.CheapShot:AbsentImun("target", Temp.TotalAndPhysAndCC) and Unit("target"):GetDR("stun") > 0 and not Unit("target"):IsBoss() then
                return A.CheapShotGreen:Show(icon)
            end

            if useCC and A.KidneyShot:IsReady("target") and A.KidneyShot:AbsentImun("target", Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit("target"):GetDR("stun") > 0 and not Unit("target"):IsBoss() then
                return A.KidneyShotGreen:Show(icon)
            end

            if useCC and A.Blind:IsReady("target") and A.Blind:AbsentImun("target", Temp.TotalAndPhysAndCC) and Unit("target"):GetDR("disorient") > 0 and not Unit("target"):IsBoss() then
                return A.BlindGreen:Show(icon)
            end
        end
    end
end
-- [2] Kick AntiFake Rotation
A[2] = function(icon)
    local unitID
    if IsUnitEnemy("mouseover") then
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then
        unitID = "target"
    end

    if unitID then
        local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
        if castLeft > A.GetPing() then
            if not notKickAble and A.Kick:IsReady(unitID, nil, nil, true) and A.Kick:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.KickGreen:Show(icon)
            end
        end
    end
end























-- [3] Single Rotation
A[3] = function(icon)

	-- stop rotation if stolen shademount
	if Unit(player):HasBuffs(A.StolenShadehound.ID) ~= 0 then return end
	if A.InstanceInfo.ID == 2286 and Unit("target"):Name() == "Farra" then return end -- if in Necrotic Wake instance and targetting Companion, stop rotation to allow for covenant Buff cast to finish stealth breaks cast
    if Unit("target"):Name() == "Ashen Phylactery" then return end
    local effective_combo_points = ((EchoingBuffMatch() and 7) or Player:ComboPoints())
    local priority_rotation = GetToggle(2, "usePriorityRotation") and MultiUnits:GetByRange(10) >= 2

	--Testing







    -- Rotations
    function EnemyRotation(unitID)
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        if Unit(unitID):HasDeBuffs("BreakAble") > 0 and Unit(player):CombatTime() == 0 then return end
        if UnitCanAttack(player, unitID) == false then return end
        --Stop Rotation if Vanish is set to off
        if Unit(player):HasBuffs(A.Vanish.ID) ~= 0 and GetToggle(2, "VanishSetting") == 0 then return end
        if IsMounted() then return end
        if Unit(player):HasBuffs(A.ShroudOfConcealment.ID) ~= 0 then return end
        local inMelee = A.Kick:IsInRange(unitID) -- @boolean
        local _, _, _, _, _, npc_id 		= Unit(unitID):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
        local inCombat = Unit(player):CombatTime() > 0
        local isBurst = BurstIsON(unitID) and npc_id ~= 174773-- @boolean ignore Spitefuls in M+
        --def->add_action( "variable,name=single_target,value=spell_targets.fan_of_knives<2" )
        local single_target = MultiUnits:GetByRange(10) <2
        --def->add_action( "variable,name=regen_saturated,value=energy.regen_combined>35", "Combined Energy Regen needed to saturate" )
        local regen_saturated = Player:EnergyRegen() >35
        --testing


        --Stealth with target enemy
        if IsUnitEnemy(unitID) and A.Stealth:IsReady(unitID, true) and Player:GetStance() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
            return A.Stealth:Show(icon)
        end
        --Stealth after Shadowmeld
        if Unit(player):HasBuffs(A.Shadowmeld.ID) ~= 0 then
            return A.Stealth:Show(icon)
        end
		--Shiv Enrages
        if A.Shiv:IsReady(unitID) and Action.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then
            return A.Shiv:Show(icon)
        end
        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then
            return A.ArcaneTorrent:Show(icon)
        end
---------------------------------------------------------------------------------------------
--Target Specific Logic (these if statements are run first and ignore all rotational logic)--
---------------------------------------------------------------------------------------------
        -- kill Explosive Affix
        if Unit(unitID):IsExplosives() 
        and inMelee
        and A.Gloomblade:IsReady(unitID) then
            return A.Gloomblade:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.Backstab:IsReady(unitID) then
            return A.Backstab:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.ShurikenToss:IsReady(unitID) and not inMelee then
            return A.ShurikenToss:Show(icon)
        end
        --Large slime in PF,
        if npc_id == 171887 then 
            if A.Blind:IsReady(unitID) then 
                return A.Blind:Show(icon) 
            else return true end
        end 
        --Torghast Vendors Stop Rotation (sometimes they are yellow)
        if npc_id == 152594 or npc_id == 170257 then return end
        --Spiteful Shade
        if npc_id == 174773 and Unit(unitID):HasDeBuffs({"Stuned", "Disoriented", "PhysStuned"}) == 0 then
            --Evasion tank
            if Unit("targettarget"):Name() == Unit(player):Name() and inMelee and A.Evasion:IsReady(player) then
                return A.Evasion:Show(icon)
            end
            --Stun
            if Unit("targettarget"):Name() == Unit(player):Name() and Player:ComboPoints() >= 2 and A.KidneyShot:IsReady(unitID) and Unit(player):HasBuffs(A.Evasion.ID) == 0 then
                return A.KidneyShot:Show(icon) 
            end
        end
        --Illusionary Vulpin in Mists
        if npc_id == 165251 then 
            if Unit(unitID):HasDeBuffs("BreakAble") == 0 then
                if A.Blind:IsReady(unitID) then 
                    return A.Blind:Show(icon) 
                elseif A.KidneyShot:IsReady(unitID) then
                    return A.KidneyShot:Show(icon)
                end
            else return true end
        end 
        -- Xira the Underhanded -- TOP
        if npc_id == 164464 then 
            if A.Blind:IsReady(unitID) then 
                return A.Blind:Show(icon) 
            elseif A.QuakingPalm:IsReady(unitID) then
                return A.QuakingPalm:Show(icon)
            elseif A.KidneyShot:IsReady(unitID) then
                return A.KidneyShot:Show(icon)
            end
    end 

------------------------------
--END Target Specific Logic --
------------------------------

------------------------------------------
--Function Definitions                  --
------------------------------------------
    -- Garrote tick_time
    local function GarroteTickTime(unitID)
        --@boolean time between each tick of Garrote in seconds
        local tickTime = 2 * Player:SpellHaste()
            if Exsanguinated(unitID, "Garrote") then
                tickTime = tickTime * .5
            end
        return tickTime
    end
    GarroteTickTime = A.MakeFunctionCachedDynamic(GarroteTickTime)
    -- Rupture tick_time
    local function RuptureTickTime(unitID)
        --@boolean time between each tick of Rupture in seconds
        local tickTime = 2 * Player:SpellHaste()
            if Exsanguinated(unitID, "Rupture") then
                tickTime = tickTime * .5
            end
        return tickTime
    end
    RuptureTickTime = A.MakeFunctionCachedDynamic(RuptureTickTime)
    local function MFDSnipe()

        if MultiUnits:GetByRange(15) >= 2 and Player:ComboPointsDeficit() >= 4 and Unit("player"):CombatTime() > 0 and GetCurrentGCD() ~= 0 and not IgnoreNameplates[npc_id] then
            for val in pairs(ActiveUnitPlates) do
                if 	A.MarkedForDeath:IsReady(unitID) 
                and A.Kick:IsInRange(val) 
                and Unit(val):TimeToDie() < Unit(unitID):TimeToDie() and not KeepTarget[select(6, Unit(val):InfoGUID())] and
                    ((UnitCanAttack("player", val) and Unit(val):GetRange() <=15 and UnitThreatSituation("player", val) ~= nil and not Unit(val):IsTotem())	or Unit(val):IsDummy()) then

                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                end
            end
        end
    end
    local function MFD()
        --function is called from StealthCD, CDs, ST
        --MfD Snipping
        if A.MarkedForDeath:IsReady(unitID) and Action.GetToggle(1, "AutoTarget") and MFDSnipe() then
            return true
        end
        --Use MFD
        if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned()) and (not GetToggle(1, "BossMods") or Unit(player):CombatTime() > 0) and not Unit(unitID):IsTotem() then
            return A.MarkedForDeath:Show(icon)
        end
    end


    local function Interrupts()
        local inInstance = IsInAnInstance[A.InstanceInfo.ID]													
        local unitIDinterrupt = "none"    
        local useKick, useCC, useRacial, notKickAble, castLeft              
        local function KickAble(unit)
            if A.AbsentImun(nil, unit, Temp.TotalAndPhysKick) and A.Kick:IsReady(unit) then
                return true
            end
        end    
        local function CheapShotAble(unit)
            if A.CheapShot:IsReadyByPassCastGCD(unit) and A.CheapShot:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Unit(unit):GetDR("stun") > 0 and not Unit(unit):IsBoss() and Unit(unit):HasBuffs(A.Sanguine.ID) == 0 then
                return true
            end
        end
        local function KidneyShotAble(unit)
            if A.KidneyShot:IsReadyByPassCastGCD(unit) and A.KidneyShot:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit(unit):GetDR("stun") > 0 and not Unit(unit):IsBoss() and Unit(unit):HasBuffs(A.Sanguine.ID) == 0 then
                return true
            end
        end
        local function QuakingPalmAble(unit)
            if  A.QuakingPalm:IsReadyByPassCastGCD(unit) and A.QuakingPalm:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Unit(unit):GetDR("incapacitate") > 0 and not Unit(unit):IsBoss() then
                return true
            end
        end
        local function BlindAble(unit)
            if A.Blind:IsReadyByPassCastGCD(unit) and A.Blind:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Unit(unit):GetDR("disorient") > 0 and not Unit(unit):IsBoss() then
                return true
            end
        end
        --All kick/cc macros require mouseover checks, so our logic must match here to prevent missing due to mouse location
        if IsUnitEnemy("mouseover") then
            unitIDinterrupt = "mouseover"
        elseif IsUnitEnemy("target") then
            unitIDinterrupt = "target"
        end
        --uses ryan interrupt table in SL dungeons and raid instance IDs
        if A.GetToggle(2, "InterruptList") and inInstance then
            useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(unitIDinterrupt, "RyanInterrupts", true, true)
        else
            useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(unitIDinterrupt)
        end
        --gather information about current cast
        local totalTime, _, _, spellID, spellName , _, isChanneling  = Unit(unitIDinterrupt):CastTime()
        --if casting anything start interrupt logic
        if spellID ~= nil 
        then
            --Check ryan interrupt snippet if this cast should be stopped instantly and ignore interval checks, update uses based on user UI if so
            if finterrupt[spellID] ~= nil 
            and finterrupt[spellID].ignoreInterval == true 
            and dbInterrupt[spellName] ~= nil
            then
                if dbInterrupt[spellName].useKick 
                and castLeft - (totalTime - GetGCD()) <= 1 - (A.InterruptGetSliders("RyanInterrupts")/100)
                then
                    useKick = dbInterrupt[spellName].useKick 
                end
                useCC = dbInterrupt[spellName].useCC
                useRacial = dbInterrupt[spellName].useRacial
            end
            --Check if target is known to not be CCable
            if (useCC or useRacial) and IsNotCCAble[npc_id] then
                useCC = false
                useRacial = false
            end
            --Check if the cast is a channel and we should wait for the channel to interrupt
            if Channels[spellID] and not isChanneling then
                useKick = false
                useCC = false
                useRacial = false
            end
            --Interrupt as appropriate based on interrupt table, ignore interval checks, and CCable knowledge   
            if useKick or useCC or useRacial then
                -- useKick
                if useKick and castLeft > A.GetPing() and not notKickAble and KickAble(unitIDinterrupt) then
                    return A.Kick:Show(icon)
                end
                -- useCC / useRacial
                if (not useKick or notKickAble or A.Kick:GetCooldown() > castLeft + A.GetPing()) and Unit(unitIDinterrupt):HasBuffs(A.Inspired.ID) == 0 then
                    if useCC and CheapShotAble(unitIDinterrupt) then
                        return A.CheapShot:Show(icon)
                    end
                    if useCC and KidneyShotAble(unitIDinterrupt) then
                        return A.KidneyShot:Show(icon)
                    end
                    if useRacial and QuakingPalmAble(unitIDinterrupt) then
                        return A.QuakingPalm:Show(icon)
                    end
                    if useCC and BlindAble(unitIDinterrupt) then
                        return A.Blind:Show(icon)
                    end
                end
            end
            --check if this is the last GCD we will get and we excpect a GCD interupt before cast done, hold GCD if so
            if 
            dbInterrupt[spellName] ~= nil and   
            ((dbInterrupt[spellName].useCC == true and (CheapShotAble(unitIDinterrupt) or KidneyShotAble(unitIDinterrupt) or BlindAble(unitIDinterrupt)))              
            or 
            (dbInterrupt[spellName].useRacial == true and QuakingPalmAble(unitIDinterrupt)))
            and inMelee
            and castLeft < (GetGCD() + GetCurrentGCD() + A.GetPing())
            then
                print("tell Ryan this happened!")
                return A.PoolResource:Show(icon)
            end
        end
        --Auto Targeting Interrupts
        if A.GetToggle(2, "ATInterrupt") 
        and (not useKick or notKickAble or A.Kick:GetCooldown() > castLeft + A.GetPing()) -- Current Target does not need interrupted
        and not useCC -- Current Target does not need interrupted
        and not useRacial -- Current Target does not need interrupted
        and GetCurrentGCD() ~= 0 --prevent getting stuck auto targeting
        and not IgnoreNameplates[npc_id]  --Target is not something we swap off
        then                                                                                                                                                      
            for val in pairs(ActiveUnitPlates) do
                if A.GetToggle(2, "InterruptList") and inInstance then--uses ryan interrupt table in SL dungeons and raid instance IDs
                useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val, "RyanInterrupts", true, true)
                else
                    useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val)
                end
                local _, _, _, spellID, spellName , _, isChanneling  = Unit(val):CastTime()
                --Check ryan interrupt table if this cast should be stopped instantly and ignore interval checks, update uses if so
                if spellID ~= nil and finterrupt[spellID] ~= nil and finterrupt[spellID].ignoreInterval == true and dbInterrupt[spellName] ~= nil
                then
                    useKick = dbInterrupt[spellName].useKick
                    useCC = dbInterrupt[spellName].useCC
                    useRacial = dbInterrupt[spellName].useRacial
                end
                if useKick or useCC or useRacial then
                    --Check if the nameplate can even be CC'd, if not, correct useCC and useRacial
                    local _, _, _, _, _, npc_id_val 		= Unit(val):InfoGUID()
                    if (useCC or useRacial) and IsNotCCAble[npc_id_val] then
                        useCC = false
                        useRacial = false
                    end
                    --Check for spells that we want to stop the channel not the cast
                    if Channels[spellID] and not isChanneling then
                        useKick = false
                        useCC = false
                        useRacial = false
                    end
                    if Unit(val):HasBuffs(A.Inspired.ID) == 0
                        and not KeepTarget[npc_id_val]
                        and UnitCanAttack("player", val) 
                        and A.Kick:IsInRange(val) 
                        and UnitThreatSituation("player", val) ~= nil
                        and  
                        ((useKick and castLeft > A.GetPing() and not notKickAble and KickAble(val))
                        or (useCC and (CheapShotAble(val) or KidneyShotAble(val) or BlindAble(val)))
                        or (useRacial and QuakingPalmAble(val)))                                                   
                        then
                                return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                end
            end
        end
    end



    local function Defensives()

    if (UnitThreatSituation("player", unitID) or 0 >= 2 ) and A.TricksOfTheTrade:IsReady("focus") then
        return A.TricksOfTheTrade:Show(icon)
    end


        --defensives
        local Evasion = GetToggle(2, "Evasion")
        if Evasion >= 0 and A.Evasion:IsReady(player) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and
        (( -- Auto
                Evasion >= 100 and
                (
                    -- HP lose per sec >= 20
                    Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 50 or Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.50 or
                    -- TTD
                    Unit(player):TimeToDieX(25) < 2 or (A.IsInPvP and Unit(player):HealthPercent() <= 40 and (Unit(player):UseDeff() or (Unit(player, 5):HasFlags() and Unit(player):GetRealTimeDMG() > 0 and Unit(player):IsFocused() )))) and Unit(player):HasBuffs("DeffBuffs", true) == 0) or
            ( -- Custom
                Evasion < 100 and Unit(player):HealthPercent() < Evasion))
        then
            return A.Evasion:Show(icon)
        end
        -- CloakofShadows
        local CloakofShadows = GetToggle(2, "CloakofShadows")
        if CloakofShadows >= 0 and A.CloakofShadows:IsReady(player) and
        (( -- Auto
                CloakofShadows >= 100 and Unit(player):TimeToDieMagicX(25) < 2 and
                -- Magic Damage still appear
                Unit(player):GetRealTimeDMG(4) > 0 and Unit(player):HasBuffs("DeffBuffsMagic") == 0) or
            ( -- Custom
                CloakofShadows < 100 and Unit(player):HealthPercent() < CloakofShadows))
        then
            return A.CloakofShadows:Show(icon)
        end
        -- Feint
        local Feint = GetToggle(2, "Feint")
        if Feint >= 0 and A.Feint:IsReady(player) and
        (( -- Auto
                Feint >= 100 and (Unit(player):IsTankingAoE(16) or A.Elusiveness:IsSpellLearned()) and Unit(player):GetRealTimeDMG() > 0 and
                (Unit(player):TimeToDieX(60) < 2 or
                    (A.IsInPvP and Unit(player):HealthPercent() < 80 and Unit(player):IsFocused(nil, true)))
            )
            or -- Custom
            (Feint < 100 and Unit(player):HealthPercent() < Feint))
        then
            return A.Feint:Show(icon)
        end
    --[[

                -- @return:	-- [1] Current Casting Left Time (seconds) (@number)	-- [2] Current Casting Left Time (percent) (@number)	-- [3] spellID (@number)	-- [4] spellName (@string)	-- [5] notInterruptable (@boolean, false is able to be interrupted)	-- [6] isChannel (@boolean)
        for key, val in pairs(DefensiveCasts) do
            if key == spellID and val:IsReady(player) then
                if not isChannel and CastTimeRemaining <= 4 then
                    return val:Show(icon)
                end
                if isChannel then
                    return val:Show(icon)
                end
            end
        end

    --]]
        --Feint Based on Target Casts
        local CastTimeRemaining, _, spellID, _, _, isChannel = Unit(unitID):IsCastingRemains()
        if DefensiveCasts[spellID] then
            if DefensiveCasts[spellID]:IsReady(player, true) then
                if not isChannel and CastTimeRemaining <= 3 then
                    return DefensiveCasts[spellID]:Show(icon)
                end
                if isChannel then
                    return DefensiveCasts[spellID]:Show(icon)
                end
            end
        end

        -- CrimsonVial
        local CrimsonVial = GetToggle(2, "CrimsonVial")
        if CrimsonVial >= 0 and A.CrimsonVial:IsReady(player) and Unit(player):HealthPercent() < CrimsonVial and Unit(player):HasBuffs(A.CrimsonVial.ID) == 0 then
            return A.CrimsonVial:Show(icon)
        end
        -- Stoneform (Self Dispel)
        if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
            return A.Stoneform:Show(icon)
        end

    end
    local function Opener()
        local useBossTimers = BossMods:HasAnyAddon()==true and GetToggle(1, "BossMods") and not inCombat and Unit(unitID):IsBoss() and (A.InstanceInfo.ID == 2450 or A.InstanceInfo.ID == 2296) --CN and SoD only

        if A.MarkedForDeath:IsReady(unitID)
        and ((not useBossTimers and IsItemInRange(10645, unitID)) or (BossMods:GetPullTimer() ~= 0 and BossMods:GetPullTimer() <= 7)) and not Unit(unitID):IsTotem()
        then
            return A.MarkedForDeath:Show(icon)
        end

        if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5
        and (not useBossTimers or (BossMods:GetPullTimer() ~= 0 and BossMods:GetPullTimer() <= 3))
        then
            return A.SliceAndDice:Show(icon)
        end
    --[[
        -- Open with Garrote from stealth. (An exception is that it is fine to open with  Mutilate if you have  Master Assassin, then apply the DoT after the increased crit window.)
        if GetToggle(2, "Opener") ~= "OFF" and GetCurrentGCD() == 0 and ((not useBossTimers) or Unit(player):CombatTime() > 0) then
            if GetToggle(2, "Opener") == "CheapShot" and A.CheapShot:IsReady(unitID) then
                return A.CheapShot:Show(icon)
            elseif GetToggle(2, "Opener") == "Garrote" then
                --if A.MasterAssassin:IsTalentLearned() and A.Mutilate:IsReady(unitID) then
               --    return A.Mutilate:Show(icon)
                if 	A.Garrote:IsReady(unitID) then
                    return A.Garrote:Show(icon)
                end
            end
        end
--]]
    
        -- Tricks with boss mods works ok in raid use only with @focus macro and Boss Timers checked
        if A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() ~= 0 and BossMods:GetPullTimer() <= 3.5) then
            return A.TricksOfTheTrade:Show(icon)
        end
        if A.ShroudOfConcealment:IsReady(player) and IsInRaid() and (BossMods:GetPullTimer() ~= 0 and BossMods:GetPullTimer() <= 9) then
            return A.ShroudOfConcealment:Show(icon)
        end
    end
    local function Vanish()
        --vanish->add_action( "variable,name=nightstalker_cp_condition,value=(!runeforge.deathly_shadows&effective_combo_points>=cp_max_spend)|(runeforge.deathly_shadows&combo_points<2)", "Finish with max CP for Nightstalker, unless using Deathly Shadows" );
        local nightstalker_cp_condition = (not A.DeathlyShadows:HasLegendaryCraftingPower() and effective_combo_points >= Player:ComboPointsMax()) or (A.DeathlyShadows:HasLegendaryCraftingPower() and Player:ComboPoints() <2)
        --vanish->add_action( this, "Vanish", "if=talent.exsanguinate.enabled&talent.nightstalker.enabled&variable.nightstalker_cp_condition&cooldown.exsanguinate.remains<1", "Vanish with Exsg + Nightstalker: Maximum CP and Exsg ready for next GCD" );
       
        if A.Vanish:IsReady(player)
        and A.Exsanguinate:IsTalentLearned()  
        and A.Nightstalker:IsTalentLearned() 
        and nightstalker_cp_condition 
        and A.Exsanguinate:GetCooldown() < 1
        then
            return A.Vanish:Show(icon)
        end
        --vanish->add_action( this, "Vanish", "if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&variable.nightstalker_cp_condition&debuff.vendetta.up", "Vanish with Nightstalker + No Exsg: Maximum CP and Vendetta up" );
        if A.Vanish:IsReady(player)
        and A.Nightstalker:IsTalentLearned()
        and not A.Exsanguinate:IsTalentLearned()  
        and nightstalker_cp_condition 
        and Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0
        then
            return A.Vanish:Show(icon)
        end
        --vanish->add_action( "pool_resource,for_next=1,extra_amount=45" );
        --vanish->add_action( this, "Vanish", "if=talent.subterfuge.enabled&cooldown.garrote.up&(dot.garrote.refreshable|debuff.vendetta.up&dot.garrote.pmultiplier<=1)&combo_points.deficit>=(spell_targets.fan_of_knives>?4)&raid_event.adds.in>12" );
        if A.Vanish:IsReady(player)
        and A.Subterfuge:IsTalentLearned()  
        and A.Garrote:GetCooldown() <= GetCurrentGCD() 
        and (Unit(unitID):PT(A.Garrote.ID, true) or Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) and A.PMultiplier(unitID, A.Garrote.ID) <= 1) 
        and Player:ComboPointsDeficit() >= math.min(MultiUnits:GetByRange(10), 4) 
        --and raid_event.adds.in>12 --just blast that shit, i cant tell the future!
        then

            if Player:Energy() <= 45 then
                return A.PoolResource:Show(icon)
            else
                return A.Vanish:Show(icon)
            end
        end

        --vanish->add_action( this, "Vanish", "if=(talent.master_assassin.enabled|runeforge.mark_of_the_master_assassin)&!dot.rupture.refreshable&dot.garrote.remains>3&debuff.vendetta.up&(debuff.shiv.up|debuff.vendetta.remains<4|dot.sepsis.ticking)&dot.sepsis.remains<3", "Vanish with Master Assasin: Rupture+Garrote not in refresh range, during Vendetta+Shiv. Sync with Sepsis final hit if possible." );
        if A.Vanish:IsReady(player)
        and (A.MasterAssassin:IsTalentLearned() or A.MarkoftheMasterAssassin:HasLegendaryCraftingPower()) 
        and  not Unit(unitID):PT(A.Rupture.ID, true) 
        and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) > 3 
        and Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0
        and (Unit(unitID):HasDeBuffs(A.ShivDebuff.ID, true) ~= 0 or Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) < 4 or Unit(unitID):HasDeBuffs(A.Sepsis.ID, true) ~= 0) 
        and Unit(unitID):HasDeBuffs(A.Sepsis.ID, true) < 3
        then
            return A.Vanish:Show(icon)
        end
    end
    local function CDs()
        local VendettaMACondition = not A.MasterAssassin:IsTalentLearned() or Unit(unitID):HasDeBuffs(A.Garrote.ID, true) > 0 or (Player:GetCovenant() == 2  and Player:ComboPointsDeficit() == 0)
        local vendetta_covenant_condition = false
        --precombat->add_action( "variable,name=vendetta_cdr,value=1-(runeforge.duskwalkers_patch*0.45)" );
        local vendetta_cdr = 1-(boolnumber(A.DuskwalkersPatch:HasLegendaryCraftingPower())*0.45)
        --cds->add_action( "variable,name=vendetta_nightstalker_condition,value=!talent.nightstalker.enabled|!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5-2*talent.deeper_stratagem.enabled", "Sync Vendetta window with Nightstalker+Exsanguinate if applicable" );
        local vendetta_nightstalker_condition =
            not A.Nightstalker:IsTalentLearned() 
        or  not  A.Exsanguinate:IsTalentLearned()  
        or  (A.Exsanguinate:IsTalentLearned() and (A.Exsanguinate:GetCooldown() <5-2*boolnumber(A.DeeperStratagem:IsTalentLearned())))
        --precombat->add_action( "variable,name=flagellation_cdr,value=1-(runeforge.obedience*0.44)", "The average CDR is 0.22 but due to the RNG nature of CP gen, 2x this value is optimal for syncing logic" );
        local flagellation_cdr = 1-(boolnumber(A.Obedience:HasLegendaryCraftingPower())*0.44)
        --Im not sure these are needed for Action, IQD is already Prioirty
        --precombat->add_action( "variable,name=trinket_sync_slot,value=1,if=trinket.1.has_stat.any_dps&(!trinket.2.has_stat.any_dps|trinket.1.cooldown.duration>=trinket.2.cooldown.duration)|trinket.1.is.inscrutable_quantum_device", "Determine which (if any) stat buff trinket we want to attempt to sync with Vendetta." );
        --precombat->add_action( "variable,name=trinket_sync_slot,value=2,if=trinket.2.has_stat.any_dps&(!trinket.1.has_stat.any_dps|trinket.2.cooldown.duration>trinket.1.cooldown.duration)|trinket.2.is.inscrutable_quantum_device" );


        --cds->add_talent( this, "Marked for Death", "line_cd=1.5,target_if=min: Unit(unitID):TimeToDie() ,if=raid_event.adds.up and ( Unit(unitID):TimeToDie() < Player:ComboPointsDeficit() *1.5 or  Player:ComboPointsDeficit() >= Player:ComboPointsMax() )", "If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP." );
        --cds->add_talent( this, "Marked for Death", "if=raid_event.adds.in>30-raid_event.adds.duration and  Player:ComboPointsDeficit() >= Player:ComboPointsMax() ", "If no adds will die within the next 30s, use MfD on boss without any CP." );
        if MFD() then return true end
        -- I dont support Fleshcraft
        --cds->add_action( "fleshcraft,if=(soulbind.pustule_eruption or soulbind.volatile_solvent) and  not stealthed.all and  not debuff.vendetta.up and master_assassin_remains=0 and (energy.time_to_max_combined>2 or  not debuff.shiv.up)", "Fleshcraft for Pustule Eruption if not stealthed or in a cooldown cycle" );
        --cds->add_action( "flagellation,if=!stealthed.rogue&(cooldown.vendetta.remains<3&effective_combo_points>=4&target.time_to_die>10|debuff.vendetta.up|fight_remains<24)", "Sync Flagellation with Vendetta as long as we won't lose a cast over the fight duration" );
        -- actions.cds+=/variable,name=vendetta_ma_condition,value=!talent.master_assassin.enabled|dot.garrote.ticking|covenant.venthyr&combo_points.deficit=0
        if not Player:IsStealthed() then
            local FlagellationCDMultiplier = A.Obedience:HasLegendaryCraftingPower() and 0.56 or 1.0
            local VendettaCDMultiplier = A.DuskwalkersPatch:HasLegendaryCraftingPower() and 0.55 or 1.0
                -- actions.cds+=/flagellation,if=!stealthed.rogue&(cooldown.vendetta.remains<3&variable.vendetta_ma_condition&effective_combo_points>=4&target.time_to_die>10|debuff.vendetta.up|fight_remains<24)
                -- actions.cds+=/flagellation,if=!stealthed.rogue&effective_combo_points>=4&(floor((fight_remains-24)%(cooldown*variable.flagellation_cdr))>floor((fight_remains-24-cooldown.vendetta.remains*variable.vendetta_cdr)%(cooldown*variable.flagellation_cdr)))
                if A.Flagellation:IsReady() then
                    if A.Vendetta:GetCooldown() < 3 and VendettaMACondition and effective_combo_points >= 4 and (Unit(unitID):TimeToDie() >10)
                    or Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0 or A.Utils.BossFilteredFightRemains("<=", 24) then
                        return A.Flagellation:Show(icon)
                    elseif effective_combo_points >= 4 and CheckWillWasteCooldown(90 * FlagellationCDMultiplier, A.Vendetta:GetCooldown() * VendettaCDMultiplier, 24) then
                        return A.Flagellation:Show(icon)
                    end
                end
        end
        --[[if A.Flagellation:IsReady()
        and not Player:IsStealthed()  
        and ( A.Vendetta:GetCooldown() <3 and effective_combo_points>=4 and Unit(unitID):TimeToDie() >10 or Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0 or Unit(unitID):TimeToDie()<24)
        then
            return A.Flagellation:Show(icon)
        end
        --cds->add_action( "flagellation,if=!stealthed.rogue&effective_combo_points>=4&(floor((fight_remains-24)%(cooldown*variable.flagellation_cdr))>floor((fight_remains-24-cooldown.vendetta.remains*variable.vendetta_cdr)%(cooldown*variable.flagellation_cdr)))" );
        if A.Flagellation:IsReady()
        and not  Player:IsStealthed()
        and VendettaMACondition
        and effective_combo_points>=4 
        and (math.floor((Unit(unitID):TimeToDie()-24)%(A.Flagellation:GetCooldown()*flagellation_cdr))>math.floor((Unit(unitID):TimeToDie()-24- A.Vendetta:GetCooldown() *vendetta_cdr)%(A.Flagellation:GetCooldown()*flagellation_cdr)))
        then
            return A.Flagellation:Show(icon)
        end
        A.Flagellation:GetCooldown()]]--
        --cds->add_action( "sepsis,if=!stealthed.rogue&(cooldown.vendetta.remains<1&target.time_to_die>10|debuff.vendetta.up|fight_remains<10)", "Sync Sepsis with Vendetta as long as we won't lose a cast over the fight duration, but prefer targets that will live at least 10s" );
        if A.Sepsis:IsReady(unitID)
        and not Player:IsStealthed() 
        and ( A.Vendetta:GetCooldown() <1 and  Unit(unitID):TimeToDie() >10 or Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0  or (Unit(unitID):IsBoss() and Unit(unitID):TimeToDie() < 10))
        then
            return A.Sepsis:Show(icon)
        end
        --cds->add_action( "sepsis,if=!stealthed.rogue&(floor((fight_remains-10)%cooldown)>floor((fight_remains-10-cooldown.vendetta.remains*variable.vendetta_cdr)%cooldown))" );
        if A.Sepsis:IsReady(unitID)
        and not Player:IsStealthed()  
        and (math.floor((Unit(unitID):TimeToDie()-10)%A.Sepsis:GetCooldown())>math.floor((Unit(unitID):TimeToDie()-10- A.Vendetta:GetCooldown() *vendetta_cdr)%A.Sepsis:GetCooldown()))
        then
            return A.Sepsis:Show(icon)
        end
        --cds->add_action( "variable,name=vendetta_covenant_condition,if=covenant.kyrian|covenant.necrolord|covenant.none,value=1", "Sync Vendetta with Flagellation and Sepsis as long as we won't lose a cast over the fight duration" );
        if Player:GetCovenant() == 1 or Player:GetCovenant() == 4 then
            vendetta_covenant_condition = true
        end
        --cds->add_action( "variable,name=vendetta_covenant_condition,if=covenant.venthyr,value=floor((fight_remains-20)%(120*variable.vendetta_cdr))>floor((fight_remains-20-cooldown.flagellation.remains)%(120*variable.vendetta_cdr))|buff.flagellation_buff.up|debuff.flagellation.up|fight_remains<20" );
        if Player:GetCovenant() == 2 then
            vendetta_covenant_condition =
            math.floor((Unit(unitID):TimeToDie()-20)%(120*vendetta_cdr))>math.floor((Unit(unitID):TimeToDie()-20-A.Flagellation:GetCooldown())%(120*vendetta_cdr)) 
            or Unit(player):HasBuffs(A.Flagellation.ID, true) ~= 0
            or Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) ~= 0 
            or (Unit(unitID):IsBoss() and Unit(unitID):TimeToDie() < 20)
        end
        --cds->add_action( "variable,name=vendetta_covenant_condition,if=covenant.night_fae,value=floor((fight_remains-20)%(120*variable.vendetta_cdr))>floor((fight_remains-20-cooldown.sepsis.remains)%(120*variable.vendetta_cdr))|dot.sepsis.ticking|fight_remains<20" );
        if Player:GetCovenant() == 3
        then
            vendetta_covenant_condition = 
            math.floor((Unit(unitID):TimeToDie()-20)%(120*vendetta_cdr))>math.floor((Unit(unitID):TimeToDie() - 20 - A.Sepsis:GetCooldown())%(120*vendetta_cdr)) or Unit(unitID):HasDeBuffs(A.Sepsis.ID, true) ~= 0 or (Unit(unitID):IsBoss() and Unit(unitID):TimeToDie() < 20)

        end
        --cds->add_action( this, "Vendetta", "if=!stealthed.rogue&dot.rupture.ticking&!debuff.vendetta.up&variable.vendetta_nightstalker_condition&variable.vendetta_covenant_condition" );
        if A.Vendetta:IsReady(unitID)
        and not Player:IsStealthed()  
        and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) ~= 0
        and Player:GetDeBuffsUnitCount(A.Vendetta.ID) < 1
        and vendetta_nightstalker_condition 
        and vendetta_covenant_condition
        and inMelee
        and isBurst
        then
            return A.Vendetta:Show(icon)
        end
        --cds->add_talent( this, "Exsanguinate", "if=!stealthed.rogue&(!dot.garrote.refreshable&dot.rupture.remains>4+4*cp_max_spend|dot.rupture.remains*0.5>target.time_to_die)&target.time_to_die>4", "Exsanguinate when not stealthed and both Rupture and Garrote are up for long enough." );
        if A.Exsanguinate:IsReady(unitID)
        and not Player:IsStealthed()  
        and (not Unit(unitID):PT(A.Garrote.ID, true) and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) >4+4 * Player:ComboPointsMax()  or Unit(unitID):HasDeBuffs(A.Rupture.ID, true) * 0.5 > Unit(unitID):TimeToDie()) 
        and  Unit(unitID):TimeToDie() > 4
        then
            return A.Exsanguinate:Show(icon)
        end
        -- actions.cds+=/shiv,if=dot.garrote.ticking&dot.rupture.ticking&(!cooldown.sepsis.ready|cooldown.vendetta.remains>12)|dot.sepsis.ticking
        if A.Shiv:IsReady(unitID)
        and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() >6.5 )
        and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) ~= 0
        and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) ~= 0
        and ((A.Sepsis:GetCooldown() > 12 or A.Vendetta:GetCooldown() >12) or Unit(unitID):HasDeBuffs(A.Sepsis.ID, true) ~= 0)
        then
            return A.Shiv:Show(icon)
        end
        --I dont currently support Potions (too expensive)
        --cds->add_action( potion_action );
        --cds->add_action( "blood_fury,if=debuff.vendetta.up" );
        if A.BloodFury:IsReady(unitID, true) and inMelee and Player:GetDeBuffsUnitCount(A.Vendetta.ID) >= 1 then
            return A.BloodFury:Show(icon)
        end
        --cds->add_action( "berserking,if=debuff.vendetta.up" );
        if A.Berserking:IsReady(unitID, true) and inMelee  and Player:GetDeBuffsUnitCount(A.Vendetta.ID) >= 1 then
            return A.Berserking:Show(icon)
        end
        --cds->add_action( "fireblood,if=debuff.vendetta.up" );
        if A.Fireblood:IsReady(unitID, true) and inMelee and Player:GetDeBuffsUnitCount(A.Vendetta.ID) >= 1 then
            return A.Fireblood:Show(icon)
        end
        --cds->add_action( "ancestral_call,if=debuff.vendetta.up" );
        if A.AncestralCall:IsReady(player) and inMelee and Player:GetDeBuffsUnitCount(A.Vendetta.ID) >= 1 then
            return A.AncestralCall:Show(icon)
        end



        --cds->add_action( "call_action_list,name=vanish,if=!stealthed.all&master_assassin_remains=0" );
        if not Player:IsStealthed() and isBurst and Unit(player):HasBuffs(A.MasterAssassin.ID) == 0 and Vanish() then return Vanish() end
        --cds->add_action( "use_items,slots=trinket1,if=variable.trinket_sync_slot=1 and (debuff.vendetta.up or fight_remains<=20) or (variable.trinket_sync_slot=2 and  not trinket.2.cooldown.ready) or  not variable.trinket_sync_slot", "Sync the priority stat buff trinket with Vendetta, otherwise use on cooldown" );
        --cds->add_action( "use_items,slots=trinket2,if=variable.trinket_sync_slot=2 and (debuff.vendetta.up or fight_remains<=20) or (variable.trinket_sync_slot=1 and  not trinket.1.cooldown.ready) or  not variable.trinket_sync_slot" );
        --Todo review code more, but i believe my implementation is close enough
        local Item = UseItems(unitID)
        if inMelee and isBurst and Unit(player):HasBuffs(A.Stealth.ID) == 0 and Player:GetDeBuffsUnitCount(A.Vendetta.ID) >= 1 and Item then --prevent all items in stealth and BTE sync
            return Item:Show(icon)
        end



    end
    local function Stealth()
        --    stealthed->add_talent( this, "Crimson Tempest", "if=talent.nightstalker.enabled&spell_targets>=3&combo_points>=4&target.time_to_die-remains>6", "Nighstalker on 3T: Crimson Tempest" );
        if A.CrimsonTempest:IsReady(unitID)
        and A.Nightstalker:IsTalentLearned() 
        and MultiUnits:GetByRange(10) >=3 
        and Player:ComboPoints() >= 4 
        and Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.CrimsonTempest.ID, true) >6
        then
            return A.CrimsonTempest:Show(icon)
        end
        --stealthed->add_action( this, "Rupture", "if=talent.nightstalker.enabled&combo_points>=4&target.time_to_die-remains>6", "Nighstalker on 1T: Snapshot Rupture" );
        if A.Rupture:IsReady(unitID)
        and A.Nightstalker:IsTalentLearned() 
        and Player:ComboPoints() >=4 
        and Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > 6
        then
            return A.Rupture:Show(icon)
        end
        --stealthed->add_action( "pool_resource,for_next=1", "Subterfuge: Apply or Refresh with buffed Garrotes" );
        --stealthed->add_action( this, "Garrote", "target_if=min:remains,if=talent.subterfuge.enabled&(remains<12|pmultiplier<=1)&target.time_to_die-remains>2" );
        if A.Garrote:GetCooldown() <= GetCurrentGCD() --the intent here is to not cause energy to skip this check, so start with Cooldown check instead, then pool, then is ready
            and A.Garrote:IsInRange(unitID)
            and A.Subterfuge:IsTalentLearned()
            then
                for val in pairs(ActiveUnitPlates) do
                    if
                        A.Kick:IsInRange(val) 
                        and not KeepTarget[select(6, Unit(val):InfoGUID())]
                        and ((UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --We have threat or it is a dummy
                        and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) > Unit(val):HasDeBuffs(A.Garrote.ID, true) -- i added this to target the "min" garrote remaining
                        and
                        (
                            (Unit(val):HasDeBuffs(A.Garrote.ID, true)<12 or A.PMultiplier(val, A.Garrote.ID) <= 1)
                            and  Unit(val):TimeToDie() - Unit(val):HasDeBuffs(A.Garrote.ID, true) >2
                        )
                        then
                            return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                end
        end
        if A.Garrote:GetCooldown() <= GetCurrentGCD() --the intent here is to not cause energy to skip this check, so start with Cooldown check instead, then pool, then is ready
        and A.Garrote:IsInRange(unitID)
        and A.Subterfuge:IsTalentLearned()
        and (Unit(unitID):HasDeBuffs(A.Garrote.ID, true)<12 or A.PMultiplier(unitID, A.Garrote.ID) <= 1)
        and  Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Garrote.ID, true) > 2

        then
            if Player:Energy() <= 45 then
                return A.PoolResource:Show(icon)
            end
            if A.Garrote:IsReady(unitID) then
                return A.Garrote:Show(icon)
            end
        end
        --stealthed->add_action( "pool_resource,for_next=1", "Subterfuge + Exsg on 1T: Refresh Garrote at the end of stealth to get max duration before Exsanguinate" );
        --stealthed->add_action( this, "Garrote", "if=talent.subterfuge.enabled&talent.exsanguinate.enabled&active_enemies=1&buff.subterfuge.remains<1.3" );
        if A.Garrote:GetCooldown() <= GetCurrentGCD() --the intent here is to not cause energy to skip this check, so start with Cooldown check instead, then pool, then is ready
        and A.Garrote:IsInRange(unitID)
        and A.Subterfuge:IsTalentLearned()
        and A.Exsanguinate:IsTalentLearned()
        and MultiUnits:GetByRange(10) == 1
        and (Unit(player):HasBuffs(A.SubterfugeBuff.ID) ~= 0 and Unit(player):HasBuffs(A.SubterfugeBuff.ID) < 1.3)
        then
            if Player:Energy() <= 45 then
                return A.PoolResource:Show(icon)
            end
            if A.Garrote:IsReady(unitID) then
                return A.Garrote:Show(icon)
            end
        end
        --stealthed->add_action( this, "Mutilate", "if=talent.subterfuge.enabled&combo_points<=3" );
        if A.Mutilate:IsReady(unitID)
        and A.Subterfuge:IsTalentLearned()
        and Player:ComboPoints() <=3
        then
            --print("1")
            return A.Mutilate:Show(icon)
        end
    end
    local function DoTs()
        --dot->add_action( "variable,name=skip_cycle_garrote,value=priority_rotation&(dot.garrote.remains<cooldown.garrote.duration|variable.regen_saturated)", "Limit secondary Garrotes for priority rotation if we have 35 energy regen or Garrote will expire on the primary target" );
        local skip_cycle_garrote = priority_rotation and (Unit(unitID):HasDeBuffs(A.Garrote.ID, true) < A.Garrote:GetCooldown() or regen_saturated)
        --dot->add_action( "variable,name=skip_cycle_rupture,value=priority_rotation&(debuff.shiv.up&spell_targets.fan_of_knives>2|variable.regen_saturated)", "Limit secondary Ruptures for priority rotation if we have 35 energy regen or Shiv is up on 2T+" );
        local skip_cycle_rupture = priority_rotation and (Unit(unitID):HasDeBuffs(A.ShivDebuff.ID, true) ~= 0 and  MultiUnits:GetByRange(10) > 2 or regen_saturated)
        --dot->add_action( "variable,name=skip_rupture,value=debuff.vendetta.up&(debuff.shiv.up|master_assassin_remains>0)&dot.rupture.remains>2", "Limit Ruptures if Vendetta+Shiv/Master Assassin is up and we have 2+ seconds left on the Rupture DoT" );
        local skip_rupture = Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0 and (Unit(unitID):HasDeBuffs(A.ShivDebuff.ID, true) ~= 0 or Unit(player):HasBuffs(A.MasterAssassin.ID) > 0) and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > 2
        --    dot->add_action( this, "Garrote", "if=talent.exsanguinate.enabled&!exsanguinated.garrote&dot.garrote.pmultiplier<=1&cooldown.exsanguinate.remains<2&spell_targets.fan_of_knives=1&raid_event.adds.in>6&dot.garrote.remains*0.5<target.time_to_die", "Special Garrote and Rupture setup prior to Exsanguinate cast" );
        if A.Garrote:IsReady(unitID)
        and A.Exsanguinate:IsTalentLearned()
        and not Exsanguinated(unitID, "Garrote")
        and A.PMultiplier(unitID, A.Garrote.ID) <= 1
        and A.Exsanguinate:GetCooldown() < 2
        and MultiUnits:GetByRange(10) == 1
        --and raid_event.adds.in>6  -- I cant know adds are coming
        and Unit(unitID):HasDeBuffs(A.Garrote.ID, true)*0.5 < Unit(unitID):TimeToDie()
        then
            return A.Garrote:Show(icon)
        end
        --dot->add_action( this, "Rupture", "if=talent.exsanguinate.enabled&(effective_combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&dot.rupture.remains*0.5<target.time_to_die)" );
        if A.Rupture:IsReady(unitID)
        and A.Exsanguinate:IsTalentLearned()
        and effective_combo_points >= Player:ComboPointsMax()
        and A.Exsanguinate:GetCooldown() < 1
        and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) * 0.5 < Unit(unitID):TimeToDie()
        then
            return A.Rupture:Show(icon)
        end
        --dot->add_action( "pool_resource,for_next=1", "Garrote upkeep, also tries to use it as a special generator for the last CP before a finisher" );
        --dot->add_action( this, "Garrote", "if=refreshable&combo_points.deficit>=1&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&(target.time_to_die-remains)>4&master_assassin_remains=0" );
        if A.Garrote:GetCooldown() <= GetCurrentGCD() --the intent here is to not cause energy to skip this check, so start with Cooldown check instead, then pool, then is ready
        and A.Garrote:IsInRange(unitID)
        and
        (
        Unit(unitID):PT(A.Garrote.ID, true)
        and  Player:ComboPointsDeficit() >= 1
        and (A.PMultiplier(unitID, A.Garrote.ID) <= 1 or Unit(unitID):HasDeBuffs(A.Garrote.ID, true) <= GarroteTickTime(unitID) and MultiUnits:GetByRange(10) >= 3)
        and (not Exsanguinated(unitID, "Garrote") or Unit(unitID):HasDeBuffs(A.Garrote.ID, true) <= GarroteTickTime(unitID)*2 and MultiUnits:GetByRange(10) >= 3)
        and (Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Garrote.ID, true)) > 4 and Unit(player):HasBuffs(A.MasterAssassin.ID) == 0
        )
        then
            -- dot->add_action( "pool_resource,for_next=1" ); -- all other conditions are met, Pool energy for this Garrote
            if Player:Energy() <= 45 then
                return A.PoolResource:Show(icon)
            end
            if A.Garrote:IsReady(unitID) then
                return A.Garrote:Show(icon)
            end
        end
        --    dot->add_action( this, "Garrote", "cycle_targets=1,if=!variable.skip_cycle_garrote&target!=self.target&refreshable&combo_points.deficit>=1&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&(target.time_to_die-remains)>12&master_assassin_remains=0" );
        if A.Garrote:GetCooldown() <= GetCurrentGCD() --the intent here is to not cause energy to skip this check, so start with Cooldown check instead, then pool, then is ready
        and A.Garrote:IsInRange(unitID)
        and Action.GetToggle(1, "AutoTarget")
        and Unit(player):CombatTime() > 0
        and not IgnoreNameplates[npc_id]
        and not skip_cycle_garrote
        and  Player:ComboPointsDeficit() >=1
        and not 
        (
            
            Unit(unitID):PT(A.Garrote.ID, true)
            and  Player:ComboPointsDeficit() >= 1
            and (A.PMultiplier(unitID, A.Garrote.ID) <= 1 or Unit(unitID):HasDeBuffs(A.Garrote.ID, true) <= GarroteTickTime(unitID) and MultiUnits:GetByRange(10) >= 3)
            and (not Exsanguinated(unitID, "Garrote") or Unit(unitID):HasDeBuffs(A.Garrote.ID, true) <= GarroteTickTime(unitID)*2 and MultiUnits:GetByRange(10) >= 3)
            and (Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Garrote.ID, true)) > 4 and Unit(player):HasBuffs(A.MasterAssassin.ID) == 0
            
        )
        --and target not =self.target -- im pretty sure this is SIMC saying (don't autotarget if we target ourself, and this isnt really appliccable in action logic)
        then
            for val in pairs(ActiveUnitPlates) do
                if
                A.Kick:IsInRange(val)
                and
                (
                    Unit(val):PT(A.Garrote.ID, true)
                    and (A.PMultiplier(val, A.Garrote.ID) <=1 or Unit(val):HasDeBuffs(A.Garrote.ID, true) <= GarroteTickTime(val) and MultiUnits:GetByRange(10) >=3)
                    and (not Exsanguinated(val, "Garrote") or Unit(val):HasDeBuffs(A.Garrote.ID, true) <= GarroteTickTime(val)*2 and MultiUnits:GetByRange(10) >=3)
                    and (Unit(val):TimeToDie() - Unit(val):HasDeBuffs(A.Garrote.ID, true) ) > 12 and Unit(player):HasBuffs(A.MasterAssassin.ID) == 0
                )
                    -- end of APL checks, start of action checks
                    and not KeepTarget[select(6, Unit(val):InfoGUID())]
                    and ((UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --We have threat or it is a dummy
                then
                    return A:Show(icon, ACTION_CONST_AUTOTARGET)
                end
            end
        end



        --dot->add_talent( this, "Crimson Tempest", "target_if=min:remains,if=spell_targets>=2&effective_combo_points>=4&energy.regen_combined>20&(!cooldown.vendetta.ready|dot.rupture.ticking)&remains<2+3*(spell_targets>=4)", "Crimson Tempest on multiple targets at 4+ CP when running out in 2-5s as long as we have enough regen and aren't setting up for Vendetta" );
        -- I didnt add any auto targeting here, your target will have the same debuff as everything around you and you can track it that way. In the furute i might need to add logic to check if targets around you have the debuff, its possible yout target may have CT but a new enemy does not, although the debuff is so short its possible it may not matter
        if A.CrimsonTempest:IsReady(unitID)
        and MultiUnits:GetByRange(10) >=2
        and effective_combo_points >= 4
        and Player:EnergyRegen() > 20
        and (A.Vendetta:GetCooldown() > 0 or Unit(unitID):HasDeBuffs(A.Rupture.ID) ~= 0)
        and Unit(unitID):HasDeBuffs(A.CrimsonTempest.ID) <2+3*(  boolnumber(MultiUnits:GetByRange(10) >=4) ) --", "Crimson Tempest on multiple targets at 4+ CP when running out in 2-5s as long as we have enough regen and aren't setting up for Vendetta" );
        then
            return A.CrimsonTempest:Show(icon)
        end

        --dot->add_action( this, "Rupture", "if=!variable.skip_rupture&effective_combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&target.time_to_die-remains>(4+(runeforge.dashing_scoundrel*5)+(runeforge.doomblade*5)+(variable.regen_saturated*6))", "Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)" );
        if A.Rupture:IsReady(unitID)
        and Unit(player):CombatTime() > 0
        and not skip_rupture
        and
        (
            Unit(unitID):PT(A.Rupture.ID, true)
            and (A.PMultiplier(unitID, A.Rupture.ID) <=1 or Unit(unitID):HasDeBuffs(A.Rupture.ID, true) <= RuptureTickTime(unitID) and  MultiUnits:GetByRange(10) >=3)
            and (not Exsanguinated(unitID, "Rupture") or Unit(unitID):HasDeBuffs(A.Rupture.ID, true) <= RuptureTickTime(unitID)*2 and  MultiUnits:GetByRange(10) >=3)
            and  Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > (4+(boolnumber(A.DashingScoundrel:HasLegendaryCraftingPower())*5)+(boolnumber(A.Doomblade:HasLegendaryCraftingPower())*5)+(boolnumber(regen_saturated)*6))
        )
        then
            return A.Rupture:Show(icon)
        end
        --dot->add_action( this, "Rupture", "cycle_targets=1,if=!variable.skip_cycle_rupture&!variable.skip_rupture&target!=self.target&effective_combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time&spell_targets.fan_of_knives>=3)&(!exsanguinated|remains<=tick_time*2&spell_targets.fan_of_knives>=3)&target.time_to_die-remains>(4+(runeforge.dashing_scoundrel*5)+(runeforge.doomblade*5)+(variable.regen_saturated*6))" );
        if A.Rupture:IsReady(unitID)
        and Action.GetToggle(1, "AutoTarget")
        and Unit(player):CombatTime() > 0
        and not IgnoreNameplates[npc_id]
        and not skip_cycle_rupture
        and not skip_rupture
        --and target not = self.target -- im pretty sure this is SIMC saying (don't autotarget if we target ourself, and this isnt really appliccable in action logic)
        and effective_combo_points >= 4
        then
            for val in pairs(ActiveUnitPlates) do
                if
                A.Kick:IsInRange(val)
                and

                (
                    Unit(val):PT(A.Rupture.ID, true)
                    and (A.PMultiplier(val, A.Rupture.ID) <=1 or Unit(val):HasDeBuffs(A.Rupture.ID, true) <= RuptureTickTime(val) and  MultiUnits:GetByRange(10) >=3)
                    and (not Exsanguinated(val, "Rupture") or Unit(val):HasDeBuffs(A.Rupture.ID, true) <= RuptureTickTime(val)*2 and  MultiUnits:GetByRange(10) >=3)
                    and  Unit(val):TimeToDie() - Unit(val):HasDeBuffs(A.Rupture.ID, true) > (4+(boolnumber(A.DashingScoundrel:HasLegendaryCraftingPower())*5)+(boolnumber(A.Doomblade:HasLegendaryCraftingPower())*5)+(boolnumber(regen_saturated)*6))
                )
                    -- end of APL checks, start of action checks
                    and not KeepTarget[select(6, Unit(val):InfoGUID())]
                    and ((UnitCanAttack("player", val) and A.Rupture:IsInRange(unitID)  and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --We have threat or it is a dummy
                then
                    return A:Show(icon, ACTION_CONST_AUTOTARGET)
                end
            end

        end
        --dot->add_talent( this, "Crimson Tempest", "if=spell_targets>=2&effective_combo_points>=4&remains<2+3*(spell_targets>=4)", "Fallback AoE Crimson Tempest with the same logic as above, but ignoring the energy conditions if we aren't using Rupture" );
        if A.CrimsonTempest:IsReady(unitID)
        and MultiUnits:GetByRange(10) >=2
        and effective_combo_points>=4
        and Unit(unitID):HasDeBuffs(A.CrimsonTempest.ID, true) <2+3*(boolnumber(MultiUnits:GetByRange(10)>=4))
        then
            return A.CrimsonTempest:Show(icon)
        end
        --dot->add_talent( this, "Crimson Tempest", "if=spell_targets=1&!runeforge.dashing_scoundrel&master_assassin_remains=0&effective_combo_points>=(cp_max_spend-1)&refreshable&!exsanguinated&(!debuff.shiv.up&(energy.deficit<=25+energy.regen_combined))&target.time_to_die-remains>4", "Crimson Tempest on ST if in pandemic and nearly max energy and if Envenom won't do more damage due to TB/MA" );
        if A.CrimsonTempest:IsReady(unitID)
        and MultiUnits:GetByRange(10) == 1
        and not A.DashingScoundrel:HasLegendaryCraftingPower()
        and Unit(player):HasBuffs(A.MasterAssassin.ID) == 0
        and effective_combo_points >= (Player:ComboPointsMax()-1)
        and Unit(unitID):PT(A.CrimsonTempest.ID, true)
        and not Exsanguinated(unitID, "CrimsonTempest")
        and (Unit(unitID):HasDeBuffs(A.ShivDebuff.ID, true) == 0 and (Player:EnergyDeficit() <=25+ Player:EnergyRegen()))
        and Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.CrimsonTempest.ID, true) > 4
        then
            return A.CrimsonTempest:Show(icon)
        end
    end
    local function DirectDamage()
        --direct->add_action( this, "Envenom", "if=effective_combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.shiv.up|debuff.flagellation.up|energy.deficit<=25+energy.regen_combined|!variable.single_target)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)", "Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up." );
        if A.Envenom:IsReady(unitID) and effective_combo_points >= 4 + boolnumber(A.DeeperStratagem:IsTalentLearned())
        and (Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) ~= 0 or Unit(unitID):HasDeBuffs(A.ShivDebuff.ID, true) ~= 0 or Player:GetDeBuffsUnitCount(A.Flagellation.ID) > 0 
            or Unit(unitID):HasBuffs(A.FlagellationBuff.ID, true) ~= 0
            -- TODO implement EnergyRegenCombined as seen in HR and replace EnergyRegen with it.
            or Player:EnergyDeficitPredicted() <= (25 + Player:EnergyRegen()) or not single_target or effective_combo_points > Player:ComboPointsMax())
        and (not A.Exsanguinate:IsTalentLearned()  or A.Exsanguinate:GetCooldown() > 2 or not isBurst)
        then
            return A.Envenom:Show(icon)
        end
        --direct->add_action( "variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+energy.regen_combined|!variable.single_target" );
        local use_filler =  Player:ComboPointsDeficit() >1 or  Player:EnergyDeficit() <=25 + Player:EnergyRegen() or not single_target

        --direct->add_action( "serrated_bone_spike,if=variable.use_filler&!dot.serrated_bone_spike_dot.ticking", "Apply SBS to all targets without a debuff as priority, preferring targets dying sooner after the primary target" );
        if A.SerratedBoneSpike:IsReady(unitID)
            and (UnitThreatSituation("player", unitID) ~= nil or Unit(unitID):IsDummy()) -- player is on the threat table somewhere (in combat with)
            and not UnitCooldown:IsSpellInFly("player", A.SerratedBoneSpike.ID)-- this is Action check not APL

            and use_filler
            and Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0

            then
                return A.SerratedBoneSpike:Show(icon)
        end
        --direct->add_action( "serrated_bone_spike,target_if=min:target.time_to_die+(dot.serrated_bone_spike_dot.ticking*600),if=variable.use_filler&!dot.serrated_bone_spike_dot.ticking" );
        --Bone Spike Targeting
        if A.SerratedBoneSpike:IsReady(unitID)
            and inCombat
            and (UnitThreatSituation("player", unitID) ~= nil or Unit(unitID):IsDummy()) -- player is on the threat table somewhere (in combat with)
            and not UnitCooldown:IsSpellInFly("player", A.SerratedBoneSpike.ID)-- this is Action check not APL
            and Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) ~= 0  -- if target has SBS
            and Action.GetToggle(1, "AutoTarget")  --AutoTargetting is Enabled
            --and Action.GetToggle(2, "SBSTarget")  --SBS Targeting is enabled not currently implemented in Sin UI, may not implement ever TODO
            and not IgnoreNameplates[npc_id] --Target is something we can swap off
            and MultiUnits:GetByRange(15) >= 2 --There are 2 targets in Range
            and use_filler
            and GetCurrentGCD() ~= 0
            then
                for val in pairs(ActiveUnitPlates) do
                    if
                    A.Kick:IsInRange(val) 
                    and
                    (
                        Unit(val):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0
                        and Unit(val):TimeToDie() >= 21
                        or Unit(val):TimeToDie() <= 5 and MultiUnits:GetByRange(10) < 3
                    )
                        -- end of APL checks, start of action checks
                        and not KeepTarget[select(6, Unit(val):InfoGUID())]
                    and ((UnitCanAttack("player", val) and Unit(val):GetRange() <=15  and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --We have threat or it is a dummy
                    then
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                end
        end
        --direct->add_action( "serrated_bone_spike,if=variable.use_filler&master_assassin_remains<0.8&(fight_remains<=5|cooldown.serrated_bone_spike.max_charges-charges_fractional<=0.25|soulbind.lead_by_example.enabled&!buff.lead_by_example.up&debuff.vendetta.up|buff.marrowed_gemstone_enhancement.up)", "When MA is not at high duration, use SBS to apply Lead by Example during Vendetta, otherwise keep from capping charges" );
        if A.SerratedBoneSpike:IsReady(unitID)
            and inCombat
            and (UnitThreatSituation("player", unitID) ~= nil or Unit(unitID):IsDummy()) -- player is on the threat table somewhere (in combat with)
            and not UnitCooldown:IsSpellInFly("player", A.SerratedBoneSpike.ID)-- this is Action check not APL
            --apl
            and use_filler
            and Unit(player):HasBuffs(A.MasterAssassin.ID) < 0.8
            and (Unit(unitID):TimeToDie() <= 5 or A.SerratedBoneSpike:GetSpellChargesMax()-A.SerratedBoneSpike:GetSpellChargesFrac() <= 0.25
                -- TODO: or soulbind.lead_by_example.enabled and not buff.lead_by_example.up and debuff.vendetta.up
                or Unit(player):HasBuffs(A.MarrowedGemstoneEnhancement.ID) ~= 0)
            then
                return A.SerratedBoneSpike:Show(icon)
            end
        --direct->add_action( this, "Fan of Knives", "if=variable.use_filler&(buff.hidden_blades.stack>=19|(!priority_rotation&spell_targets.fan_of_knives>=4+stealthed.rogue))", "Fan of Knives at 19+ stacks of Hidden Blades or against 4+ targets." );
        if A.FanofKnives:IsReady(unitID)
        and use_filler
        and (Unit(player):HasBuffsStacks(A.HiddenBlades.ID) >=19 or (not priority_rotation and MultiUnits:GetByRange(10) >=4 + boolnumber(Player:IsStealthed()) ))
        then
            return A.FanofKnives:Show(icon)
        end
        --direct->add_action( this, "Fan of Knives", "target_if=!dot.deadly_poison_dot.ticking&(!priority_rotation|dot.garrote.ticking|dot.rupture.ticking),if=variable.use_filler&spell_targets.fan_of_knives>=3", "Fan of Knives to apply poisons if inactive on any target (or any bleeding targets with priority rotation) at 3T" );
        if A.FanofKnives:IsReady(unitID)
        and Action.GetToggle(1, "AutoTarget")
        and Unit(player):CombatTime() > 0
        and GetCurrentGCD() ~= 0
        and not IgnoreNameplates[npc_id]
        --APL
        and Unit(player):HasBuffs(A.DeadlyPoison.ID) ~= 0
        and use_filler
        and  MultiUnits:GetByRange(10) >= 3
        then
            for val in pairs(ActiveUnitPlates) do
                if
                    A.Kick:IsInRange(val) 
                    and not KeepTarget[select(6, Unit(val):InfoGUID())]
                    and
                    (( UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy())
                    and Unit(val):GetRange() <= 5
                    and Unit(val):HasDeBuffs(A.DeadlyPoison.ID, true) == 0
                    and
                    (
                        Unit(val):HasDeBuffs(A.DeadlyPoison.ID, true) == 0
                        and (not priority_rotation or Unit(val):HasDeBuffs(A.Garrote.ID, true) ~= 0 or Unit(val):HasDeBuffs(A.Rupture.ID, true) ~= 0)
                    )
                    then
                        return
                        A:Show(icon, ACTION_CONST_AUTOTARGET)
                end
            end
        end
        if A.FanofKnives:IsReady(unitID)
        and not Player:IsStealthed()
        and Unit(player):HasBuffs(A.DeadlyPoison.ID) ~= 0
        and use_filler
        and MultiUnits:GetByRange(10) >= 3
        and
        (
            Unit(unitID):HasDeBuffs(A.DeadlyPoison.ID, true) == 0
            and (not priority_rotation or Unit(unitID):HasDeBuffs(A.Garrote.ID, true) ~= 0 or Unit(unitID):HasDeBuffs(A.Rupture.ID, true) ~= 0)
        )
        then
            return A.FanofKnives:Show(icon)
        end
        --direct->add_action( "echoing_reprimand,if=variable.use_filler&cooldown.vendetta.remains>10" );
        if A.EchoingReprimand:IsReady(unitID)
            and use_filler
            and A.Vendetta:GetCooldown() > 10
            then
                return A.EchoingReprimand:Show(icon)
            end
        --direct->add_action( this, "Ambush", "if=variable.use_filler&(master_assassin_remains=0&!runeforge.doomblade|buff.blindside.up)" );
        if A.Ambush:IsReady(unitID) and
        use_filler
        and
        (
            Unit(player):HasBuffs(A.MasterAssassin.ID) == 0
            and not A.Doomblade:HasLegendaryCraftingPower()
            or Unit(player):HasBuffs(A.Blindside.ID) ~= 0
        )
        then
            return A.Ambush:Show(icon)
        end
        --direct->add_action( this, "Mutilate", "target_if=!dot.deadly_poison_dot.ticking,if=variable.use_filler&spell_targets.fan_of_knives=2", "Tab-Mutilate to apply Deadly Poison at 2 targets" );
        if A.Mutilate:IsReady(unitID)
        and Action.GetToggle(1, "AutoTarget")
        and Unit(player):CombatTime() > 0
        and not IgnoreNameplates[npc_id]
        --APL
        and MultiUnits:GetByRange(10) == 2
        and Unit(player):HasBuffs(A.DeadlyPoison.ID) ~= 0
        and use_filler
        and Unit(unitID):HasDeBuffs(A.DeadlyPoison.ID, true) ~= 0

        and GetCurrentGCD() ~= 0 --the idea is that only look for targets during GCD, but for Garrote lets go crazy!
        then
            for val in pairs(ActiveUnitPlates) do
                if 	
                
                A.Kick:IsInRange(val) 
                and
                (
                    Unit(val):HasDeBuffs(A.DeadlyPoison.ID, true) == 0
                    and not KeepTarget[select(6, Unit(val):InfoGUID())]
                    and A.Mutilate:IsInRange(val)
                    )
                    and
                    (( UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy())
                    then
                        return
                        A:Show(icon, ACTION_CONST_AUTOTARGET)
                end
            end
        end
        --direct->add_action( this, "Mutilate", "if=variable.use_filler" );
        if A.Mutilate:IsReady(unitID)
        and
        use_filler
        then
           -- print ("2")
            return A.Mutilate:Show(icon)
        end
    end

------------------------------------------
--Functional Rotation Calls             --
------------------------------------------
        --INTERRUPTS
        if Interrupts() then return true end
        --DEFENSIVES
        if Defensives() then return true end
        -- OPENER
        if Unit(unitID):HasBuffs(350158) ~= 0 then return end
        if Player:IsStealthed() and Opener() then return true end
        --def->add_action( "call_action_list,name=stealthed,if=stealthed.rogue" );
        if Player:IsStealthed() and Stealth() then return true end
        --def->add_action( "call_action_list,name=cds,if=(!talent.master_assassin.enabled|dot.garrote.ticking)" );

        --if (Player:IsStealthed() or LastPlayerCastID == A.Vanish.ID or LastPlayerCastID == A.Stealth.ID) then return end



        if (not A.MasterAssassin:IsTalentLearned() or Unit(unitID):HasDeBuffs(A.Garrote.ID, true)) and CDs() then return true end
        --def->add_action( this, "Slice and Dice", "if=!buff.slice_and_dice.up&combo_points>=1", "Put SnD up initially for Cut to the Chase, refresh with Envenom if at low duration" );
        --Stop here if stealthed still i think, need to test more, bust at some point in the rotation we need to stop cause we arent opening yet and this makes sense i think TODO
        --if Player:IsStealthed() then return false end
        if A.SliceAndDice:IsReady(player)
        and Unit(player):HasBuffs(A.SliceAndDice.ID) == 0
        and Player:ComboPoints() >= 1
        then
            return A.SliceAndDice:Show(icon)
        end
        --def->add_action( this, "Envenom", "if=buff.slice_and_dice.up&buff.slice_and_dice.remains<5&combo_points>=4" );
        if A.Envenom:IsReady(unitID)
        and Unit(player):HasBuffs(A.SliceAndDice.ID) ~= 0
        and Unit(player):HasBuffs(A.SliceAndDice.ID) < 5
        and Player:ComboPoints() >= 4
        then
            return A.Envenom:Show(icon)
        end
        --def->add_action( "call_action_list,name=dot" );
        if DoTs() then return true end
        --def->add_action( "call_action_list,name=direct" );
        if DirectDamage() then return true end
        --def->add_action( "arcane_torrent,if= Player:EnergyDeficit() >=15+ Player:EnergyRegen() " );
        --Arcane Torrent falls here in APL but is saved for dispell
        --def->add_action( "arcane_pulse" );
        if A.ArcanePulse:IsReady(unitID) and inMelee then
            return A.ArcanePulse:Show(icon)
        end
        --def->add_action( "lights_judgment" );
        if A.LightsJudgment:IsReady(unitID) and inMelee then
            return A.LightsJudgment:Show(icon)
        end
        --def->add_action( "bag_of_tricks" );
        if A.BagofTricks:IsReady(unitID) and inMelee then
            return A.BagofTricks:Show(icon)
        end
    end-- end of EnemyRotation()
------------------------------------------
--OOC Actions                         --
------------------------------------------
    --Use BottledFlayedwingToxin if out of combat with other poisons. before stealth
    if A.BottledFlayedwingToxin:IsReady(player, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then
        return A.BottledFlayedwingToxin:Show(icon)
    end
	--Summon Steward
	if A.SummonSteward:IsReady(player) and GetItemCount(177278) < 1 and Player:GetStance() == 0  and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
		return A.SummonSteward:Show(icon)
	end
        --Attempt to stop recasts of stealth/poisons by waiting for two times ping after a cast is over
    if  Player:IsCasting() then
        Temp.CastStartTime[1] = TMW.time
    elseif TMW.time - (Temp.CastStartTime[1] or 0) < (2*A.GetPing()) then
        return true
    end
    --OOC Stealth
    if GetToggle(2, "OOCStealth") and A.Stealth:IsReady(player, true) and not IsResting() and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
        return A.Stealth:Show(icon)
    end
    --Poisons use UI settings to check if poison selected is ready, already applied and ooc
    if Unit(player):CombatTime() == 0 and not IsMounted() and not Player:IsMoving() then
        if GetToggle(2, "LethalPoison") == "DeadlyPoison" then
            if A.DeadlyPoison:IsReady(player, true)
            and Unit(player):HasBuffs(A.DeadlyPoison.ID) == 0 then
                return A.DeadlyPoison:Show(icon)
            end
        end
        if GetToggle(2, "LethalPoison") == "WoundPoison" then
            if A.WoundPoison:IsReady(player, true)
            and Unit(player):HasBuffs(A.WoundPoison.ID) == 0 then
                return A.WoundPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "NumbingPoison" then
            if A.NumbingPoison:IsReady(player, true)
            and Unit(player):HasBuffs(A.NumbingPoison.ID) == 0 then
                return A.NumbingPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "CripplingPoison" then
            if A.CripplingPoison:IsReady(player, true)
            and Unit(player):HasBuffs(A.CripplingPoison.ID) == 0 then
                return A.CripplingPoison:Show(icon)
            end
        end
    end
    -- Target
    if IsUnitEnemy("target") and EnemyRotation("target") then
        return true
    end
end


A[4] = nil
A[5] = nil
A[6] = function(icon)
    local MOExplosive = GetToggle(2, "MOExplosive")
    local MOTotem = GetToggle(2, "MOTotem")

    if MOExplosive and IsUnitEnemy("mouseover") and Unit("mouseover"):IsExplosives() or MOTotem and IsUnitEnemy("mouseover") and Unit("mouseover"):IsTotem() then
        return A:Show(icon, ACTION_CONST_LEFT)
    end
end
A[7] = nil
A[8] = nil




























