local _G, setmetatable, pairs, type, math = _G, setmetatable, pairs, type, math
--local huge = math.huge
local TMW = _G.TMW
local Action = _G.Action
local CONST = Action.Const
--local Listener = Action.Listener
local Create = Action.Create
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
--local IsIndoors, UnitIsUnit = _G.IsIndoors, _G.UnitIsUnit

Action[ACTION_CONST_ROGUE_ASSASSINATION] = {
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
	Subterfuge = Create({ Type = "Spell", ID = 108208}),
    Subterfugebuff = Create({ Type = "Spell", ID = 115192}),
    GhostlyStrike = Create({ Type = "Spell", ID = 196937}),
    BladeRush = Create({ Type = "Spell", ID = 271877}),
	Nightstalker = Create({ Type = "Spell", ID = 14062}),
	Exsanguinate = Create({ Type = "Spell", ID = 200806}),
	CrimsonTempest = Create({ Type = "Spell", ID = 121411}),
	MasterAssassin = Create({ Type = "Spell", ID = 255989}),
    -- general
    Stealth = Create({ Type = "Spell", ID = 1784}),
    DeadlyPoison = Create({ Type = "Spell", ID = 2823}),
    CripplingPoison = Create({ Type = "Spell", ID = 3408}),
    NumbingPoison = Create({ Type = "Spell", ID = 5761}),
    WoundPoison = Create({ Type = "Spell", ID = 8679}),
    CrimsonVial = Create({ Type = "Spell", ID = 185311}),
    TricksOfTheTrade = Create({ Type = "Spell", ID = 57934}),
    PoolResource = Create({ Type = "Spell", ID = 97238,Hidden = true}),
    ShroudOfConcealment = Create({ Type = "Spell", ID = 114018}),
	Sap = Create({ Type = "Spell", ID = 6770}),
    Shiv = Create({ Type = "Spell", ID = 5938}),
    Ambush = Create({ Type = "Spell", ID = 8676}),
    CheapShot = Create({ Type = "Spell", ID = 1833}),
    Blind = Create({ Type = "Spell", ID = 2094}),
    Feint = Create({ Type = "Spell", ID = 1966}),
    KidneyShot = Create({ Type = "Spell", ID = 408}),
    Evasion = Create({ Type = "Spell", ID = 5277}),
    CloakofShadows = Create({ Type = "Spell", ID = 31224}),
	-- CDS
	Vendetta = Create({ Type = "Spell", ID = 79140}),
    --Covenants
    Sepsis = Create({ Type = "Spell", ID = 328305}),
    SerratedBoneSpike = Create({ Type = "Spell", ID = 328547}),
    EchoingReprimand = Create({ Type = "Spell", ID = 323547}),
    Flagellation = Create({ Type = "Spell", ID = 323654}),
    --PhialofSerenity = Create({ Type = "Spell", ID = 177278}),
	SummonSteward = Create({ Type = "Spell", ID = 324739}),
    --Conduits
    TripleThreat = Create({ Type = "Spell", ID = 341540}),
	--Legendary
	Celerity = Create({ Type = "Spell", ID = 340087,Hidden = true}),
	MarkoftheMasterAssassin = Create({ Type = "Spell", ID = 340076,Hidden = true}),
	TinyToxicBlade = Create({ Type = "Spell", ID = 340078,Hidden = true}),
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

Action:CreateEssencesFor(ACTION_CONST_ROGUE_ASSASSINATION)
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
  return value and 1 or 0
end
function Action:IsLatenced(delay)
    -- @return boolean
    return TMW.time - (Temp.CastStartTime[self:Info()] or 0) > (delay or 0.1)
end
local function InscrutableQuantumDeviceCheck()
    --@boolean true - Trinket will DPS or give stat buff, false - Trinket will heal or restore mana
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
-- Use Items (function call includes stealth prevention)
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
    InMelee = A.Mutilate:IsInRange(unitID)
	-- stop rotation if stolen shademount
	if Unit(player):HasBuffs(A.StolenShadehound.ID) ~= 0 then return end
	if A.InstanceInfo.ID == 2286 and Unit("target"):Name() == "Farra" then return end -- if in Necrotic Wake instance and targetting Companion, stop rotation to allow for covenant Buff cast to finish stealth breaks cast
    if Unit("target"):Name() == "Ashen Phylactery" then return end

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

        local isBurst = BurstIsON(unitID) -- @boolean

        --testing

        --Stealth with target enemy
        if IsUnitEnemy(unitID) and A.Stealth:IsReady(unitID, true) and Player:GetStance() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
            return A.Stealth:Show(icon)
        end
		-- kill Explosive Affix
        if Unit(unitID):IsExplosives() and A.Mutilate:IsReady(unitID) then
            return A.Mutilate:Show(icon)

		end
        if Unit(unitID):IsExplosives() and A.PoisonedKnife:IsReady(unitID) and not InMelee then
            return A.PoisonedKnife:Show(icon)
        end

		--Shiv Enrages
        if A.Shiv:IsReady(unitID) and Unit(player):HasBuffs(A.NumbingPoison.ID) ~= 0 and Action.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then
            return A.Shiv:Show(icon)
        end
        --Spiteful Shade
        if Unit(unitID):Name() == "Spiteful Shade" and Unit(unitID):HasDeBuffs({"Stuned", "Disoriented", "PhysStuned"}) == 0 then
            --Evasion tank
            if Unit("targettarget"):Name() == Unit(player):Name() and InMelee and A.Evasion:IsReady(player) then
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

------------------------------------------
--Function Definitions                  --
------------------------------------------

        local function BoneSpike()
            if A.SerratedBoneSpike:IsReady(unitID) and Unit(player):CombatTime() > 0 and Unit(player):HasBuffs(A.Stealth.ID) == 0
                and
                ((Player:GetDeBuffsUnitCount(A.SerratedBoneSpike.ID)+1 <= Player:ComboPointsDeficit()) -- CP to be generated is less than the deficit
                or
                ((Player:GetDeBuffsUnitCount(A.SerratedBoneSpike.ID)+1) >= 4+boolnumber(A.DeeperStratagem:IsTalentLearned()) and Player:ComboPointsDeficit() >=4+boolnumber(A.DeeperStratagem:IsTalentLearned())))
                and (UnitThreatSituation("player", unitID) ~= nil or Unit(unitID):IsDummy()) --not SL dummies :( -- player is on the threat table somewhere (in combat with)
                then
            --Bonepsike target missing buff
                    if Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0 and not UnitCooldown:IsSpellInFly("player", A.SerratedBoneSpike.ID) then
                        return A.SerratedBoneSpike:Show(icon)
                    end
                --all targets have bonespike or autotarget is off
                    if Player:GetDeBuffsUnitCount(A.SerratedBoneSpike.ID) >= MultiUnits:GetByRange(15) or not Action.GetToggle(1, "AutoTarget") then
                        if (Unit(unitID):TimeToDie() >= A.SerratedBoneSpike:GetSpellChargesFullRechargeTime() - 30 * Player:GetDeBuffsUnitCount(A.SerratedBoneSpike.ID)) or IsInRaid() then
                            return A.SerratedBoneSpike:Show(icon)
                            end
                    end
                --Bone Spike Targeting
                    if Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) ~= 0 and Action.GetToggle(1, "AutoTarget") and Player:GetDeBuffsUnitCount(A.SerratedBoneSpike.ID) < MultiUnits:GetByRange(15) then
                        for val in pairs(ActiveUnitPlates) do
                            if 	(Unit(val):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0 and Unit(val):TimeToDie() > 1 and MultiUnits:GetByRange(15) >= 2 and ValidAutotarget(val))
                                and
                                (( UnitCanAttack("player", val) and Unit(val):GetRange() <=15  and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) then
                                    return A:Show(icon, ACTION_CONST_AUTOTARGET)
                            end
                        end
                    end
            end

        end
        local function SubterfugeGarrote()
            --With  Subterfuge you want to use all globals during it to apply  Garrote to as many targets as possible.
			--Garrote Targeting
			if A.Garrote:IsReady(unitID) and Action.GetToggle(1, "AutoTarget") and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) ~= 0
            and Unit(player):CombatTime() > 0 and Player:GetDeBuffsUnitCount(A.Garrote.ID) < MultiUnits:GetByRange(5)
            -- and GetCurrentGCD() ~= 0 --the idea is that only look for targets during GCD, but for Garrote lets go crazy!
			then
				for val in pairs(ActiveUnitPlates) do
					if 	(Unit(val):HasDeBuffs(A.Garrote.ID, true) == 0 and ValidAutotarget(val) and Unit(val):TimeToDie() > 12 and A.Mutilate:IsInRange(val))
						and
						(( UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) then

							return

							A:Show(icon, ACTION_CONST_AUTOTARGET)
					end
				end
			end
			--todo Garrote Snapshotting
            if A.Garrote:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) <= 5.4 and Unit(unitID):TimeToDie() > 12 then
                return A.Garrote:Show(icon)
            end
        end
	    local function MFDSnipe()

			if MultiUnits:GetByRange(15) >= 2 and Player:ComboPointsDeficit() >= 4 and Unit("player"):CombatTime() > 0 and GetCurrentGCD() ~= 0 then
				for val in pairs(ActiveUnitPlates) do
					if 	A.MarkedForDeath:IsReady(unitID) and Unit(val):TimeToDie() < Unit(unitID):TimeToDie() and ValidAutotarget(val) and
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
			if Action.GetToggle(1, "AutoTarget") and A.GetToggle(2, "ATInterrupt") and not useKick and not useCC and not useRacial and MultiUnits:GetByRange(8) >= 2  and GetCurrentGCD() ~= 0 then  -- and Unit("player"):CombatTime() > 0 i dont think i care if we are in combat for interrupt auto targeting
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

			-- CrimsonVial
            local CrimsonVial = GetToggle(2, "CrimsonVial")
            if CrimsonVial >= 0 and A.CrimsonVial:IsReady(player) and Unit(player):HealthPercent() <= CrimsonVial and Unit(player):HasBuffs(A.CrimsonVial.ID) == 0 then
                return A.CrimsonVial:Show(icon)
            end
            -- Stoneform (Self Dispel)
            if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
                return A.Stoneform:Show(icon)
            end

        end
        local function Opener()
            local ignoretimers = (BossMods:HasAnyAddon()~=true) or (BossMods:HasAnyAddon()==true and not GetToggle(1, "BossMods")) -- logic for bossmods toggle returns true if no boss mods installed, need extra hasanyaddon check

            if A.MarkedForDeath:IsReady(unitID)
            and ((ignoretimers and IsItemInRange(10645, unitID)) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 7)) and not Unit(unitID):IsTotem()
            then
                return A.MarkedForDeath:Show(icon)
            end

            if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5
            and (ignoretimers or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 3))
            then
                return A.SliceAndDice:Show(icon)
            end

			-- Open with Garrote from stealth. (An exception is that it is fine to open with  Mutilate if you have  Master Assassin, then apply the DoT after the increased crit window.)
			if GetToggle(2, "Opener") ~= "OFF" and GetCurrentGCD() == 0 and ((ignoretimers) or Unit(player):CombatTime() > 0) then
				if GetToggle(2, "Opener") == "CheapShot" and A.CheapShot:IsReady(unitID) then
					return A.CheapShot:Show(icon)
				elseif GetToggle(2, "Opener") == "Garrote" then
					if A.MasterAssassin:IsTalentLearned() and A.Mutilate:IsReady(unitID) then
						return A.Mutilate:Show(icon)
					elseif 	A.Garrote:IsReady(unitID) then
						return A.Garrote:Show(icon)
					end
				end
			end
            -- Tricks with boss mods works ok in raid use only with @focus macro and Boss Timers checked
            if A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2.5) then
                return A.TricksOfTheTrade:Show(icon)
            end
            if A.ShroudOfConcealment:IsReady(player) and IsInRaid() and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 6) then
                return A.ShroudOfConcealment:Show(icon)
            end
        end
        local function StealthCDs()
		    --MFD (also in CDs)
            if MFD()
                then return true
            end
			--reopen based on talent

            if GetToggle(2, "VanishSetting") >=1 then
				--With  Subterfuge, use it when  Garrote is ready with enough space for incoming combo points (i.e. pay attention to having only 0-1 combo points if you are going to apply it to multiple targets). This should be done during  Vendetta, during the last 5.4 seconds of the DoT if you have an empowered one up from the opener, otherwise without regard to the remaining time on your active  Garrote.
				if A.Subterfuge:IsTalentLearned() and A.Garrote:IsReady(unitID) and Player:GetDeBuffsUnitCount(A.Vendetta.ID) ~= 0
                and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) < 8
                then
					return A.Garrote:Show(icon)
				end
				--With  Nightstalker, use it at maximum combo points in order to apply an empowered  Rupture. Make sure  Exsanguinate is ready if talented. Against 3 or more targets, snapshot  Crimson Tempest instead (if talented).
				if A.Nightstalker:IsTalentLearned() and Player:ComboPointsDeficit() == 0 and ((A.Exsanguinate:IsReady(unitID)) or (not A.Exsanguinate:IsSpellLearned())) then
					if (MultiUnits:GetByRange(8) >= 3 and A.CrimsonTempest:IsReady(unitID))  then
						return A.CrimsonTempest:Show(icon)
					elseif A.Rupture:IsReady() then
						return A.Rupture:Show(icon)
					end
				end
				--With  Master Assassin, use it with  Vendetta if you are not going to have to refresh your bleeds during the  Master Assassin buff.
				if A.MasterAssassin:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > 3 and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) > 3 then
					return A.Mutilate:Show(icon)
				end
			end
		end
        local function CDs()
            local EightYardTTD = A.MultiUnits:GetByRangeAreaTTD(8) --@number average time to die of all targets in 8 yards
            local Item = UseItems(unitID)
            if Item and InMelee and Unit(player):HasBuffs(A.Stealth.ID) == 0 then --prevent all items in stealth
                return Item:Show(icon)
            end
            			-- apply inital SnD -- SIMC APL has SnD before extra Garrotes after opener
			if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) < 3 and Unit(player):CombatTime() <= 10 then
				return A.SliceAndDice:Show(icon)
			end
            if Unit(player):CombatTime() <= 10 and SubterfugeGarrote()--if Garrote wasnt on CD from opener due to subterfuge
            then return true end    


			if (A.Flagellation:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) == 0 and A.Vanish:GetCooldown() <= 2 and (EightYardTTD > 4 or Unit(unitID):IsBoss())) and Player:ComboPointsDeficit() <= 1 then
                return A.Flagellation:Show(icon)
            end
		    if A.Sepsis:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) then
                return A.Sepsis:Show(icon)
            end
            if A.EchoingReprimand:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Player:ComboPointsDeficit() >= 2 then
				return A.EchoingReprimand:Show(icon)
            end

		   --SBS (also in ST as builder)
            if BoneSpike()
                then return true
            end
		   --MFD (also in CDs)
            if MFD()
            then return true
            end

			--Vendetta!
			if A.Vendetta:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Vendetta.ID, true) == 0 and Unit(unitID):TimeToDie() > 10 and
			(((A.Vanish:GetCooldown() <= 1 or A.Vanish:GetCooldown() >= 110) and GetToggle(2, "VanishSetting") == 2) or (GetToggle(2, "VanishSetting") ~= 2))

			and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) ~= 0
			and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) ~= 0
			and Player:Energy() > 44
			and ((not A.Flagellation:IsSpellLearned()) or (A.Flagellation:GetCooldown() ~= 0))
			then
				return A.Vendetta:Show(icon)
			end

			-- Use Vanish if setting is set to Auto
			if A.Vanish:IsReady(player) and GetToggle(2, "VanishSetting") == 2 and InMelee and Unit(player):CombatTime() > 0 and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0
			then
				--With  Subterfuge, use it when  Garrote is ready with enough space for incoming combo points (i.e. pay attention to having only 0-1 combo points if you are going to apply it to multiple targets). This should be done during  Vendetta, during the last 5.4 seconds of the DoT if you have an empowered one up from the opener, otherwise without regard to the remaining time on your active  Garrote.
				--todo garrote snapshot
				--todo multiple garrote checks
				if A.Subterfuge:IsTalentLearned() and A.Garrote:IsReady(unitID) and Player:GetDeBuffsUnitCount(A.Vendetta.ID) ~= 0 and Player:ComboPointsDeficit() >=  MultiUnits:GetByRange(5) - Player:GetDeBuffsUnitCount(A.Garrote.ID)  then
					return A.Vanish:Show(icon)
				end
				--With  Nightstalker, use it at maximum combo points in order to apply an empowered  Rupture. Make sure  Exsanguinate is ready if talented. Against 3 or more targets, snapshot  Crimson Tempest instead (if talented).
				if A.Nightstalker:IsTalentLearned() and Player:ComboPointsDeficit() == 0 and (((A.Exsanguinate:GetCooldown() <= 1) or (not A.Exsanguinate:IsSpellLearned())) or (MultiUnits:GetByRange(8) >= 3 and A.CrimsonTempest:IsTalentLearned() and A.CrimsonTempest:GetCooldown() <= 1)) then
					return A.Vanish:Show(icon)
				end
				--With  Master Assassin, use it with  Vendetta if you are not going to have to refresh your bleeds during the  Master Assassin buff.
				if A.MasterAssassin:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > 3 and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) > 3 then
					return A.Vanish:Show(icon)
				end
			end

			--Shiv /w Vendetta Sync
			if A.Shiv:IsReady(unitID)
			and	((Player:GetDeBuffsUnitCount(A.Vendetta.ID) or (A.Vendetta:GetCooldown() > 14)))  --todo Check 14 seconds. Idea is that you should alwasy shiv during vendetta so 5+9 seconds before a vendetta
			then
				return A.Shiv:Show(icon)
			end

			--Exsanguinate when Rupture is up for longer than it's base duration and  Garrote is also up for more than 6 seconds.
			if A.Exsanguinate:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) >= 20 and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) >= 20 then
				return A.Exsanguinate:Show(icon)
			end

		    if A.Fireblood:IsReady(unitID, true) and InMelee and Player:Energy() < 44 then
                return A.Fireblood:Show(icon)
            end
            if A.Berserking:IsReady(unitID, true) and InMelee and Player:Energy() <44 then
                return A.Berserking:Show(icon)
            end
            if A.BloodFury:IsReady(unitID, true) and InMelee and Player:Energy() <44 then
                return A.BloodFury:Show(icon)
            end
            if A.LightsJudgment:IsReady(unitID) and Player:Energy() <44 then
                return A.LightsJudgment:Show(icon)
            end
            if A.BagofTricks:IsReady(player) and InMelee and Player:Energy() <44 then
                return A.BagofTricks:Show(icon)
            end
            if A.AncestralCall:IsReady(player) and InMelee and Player:Energy() <44 then
                return A.AncestralCall:Show(icon)
            end
		end
		local function Finishers()
            -- inital SnD if CD is off
			if A.SliceAndDice:IsReady(unitID, true) and Player:ComboPoints() >= 3 and Unit(player):HasBuffs(A.SliceAndDice.ID) == 0 and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0 and Player:GetStance() <=1  then
				return A.SliceAndDice:Show(icon)
			end
			
            --Maintain SND by prioritizing  Envenom if it is about to drop
            if  Unit(player):HasBuffs(A.SliceAndDice.ID) < 4 and (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) and A.Envenom:IsReady(unitID) then
					return A.Envenom:Show(icon)
			end

          
            --todo snapshotting
			--Use  Rupture at maximum combo points if  Exsanguinate is ready.
			if  (Player:ComboPointsDeficit() <= 0 or EchoingBuffMatch()) and A.Rupture:IsReady(unitID) and A.Exsanguinate:IsReady(unitID) then
				return A.Rupture:Show(icon)
			end
			--Keep up  Crimson Tempest (if talented) against 2 or more targets with four or more combo points. Refresh it only during the last 2s.
			if  (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) and A.CrimsonTempest:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.CrimsonTempest.ID, true) <= 2
				then
					if MultiUnits:GetByRange(8) >= 2 or (MultiUnits:GetByRange(8) == 1 and Player:GetDeBuffsUnitCount(A.Vendetta.ID) == 0 and Player:GetDeBuffsUnitCount(A.Shiv.ID) == 0) then
						return A.CrimsonTempest:Show(icon)
					end
			end

            --todo snappshotting
			--Keep up  Rupture with four or more combo points on all targets.
            --Rupture Targeting
			if (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) and A.Rupture:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) >= 6 and Action.GetToggle(1, "AutoTarget") and Unit(player):CombatTime() > 0 and Player:GetDeBuffsUnitCount(A.Rupture.ID) <= MultiUnits:GetByRange(5) and GetCurrentGCD() ~= 0
			then
				for val in pairs(ActiveUnitPlates) do
					if 	(Unit(val):HasDeBuffs(A.Rupture.ID, true) <= 6 and Unit(val):TimeToDie() > 16 and A.Mutilate:IsInRange(val)) and ValidAutotarget(val)
						and
						(( UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) then
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
					end
				end
			end

			if  (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) and A.Rupture:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) <= 6 and Unit(unitID):TimeToDie() > 16 then
				return A.Rupture:Show(icon)
			end


			if  (Player:ComboPointsDeficit() <= 1 or EchoingBuffMatch()) and A.Envenom:IsReady(unitID) then
				if MultiUnits:GetByRange(10) < 2 and Player:GetDeBuffsUnitCount(A.Vendetta.ID) == 0 and Player:EnergyPercentage() < 80 then
					return A.PoolResource:Show(icon)
				else
					return A.Envenom:Show(icon)
				end
			end
		end
        local function ST()

            if SubterfugeGarrote() 
            then return true end

		   --MFD (also in CDs)
            if MFD()
                then return true
            end

			--Shiv /w Vendetta Sync
			if A.Shiv:IsReady(unitID)
			and	((Player:GetDeBuffsUnitCount(A.Vendetta.ID) or (A.Vendetta:GetCooldown() > 14)))  --todo Check 14 seconds. Idea is that you should alwasy shiv during vendetta so 5+9 seconds before a vendetta
			then
				return A.Shiv:Show(icon)
			end

			--Exsanguinate when Rupture is up for longer than it's base duration and  Garrote is also up for more than 6 seconds.
			if A.Exsanguinate:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) >= 20 and Unit(unitID):HasDeBuffs(A.Garrote.ID, true) >= 20 then
				return A.Exsanguinate:Show(icon)
			end

            --Use Spesis Stealth buff on Ambush, Pool energy for Ambush
            if Unit(player):HasBuffs(A.SepsisStealth.ID) ~= 0 and A.Ambush:IsInRange(unitID) and Player:ComboPointsDeficit() >= 1 then
                if A.Ambush:IsReadyByPassCastGCD(unitID) then
                    return A.Ambush:Show(icon)
                end
                --pool energy for Ambush with Sepsis Buff
                if Player:Energy() <= 51 then
                    return A.PoolResource:Show(icon)
                end
            end
            --Builders
            --SBS (also in CD) but it is a good builder
            if BoneSpike()
                then return true
            end
			--Use  Fan of Knives at 4 or more targets or 3 targets if any of them has no Deadly Poison ticking.
			if A.FanofKnives:IsReady(unitID) and GetToggle(2, "AoE")
			and (MultiUnits:GetByRange(8) >= 4 or (MultiUnits:GetByRange(10) == 3 and Player:GetDeBuffsUnitCount(A.DeadlyPoison.ID) <= MultiUnits:GetByRange(10))) then
				return A.FanofKnives:Show(icon)
			end
			--Use Ambush with the proc from  Blindside
			if A.Ambush:IsReady(unitID) and Player:ComboPointsDeficit() >= 2 then
				return A.Ambush:Show(icon)
			end
			-- Filler
            if A.Mutilate:IsReady(unitID) and GetCurrentGCD() <= 0.100 then
                return A.Mutilate:Show(icon)
            end
            --Ranged filler
            if A.PoisonedKnife:IsReady(unitID) and Player:EnergyPercentage() >=89 and Unit(unitID):HealthPercent() < 100 and not InMelee then
                return A.PoisonedKnife:Show(icon)
            end
        end
