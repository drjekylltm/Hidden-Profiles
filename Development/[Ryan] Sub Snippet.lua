local _G, setmetatable, pairs, type, math = _G, setmetatable, pairs, type, math
local huge = math.huge
local TMW = _G.TMW 
local Action = _G.Action
local CONST = Action.Const
local Listener = Action.Listener
local Create = Action.Create
local GetToggle = Action.GetToggle
local GetLatency = Action.GetLatency
local GetGCD = Action.GetGCD
local GetCurrentGCD = Action.GetCurrentGCD
local ShouldStop = Action.ShouldStop
local BurstIsON = Action.BurstIsON
local AuraIsValid = Action.AuraIsValid
local InterruptIsValid = Action.InterruptIsValid
local DetermineUsableObject = Action.DetermineUsableObject
local Utils = Action.Utils
local BossMods = Action.BossMods
local TeamCache = Action.TeamCache
local EnemyTeam = Action.EnemyTeam
local FriendlyTeam = Action.FriendlyTeam
local LoC = Action.LossOfControl
local Player = Action.Player 
local MultiUnits = Action.MultiUnits
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local UnitCooldown = Action.UnitCooldown
local Unit = Action.Unit
local Covenant = _G.LibStub("Covenant")
local IsUnitEnemy = Action.IsUnitEnemy
local IsUnitFriendly = Action.IsUnitFriendly
local Combat = Action.Combat
local DisarmIsReady = Action.DisarmIsReady
local LastPlayerCastID = Action.LastPlayerCastID
local Azerite = LibStub("AzeriteTraits")
local ACTION_CONST_ROGUE_SUBTLETY = CONST.ROGUE_SUBTLETY
local ACTION_CONST_AUTOTARGET = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP = CONST.SPELLID_FREEZING_TRAP
local IsIndoors, UnitIsUnit = _G.IsIndoors, _G.UnitIsUnit

