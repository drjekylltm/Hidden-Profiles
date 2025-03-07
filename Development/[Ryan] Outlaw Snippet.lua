local _G, setmetatable, pairs, type, math = _G, setmetatable, pairs, type, math
local huge = math.huge
local math_max					= math.max 
local random = math.random
local TMW = _G.TMW
local Action = _G.Action
local Toaster = _G.Toaster
local GetSpellTexture = _G.TMW.GetSpellTexture
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
--local Azerite = LibStub("AzeriteTraits")
local ACTION_CONST_ROGUE_OUTLAW = CONST.ROGUE_OUTLAW
local ACTION_CONST_AUTOTARGET = CONST.AUTOTARGET
--local ACTION_CONST_SPELLID_FREEZING_TRAP = CONST.SPELLID_FREEZING_TRAP
local IsIndoors, UnitIsUnit = _G.IsIndoors, _G.UnitIsUnit
local interrupt = Action.StdUi.Factory[4]["RyanInterrupts"][_G.GetLocale()]


Action[ACTION_CONST_ROGUE_OUTLAW] = {
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
    QuickDraw = Create({ Type = "Spell", ID = 196938, isTalent = true, Hidden = true }),
    AcrobaticStrikes = Create({ Type = "Spell", ID = 196924, isTalent = true, Hidden = true}),
    Elusiveness = Create({ Type = "Spell", ID = 79008, isTalent = true, Hidden = true}),
    DeeperStratagem = Create({ Type = "Spell", ID = 193531, isTalent = true, Hidden = true}),
    DirtyTricks = Create({ Type = "Spell", ID = 108216, isTalent = true, Hidden = true}),
    MarkedForDeath = Create({ Type = "Spell", ID = 137619, isTalent = true}),
    Vigor = Create({ Type = "Spell", ID = 14983, isTalent = true}),
    --General -- All rogue spells not spec specific
    Stealth = Create({ Type = "Spell", ID = 1784}),
    InstantPoison = Create({ Type = "Spell", ID = 315584}),
    CripplingPoison = Create({ Type = "Spell", ID = 3408}),
    NumbingPoison = Create({ Type = "Spell", ID = 5761}),
    WoundPoison = Create({ Type = "Spell", ID = 8679}),
    CrimsonVial = Create({ Type = "Spell", ID = 185311}),
    TricksOfTheTrade = Create({ Type = "Spell", ID = 57934}),
    PoolResource = Create({ Type = "Spell", ID = 97238, Hidden = true}),
    ShroudOfConcealment = Create({ Type = "Spell", ID = 114018}),
	Sap = Create({ Type = "Spell", ID = 6770}),
    Shiv = Create({ Type = "Spell", ID = 5938}),
    CheapShot = Create({ Type = "Spell", ID = 1833}),
    SliceAndDice = Create({ Type = "Spell", ID = 145418}),
    Feint = Create({ Type = "Spell", ID = 1966}),
    KidneyShot = Create({ Type = "Spell", ID = 408}),
    Evasion = Create({ Type = "Spell", ID = 5277}),
    CloakofShadows = Create({ Type = "Spell", ID = 31224}),
    Distract = Create({ Type = "Spell", ID = 1725}),
    PickPocket = Create({ Type = "Spell", ID = 921}),
    --CDS
    AdrenalineRush = Create({ Type = "Spell", ID = 186286}),
    RollTheBones = Create({ Type = "Spell", ID = 315508}),
    --Covenants
    Sepsis = Create({ Type = "Spell", ID = 328305}),
    SerratedBoneSpike = Create({ Type = "Spell", ID = 328547}),
    EchoingReprimand = Create({ Type = "Spell", ID = 323547}),
    Flagellation = Create({ Type = "Spell", ID = 323654}),
	SummonSteward = Create({ Type = "Spell", ID = 324739}),
    --Conduits
    TripleThreat = Create({ Type = "Spell", ID = 341540}),
	--Legendary
	Celerity = Create({ Type = "Spell", ID = 340087,Hidden = true}),
	MarkoftheMasterAssassin = Create({ Type = "Spell", ID = 340076,Hidden = true}),
	TinyToxicBlade = Create({ Type = "Spell", ID = 340078,Hidden = true}),
	DeathlyShadows = Create({ Type = "Spell", ID = 340092,Hidden = true}),
    GreenskinsWickers = Create({ Type = "Spell", ID = 340573,Hidden = true}), -- Buff from Legendary Greenskin's 15 second duration
    ConcealedBlunderbuss = Create({ Type = "Spell", ID = 340088, Hidden = true}), -- Buff from Legendary ConcealedBlunderbuss maybe? 15 second duration
    --rollthebonesbuff
    Broadside = Create({ Type = "Spell", ID = 193356, Hidden = true}),
    BuriedTreasure = Create({ Type = "Spell", ID = 199600, Hidden = true}),
    GrandMelee = Create({ Type = "Spell", ID = 193358, Hidden = true}),
    RuthlessPrecision = Create({ Type = "Spell", ID = 193357, Hidden = true}),
    SkullandCrossbones = Create({ Type = "Spell", ID = 199603, Hidden = true}),
    TrueBearing = Create({ Type = "Spell", ID = 193359, Hidden = true}),
    --Buffs
    Opportunity = Create({ Type = "Spell", ID = 195627, Hidden = true}), --buff from talent QuickDraw
    FlayedwingToxin = Create({ Type = "Spell", ID = 345545,Hidden = true}),
    Soulshape = Create({ Type = "Spell", ID = 310143}),
    Vanish = Create({ Type = "Spell", ID = 1856}),
    VanishStealth = Create({ Type = "Spell", ID = 11327,Hidden = true}),
    SepsisStealth = Create({ Type = "Spell", ID = 347037,Hidden = true}),
    MasterAssassinsMark = Create({ Type = "Spell", ID = 340094,Hidden = true}),
	StolenShadehound = Create({ Type = "Spell", ID = 338659,Hidden = true}),
	Sanguine = Create({ Type = "Spell", ID = 226510,Hidden = true}),
	Inspired = Create({ Type = "Spell", ID = 343503,Hidden = true}),
	--Debuffs
	GluttonousMiasma= Create({ Type = "Spell", ID = 329298,Hidden = true}),
    --kick
    Kick = Create({ Type = "Spell", ID = 1766}),
    KickGreen = Create({ Type = "SpellSingleColor",ID = 1766,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    GougeGreen = Create({ Type = "SpellSingleColor",ID = 1776,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    BlindGreen = Create({ Type = "SpellSingleColor",ID = 2094,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    KidneyShotGreen = Create({ Type = "SpellSingleColor",ID = 408,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    CheapShotGreen = Create({ Type = "SpellSingleColor",ID = 1833,Hidden = true,Color = "GREEN",QueueForbidden = true}),
    --Rotation
    Ambush = Create({ Type = "Spell", ID = 8676}),
    Dispatch = Create({ Type = "Spell", ID = 2098}),
    Eviscerate = Create({ Type = "Spell", ID = 196819, FixedTexture = GetSpellTexture(2098)}), --Use Dispatch icon
    PistolShot = Create({ Type = "Spell", ID = 185763}),
    SinisterStrike = Create({ Type = "Spell", ID = 1752}),
    BladeFlurry = Create({ Type = "Spell", ID = 13877}),
    GhostlyStrike = Create({ Type = "Spell", ID = 196937}),
    KillingSpree = Create({ Type = "Spell", ID = 51690}),
    BladeRush = Create({ Type = "Spell", ID = 271877}),
    BetweenTheEyes = Create({ Type = "Spell", ID = 199804}),
    Gouge = Create({ Type = "Spell", ID = 1776}),
    Blind = Create({ Type = "Spell", ID = 2094}),
	Dismantle = Create({ Type = "Spell", ID = 207777}),
	SmokeBomb = Create({ Type = "Spell", ID = 212182}),
	SmokeBombDebuff = Create({ Type = "Spell", ID = 212183}),
	CheapTricks	= Create({ Type = "Spell", ID = 212035}),
	DeathfromAbove = Create({ Type = "Spell", ID = 269513}),
    --Items
    PotionofUnbridledFury = Create({ Type = "Potion", ID = 169299}),
    BottledFlayedwingToxin = Create({ Type = "Trinket", ID = 178742,Hidden = true}),
    InscrutableQuantumDevice = Create({ Type = "Trinket", ID = 179350,Hidden = true}),
    ShadowGraspTotem = Create({ Type = "Trinket", ID = 179356,Hidden = true}),
    --Gladiator Badges/Medallions
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

--Action:CreateEssencesFor(ACTION_CONST_ROGUE_OUTLAW)
local A = setmetatable(Action[ACTION_CONST_ROGUE_OUTLAW], { __index = Action })
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
    for key, val in pairs(Action[ACTION_CONST_ROGUE_OUTLAW]) do
        if type(val) == "table" and val.Type == "Trinket" then
            Temp.IsSlotTrinketBlocked[val.ID] = true
        end
    end
end



local DefensiveCasts = {
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
    [319685] = A.Feint, --Severing Smash, SD
    [334625] = A.Feint, --Abyssal Detonation, SOA
    [322895] = A.Feint, --Gloom Squall, SD
    [324527] = A.Feint, --Plaguestomp, PF
    [323195] = A.Feint, --Purifying Blast, SOA
    [333827] = A.Feint, --Seismic Stomp, ToP
    [322232] = A.Feint, --Infectious Rain, PF
    [322486] = A.CloakofShadows, --Overgrowth, Mists
}

------------------------------------------------------------
--Ryan Generic Functions
------------------------------------------------------------
local function boolnumber(value)
    --@number 1 or 0
    --converts a boolean to 1=true 0=false for use in math operations
  return value and 1 or 0
end
boolnumber = A.MakeFunctionCachedDynamic(boolnumber)
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
    if EchoingBuffs[Player:ComboPoints()] then return true end
end
EchoingBuffMatch = A.MakeFunctionCachedStatic(EchoingBuffMatch)
local function ReTabTarget()
    if Unit(player):CombatTime() > 0  and not IgnoreNameplates[select(6, Unit("target"):InfoGUID())] and MultiUnits:GetByRange(5+3*boolnumber(A.AcrobaticStrikes:IsTalentLearned())) >= 1 and

    ((not Unit("target"):IsNameplateAny()) or (Unit("target"):GetRange() > 20))
    then 
            for val in pairs(ActiveUnitPlates) do
                if not KeepTarget[select(6, Unit(val):InfoGUID())] and Unit(val):GetRange(5+3*boolnumber(A.AcrobaticStrikes:IsTalentLearned())) and
                    ((UnitCanAttack("player", val)  and UnitThreatSituation("player", val) ~= nil)	or Unit(val):IsDummy()) then
                        return true
                end
            end
    end
end
------------------------------------------------------------
--Ryan Generic Functions End
------------------------------------------------------------
-- [1] CC AntiFake Rotation
A[1] = function(icon)
    local unitID = "none"
    if IsUnitEnemy("mouseover") then
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then
        unitID = "target"
    end
    local useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid("target")
    if useKick or useCC or useRacial then
        -- useCC / useRacial
        if not useKick or notKickAble or A.Kick:GetCooldown() > 0 then
            if useCC
            and (Player:GetStance() >=1) and A.CheapShot:IsReadyP(unitID, nil, true, true) and Unit(unitID):GetDR("stun") > 0 and not Unit(unitID):IsBoss() and A.CheapShot:AbsentImun(unitID, Temp.TotalAndPhysAndCC) then
                return A.CheapShotGreen:Show(icon)
            end
            if useCC and A.Gouge:IsReadyP(unitID, nil, true, true) and Player:IsBehind(.3) and Unit(unitID):GetDR("incapacitate") > 0 and not Unit(unitID):IsBoss() and A.Gouge:AbsentImun(unitID, Temp.TotalAndPhysAndCC) then
                return A.GougeGreen:Show(icon)
            end
            if useCC and A.KidneyShot:IsReadyP(unitID, nil, true, true) and Player:ComboPoints() >= 1 and Unit(unitID):GetDR("stun") > 0 and not Unit(unitID):IsBoss() and A.KidneyShot:AbsentImun(unitID, Temp.TotalAndPhysAndCC) then
                return A.KidneyShotGreen:Show(icon)
            end
            if useCC and A.Blind:IsReadyP(unitID, nil, true, true) and Unit(unitID):GetDR("disorient") > 0 and not Unit(unitID):IsBoss() and A.Blind:AbsentImun(unitID, Temp.TotalAndPhysAndCC) then
                return A.BlindGreen:Show(icon)
            end
        end
    end
end
-- [2] Kick AntiFake Rotation
A[2] = function(icon)
    local unitID = "none"
    if IsUnitEnemy("mouseover") then
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then
        unitID = "target"
    end
    if unitID then
        local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
        if castLeft > A.GetPing() then
            if not notKickAble and A.Kick:IsReadyP(unitID, nil, true, true) and A.Kick:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.KickGreen:Show(icon)
            end
        end
    end
end
-- [3] Single Rotation
A[3] = function(icon)
	-- stop rotation if stolen shademount
	if Unit(player):HasBuffs(A.StolenShadehound.ID) ~= 0 then return end
	-- if in Necrotic Wake instance and targetting Companion, stop rotation to allow for covenant Buff cast to finish (stealth breaks cast)
    if A.InstanceInfo.ID == 2286 and Unit("target"):Name() == "Farra" then return end
    -- Stop rotation on Torghast Containers
	if Unit("target"):Name() == "Ashen Phylactery" then return end
	--164698 or 167986 or 165533 or 165523 or 170525 or 167987 or 178523 or 179514 or

    --testing

--
        local function TestCustom(n, func)
            local t = debugprofilestop()
            local f
            for i = 1, (n or 100) do
                f = func()
            end
            print(debugprofilestop() - t)    
            return f
        end 
--

    -- Rotations
    function EnemyRotation(unitID)
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        if Unit(unitID):HasDeBuffs("BreakAble") > 0 and Unit(player):CombatTime() == 0 then return end --Stop Rotation if Target is sapped and OOC
        if A.Sap:IsQueued() then return true end --Sap is queued, stop everything else
        if UnitCanAttack(player, unitID) == false then return end --Stop Rotation if Target can not attack back (yellow enemies)
        if Unit(player):HasBuffs(A.Vanish.ID) ~= 0 and GetToggle(2, "VanishSetting") == 0 then return end  --Stop Rotation if Vanish is set to off
        if IsMounted() then return end  --Stop Rotation if Mounted. Action has check for this but can lag after stealthing
        --if Unit(unitID):HasDeBuffs("BreakAble") > 0 and ((A.Zone == "arena" or A.Zone == "pvp") or ((A.Zone ~= "arena" or A.Zone ~= "pvp") and Unit(player):CombatTime() == 0)) then return end --stop on breakable target in pvp
        local _, _, _, _, _, npc_id 		= Unit(unitID):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
        local isBurst = BurstIsON(unitID) and npc_id ~= 174773-- @boolean ignore Spitefuls in M+
        local inMelee = A.Kick:IsInRange(unitID) -- @boolean
        local inCombat = Unit(player):CombatTime() > 0
        local inAoE = MultiUnits:GetByRange(5+3*boolnumber(A.AcrobaticStrikes:IsTalentLearned())) >= 2
        local extraBSCP = boolnumber(Unit(player):HasBuffs(A.Broadside.ID) >= 1)
        local EightYardTTD = A.MultiUnits:GetByRangeAreaTTD(5+3*boolnumber(A.AcrobaticStrikes:IsTalentLearned())) --@number average time to die of all targets in 8 yards
        local effective_combo_points = ((EchoingBuffMatch() and 7) or Player:ComboPoints())
        local finish_condition = Player:ComboPoints() >= Player:ComboPointsMax() - extraBSCP - (boolnumber(Unit(player):HasBuffs(A.Opportunity.ID) ~= 0) * boolnumber(A.QuickDraw:IsTalentLearned())) or effective_combo_points >= Player:ComboPointsMax() 
        local ignoretimers = (BossMods:HasAnyAddon()~=true) or (inCombat) or (BossMods:HasAnyAddon()==true and not GetToggle(1, "BossMods") and (A.InstanceInfo.ID ~= 2450 or A.InstanceInfo.ID ~= 2296)) --ignore timers if no BossMods or incomabt or BossMods and unchecked

        if A.BetweenTheEyes:IsReady(unitID) and effective_combo_points < 5 then finish_condition = false 
        end

        --Testing
        if not Player:IsStealthed() and LastPlayerCastID == A.Vanish.ID
        then print ("Lag!")
        end
        --Stealth with target enemy
        if IsUnitEnemy(unitID) and A.Stealth:IsReady(unitID, true) and Player:GetStance() == 0 and not IsMounted() then --apparently the wow API is shit and soulshape is also getstance == 2
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
        if Unit(unitID):IsExplosives() and A.SinisterStrike:IsReady(unitID) then
            return A.SinisterStrike:Show(icon)
        end
        if Unit(unitID):IsExplosives() and A.PistolShot:IsReady(unitID) and not inMelee then
            return A.PistolShot:Show(icon)
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
            if Unit("targettarget"):Name() == Unit(player):Name() then
                if inMelee and A.Evasion:IsReady(player) then
                    return A.Evasion:Show(icon)
                end
            --Stun
                if A.KidneyShot:IsReady(unitID) and Player:ComboPoints() >= 2 and  Unit(player):HasBuffs(A.Evasion.ID) == 0 then
                    return A.KidneyShot:Show(icon)
                end
            end
            --Slow
            if Unit(unitID):HasDeBuffs(A.PistolShot.ID) == 0 and A.PistolShot:IsReady(unitID) and not inMelee then
                return A.PistolShot:Show(icon)
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
                elseif A.Gouge:IsReady(unitID) and Player:IsBehind(.3) then
                    return A.Gouge:Show(icon)
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
        local function TimeOnTarget()
            --returns @number
            --how many seconds player is from target. GetCurrentSpeed returns percentage of speed from base 7 yards per second
            --1 Second == Melee Range
            local _, min_range				= Unit("target"):GetRange()
            local timefromtarget = ((min_range+5+3*boolnumber(A.AcrobaticStrikes:IsTalentLearned()))/((Unit("player"):GetCurrentSpeed()+ 0.000000001) /100*7))
            return timefromtarget
        end
        TimeOnTarget = A.MakeFunctionCachedStatic(TimeOnTarget)
	    local function MFDSnipe()
			if MultiUnits:GetByRange(15) >= 2 and Player:ComboPointsDeficit() >= 4 and Unit("player"):CombatTime() > 0 and GetCurrentGCD() ~= 0 and not IgnoreNameplates[npc_id] then
				for val in pairs(ActiveUnitPlates) do
					if 	A.MarkedForDeath:IsReady(unitID) and Unit(val):TimeToDie() < Unit(unitID):TimeToDie() 
                    and not KeepTarget[select(6, Unit(val):InfoGUID())] 
                    and
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
            if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned()) and (not GetToggle(1, "BossMods") or inCombat) and not Unit(unitID):IsTotem() then
                return A.MarkedForDeath:Show(icon)
            end
        end
        MFD = A.MakeFunctionCachedStatic(MFD)
        local function BetweenTheEyesRetarget()
                --disable RTBtE toggle if target has debuff
                if Unit(unitID):HasDeBuffs(A.BetweenTheEyes.ID, true) ~= 0 and Action.GetToggle(2, "REBTE") == 1 then 
                    Action.SetToggle({2, "REBTE"}, 0) 
                end
                --BetweenTheEyes Retarget
                if Player:GetDeBuffsUnitCount(A.BetweenTheEyes.ID) > 0 and not IgnoreNameplates[npc_id] --something has between the eyes from us
                and Unit(unitID):HasDeBuffs(A.BetweenTheEyes.ID, true) == 0 
                --and not A.SerratedBoneSpike:IsReady(unitID) and not A.MarkedForDeath:IsReady(unitID)  
                and inCombat and GetCurrentGCD() ~= 0
 	            then
                    for val in pairs(ActiveUnitPlates) do
                        if 	Unit(val):HasDeBuffs(A.BetweenTheEyes.ID, true) ~= 0 	-- if a nameplate has BTE buff
                            and A.Kick:IsInRange(val) --and is in melee range
                            and ((UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) then
                                return true
                        end
                    end
            end
        end
        local function CheckBuffCountRB()
            local count = 0
            if Unit(player):HasBuffs(A.Broadside.ID) ~= 0 then count = count + 1 end
            if Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 then count = count + 1 end
            if Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 then count = count + 1 end
            if Unit(player):HasBuffs(A.RuthlessPrecision.ID) ~= 0 then count = count + 1 end
            if Unit(player):HasBuffs(A.TrueBearing.ID) ~= 0 then count = count + 1 end
            if Unit(player):HasBuffs(A.SkullandCrossbones.ID) ~= 0 then count = count + 1 end
            return count
        end
        CheckBuffCountRB = A.MakeFunctionCachedStatic(CheckBuffCountRB)
        local function BoneSpike()
            --Bone Spike Targeting
            if A.SerratedBoneSpike:IsReady(unitID)
            and Action.GetToggle(1, "AutoTarget") 
            and Action.GetToggle(2, "SBSTarget") 
            and Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) ~= 0 
            and not IgnoreNameplates[npc_id] 
            then
                for val in pairs(ActiveUnitPlates) do
                    if 	(Unit(val):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0 
                        and Unit(val):TimeToDie() < Unit(unitID):TimeToDie() 
                        and Unit(val):TimeToDie() > 1 
                        and not KeepTarget[select(6, Unit(val):InfoGUID())])
                        and (( UnitCanAttack("player", val) and Unit(val):GetRange() <=15  and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) 
                    then
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                end
            end
            --Bone Spike Target Missing Debuff
            if A.SerratedBoneSpike:IsReady(unitID)
            and Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0
            and inCombat 
            and not Player:IsStealthed()
            and (UnitThreatSituation(player, unitID) ~= nil or Unit(unitID):IsDummy()) -- player is on the threat table somewhere (in combat with)
            and not UnitCooldown:IsSpellInFly(player, A.SerratedBoneSpike.ID)
            then
                return A.SerratedBoneSpike:Show(icon)
            end
            --Im going to simplifiy this logic, the assumption is that if you make it here in the rotation, then all targets have SBS and now you need logic to keep from wasting it
            --Attempt to use when it will cap combo points and SnD is down, otherwise keep from capping charges
            if A.SerratedBoneSpike:IsReady(unitID)
            and inCombat 
            and not Player:IsStealthed()
            and (UnitThreatSituation(player, unitID) ~= nil or Unit(unitID):IsDummy()) -- player is on the threat table somewhere (in combat with)
            and not UnitCooldown:IsSpellInFly(player, A.SerratedBoneSpike.ID)
            and
            (
            (Unit(unitID):IsBoss() and Unit(unitID):TimeToDie()<=5)
            or A.SerratedBoneSpike:GetSpellChargesMax() - A.SerratedBoneSpike:GetSpellChargesFrac() <=0.25 
            or Player:ComboPointsDeficit() >= (math.min((Player:GetDeBuffsUnitCount(A.SerratedBoneSpike.ID)+ 1 + extraBSCP), 4+boolnumber(A.DeeperStratagem:IsTalentLearned()))) and Unit(player):HasBuffs(A.SkullandCrossbones.ID) == 0 and Player:EnergyTimeToMax() > 1
            )
            then
                return A.SerratedBoneSpike:Show(icon)
            end
        end
		local function MasterAss()
            --[[
            --Vanish > dispatch > mfd > bte/dispatch > ks - with flurry active and MFD
            --Vanish > ambush > bf > ks - without flurry active
            --Vanish > ambush to max cp > dispatch > ks - with flurry active and no MFD
            --]]
                --Panick Killing spree to make sure it is used before MA ends, it does snapshot crit, If we dont KS what's the point!!!!
                if A.KillingSpree:IsReady(unitID) and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) <= 1 + (2*A.GetPing())
                then
                    return A.KillingSpree:Show(icon)
                end
                -- ambush if not at cap
                if A.Ambush:IsReady(unitID) and Player:ComboPointsDeficit() >= 2 then
                    return A.Ambush:Show(icon)
                end
                --bladeflurry if needed
                if A.BladeFlurry:IsReady(unitID, true)
                and GetToggle(2, "AoE")
                and inAoE
                and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2 then
                    return A.BladeFlurry:Show(icon)
                end
                -- use CP if we have Cap but not after a BF cause that would prevent KS
                if A.BetweenTheEyes:IsReady(unitID) and Player:ComboPointsDeficit() <= 1 and ((inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) >= 2) or (Unit(unitID):IsBoss())) and LastPlayerCastID ~= A.BladeFlurry.ID then
                    return A.BetweenTheEyes:Show(icon)
                end
                if A.Dispatch:IsReady(unitID) and Player:ComboPointsDeficit() <= 1 and ((inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) >= 2) or (Unit(unitID):IsBoss())) and LastPlayerCastID ~= A.BladeFlurry.ID then
                    return A.Dispatch:Show(icon)
                end
                --MfD Snipping
                if A.MarkedForDeath:IsReady(unitID) and Action.GetToggle(1, "AutoTarget") and Action.GetToggle(2, "MFDSnipping") and MFDSnipe() then
                    return true
                end
                --MFD if possible, with flurry active
                if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4  + boolnumber(A.DeeperStratagem:IsTalentLearned()) and not Unit(unitID):IsTotem() and Unit(player):HasBuffs(A.BladeFlurry.ID) >= 2 and LastPlayerCastID ~= A.BladeFlurry.ID then
                    return A.MarkedForDeath:Show(icon)
                end
                --Killing Spree
                if A.KillingSpree:IsReady(unitID)
                and (inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0)
                or (Unit(unitID):IsBoss())
                --and Player:ComboPointsDeficit() >= 1 maybe not needed? the concern is off hand CP pushing back into a finisher instead of KS, look into a GCD vs Buff remaining check to ensure the last second of buff is used to cast KS
                then
                    return A.KillingSpree:Show(icon)
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
                if (Player:GetStance() ~= 0) and A.CheapShot:IsReady(unit) and A.CheapShot:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Unit(unit):GetDR("stun") > 0 and not Unit(unit):IsBoss() and Unit(unit):HasBuffs(A.Sanguine.ID) == 0 then
                    return true
                end
            end
            local function GougeAble(unit)
                if A.Gouge:IsReady(unit) and A.Gouge:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Player:IsBehind(.3) and Unit(unit):GetDR("incapacitate") > 0 and not Unit(unit):IsBoss() then
                    return true
                end
            end
            local function KidneyShotAble(unit)
                if A.KidneyShot:IsReady(unit) and A.KidneyShot:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Player:ComboPoints() >= 1 and Unit(unit):GetDR("stun") > 0 and not Unit(unit):IsBoss() and Unit(unit):HasBuffs(A.Sanguine.ID) == 0 then
                    return true
                end
            end
            local function QuakingPalmAble(unit)
                if  A.QuakingPalm:IsReady(unit) and A.QuakingPalm:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Unit(unit):GetDR("incapacitate") > 0 and not Unit(unit):IsBoss() then
                    return true
                end
            end
            local function BlindAble(unit)
                if A.Blind:IsReady(unit) and A.Blind:AbsentImun(unit, Temp.TotalAndPhysAndCC) and Unit(unit):GetDR("disorient") > 0 and not Unit(unit):IsBoss() then
                    return true
                end
            end
            --All kick/cc macros require mouseover checks, so our logic mustmatch here to prevent missing due to mouse location
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
            local _, _, SpellID, _ ,_ , IsChanneling = Unit(unitIDinterrupt):IsCastingRemains()
            --if casting anything start interrupt logic
            if SpellID ~= nil 
            then
                --Check ryan interrupt table if this cast should be stopped instantly and ignore interval checks, update uses if so
                if interrupt[SpellID] ~= nil and interrupt[SpellID].ignoreInterval == true
                then
                    useKick = interrupt[SpellID].useKick
                    useCC = interrupt[SpellID].useCC
                    useRacial = interrupt[SpellID].useRacial
                end
                --Check if target is known to not be CCable
                if (useCC or useRacial) and IsNotCCAble[npc_id] then
                    useCC = false
                    useRacial = false
                end
                --Check if the cast is a channel and we should wait for the channel to interrupt
                if Channels[SpellID] and not IsChanneling then
                    useKick = false
                    useCC = false
                    useRacial = false
                end
                --Interrupt as appropriate based on interrupt table and CC knowledge   
                if useKick or useCC or useRacial then
                    -- useKick
                    if useKick and castLeft > A.GetPing() and not notKickAble  and KickAble(unitIDinterrupt) then
                        return A.Kick:Show(icon)
                    end
                    -- useCC / useRacial
                    if (not useKick or notKickAble or A.Kick:GetCooldown() > castLeft + A.GetPing()) and Unit(unitIDinterrupt):HasBuffs(A.Inspired.ID) == 0 then
                        if useCC and CheapShotAble(unitIDinterrupt) then
                            return A.CheapShot:Show(icon)
                        end
                        if useCC and GougeAble(unitIDinterrupt) then
                            return A.Gouge:Show(icon)
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
                interrupt[SpellID] ~= nil and            
                (interrupt[SpellID].useCC == true or 
                interrupt[SpellID].useRacial == true)
                and inMelee
                and castLeft < (GetGCD() + GetCurrentGCD() + A.GetPing())
                then
                    return A.PoolResource:Show(icon)
                end
            end
            --Auto Targeting Interrupts
            if Action.GetToggle(1, "AutoTarget") and A.GetToggle(2, "ATInterrupt") 
            and (not useKick or notKickAble or A.Kick:GetCooldown() > castLeft + A.GetPing()) -- Current Target does not need interrupted
            and not useCC -- Current Target does not need interrupted
            and not useRacial -- Current Target does not need interrupted
            and GetCurrentGCD() ~= 0 --prevent getting stuck auto targeting
            and not IgnoreNameplates[npc_id]  --Target is not something we swap off
            then                                                                                                                                                      
                for val in pairs(ActiveUnitPlates) do
                    if A.GetToggle(2, "InterruptList") and inInstance then--uses ryan interrupt table in SL dungeons and raid instance IDs
                    useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val, "RyanInterrupts", true)
                    else
                        useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val)
                    end
                    local _, _, SpellID, _ ,_ , IsChanneling = Unit(val):IsCastingRemains()
                    --Check ryan interrupt table if this cast should be stopped instantly and ignore interval checks, update uses if so
                    if SpellID ~= nil and interrupt[SpellID] ~= nil and interrupt[SpellID].ignoreInterval == true
                    then
                        useKick = interrupt[SpellID].useKick
                        useCC = interrupt[SpellID].useCC
                        useRacial = interrupt[SpellID].useRacial
                    end
                    if useKick or useCC or useRacial then
                        --Check if the nameplate can even be CC'd, if not, correct useCC and useRacial
                        local _, _, _, _, _, npc_id_val 		= Unit(val):InfoGUID()
                        if (useCC or useRacial) and IsNotCCAble[npc_id_val] then
                            useCC = false
                            useRacial = false
                        end
                        --Check for spells that we want to stop the channel not the cast
                        if Channels[SpellID] and not IsChanneling then
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
                            or (useCC and CheapShotAble(val))
                            or (useCC and GougeAble(val))
                            or (useCC and KidneyShotAble(val))
                            or (useRacial and QuakingPalmAble(val))
                            or (useCC and BlindAble(val)))                                                   
                            then
                                    return A:Show(icon, ACTION_CONST_AUTOTARGET)
                        end
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
--]]  

			-- CrimsonVial
            local CrimsonVial = GetToggle(2, "CrimsonVial")
            if CrimsonVial >= 0 and A.CrimsonVial:IsReady(player) and Unit(player):HealthPercent() < CrimsonVial and Unit(player):HasBuffs(A.CrimsonVial.ID) == 0 and Unit(player):HasDeBuffs(A.GluttonousMiasma.ID) == 0 then
                return A.CrimsonVial:Show(icon)
            end
            -- Stoneform (Self Dispel)
            if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then
                return A.Stoneform:Show(icon)
            end
        end
        local function Opener()
            if A.MarkedForDeath:IsReady(unitID) and not Unit(unitID):IsTotem() and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned())
            and ((ignoretimers and (TimeOnTarget() <= 2.5 or inMelee)) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 7*GetGCD()+.100))
            then
                return A.MarkedForDeath:Show(icon)
            end
            if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5
            and ((ignoretimers and (TimeOnTarget() <= 2  or inMelee)) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 3*GetGCD()+.100 + GetLatency()))
            then
                return A.SliceAndDice:Show(icon)
            end
            if CheckBuffCountRB() <= 1 
            and A.RollTheBones:IsReady(unitID, true) 
            and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.RuthlessPrecision.ID) ~= 0 or Unit(player):HasBuffs(A.SkullandCrossbones.ID) ~= 0))
            and ((ignoretimers and (TimeOnTarget() <= 2+1*boolnumber(A.MarkedForDeath:IsTalentLearned()) or inMelee)) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2*GetGCD()+.100+ GetLatency()))
                then
                return A.RollTheBones:Show(icon)
            end
            if (ignoretimers or BossMods:IsEngage() or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= .100 + GetLatency()))
            and inMelee
            then
                if Player:ComboPointsDeficit() < 2 + extraBSCP  and GetCurrentGCD() == 0  then
                    if A.BetweenTheEyes:IsReady(unitID) then
                        return A.BetweenTheEyes:Show(icon)
                    end
                    if A.Dispatch:IsReady(unitID) then
                        return A.Dispatch:Show(icon)
                    end
                    if A.Eviscerate:IsReady(unitID) then
                        return A.Eviscerate:Show(icon)
                    end
                end
                if GetToggle(2, "Opener") == "Ambush" then
                    if A.Ambush:IsReady(unitID) and GetCurrentGCD() == 0
                    then
                        return A.Ambush:Show(icon)
                    end
                end
                if GetToggle(2, "Opener") == "CheapShot" then
                    if A.CheapShot:IsReady(unitID) then
                        return A.CheapShot:Show(icon)
                    end
                end
            end
            -- Tricks with boss mods
            if A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2.5) then
                return A.TricksOfTheTrade:Show(icon)
            end
            if A.ShroudOfConcealment:IsReady(player) and IsInRaid() and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 9) then
                return A.ShroudOfConcealment:Show(icon)
            end





        end
        local function StealthCDs()
            if A.RollTheBones:IsReady(unitID, true) 
            and CheckBuffCountRB() <= 1 -- more than 1 buff we dont RTB
            and (CheckBuffCountRB() == 0 or Unit(player):HasBuffs(A.BuriedTreasure.ID, A.GrandMelee.ID, A.RuthlessPrecision.ID, A.SkullandCrossbones.ID) ~= 0) 
            and inMelee 
            and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0 then
                return A.RollTheBones:Show(icon)
            end
		   --MFD (also in CDs)
            if MFD()
                then return true
            end
            --Use Ambush from Maunal or Auto Vanish
            if GetToggle(2, "VanishSetting") >=1 then
				if (A.DeathlyShadows:HasLegendaryCraftingPower() or Player:ComboPointsDeficit() < 2 + extraBSCP) and GetCurrentGCD() == 0 and (not GetToggle(1, "BossMods") or inCombat) then
					if A.BetweenTheEyes:IsReady(unitID) then
						return A.BetweenTheEyes:Show(icon)
					end
					if A.Dispatch:IsReady(unitID) then
						return A.Dispatch:Show(icon)
					end
                    if A.Eviscerate:IsReady(unitID) then
                        return A:Show(icon, GetSpellTexture(2098))
                    end
				end
				if not A.DeathlyShadows:HasLegendaryCraftingPower() and A.Ambush:IsReady(unitID) and GetCurrentGCD() == 0 
                then
					return A.Ambush:Show(icon)
				end
				if Player:Energy() <= 50 then
					return A.PoolResource:Show(icon)
				end
            end
        end
        local function CDs()
            local Item = UseItems(unitID)
            local _, _, threatpct = UnitDetailedThreatSituation(player, unitID)

            if Item and inMelee and Unit(player):HasBuffs(A.Stealth.ID) == 0 and Player:GetDeBuffsUnitCount(A.BetweenTheEyes.ID) >= 1 and isBurst then --prevent all items in stealth and BTE sync
                return Item:Show(icon)
            end
			        -- Use Vanish if setting is set to Auto for MA builds
                    if A.Vanish:IsReady(player) 
                    and GetToggle(2, "VanishSetting") == 2 
                    and inMelee 
                    and inCombat 
                    and isBurst
                    and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0 
                    and A.MarkoftheMasterAssassin:HasLegendaryCraftingPower() 
                    and A.KillingSpree:IsTalentLearned() and A.KillingSpree:GetCooldown() <= 2 and EightYardTTD >= 8 then
					--if aoe and flurry active >= 4 and MFD ready and CP deficit <= 1
					if ((inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) >= 4))    --if AOE and bladeflurry will last
					and A.MarkedForDeath:IsReady(unitID) and not Unit(unitID):IsTotem() -- and MFD is ready
					and Player:ComboPointsDeficit() <= 1 then
						if Player:Energy() <= 35 then  -- pool energy for dispatch
							return A.PoolResource:Show(icon)
                        else
							return A.Vanish:Show(icon)
						end
					end
					--if aoe and no BF, BF is ready, CP deficit >= 2
					if ((inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2)) --if AOE and bladeflurry wont last till KS
					and A.BladeFlurry:GetCooldown() <= 1 		-- BF will be ready to refresh
					and Player:ComboPointsDeficit() >= 2 then 	-- ambush wont cap CP
						if Player:Energy() <= 51 then
							return A.PoolResource:Show(icon)
						else
							return A.Vanish:Show(icon)
						end
					end
					--if ((aoe and flurry active) ) and (CP deficit =2 or 3) and MFD not ready
					if ((inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) >= 4))    --if AOE and bladeflurry will last
						and (Player:ComboPointsDeficit() == 2 or Player:ComboPointsDeficit() == 3) then
							if Player:Energy() <= 51 then  -- pool energy for ambush to max CP
								return A.PoolResource:Show(icon)
							else
								return A.Vanish:Show(icon)
							end
					end
			end
            if (A.Flagellation:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.Flagellation.ID, true) == 0 and (EightYardTTD > 4 or Unit(unitID):IsBoss())) and (Player:ComboPointsDeficit() <= 0 + extraBSCP + boolnumber(Unit(player):HasBuffs(A.Opportunity.ID) >= 1 and A.QuickDraw:IsTalentLearned())) then
                return A.Flagellation:Show(icon)
            end
            if A.AdrenalineRush:IsReady(unitID, true) and isBurst and Unit(player):HasBuffs(A.AdrenalineRush.ID) == 0 and inMelee and (EightYardTTD > 8 or Unit(unitID):IsBoss()) and (GetToggle(2, "Adrenaline") <= MultiUnits:GetByRange(8) or Unit(unitID):IsBoss()) then
                return A.AdrenalineRush:Show(icon)
            end
            --RtB is not a cooldown, it is here to ensure correct prioirty with Burst on
            if CheckBuffCountRB() <= 1 and A.RollTheBones:IsReady(unitID, true) and (CheckBuffCountRB() == 0 or (Unit(player):HasBuffs(A.BuriedTreasure.ID) ~= 0 or Unit(player):HasBuffs(A.GrandMelee.ID) ~= 0 or Unit(player):HasBuffs(A.RuthlessPrecision.ID) ~= 0 or Unit(player):HasBuffs(A.SkullandCrossbones.ID) ~= 0)) and inMelee and (not GetToggle(1, "BossMods") or inCombat) and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0 then
                return A.RollTheBones:Show(icon)
            end
            --AoE (bladeflurry is also in ST(), this is to ensure correct prioitizaion for isBurst on and off. The intent is for GetToggle(2, "AoE") to control bladeflurry, not isBurst.
            if A.BladeFlurry:IsReady(unitID, true) and GetToggle(2, "AoE") and inAoE and (not A.IsInPvP or not EnemyTeam():IsBreakAble(12)) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Unit(player):HasBuffs(A.BladeFlurry.ID) <= 2 and (not GetToggle(1, "BossMods") or inCombat) then
                return A.BladeFlurry:Show(icon)
            end
		   --MFD (also in CDs)
            if MFD()
                then return true
            end
            if Action.GetToggle(1, "AutoTarget") and Action.GetToggle(2, "REBTE") >= 1 and BetweenTheEyesRetarget() then
                return A:Show(icon, ACTION_CONST_AUTOTARGET)
            end
            if A.GhostlyStrike:IsReady(unitID) and Player:ComboPointsDeficit() >= 1 + extraBSCP then
                return A.GhostlyStrike:Show(icon)
            end
			--Killing Spree for non MA builds
			if A.KillingSpree:IsReady(unitID) and isBurst and Player:EnergyTimeToMax() >= 2.0 + GetCurrentGCD() and ((inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0) or MultiUnits:GetByRange(8) <= 1) and not A.MarkoftheMasterAssassin:HasLegendaryCraftingPower() then
                return A.KillingSpree:Show(icon)
            end
            --Do not bladerush Spiteful Shades
            if A.BladeRush:IsReady(unitID) and Unit(player):HasBuffs(A.Stealth.ID) == 0 and npc_id ~= 174773
			and (MultiUnits:GetByRange(8) <= 1 or (inAoE and Unit(player):HasBuffs(A.BladeFlurry.ID) ~= 0))
			and ((GetToggle(2, "BladeRushRange") and Unit(unitID):GetRange() <=5) or not GetToggle(2, "BladeRushRange")) then
                return A.BladeRush:Show(icon)
            end
            -- Use Vanish if setting is set to Auto (non MA)
	    if (A.Vanish:IsReady(player, true))
		  and GetToggle(2, "VanishSetting") == 2 
          and isBurst
          and           
          (((threatpct or 100) ~= 100) or Unit(unitID):IsDummy()) --threatpct is 100 if we are the only target, otherwise it is some other number and it is safe to vanish. Dummys return nil
		  and inMelee and inCombat and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0
		  and (not A.MarkoftheMasterAssassin:HasLegendaryCraftingPower() or not A.KillingSpree:IsTalentLearned())
		  and EightYardTTD > 6 
          then
				if ((Player:ComboPointsDeficit() >= 2 + extraBSCP  and not A.DeathlyShadows:HasLegendaryCraftingPower()) or (A.DeathlyShadows:HasLegendaryCraftingPower() and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned())))
				then  -- for not MA build
						if Player:Energy() <= 51 then
							return A.PoolResource:Show(icon)
                        elseif A.Vanish:IsReady() then
							return A.Vanish:Show(icon)
						end
				end
		end
        if A.Sepsis:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) then
                return A.Sepsis:Show(icon)
        end
        if A.EchoingReprimand:IsReady(unitID) and (EightYardTTD > 4 or Unit(unitID):IsBoss()) and Player:ComboPointsDeficit() >= 2 then
			return A.EchoingReprimand:Show(icon)
        end
        if A.Fireblood:IsReady(unitID, true) and inMelee and Player:Energy() < 44 then return A.Fireblood:Show(icon)         end
 
        if A.Berserking:IsReady(unitID, true) and inMelee and Player:Energy() < 44 then return A.Berserking:Show(icon)         end
            

        if A.BloodFury:IsReady(unitID, true) and inMelee and Player:Energy() < 44 then             return A.BloodFury:Show(icon)         end


        if A.LightsJudgment:IsReady(unitID) and Player:Energy() < 44 then
            return A.LightsJudgment:Show(icon)
        end
        if A.BagofTricks:IsReady(player) and inMelee and Player:Energy() < 44 then
            return A.BagofTricks:Show(icon)
        end
        if A.AncestralCall:IsReady(player) and inMelee and Player:Energy() < 44 then
            return A.AncestralCall:Show(icon)
        end
        end
        local function Finishers()
            --finish->add_action( this, "Between the Eyes", "if= Unit(unitID):TimeToDie() >3", "BtE on cooldown to keep the Crit debuff up, unless the target is about to die" );
            if A.BetweenTheEyes:IsReady(unitID) 
            and (Unit(unitID):TimeToDie() > 3 or Unit(unitID):IsBoss()) then
                return A.BetweenTheEyes:Show(icon)
            end
            --finish->add_action( this, "Slice and Dice", "if=buff.slice_and_dice.remains<fight_remains and refreshable" );
            if A.SliceAndDice:IsReady(player) 
            and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0 
            and Player:GetStance() <=1 
            and Unit(player):HasBuffs(A.SliceAndDice.ID) < EightYardTTD
            and Unit(player):HasBuffs(A.SliceAndDice.ID) <= (1.8 + (Player:ComboPoints()) * 1.8)
            then
                return A.SliceAndDice:Show(icon)
            end
            --finish->add_action( this, "Dispatch" );
            if A.Dispatch:IsReady(unitID) then
                return A.Dispatch:Show(icon)
            end
            --evicerate is low level ability, not in loader, defined to show Dispatch icon instead
            if A.Eviscerate:IsReady(unitID) then
                return A.Eviscerate:Show(icon)
            end
            if Player:Energy() < 35 then
                return A.PoolResource:Show(icon)
            end
        end
        local function ST()
            if A.Shiv:IsReady(unitID) and A.TinyToxicBlade:HasLegendaryCraftingPower() and Player:ComboPointsDeficit() >= 1 + extraBSCP then
                return A.Shiv:Show(icon)
            end 
            --Use Spesis Stealth buff on Ambush, Pool energy for Ambush
            if Unit(player):HasBuffs(A.SepsisStealth.ID) ~= 0 and inMelee and Player:ComboPointsDeficit() >= 1 then
                if A.Ambush:IsReadyByPassCastGCD(unitID) then
                    return A.Ambush:Show(icon)
                end
                --pool energy for Ambush with Sepsis Buff
                if Player:Energy() <= 51 then
                    return A.PoolResource:Show(icon)
                end
            end
            --SBS (also in CDs)
            if BoneSpike()
                then return true
            end
            --build->add_action( this, "Pistol Shot", "if=buff.opportunity.up&(energy.deficit>(energy.regen+10)|combo_points.deficit<=1+buff.broadside.up|talent.quick_draw.enabled)", "Use Pistol Shot with Opportunity if Combat Potency won't overcap energy, when it will exactly cap CP, or when using Quick Draw" );
            --build->add_action( this, "Pistol Shot", "if=buff.opportunity.up&(buff.greenskins_wickers.up|buff.concealed_blunderbuss.up)" );
            if A.PistolShot:IsReady(unitID) and Unit(player):HasBuffs(A.Opportunity.ID) ~= 0 and not A.Ambush:IsReady(unitID) and
                ((Player:EnergyDeficit() > (Player:EnergyRegen()+10) or Player:ComboPointsDeficit()<=1+extraBSCP or A.QuickDraw:IsTalentLearned()) --"Use Pistol Shot with Opportunity if Combat Potency won't overcap energy, when it will exactly cap CP, or when using Quick Draw" );
                or
                (Unit(player):HasBuffs(A.GreenskinsWickers.ID) ~= 0 or Unit(player):HasBuffs(A.ConcealedBlunderbuss.ID) ~= 0)) -- Use Pistol Shot with Opp proc and PS legendaries
                then
                    return A.PistolShot:Show(icon)
            end
            -- I ran some sims changing the PS logic to include Non Opportunity PS and it was always a DPS loss
            --build->add_action( this, "Sinister Strike" );
            if A.SinisterStrike:IsReady(unitID) and Player:ComboPointsDeficit() > 0  then
                return A.SinisterStrike:Show(icon)
            end
            --build->add_action( this, "Gouge", "if=talent.dirty_tricks.enabled&combo_points.deficit>=1+buff.broadside.up" );
            --Gogue is a free builder with Dirty Tricks learned
            if A.Gouge:IsReady(unitID) 
            and A.DirtyTricks:IsTalentLearned() 
            and (Player:ComboPointsDeficit() >= 1 + extraBSCP) 
            and A.Gouge:AbsentImun(unitID, Temp.TotalAndPhysAndCC) 
            and Player:IsBehind(.3) and Unit(unitID):GetDR("incapacitate") > 0 
            and not Unit(unitID):IsBoss()
            and not (IsNotCCAble[npc_id])
            and GetToggle(2, "offensiveGouge")
            then
                return A.Gouge:Show(icon)
            end
            --In combat ranged GCD filler
            if A.PistolShot:IsReady(unitID) and Player:Energy() >=90 and Unit(unitID):HealthPercent() < 100 and not inMelee then
                return A.PistolShot:Show(icon)
            end
        end