------------------------------------------
--Functional Rotation Calls             --
------------------------------------------
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
        --Subterfuge Garrote Spam
        if Unit(player):HasBuffs(A.Subterfugebuff.ID) ~= 0 and SubterfugeGarrote() then
            return true
        end
           --StealthCDs
        if isBurst
        --TODO: review "or" here : the intent is for vanish to allow for in combat stealth CDs (RtB, MfD, and Ambush) but if vanish lasts so long you gain the stealth buff, we will just reopen instead which will also use stealth abilities based on user Opener Settings
        and (Player:GetStance() == 2 or (LastPlayerCastID == A.Vanish.ID and Player:GetStance() ~= 1))
				and StealthCDs() then
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
            if LastPlayerCastID ~= 1856 and ST() then
                return true
            end
            -- GiftofNaaru
            if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then
                return A.GiftofNaaru:Show(icon)
            end
        end
    end-- end of EnemyRotation()
------------------------------------------
--OOC Actions                         --
------------------------------------------
    --Use BottledFlayedwingToxin if out of combat with other poisons. before stealth
    if A.BottledFlayedwingToxin:IsReady(unitID, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then
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
    if GetToggle(2, "OOCStealth")
	and A.Stealth:IsReady(unitID, true)	and A.Stealth:IsLatenced(GetGCD() + 0.5) and Player:GetStance() == 0 and Unit(player):CombatTime() == 0
	and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
        return A.Stealth:Show(icon)
    end
    --Poisons use UI settings to check if poison selected is ready, already applied and ooc
    if Unit(player):CombatTime() == 0 and not IsMounted() and not Player:IsMoving() then
        if GetToggle(2, "LethalPoison") == "DeadlyPoison" then
            if A.DeadlyPoison:IsReady(unitID, true)
            and A.DeadlyPoison:IsLatenced(GetGCD() +0.5)
            and Unit(player):HasBuffs(A.DeadlyPoison.ID) == 0 then
                return A.DeadlyPoison:Show(icon)
            end
        end
        if GetToggle(2, "LethalPoison") == "WoundPoison" then
            if A.WoundPoison:IsReady(unitID, true)
            and A.WoundPoison:IsLatenced(GetGCD() +0.5)
            and Unit(player):HasBuffs(A.WoundPoison.ID) == 0 then
                return A.WoundPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "NumbingPoison" then
            if A.NumbingPoison:IsReady(unitID, true)
            and A.NumbingPoison:IsLatenced(GetGCD() + 0.5)
            and Unit(player):HasBuffs(A.NumbingPoison.ID) == 0 then
                return A.NumbingPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "CripplingPoison" then
            if A.CripplingPoison:IsReady(unitID, true)
            and A.CripplingPoison:IsLatenced(GetGCD() +0.5)
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