Action[ACTION_CONST_ROGUE_SUBTLETY] = {
    -- Racial
    ArcaneTorrent = Create({ Type = "Spell", ID = 50613}),
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

	Premeditation = Create({ Type = "Spell", ID = 343160}),
	Gloomblade = Create({ Type = "Spell", ID = 200758}),
	Subterfuge = Create({ Type = "Spell", ID = 108208}),
	SecretTechnique = Create({ Type = "Spell", ID = 280719}), 
	ShurikenTornado = Create({ Type = "Spell", ID = 277925}),
	
	
	
    -- general
    Stealth = Create({ Type = "Spell", ID = 1784}),
    InstantPoison = Create({ Type = "Spell", ID = 315584}),
    CripplingPoison = Create({ Type = "Spell", ID = 3408}),
    NumbingPoison = Create({ Type = "Spell", ID = 5761}),
    WoundPoison = Create({ Type = "Spell", ID = 8679}),
    CrimsonVial = Create({ Type = "Spell", ID = 185311}),
    TricksOfTheTrade = Create({ Type = "Spell", ID = 57934}),
    PoolResource = Create({ Type = "Spell", ID = 97238,Hidden = true}),
    ShroudOfConcealment = Create({ Type = "Spell", ID = 114018}), 
	Sap = Create({ Type = "Spell", ID = 6770}), 
	Shiv = Create({ Type = "Spell", ID = 5938}),
    CheapShot = Create({ Type = "Spell", ID = 1833}),
	Blind = Create({ Type = "Spell", ID = 2094}),
    Feint = Create({ Type = "Spell", ID = 1966}),
    KidneyShot = Create({ Type = "Spell", ID = 408}),	
    Evasion = Create({ Type = "Spell", ID = 5277}), 
    CloakofShadows = Create({ Type = "Spell", ID = 31224}), 	
	
	
    -- CDS
	ShadowBlades = Create({ Type = "Spell", ID = 121471}), 

    --Covenants
    Sepsis = Create({ Type = "Spell", ID = 328305}),
    SerratedBoneSpike = Create({ Type = "Spell", ID = 328547}),
    EchoingReprimand = Create({ Type = "Spell", ID = 323547}),
    Flagellation = Create({ Type = "Spell", ID = 323654}),
    ClaimFlagellation = Create({ Type = "Spell", ID = 346975,Hidden = true}),
	--PhialofSerenity = Create({ Type = "Spell", ID = 177278}),
	SummonSteward = Create({ Type = "Spell", ID = 324739}), 
    
	--Conduits
   
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
    MasterAssassinsMark = Create({ Type = "Spell", ID = 340094,Hidden = true}),
	StolenShadehound = Create({ Type = "Spell", ID = 338659,Hidden = true}),
    --kick
    Kick = Create({ Type = "Spell", ID = 1766}),
    KickGreen = Create({ Type = "SpellSingleColor",ID = 1766,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    BlindGreen = Create({ Type = "SpellSingleColor",ID = 2094,Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    KidneyShotGreen = Create({ Type = "SpellSingleColor",ID = 408,Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    CheapShotGreen = Create({ Type = "SpellSingleColor",ID = 1833,Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    
	-- Rotation
	
	Eviscerate = Create({ Type = "Spell", ID = 196819}), 
	Backstab = Create({ Type = "Spell", ID = 53}), 
	Shadowstep = Create({ Type = "Spell", ID = 36554}), 
	BlackPowder = Create({ Type = "Spell", ID = 319175}), 
	Shadowstrike = Create({ Type = "Spell", ID = 185438}), 
	Rupture = Create({ Type = "Spell", ID = 1943}), 
	ShurikenStorm = Create({ Type = "Spell", ID = 197835}), 

	ShurikenToss = Create({ Type = "Spell", ID = 114014}), 
	SymbolsOfDeath = Create({ Type = "Spell", ID = 212283}), 
	ShadowDance = Create({ Type = "Spell", ID = 185313}), 
	FindWeakness = Create({ Type = "Spell", ID = 316219,Hidden = true}),
	
    -- Items
    PotionofUnbridledFury = Create({ Type = "Potion", ID = 169299}), 
    BottledFlayedwingToxin = Create({ Type = "Trinket", ID = 178742,Hidden = true}),
    InscrutableQuantumDevice = Create({ Type = "Trinket", ID = 179350,Hidden = true}),
    ShadowGraspTotem = Create({ Type = "Trinket", ID = 179356,Hidden = true}),
    
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

Action:CreateEssencesFor(ACTION_CONST_ROGUE_SUBTLETY)
local A = setmetatable(Action[ACTION_CONST_ROGUE_SUBTLETY], { __index = Action })

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
        [A.ShadowGraspTotem.ID] = true,
    },
}; do 
    -- Push IsSlotTrinketBlocked
    for key, val in pairs(Action[ACTION_CONST_ROGUE_SUBTLETY]) do 
        if type(val) == "table" and val.Type == "Trinket" then 
            Temp.IsSlotTrinketBlocked[val.ID] = true
        end 
    end 
end 

------------------------------------------------------------
--Ryan Generic Functions
------------------------------------------------------------
--Generic Functions that are not specific to any Spec/Class

local function ValidAutotarget(nameplate)
    -- @return boolean
    --This function checks the KeepTarget table for targets you should not swap to for any reason
local _, _, _, _, _, npc_id 		= Unit(nameplate):InfoGUID()
if KeepTarget[npc_id] == false then
    return false
else
    return true
end
end

local function boolnumber(value)
--@number 1 or 0
--converts a boolean to 1=true 0=false for use in math operations
return value and 1 or 0
end
boolnumber = A.MakeFunctionCachedDynamic(boolnumber)

function Action:PreventRecast(delay)
-- @return boolean False if last cast was in delay seconds ago
if  self:IsSpellInCasting() then
    Temp.CastStartTime[self.ID] = TMW.time
end

return TMW.time - (Temp.CastStartTime[self.ID] or 0) > (delay)
end

local function InscrutableQuantumDeviceCheck()
--@boolean true - Trinket will DPS or give stat buff. false - Trinket will heal or restore mana
for GUIDs, v in pairs(TeamCache.Friendly.GUIDs) do
    if Unit(v):HealthPercent() <= 30 then
        return false
    end
    if Unit(v):PowerType() == "MANA" then
        if Unit(v):PowerPercent() <= 20 then
            return false
        end
    end
end
return true
end

local function UseItems(unitID)
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
if A.InscrutableQuantumDevice:IsReady(unitID) and InscrutableQuantumDeviceCheck() then
    return A.InscrutableQuantumDevice
end
if A.ShadowGraspTotem:IsReady(unitID) and Unit(unitID):TimeToDie() > 12 then
    return A.ShadowGraspTotem
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
EchoingBuffMatch = A.MakeFunctionCachedStatic(EchoingBuffMatch)
------------------------------------------------------------
--Ryan Generic Functions End
------------------------------------------------------------


-- [1] CC AntiFake Rotation
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
        if castLeft > 0 then 
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
	local _, _, _, _, _, npc_id 		= Unit("target"):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
	-- if in Necrotic Wake instance and targetting Companion, stop rotation to allow for covenant Buff cast to finish (stealth breaks cast)
    if A.InstanceInfo.ID == 2286 and Unit("target"):Name() == "Farra" then return end
    -- Stop rotation on Torghast Containers
	if Unit("target"):Name() == "Ashen Phylactery" then return end
	--164698 or 167986 or 165533 or 165523 or 170525 or 167987 or 178523 or 179514 or
	
	
	--Testing

	
	
	
    -- Rotations 
    function EnemyRotation(unitID) 
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        if Unit(unitID):HasDeBuffs("BreakAble") > 0 and Unit(player):CombatTime() == 0 then return end --Stop Rotation if Target is sapped and OOC
        if UnitCanAttack(player, unitID) == false then return end --Stop Rotation if Target can not attack back (yellow enemies)
        --todo:check vanish
        if Unit(player):HasBuffs(A.Vanish.ID) ~= 0 and GetToggle(2, "VanishSetting") == 0 then return end  --Stop Rotation if Vanish is set to off
        if IsMounted() then return end  --Stop Rotation if Mounted. Action has check for this but can lag after stealthing

        local isBurst = BurstIsON(unitID) -- @boolean
        local inMelee = A.Kick:IsInRange(unitID) -- @boolean
        local inCombat = Unit(player):CombatTime() > 0
        local inAoE = MultiUnits:GetByRange(5) >= 2
        local EightYardTTD = A.MultiUnits:GetByRangeAreaTTD(8) --@number average time to die of all targets in 8 yards
        



        --testing

        
        --Stealth with target enemy
        if IsUnitEnemy(unitID) and A.Stealth:IsReady(unitID, true) and Player:GetStance() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
            return A.Stealth:Show(icon)
        end
        -- kill Explosive Affix
        if Unit(unitID):IsExplosives() and A.Gloomblade:IsReady(unitID) then
            return A.Gloomblade:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.Backstab:IsReady(unitID) then
            return A.Backstab:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.ShurikenToss:IsReady(unitID) and not inMelee then
            return A.ShurikenToss:Show(icon)
        end
        --Shiv Enrages
        if A.Shiv:IsReady(unitID) and Unit(player):HasBuffs(A.NumbingPoison.ID) ~= 0 and Action.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then
            return A.Shiv:Show(icon)
        end 
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
        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then 
            return A.ArcaneTorrent:Show(icon)
        end 



        local function TimeOnTarget()
            --returns @number
            --how many seconds player is from target. GetCurrentSpeed returns percentage of speed from base 7 yards per second
            --1 Second == Melee Range
            local _, min_range				= Unit("target"):GetRange()
            local timefromtarget = ((min_range+5)/((Unit("player"):GetCurrentSpeed()+ 0.000000001) /100*7))
            return timefromtarget
        end
        TimeOnTarget = A.MakeFunctionCachedStatic(TimeOnTarget)




        local function Interrupts()
            local inInstance = IsInAnInstance[A.InstanceInfo.ID]
	        local unitIDinterrupt = "none"
            local stopbeforechannel = true
			if IsUnitEnemy("mouseover") then
				unitIDinterrupt = "mouseover"
			elseif IsUnitEnemy("target") then
				unitIDinterrupt = "target"
			end
            local SpellID = nil
	        if A.GetToggle(2, "InterruptList") and inInstance then--uses ryan interrupt table in SL dungeons and raid instance IDs
                useKick, useCC, useRacial, notKickAble, castLeft, castDoneTime = InterruptIsValid(unitIDinterrupt, "RyanInterrupts", true)
            else
                useKick, useCC, useRacial, notKickAble, castLeft, castDoneTime = InterruptIsValid(unitIDinterrupt)
            end
 
            if useKick or useCC or useRacial then
                local CastTimeRemaining, Percentcast, SpellID, _ ,_ , IsChanneling = Unit(unitIDinterrupt):IsCastingRemains()
                local Slidermin, Slidermax = Action.InterruptGetSliders("RyanInterrupts")
                --this is personal check for my Action install, if you're reading this and want to know why i check this DM me and i'll explain it. 
                local percenttokick = Percentcast > Slidermin
                
                --This checks the SpellID of the cast against my table to decide to wait for a channel instead of interrupting the first cast
                --useful for abilities that should be interrupted during the channel to make it go on CD instead of enemy spamming it
                if Channels[SpellID] then
                    stopbeforechannel = IsChanneling 
                 end
                -- useKick
                if useKick and percenttokick and stopbeforechannel and castLeft > 0 and not notKickAble  and A.AbsentImun(nil, unitIDinterrupt, Temp.TotalAndPhysKick) and A.Kick:IsReady(unitIDinterrupt) then
                    return A.Kick:Show(icon)
                end
                -- useCC / useRacial
                if (not useKick or notKickAble or A.Kick:GetCooldown() > 0) and stopbeforechannel and Unit(unitIDinterrupt):HasBuffs(A.Inspired.ID) == 0 then
                    if useCC and (Player:GetStance() ~= 0) and A.CheapShot:IsReady(unitIDinterrupt) and A.CheapShot:AbsentImun(unitIDinterrupt, Temp.TotalAndPhysAndCC) and Unit(unitIDinterrupt):GetDR("stun") > 0 and not Unit(unitIDinterrupt):IsBoss() and Unit(unitIDinterrupt):HasBuffs(A.Sanguine.ID) == 0 then
                        return A.CheapShot:Show(icon)
                    end

                    if useCC and A.KidneyShot:IsReady(unitIDinterrupt) and A.KidneyShot:AbsentImun(unitIDinterrupt, Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit(unitIDinterrupt):GetDR("stun") > 0 and not Unit(unitIDinterrupt):IsBoss() and Unit(unitIDinterrupt):HasBuffs(A.Sanguine.ID) == 0 then
                        return A.KidneyShot:Show(icon)
                    end
                    if useRacial and A.QuakingPalm:IsReady(unitIDinterrupt) and A.QuakingPalm:AbsentImun(unitIDinterrupt, Temp.TotalAndPhysAndCC) and Unit(unitIDinterrupt):GetDR("incapacitate") > 0 and not Unit(unitIDinterrupt):IsBoss() then
                        return A.QuakingPalm:Show(icon)
                    end
                    if useCC and A.Blind:IsReady(unitIDinterrupt) and A.Blind:AbsentImun(unitIDinterrupt, Temp.TotalAndPhysAndCC) and Unit(unitIDinterrupt):GetDR("disorient") > 0 and not Unit(unitIDinterrupt):IsBoss() then
                        return A.Blind:Show(icon)
                    end
                end
            end
			--Auto Targeting Interrupts
			if Action.GetToggle(1, "AutoTarget") and A.GetToggle(2, "ATInterrupt") and not useKick and not useCC and not useRacial and inAoE  and GetCurrentGCD() ~= 0 then  -- and Unit("player"):CombatTime() > 0 i dont think i care if we are in combat for interrupt auto targeting
				for val in pairs(ActiveUnitPlates) do

	        if A.GetToggle(2, "InterruptList") and inInstance then--uses ryan interrupt table in SL dungeons and raid instance IDs
               useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val, "RyanInterrupts", true)
            else
                useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val)
            end

					if Unit(val):HasBuffs(A.Inspired.ID) == 0 and ValidAutotarget(val)
					and ((UnitCanAttack("player", val) and Unit(val):GetRange() <=8  and not Unit(val):IsTotem())	or Unit(val):IsDummy()) -- and UnitThreatSituation("player", val) ~= nil
					and  ((useKick and castLeft > 0 and not notKickAble  and A.AbsentImun(nil, val, Temp.TotalAndPhysKick) and A.Kick:IsReady(val))
                    or (useCC and (Player:GetStance() ~= 0) and A.CheapShot:IsReady(val) and A.CheapShot:AbsentImun(val, Temp.TotalAndPhysAndCC) and Unit(val):GetDR("stun") > 0 and not Unit(val):IsBoss() and Unit(val):HasBuffs(A.Sanguine.ID) == 0)
                    or (useCC and A.KidneyShot:IsReady(val) and A.KidneyShot:AbsentImun(val, Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit(val):GetDR("stun") > 0 and not Unit(val):IsBoss() and Unit(val):HasBuffs(A.Sanguine.ID) == 0)
                    or (useRacial and A.QuakingPalm:IsReady(val) and A.QuakingPalm:AbsentImun(val, Temp.TotalAndPhysAndCC) and Unit(val):GetDR("incapacitate") > 0 and not Unit(val):IsBoss())
                    or (useCC and A.Blind:IsReady(val) and A.Blind:AbsentImun(val, Temp.TotalAndPhysAndCC) and Unit(val):GetDR("disorient") > 0 and not Unit(val):IsBoss()))
					then
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
					end
				end
			end
        end
        
        local function Defensives()
            if Unit(player):IsTankingAoE(10) and A.TricksOfTheTrade:IsReady("focus") then
                return A.TricksOfTheTrade:Show(icon)
            end
            --Evasion
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
                    Evasion < 100 and Unit(player):HealthPercent() <= Evasion))
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
                    CloakofShadows < 100 and Unit(player):HealthPercent() <= CloakofShadows))
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
			--Feint Based on Target Casts
			local CastTimeRemaining, _, spellID, _, _, isChannel = Unit(unitID):IsCastingRemains()
			 		-- @return:	-- [1] Current Casting Left Time (seconds) (@number)	-- [2] Current Casting Left Time (percent) (@number)	-- [3] spellID (@number)	-- [4] spellName (@string)	-- [5] notInterruptable (@boolean, false is able to be interrupted)	-- [6] isChannel (@boolean)
			if Feint >= 100 then
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
			end
			-- CrimsonVial
            local CrimsonVial = GetToggle(2, "CrimsonVial")
            if CrimsonVial >= 0 and A.CrimsonVial:IsReady(player) and Unit(player):HealthPercent() <= CrimsonVial and Unit(player):HasBuffs(A.CrimsonVial.ID) == 0 and Unit(player):HasDeBuffs(A.GluttonousMiasma.ID) == 0 then
                return A.CrimsonVial:Show(icon)
            end
            -- Stoneform (Self Dispel)
            if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
                return A.Stoneform:Show(icon)
            end
        end
        
        -- [[ Opener ]]
        local function Opener()
            local ignoretimers = (BossMods:HasAnyAddon()~=true) or (BossMods:HasAnyAddon()==true and not GetToggle(1, "BossMods")) -- logic for bossmods toggle returns true if no boss mods installed, need extra hasanyaddon check
            if A.MarkedForDeath:IsReady(unitID) and not Unit(unitID):IsTotem() and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned())
            and ((ignoretimers and TimeOnTarget() <= 2.5) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 7*GetGCD()))
            then
                return A.MarkedForDeath:Show(icon)
            end
            if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5
            and ((ignoretimers and TimeOnTarget() <= 2) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 3))
            then
                return A.SliceAndDice:Show(icon)
            end
			
			if A.ShadowBlades:IsReady(unitID) and isBurst and Unit(player):HasBuffs(A.MasterAssassinsMark) ~= 0 and (not GetToggle(1, "BossMods") or inCombat) then
				return A.ShadowBlades:Show(icon)
			end
            if GetToggle(2, "Opener") == "Shadowstrike" then
                if A.Shadowstrike:IsReady(unitID) and GetCurrentGCD() == 0 and (not GetToggle(1, "BossMods") or inCombat) 
				and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                then
                    return A.Shadowstrike:Show(icon)
                end
            end
            if GetToggle(2, "Opener") == "CheapShot" then
                if A.CheapShot:IsReady(unitID) and (not GetToggle(1, "BossMods") or inCombat)then
                    return A.CheapShot:Show(icon)
                end
            end
            -- Tricks with boss mods
            if A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2.5) then
                return A.TricksOfTheTrade:Show(icon)
            end
            if A.ShroudOfConcealment:IsReady(player) and IsInRaid() and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 6) then
                return A.ShroudOfConcealment:Show(icon)
            end
        end
        
		
		
        local function StealthCDs()
            --MfD is also in ST() it is a CD that resets on death and is used with burst off as well
            if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 and not Unit(unitID):IsTotem() then
                return A.MarkedForDeath:Show(icon)
            end
          