------------------------------------------
--Functional Rotation Calls             --
------------------------------------------
        --Master Assassian Rotation during MA
        if A.MarkoftheMasterAssassin:HasLegendaryCraftingPower() and A.KillingSpree:IsTalentLearned() and A.Vanish:GetCooldown() >= 103 and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) ~= 0 and MasterAss() then
			return true
		end
		--INTERRUPTS
        if Interrupts() then return true end
        --DEFENSIVES
        if Defensives() then return true end
        --stop DPS on sylvanas immune
        if Unit(unitID):HasBuffs(350857) > 0 then return false end
        -- OPENER
        if (Player:IsStealthed() or LastPlayerCastID == A.Vanish.ID or LastPlayerCastID == A.Stealth.ID) and not inCombat and GetToggle(2, "Opener") ~= "OFF" and Opener() then return true end
        --StealthCDs allow for in combat stealth CDs (RtB, MfD, and Ambush) but if vanish lasts so long you gain the stealth buff, we will just reopen instead which will also use stealth CDs based on user Opener Settings
        if (Player:IsStealthed() or LastPlayerCastID == A.Vanish.ID or LastPlayerCastID == A.Stealth.ID) and inCombat and StealthCDs() then return true end
        if not Player:IsStealthed() and LastPlayerCastID ~= A.Vanish.ID and LastPlayerCastID ~= A.Stealth.ID then
            -- CDs
            if CDs() then return true end
            -- FINISHERS
            if finish_condition and Finishers() then return true end
            --Single Target
            if ST() then return true end
            -- GiftofNaaru
            if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then
                return A.GiftofNaaru:Show(icon)
            end
            if ReTabTarget() then return A:Show(icon, ACTION_CONST_AUTOTARGET) end -- if there is nothing to do, and a target we are in combat with is in melee, tab target
        end
    end -- end of EnemyRotation()