--[[		  --Use Ambush from Maunal or Auto Vanish
            if GetToggle(2, "VanishSetting") >=1 then
               if GetToggle(2, "Opener") == "Echoing Reprimand" then 
					if A.EchoingReprimand:IsReadyByPassCastGCD(unitID) then
						return A.EchoingReprimand:Show(icon) 
					end
				end
               if GetToggle(2, "Opener") ~= "Echoing Reprimand" then	
					if A.Ambush:IsReadyByPassCastGCD(unitID) then
						return A.Ambush:Show(icon) 
					end
					if Player:Energy() <= 50 then 
						return A.PoolResource:Show(icon)
					end 
				end
            end
           --]] 
			
        end
       


	   -- [[ CDs ]]
        local function CDs() -- indented fucntions are used from stealth/vanish
			
            local Item = UseItems(unitID)
            if Item and inMelee and Unit(player):HasBuffs(A.Stealth.ID) == 0 and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 then --prevent all items in stealth and save them for Symbols windows
                return Item:Show(icon)
            end
			--racials when low on energy
            if A.Fireblood:IsReady(unitID, true) and inMelee and Player:Energy() < 34 then
                return A.Fireblood:Show(icon)
            end
            if A.Berserking:IsReady(unitID, true) and inMelee and Player:Energy() <34 then
                return A.Berserking:Show(icon)
            end
            if A.BloodFury:IsReady(unitID, true) and inMelee and Player:Energy() <34 then
                return A.BloodFury:Show(icon)
            end
            if A.LightsJudgment:IsReady(unitID) and Player:Energy() <34 then
                return A.LightsJudgment:Show(icon)
            end
            if A.BagofTricks:IsReady(player) and inMelee and Player:Energy() <34 then 
                return A.BagofTricks:Show(icon)
            end
            if A.AncestralCall:IsReady(player) and inMelee and Player:Energy() <34 then 
                return A.AncestralCall:Show(icon)
            end 
			
					
            if ((A.Flagellation:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) == 0 and (EightYardTTD > 4 or Unit(unitID):IsBoss())) or (Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) <= 2 or Unit(unitID):HasDeBuffsStacks(A.Flagellation.ID, true) >= 30)) then
                return A.Flagellation:Show(icon)
            end
           
		   	-- Multiunits checks for the number of dots and allows using it if we will gain 3 or less CP, after +3 CP gained per use we can waste the extra generated. Highly unlikley that 3+ targets will live long enough to gain enough dots to generate >4 CP per use. 
            if (A.SerratedBoneSpike:IsReady(unitID) and MultiUnits:GetByRangeAppliedDoTs(15, 2, A.SerratedBoneSpike.ID)+1 >= Player:ComboPointsDeficit() and ((Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID) == 0 or (A.SerratedBoneSpike:GetSpellChargesFrac() >= 2.95) )) or (A.SerratedBoneSpike:IsReady("mouseover") and IsUnitEnemy("mouseover") and Unit("mouseover"):HasDeBuffs(A.SerratedBoneSpike.ID) == 0)) then
                return A.SerratedBoneSpike:Show(icon)
            end
            if A.Sepsis:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) then
                return A.Sepsis:Show(icon)
            end	   

            
			if A.SymbolsOfDeath:IsReady(unitID) and inMelee then
				return A.SymbolsOfDeath:Show(icon)
			end
		   --MfD is also in ST() it is a CD that resets on death and is used with burst off as well
            if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 and (not GetToggle(1, "BossMods") or inCombat) and not Unit(unitID):IsTotem() then
                return A.MarkedForDeath:Show(icon)
            end			
			-- i just copied finisher CP logic and put a not infront if, in future dont be lazy, Ryan
			if A.ShadowBlades:IsReady(unitID) and inMelee 	and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 
			and not (Player:ComboPointsDeficit() <= 1 or  EchoingBuffMatch())	then
				return A.ShadowBlades:Show(icon)
			end




			--todo add shiv with lego power
			--	Use  Shiv on cooldown if you play with  Tiny Toxic Blade. Do this during  Shadow Dance if you picked  Nightstalker, outside Dance otherwise.




            if A.EchoingReprimand:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Player:ComboPointsDeficit() >= 2 and MultiUnits:GetByRange(10) <= 4 then
				    return A.EchoingReprimand:Show(icon)
				end



			--todo:
			--Use  Shuriken Tornado (if talented) by stacking it with  Symbols of Death and  Shadow Dance.
			--Remember that the first  Shuriken Storm does not trigger until the first second is over, so you can use the cooldowns during that period. 
			--With  Shadow Focus it is worth it to use  Symbols of Death on cooldown before  Shuriken Tornado if you do not have the 60 energy already, otherwise pool energy and use both  Symbols of Death and  Shadow Dance in the first second of it. 
			--The cooldowns align so well that you do not have to delay  Symbols of Death long for this special case.
            
			
            -- Use Vanish if setting is set to Auto
            if A.Vanish:IsReady(player) 
			and GetToggle(2, "VanishSetting") == 2 
			and inMelee 
			and inCombat 
			and Player:ComboPointsDeficit() >= 2 
			and Unit(player):HasBuffs(A.SkullandCrossbones.ID) == 0 
			and Unit(player):HasBuffs(A.MasterAssassinsMark) == 0 then
				
				if GetToggle(2, "Opener") ~= "Echoing Reprimand" then	
					if Player:Energy() <= 51 then 
						return A.PoolResource:Show(icon)
					else
						return A.Vanish:Show(icon) 
					end
				end
				if GetToggle(2, "Opener") == "Echoing Reprimand" and A.EchoingReprimand:IsReadyByPassCastGCD(unitID) then
						return A.Vanish:Show(icon) 
				end
			end 


        end
        
        
        -- [[ finishers ]]
        local function Finishers() 
            if (A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) < (1 + (Player:ComboPoints()) * 1.8 ) and Unit(player):HasBuffs(A.MasterAssassinsMark) == 0 and Player:GetStance() <=1 ) and ((Player:ComboPointsDeficit() == 0)) then
                return A.SliceAndDice:Show(icon)
            end
			
			--todo: rework debuff pandemic equation for shorter Rupture window
			--todo: "In order to avoid refreshes during  Shadow Dance here as well, it is worth refreshing it early if it is going to expire during your next  Symbols of Death." logic
			if A.Rupture:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Rupture.ID) < (1 + (Player:ComboPoints()) * 1.8 ) and (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) and Unit(player):HasBuffs(A.MasterAssassinsMark) == 0 then
				return A.Rupture:Show(icon)
			end
			
			if A.SecretTechnique:IsReady(unitID) and (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) then
				return A.SecretTechnique:Show(icon)
			end
			--[[
			todo:look into Multidot implemnetations
			<=4 targets Rupture off targets outside SymbolsOfDeath/ShadowDance
			if A.Rupture:IsReady(unitID) and MultiUnits:GetByRange(10) <= 4 and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) == 0 and Unit(player):HasBuffs(A.ShadowDance.ID) == 0 
			--]]
			if A.BlackPowder:IsReady(unitID) and MultiUnits:GetByRange(10) >= 3 and GetToggle(2, "AoE") and (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) then
				return A.BlackPowder:Show(icon)
			end
			if A.Eviscerate:IsReady(unitID) and (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) then
                return A.Eviscerate:Show(icon)
            end
        end
        
		
		
        -- [[ Single Target ]]
        local function ST()
            --MfD is a CD that resets if the target dies, no need to hold based on Burst setting, Can not be used on Totems
            if A.MarkedForDeath:IsReady(unitID) and not isBurst and Player:ComboPointsDeficit() >=4 and(not GetToggle(1, "BossMods") or inCombat) and not Unit(unitID):IsTotem()
            then
                return A.MarkedForDeath:Show(icon)
            end