------------------------------------------
--OOC Actions                           --
------------------------------------------
    --Use BottledFlayedwingToxin if out of combat with other poisons. before stealth
    if A.BottledFlayedwingToxin:IsReady(player, true) and Unit(player):HasBuffs(A.FlayedwingToxin.ID) == 0 and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then
        return A.BottledFlayedwingToxin:Show(icon)
    end
	--Summon Steward
	if A.SummonSteward:IsReady(player) and GetItemCount(177278) < 1 and Player:GetStance() == 0  and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
		return A.SummonSteward:Show(icon)
	end
    --Attempt to stop recasts of stealth/poisons by waiting for 4 times ping after a cast is over
    if  Player:IsCasting() then
        Temp.CastStartTime[1] = TMW.time
    elseif TMW.time - (Temp.CastStartTime[1] or 0) < (4*A.GetPing()) then
        return true
    end
    --OOC Stealth
    if GetToggle(2, "OOCStealth") and A.Stealth:IsReady(player, true) and not IsResting() and  Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
        return A.Stealth:Show(icon)
    end
    --Poisons use UI settings to check if poison selected is ready, already applied and ooc
    if Unit(player):CombatTime() == 0 and not IsMounted() and not Player:IsMoving() then
        if GetToggle(2, "LethalPoison") == "InstantPoison" then
            if A.InstantPoison:IsReady(player, true) and Unit(player):HasBuffs(A.InstantPoison.ID) == 0  then
                return A.InstantPoison:Show(icon)
            end
        else
            if A.WoundPoison:IsReady(player, true) and Unit(player):HasBuffs(A.WoundPoison.ID) == 0  then
                return A.WoundPoison:Show(icon)
            end
        end
        if GetToggle(2, "NonLethalPoison") == "NumbingPoison" then
            if A.NumbingPoison:IsReady(player, true) and Unit(player):HasBuffs(A.NumbingPoison.ID) == 0 then
                return A.NumbingPoison:Show(icon)
            end
        else
            if A.CripplingPoison:IsReady(player, true) and Unit(player):HasBuffs(A.CripplingPoison.ID) == 0 then
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