--[[        --Covenant Builders
            --Use Spesis Stealth buff on Shadowstrike, Pool energy for Shadowstrike
            if Unit(player):HasBuffs(A.SepsisStealth.ID) ~= 0 and A.Shadowstrike:IsInRange(unitID) and Player:ComboPointsDeficit() >= 1 then
                if A.Shadowstrike:IsReadyByPassCastGCD(unitID) then
                    return A.Shadowstrike:Show(icon) 
                end
                --pool energy for Shadowstrike with Sepsis Buff
                if Player:Energy() <= 41 then 
                    return A.PoolResource:Show(icon)
                end
            end
		--]]



            --Builders
			--todo: add stealth/shadowdance check here. is this needed?, i doubt it since Shadowstrike wont be ready if not stealth or shadowdance
			-- may be needed due to energy cost, 32 for shadowstrike, 28 for shurikenstorm and 
			if  Unit(player):HasBuffs(A.Premeditation.ID) ~= 0 and (Unit(player):HasBuffs(A.Stealth.ID) ~= 0 or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0 or Unit(player):HasBuffs(A.ShadowDance.ID) ~= 0) and MultiUnits:GetByRange(10) <=3  and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6)) then
				if A.Shadowstrike:IsReady(unitID) then 
					return A.Shadowstrike:Show(icon)
				else
					return A.PoolResource:Show(icon)
				end
			end
			--added 10 yard range check on unitID to prevent AOE spam during running out. May not matter much, but makes dummy testing easier
			if A.ShurikenStorm:IsReady(unitID) and MultiUnits:GetByRange(10) >= 3 and GetToggle(2, "AoE") and Unit(unitID):GetRange() <=10 then	
				return A.ShurikenStorm:Show(icon)
			end
			--todo: add stealth/shadowdance check here. is this needed?, i doubt it since Shadowstrike wont be ready if not stealth or shadowdance
			if (Unit(player):HasBuffs(A.Stealth.ID) ~= 0 or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0 or Unit(player):HasBuffs(A.ShadowDance.ID) ~= 0) and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6)) then
				if A.Shadowstrike:IsReady(unitID) then
					return A.Shadowstrike:Show(icon)
				else
					return A.PoolResource:Show(icon)
				end				
			end
			--added 10 yard range check on unitID to prevent AOE spam during running out. May not matter much, but makes dummy testing easier			
			if A.ShurikenStorm:IsReady(unitID) and MultiUnits:GetByRange(10) >= 2 and GetToggle(2, "AoE") and Unit(unitID):GetRange() <=10 then	
				return A.ShurikenStorm:Show(icon)
			end
			--todo: learn how to simplify this since gloomblade replaces backstab
			if A.Gloomblade:IsReady(unitID) then
				return A.Gloomblade:Show(icon)
			end
			if A.Backstab:IsReady(unitID) then
				return A.Backstab:Show(icon)
			end
			--In combat ranged GCD filler
            if A.ShurikenToss:IsReady(unitID) and Player:Energy() >=90 and Unit(unitID):HealthPercent() < 100 and not inMelee then
                return A.ShurikenToss:Show(icon)
            end	
        end
        
		

		
		
		
        --INTERRUPTS
        if Interrupts() then
            return true
        end
        --DEFENSIVES
        if Defensives() then 
            return true
        end
        -- OPENER
        if Opener() and Unit(player):HasBuffs(A.Stealth.ID) ~= 0 and GetToggle(2, "Opener") ~= "OFF" then
            return true
        end
        --StealthCDs
        if StealthCDs() and isBurst 
        --Intent is for vanish to allow for in combat stealth CDs (RtB, MfD, and Ambush) but if vanish lasts so long you gain the stealth buff, we will just reopen instead which will also use stealth CDs based on user Opener Settings
        and (Player:GetStance() == 2 or (LastPlayerCastID == 1856 and Player:GetStance() ~= 1)) then
            return true 
        end
        
        if Unit(player):HasBuffs(A.Stealth.ID) == 0 then
            -- CDs
            if CDs() and isBurst then
                return true 
            end
            -- FINISHERS
            if Finishers() then
                return true
            end
            --Single Target
            if ST() then
                return true
            end
            -- GiftofNaaru
            if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then 
                return A.GiftofNaaru:Show(icon)
            end
        end 
    end  -- end of EnemyRotation()
------------------------------------------
--OOC Actions                           --
------------------------------------------
    --Use BottledFlayedwingToxin if out of combat with other poisons. before stealth
    if A.BottledFlayedwingToxin:IsReady(unitID, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then
        return A.BottledFlayedwingToxin:Show(icon)
    end
	--Summon Steward
	if A.SummonSteward:IsReady(player) and GetItemCount(177278) <= 1 and Player:GetStance() == 0  and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
		return A.SummonSteward:Show(icon)
	end
	
    if GetToggle(2, "OOCStealth") and A.Stealth:IsReady(unitID, true) and A.Stealth:IsLatenced(GetGCD() + 0.5) and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
        return A.Stealth:Show(icon)
    end
    
    --Poisons use UI settings to check if poison selected is ready, already applied and ooc
    if Unit(player):CombatTime() == 0 and not IsMounted() and not Player:IsMoving() then
        if GetToggle(2, "LethalPoison") == "InstantPoison" then
            if A.InstantPoison:IsReady(unitID, true) and Unit(player):HasBuffs(A.InstantPoison.ID) == 0  then
                return A.InstantPoison:Show(icon)
            end
        else
            if A.WoundPoison:IsReady(unitID, true) and Unit(player):HasBuffs(A.WoundPoison.ID) == 0  then
                return A.WoundPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "NumbingPoison" then
            if A.NumbingPoison:IsReady(unitID, true) and Unit(player):HasBuffs(A.NumbingPoison.ID) == 0 then
                return A.NumbingPoison:Show(icon)
            end
        else
            if A.CripplingPoison:IsReady(unitID, true) and Unit(player):HasBuffs(A.CripplingPoison.ID) == 0 then
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

