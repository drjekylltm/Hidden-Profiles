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
	Premeditation = Create({ Type = "Spell", ID = 343160, isTalent = true}),
	Gloomblade = Create({ Type = "Spell", ID = 200758, isTalent = true}),
	Subterfuge = Create({ Type = "Spell", ID = 108208, isTalent = true}),
	SecretTechnique = Create({ Type = "Spell", ID = 280719, isTalent = true}), 
	ShurikenTornado = Create({ Type = "Spell", ID = 277925, isTalent = true}),
	Nightstalker = Create({ Type = "Spell", ID = 14062, isTalent = true, Hidden = true}),
	DarkShadow = Create({ Type = "Spell", ID = 245687, isTalent = true, Hidden = true}),
    ShadowFocus = Create({ Type = "Spell", ID = 108209, isTalent = true, Hidden = true}),
	EnvelopingShadows = Create({ Type = "Spell", ID = 238104, isTalent = true, Hidden = true}),
    Vigor = Create({ Type = "Spell", ID = 14983, isTalent = true, Hidden = true}),
    MasterOfTheShadows = Create({ Type = "Spell", ID = 196976, isTalent = true, Hidden = true}),
    Alacrity = Create({ Type = "Spell", ID = 193538, isTalent = true, Hidden = true}),
    ShotInTheDark = Create({ Type = "Spell", ID = 257505, isTalent = true, Hidden = true}),
    Weaponmaster = Create({ Type = "Spell", ID = 193537, isTalent = true }),


    -- general
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
    ClaimFlagellation = Create({ Type = "Spell", ID = 346975, Hidden = true}),
	--PhialofSerenity = Create({ Type = "Spell", ID = 177278}),
	SummonSteward = Create({ Type = "Spell", ID = 324739}), 
	--Conduits
    PerforatedVeins = Create({ Type = "Spell", ID = 341572, Hidden = true}), --Conduit gives stacking buff
    LeadByExample = Create({ Type = "Spell", ID = 342156, Hidden = true}), 
    --Legendary
    TinyToxicBlade = Create({ Type = "Spell", ID = 340078, Hidden = true}),
	MarkoftheMasterAssassin = Create({ Type = "Spell", ID = 340076, Hidden = true}),
    Finality = Create({ Type = "Spell", ID = 340089, Hidden = true}),
    AkaarisSoulFragment = Create({ Type = "Spell", ID = 340090, Hidden = true}),
    ResoundingClarity = Create({ Type = "Spell", ID = 354837, Hidden = true}),
    Obedience = Create({ Type = "Spell", ID = 354703, Hidden = true}),
    DeathlyShadows = Create({ Type = "Spell", ID = 340092,Hidden = true}),
    --Buffs
    SliceAndDice = Create({ Type = "Spell", ID = 145418}),
    DeeperStratagem = Create({ Type = "Spell", ID = 193531}),
    MarkedForDeath = Create({ Type = "Spell", ID = 137619}),
    FlayedwingToxin = Create({ Type = "Spell", ID = 345545, Hidden = true}),
    Soulshape = Create({ Type = "Spell", ID = 310143}),
    Vanish = Create({ Type = "Spell", ID = 1856}),
    VanishStealth = Create({ Type = "Spell", ID = 11327, Hidden = true}),
    SepsisStealth = Create({ Type = "Spell", ID = 347037, Hidden = true}),
    Elusiveness = Create({ Type = "Spell", ID = 79008}),
    MasterAssassinsMark = Create({ Type = "Spell", ID = 340094, Hidden = true}),
	StolenShadehound = Create({ Type = "Spell", ID = 338659, Hidden = true}),
    SymbolsOfDeathCrit = Create({ Type = "Spell", ID = 227151, Hidden = true}), 
    TheRotten = Create({ Type = "Spell", ID = 341134, Hidden = true}), --Buff from legendary
    ShadowDanceBuff = Create({ Type = "Spell", ID = 185422, Hidden = true}),
    Sanguine = Create({ Type = "Spell", ID = 226510,Hidden = true}),
	Inspired = Create({ Type = "Spell", ID = 343503,Hidden = true}),
    --Debuffs
	GluttonousMiasma= Create({ Type = "Spell", ID = 329298,Hidden = true}),
    --kick
    Kick = Create({ Type = "Spell", ID = 1766}),
    KickGreen = Create({ Type = "SpellSingleColor",ID = 1766, Hidden = true,Color = "GREEN",QueueForbidden = true}),
    BlindGreen = Create({ Type = "SpellSingleColor",ID = 2094, Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    KidneyShotGreen = Create({ Type = "SpellSingleColor",ID = 408, Hidden = true,Color = "GREEN",QueueForbidden = true}), 
    CheapShotGreen = Create({ Type = "SpellSingleColor",ID = 1833, Hidden = true,Color = "GREEN",QueueForbidden = true}), 
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
	FindWeakness = Create({ Type = "Spell", ID = 316219, Hidden = true}),
    -- Items
    PotionofUnbridledFury = Create({ Type = "Potion", ID = 169299}), 
    BottledFlayedwingToxin = Create({ Type = "Trinket", ID = 178742, Hidden = true}),
    InscrutableQuantumDevice = Create({ Type = "Trinket", ID = 179350, Hidden = true}),
    ShadowGraspTotem = Create({ Type = "Trinket", ID = 179356, Hidden = true}),
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion = Create({ Type = "Trinket", ID = 161674}), 
    DreadCombatantsInsignia = Create({ Type = "Trinket", ID = 161676}), 
    DreadCombatantsMedallion = Create({ Type = "Trinket", ID = 161811, Hidden = true}), -- Game has something incorrect with displaying this
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
local function ValidKeeptarget(unitID)
-- @return boolean
--This function checks the IgnoreNameplates table for targets you should not swap to for any reason
local _, _, _, _, _, npc_id 		= Unit(unitID):InfoGUID()
if IgnoreNameplates[npc_id] == false then
    return false
else
    return true
end
end
ValidKeeptarget = A.MakeFunctionCachedStatic(ValidKeeptarget)
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
local function ReTabTarget()
    if Unit(player):CombatTime() > 0  and ValidKeeptarget("target") and MultiUnits:GetByRange(5) >= 1 and

    ((not Unit("target"):IsNameplateAny()) or (Unit("target"):GetRange() > 20))
    then 
            for val in pairs(ActiveUnitPlates) do
                if 	ValidAutotarget(val) and Unit(val):GetRange(5) and
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
    --def->add_action( "variable,name=stealth_threshold,value=25+talent.vigor.enabled*20+talent.master_of_shadows.enabled*20+talent.shadow_focus.enabled*25+talent.alacrity.enabled*20+25*(spell_targets.shuriken_storm>=4)", "Used to define when to use stealth CDs or builders" );
    local stealth_threshold =25+boolnumber(A.Vigor:IsTalentLearned())*20+boolnumber(A.MasterOfTheShadows:IsTalentLearned())*20+boolnumber(A.ShadowFocus:IsTalentLearned())*25+boolnumber(A.Alacrity:IsTalentLearned())*20+25*(boolnumber(MultiUnits:GetByRange(10) >=4))
    --def->add_action( "variable,name=use_priority_rotation,value=priority_rotation and spell_targets.shuriken_storm>=2", "Only change rotation if we have priority_rotation set and multiple targets up." );   
    local use_priority_rotation = GetToggle(2, "usePriorityRotation") and MultiUnits:GetByRange(10) >= 2
    local effective_combo_points = ((EchoingBuffMatch() and 7) or Player:ComboPoints())
    --def->add_action( "variable,name=snd_condition,value=buff.slice_and_dice.up or spell_targets.shuriken_storm>=6", "Used to determine whether cooldowns wait for SnD based on targets." );
    local snd_condition = Unit(player):HasBuffs(A.SliceAndDice.ID) ~= 0 or MultiUnits:GetByRange(10) >=6  

    -- if in Necrotic Wake instance and targetting Companion, stop rotation to allow for covenant Buff cast to finish (stealth breaks cast)
    if A.InstanceInfo.ID == 2286 and Unit("target"):Name() == "Farra" then return end
    -- Stop rotation on Torghast Containers
	if Unit("target"):Name() == "Ashen Phylactery" then return end
	--164698 or 167986 or 165533 or 165523 or 170525 or 167987 or 178523 or 179514 or

	--Testing
--



    -- Rotations 
    function EnemyRotation(unitID) 
        if not IsUnitEnemy(unitID) then return end
        if Unit(unitID):IsDead() then return end
        if Unit(unitID):HasDeBuffs("BreakAble") > 0 and Unit(player):CombatTime() == 0 then return end --Stop Rotation if Target is sapped and OOC
        if UnitCanAttack(player, unitID) == false then return end --Stop Rotation if Target can not attack back (yellow enemies)
        if Unit(player):HasBuffs(A.Vanish.ID) ~= 0 and GetToggle(2, "VanishSetting") == 0 then return end  --Stop Rotation if Vanish is set to off
        if IsMounted() then return end  --Stop Rotation if Mounted. Action has check for this but can lag after stealthing
        local isBurst = BurstIsON(unitID) -- @boolean
        local inMelee = A.Kick:IsInRange(unitID) -- @boolean
        local inCombat = Unit(player):CombatTime() > 0
        local _, _, _, _, _, npc_id 		= Unit("target"):InfoGUID() --@number npcID from wowhead/evlui, better than using strings for other languages
        --local GCDPercentage = (1- GetCurrentGCD()/GetGCD())*100 --@number % through current GCD from 0-100, used to time multiple GCDs and give time for Buffs to appear

        --testing

        --Stealth with target enemy
        if IsUnitEnemy(unitID) and A.Stealth:IsReady(unitID, true) and Player:GetStance() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
            return A.Stealth:Show(icon)
        end
        --Shiv Enrages
        if A.Shiv:IsReady(unitID) and Unit(player):HasBuffs(A.NumbingPoison.ID) ~= 0 and Action.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then
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
            local timefromtarget = ((min_range+5)/((Unit("player"):GetCurrentSpeed()+ 0.000000001) /100*7))
            return timefromtarget
        end
        TimeOnTarget = A.MakeFunctionCachedStatic(TimeOnTarget)
	    local function MFDSnipe()
			if MultiUnits:GetByRange(15) >= 2 and Player:ComboPointsDeficit() >= 4 and Unit("player"):CombatTime() > 0 and GetCurrentGCD() ~= 0 and ValidKeeptarget(unitID) then
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
            if A.MarkedForDeath:IsReady(unitID) and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned()) and (not GetToggle(1, "BossMods") or inCombat) and not Unit(unitID):IsTotem() then
                return A.MarkedForDeath:Show(icon)
            end
        end
        MFD = A.MakeFunctionCachedStatic(MFD)
        local function Interrupts()
            local inInstance = IsInAnInstance[A.InstanceInfo.ID]
	        local unitIDinterrupt = "none"
            local stopbeforechannel = true
			if IsUnitEnemy("mouseover") then
				unitIDinterrupt = "mouseover"
			elseif IsUnitEnemy("target") then
				unitIDinterrupt = "target"
			end
            local Slidermin, Slidermax = Action.InterruptGetSliders("RyanInterrupts")

            local function DetermineInterrupts(unit)
                --Return Vars used for each interrupt so logic is always the same for interrupt and autotargeting  
                local kick = castLeft > (2*A.GetPing()) and A.Kick:IsReady(unit) and not notKickAble  and A.AbsentImun(nil, unit, Temp.TotalAndPhysKick) 
                local cheapshot = castLeft > (2*A.GetPing()) and A.CheapShot:IsReady(unit)  and Unit(unit):GetDR("stun") > 0 and not Unit(unit):IsBoss() and Unit(unit):HasBuffs(A.Sanguine.ID) == 0 and A.CheapShot:AbsentImun(unit, Temp.TotalAndPhysAndCC)
                local kidneyshot = castLeft > (2*A.GetPing()) and A.KidneyShot:IsReady(unit)  and Player:ComboPoints() >= 1 and Unit(unit):GetDR("stun") > 0 and not Unit(unit):IsBoss() and Unit(unit):HasBuffs(A.Sanguine.ID) == 0 and A.KidneyShot:AbsentImun(unit, Temp.TotalAndPhysAndCC)
                local quakingpalm = castLeft > (2*A.GetPing()) and A.QuakingPalm:IsReady(unit)  and Unit(unit):GetDR("incapacitate") > 0 and not Unit(unit):IsBoss() and A.QuakingPalm:AbsentImun(unit, Temp.TotalAndPhysAndCC)
                local blind = castLeft > (2*A.GetPing()) and A.Blind:IsReady(unit)  and Unit(unit):GetDR("disorient") > 0 and not Unit(unit):IsBoss() and A.Blind:AbsentImun(unit, Temp.TotalAndPhysAndCC)
                return kick, cheapshot, kidneyshot, quakingpalm, blind
            end
            DetermineInterrupts = A.MakeFunctionCachedDynamic(DetermineInterrupts) --should be faster dynamic cached since the number of nameplates is unknown
            if A.GetToggle(2, "InterruptList") and inInstance then--uses ryan interrupt table in SL dungeons and raid instance IDs
                useKick, useCC, useRacial, notKickAble, castLeft, castDoneTime = InterruptIsValid(unitIDinterrupt, "RyanInterrupts", true)
            else
                useKick, useCC, useRacial, notKickAble, castLeft, castDoneTime = InterruptIsValid(unitIDinterrupt)
            end
            if useKick or useCC or useRacial then
                local kickCanBeUsed, cheapshotCanBeUsed, kidneyshotCanBeUsed, quakingpalmCanBeUsed, blindCanBeUsed = DetermineInterrupts(unitIDinterrupt)
                local CastTimeRemaining, Percentcast, SpellID, _ ,_ , IsChanneling = Unit(unitIDinterrupt):IsCastingRemains()
                --this is personal check for my Action install, if you're reading this and want to know why i check this DM me and i'll explain it. 
                local percenttokick = Percentcast > Slidermin
                --Var used for each interrupt so logic is always the same for interrupt and autotargeting
                --This checks the SpellID of the cast against my table to decide to wait for a channel instead of interrupting the first cast
                --useful for abilities that should be interrupted during the channel to make it go on CD instead of enemy spamming it
                if Channels[SpellID] then
                    stopbeforechannel = IsChanneling 
                 end

                -- useKick
                if useKick and percenttokick and stopbeforechannel and kickCanBeUsed then
                    return A.Kick:Show(icon)
                end
                -- useCC / useRacial
                if (not useKick or notKickAble or A.Kick:GetCooldown() > 0) and percenttokick and stopbeforechannel and Unit(unitIDinterrupt):HasBuffs(A.Inspired.ID) == 0 then
                    if useCC and cheapshotCanBeUsed then
                        return A.CheapShot:Show(icon)
                    elseif useCC and kidneyshotCanBeUsed then
                        return A.KidneyShot:Show(icon)
                    elseif useRacial and quakingpalmCanBeUsed then
                        return A.QuakingPalm:Show(icon)
                    elseif useCC and blindCanBeUsed then
                        return A.Blind:Show(icon)
                    end
                end
            end
			--Auto Targeting Interrupts
			if Action.GetToggle(1, "AutoTarget") and A.GetToggle(2, "ATInterrupt") and ((not useKick and not useCC and not useRacial) or not inMelee) and ValidKeeptarget(unitID) and GetCurrentGCD() ~= 0 then  -- and Unit("player"):CombatTime() > 0 i dont think i care if we are in combat for interrupt auto targeting
                -- removed and inAoE check from above since its possible target is far and nameplate is in melee, i only need one nameplate in melee to check for kicks
                for val in pairs(ActiveUnitPlates) do
                    if A.GetToggle(2, "InterruptList") and inInstance then--uses ryan interrupt table in SL dungeons and raid instance IDs
                        useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val, "RyanInterrupts", true)
                    else
                        useKick, useCC, useRacial, notKickAble, castLeft = InterruptIsValid(val)
                    end
                    local CastTimeRemaining, Percentcast, SpellID, _ ,_ , IsChanneling = Unit(val):IsCastingRemains()
                    --this is personal check for my Action install, if you're reading this and want to know why i check this DM me and i'll explain it. 
                    local percenttokick = Percentcast > Slidermin
                    --redfine interrupts for each nameplate
                    local kickCanBeUsed, cheapshotCanBeUsed, kidneyshotCanBeUsed, quakingpalmCanBeUsed, blindCanBeUsed = DetermineInterrupts(val)
                    if percenttokick and Unit(val):HasBuffs(A.Inspired.ID) == 0 and ValidAutotarget(val)
                        and ((UnitCanAttack("player", val) and A.Kick:IsInRange(val) and not Unit(val):IsTotem()) or Unit(val):IsDummy()) 
                        and ((useKick and kickCanBeUsed)
                            or (useCC and cheapshotCanBeUsed)
                            or (useCC and kidneyshotCanBeUsed)
                            or (useRacial and quakingpalmCanBeUsed)
                            or (useCC and blindCanBeUsed))
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

            local function CDs()
                local Item = UseItems(unitID)
                if Item and inMelee  and (Unit(player):HasBuffs(A.SymbolsOfDeath.ID, false, true) ~= 0 or Unit(unitID):TimeToDie() <20) then --prevent all items in stealth and save them for Symbols windows
                    return Item:Show(icon)
                end
                --cds->add_action( this, "Shadow Dance", "use_off_gcd=1,if= not buff.shadow_dance.up and buff.shuriken_tornado.up and buff.shuriken_tornado.remains<=3.5", "Use Dance off-gcd before the first Shuriken Storm from Tornado comes in." );
                if A.ShadowDance:IsReady(player)
                and inMelee
                and (Unit(unitID):TimeToDie() > 8 or Unit(unitID):IsBoss())
                and
                (
                    Unit(player):HasBuffs(A.ShadowDanceBuff.ID) == 0 
                and Unit(player):HasBuffs(A.ShurikenTornado.ID) ~= 0 
                and Unit(player):HasBuffs(A.ShurikenTornado.ID) <=3.5
                )
                then
                    return A.ShadowDance:Show(icon)
                end
                --cds->add_action( this, "Symbols of Death", "use_off_gcd=1,if=buff.shuriken_tornado.up and buff.shuriken_tornado.remains<=3.5", "(Unless already up because we took Shadow Focus) use Symbols off-gcd before the first Shuriken Storm from Tornado comes in." );
                if A.SymbolsOfDeath:IsReady(player)
                and inMelee 
                and (Unit(unitID):TimeToDie() > 10 or Unit(unitID):IsBoss())
                --and inCombat
                and 
                (
                    Unit(player):HasBuffs(A.ShurikenTornado.ID) ~= 0 and Unit(player):HasBuffs(A.ShurikenTornado.ID) <=3.5
                )
                then
                    return A.SymbolsOfDeath:Show(icon)
                end
                --cds->add_action( "flagellation,if=variable.snd_condition and  not stealthed.mantle and buff.symbols_of_death.up and combo_points>=5" );
                --"not stealthed.mantle" in the SIMC APL, means not staelthed or vanished (buffs that give MA)
                if A.Flagellation:IsReady(unitID)
                and
                (
                snd_condition 
                and (Unit(player):HasBuffs(A.Stealth.ID) == 0 and Unit(player):HasBuffs(A.VanishStealth.ID) == 0)
                and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0
                and Player:ComboPoints() >= 5
                )
                then
                    return A.Flagellation:Show(icon)
                end
                --cds->add_action( this, "Vanish", "if=(runeforge.mark_of_the_master_assassin and combo_points.deficit<=1-talent.deeper_strategem.enabled or runeforge.deathly_shadows and combo_points<1) and buff.symbols_of_death.up and buff.shadow_dance.up and master_assassin_remains=0 and buff.deathly_shadows.down" );
                if A.Vanish:IsReady(player)
                and GetToggle(2, "VanishSetting") == 2 
                and inMelee 
                and inCombat
                and
                (
                    (A.MarkoftheMasterAssassin:HasLegendaryCraftingPower() and Player:ComboPointsDeficit() <= 1 - boolnumber(A.DeeperStratagem:IsTalentLearned()) or A.DeathlyShadows:HasLegendaryCraftingPower() and Player:ComboPoints() < 1) 
                    and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0  
                    and Unit(player):HasBuffs(A.ShadowDanceBuff.ID) ~= 0 
                    and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) == 0 
                    and Unit(player):HasBuffs(A.DeathlyShadows.ID) == 0
                )
                then
                    return A.Vanish:Show(icon)
                end
                --cds->add_action( "pool_resource,for_next=1,if=", "Pool for Tornado pre-SoD with ShD ready when not running SF." );
                --cds->add_talent( this, "Shuriken Tornado", "if=energy>=60 and variable.snd_condition and cooldown.symbols_of_death.up and cooldown.shadow_dance.charges>=1 and ( not runeforge.obedience or debuff.flagellation.up) and combo_points<=2 and ( not buff.premeditation.up or spell_targets.shuriken_storm>4)", "Use Tornado pre SoD when we have the energy whether from pooling without SF or just generally." );
                if A.ShurikenTornado:IsTalentLearned()
                    and GetToggle(2, "AoE")
                    and
                    (
                    snd_condition 
                    and A.SymbolsOfDeath:IsReady(player) 
                    and A.ShadowDance:GetSpellChargesFrac() >=1 
                    and (not A.Obedience:HasLegendaryCraftingPower() or Unit(unitID):HasDebuffs(A.Flagellation.ID, true) ~= 0) 
                    and Player:ComboPoints() <= 2 
                    and (Unit(player):HasBuffs(A.Premeditation.ID) ~= 0 or MultiUnits:GetByRange(10) > 4)
                    )
                    then
                        if Player:Energy() < 60 
                        and not A.ShadowFocus:IsTalentLearned()
                            then 
                                return A.PoolResource:Show(icon)
                        end
                        if A.ShurikenTornado:IsReady(unitID)
                        then
                            return A.ShurikenTornado:Show(icon)
                        end
                end
                --TODO this was taken from old sub rotation, if there are still errors review here first
                --cds->add_action( "serrated_bone_spike,cycle_targets=1,if=variable.snd_condition and  not dot.serrated_bone_spike_dot.ticking and target.time_to_die>=21 or fight_remains<=5 and spell_targets.shuriken_storm<3" );
                if A.SerratedBoneSpike:IsReady(unitID) and inCombat
                and (UnitThreatSituation("player", unitID) ~= nil or Unit(unitID):IsDummy()) -- player is on the threat table somewhere (in combat with)
                    then
                        --Bonepsike target missing buff
                        if (SNDCondition and Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0 and  Unit(unitID):TimeToDie() >=21 and not UnitCooldown:IsSpellInFly("player", A.SerratedBoneSpike.ID)) 
                        or  
                        (Unit(unitID):TimeToDie() <=5 and MultiUnits:GetByRange(10) <3) 
                            then
                                return A.SerratedBoneSpike:Show(icon)
                            end
                            --Bone Spike Targeting
                            if Unit(unitID):HasDeBuffs(A.SerratedBoneSpike.ID, true) ~= 0  -- if target has SBS
                            and Action.GetToggle(1, "AutoTarget")  --AutoTargetting is Enabled
                            --and Action.GetToggle(2, "SBSTarget")  --SBS Targeting is enabled not currently implemented in Sub UI, may not implement ever
                            and ValidKeeptarget(unitID) --Target is something we can swap off
                            and MultiUnits:GetByRange(15) >= 2 --There are 2 targets in Range
                            then
                                for val in pairs(ActiveUnitPlates) do
                                    if ((SNDCondition and Unit(val):HasDeBuffs(A.SerratedBoneSpike.ID, true) == 0 and  Unit(val):TimeToDie() >=21 and not UnitCooldown:IsSpellInFly("player", A.SerratedBoneSpike.ID)) 
                                    or  
                                    (Unit(val):TimeToDie() <=5 and MultiUnits:GetByRange(10) <3))
                                    and ValidAutotarget(val)
                                    and
                                    ((UnitCanAttack("player", val) and Unit(val):GetRange() <=15  and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --We have threat or it is a dummy        
                                    then
                                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                                    end
                                end
                    end
                end
                --cds->add_action( "sepsis,if=variable.snd_condition and combo_points.deficit>=1" );
                if A.Sepsis:IsReady(unitID) 
                and
                (
                snd_condition and Player:ComboPointsDeficit() >= 1
                )
                then
                    return A.Sepsis:Show(icon)
                end	 
                --cds->add_action( this, "Symbols of Death", "if=variable.snd_condition and (talent.enveloping_shadows.enabled or cooldown.shadow_dance.charges>=1) and ( not talent.shuriken_tornado.enabled or talent.shadow_focus.enabled or cooldown.shuriken_tornado.remains>2) and ( not covenant.venthyr or cooldown.flagellation.remains>10 or cooldown.flagellation.up and combo_points>=5)", "Use Symbols on cooldown (after first SnD) unless we are going to pop Tornado and do not have Shadow Focus." );
                if A.SymbolsOfDeath:IsReady(player)
                and (Unit(unitID):TimeToDie() > 10 or Unit(unitID):IsBoss())
                and inMelee
               and
               (
                snd_condition 
                and (A.EnvelopingShadows:IsTalentLearned() or A.ShadowDance:GetSpellChargesFrac() >=1) 
                and (not A.ShurikenTornado:IsTalentLearned() or A.ShadowFocus:IsTalentLearned() or A.ShurikenTornado:GetCooldown()>2) 
                and (Player:GetCovenant() ~= 2 or A.Flagellation:GetCooldown() > 10 or A.Flagellation:IsReady(unitID) and Player:ComboPoints()>=5)
               )
                then
                    return A.SymbolsOfDeath:Show(icon)
                end
                --cds->add_talent( this, "Marked for Death", "line_cd=1.5,target_if=min:target.time_to_die,if=raid_event.adds.up and (target.time_to_die<combo_points.deficit or  not stealthed.all and combo_points.deficit>=cp_max_spend)", "If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or not stealthed without any CP." );
                --cds->add_talent( this, "Marked for Death", "if=raid_event.adds.in>30-raid_event.adds.duration and combo_points.deficit>=cp_max_spend", "If no adds will die within the next 30s, use MfD on boss without any CP." );
                if MFD()
                    then return true
                end
                --cds->add_action( this, "Shadow Blades", "if=variable.snd_condition and combo_points.deficit>=2 and (cooldown.symbols_of_death.remains<1 or buff.symbols_of_death.up or fight_remains<=20)" );
                if A.ShadowBlades:IsReady(player)
                and inMelee
                and
                (
                    snd_condition 
                    and Player:ComboPointsDeficit() >= 2 
                    and (A.SymbolsOfDeath:GetCooldown() < 1 or Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 or Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() >= 21)
                )
                then
                    return A.ShadowBlades:Show(icon)
                end
                --cds->add_action( "echoing_reprimand,if=variable.snd_condition and combo_points.deficit>=2 and (variable.use_priority_rotation or spell_targets.shuriken_storm<=4 or runeforge.resounding_clarity)" );
                if A.EchoingReprimand:IsReady(unitID) 
                and
                (
                    snd_condition 
                    and Player:ComboPointsDeficit() >= 2 
                    and (use_priority_rotation or MultiUnits:GetByRange(10) <= 4 or A.ResoundingClarity:HasLegendaryCraftingPower())
                )
                then
                    return A.EchoingReprimand:Show(icon)
                end
                --cds->add_talent( this, "Shuriken Tornado", "if=talent.shadow_focus.enabled and variable.snd_condition and buff.symbols_of_death.up and combo_points<=2 and ( not buff.premeditation.up or spell_targets.shuriken_storm>4)", "With SF, if not already done, use Tornado with SoD up." );
                if A.ShurikenTornado:IsReady(unitID)
                and GetToggle(2, "AoE")
                and
                (
                A.ShadowFocus:IsTalentLearned() 
                and snd_condition 
                and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 
                and Player:ComboPoints() <= 2 
                and (Unit(player):HasBuffs(A.Premeditation.ID) == 0 or MultiUnits:GetByRange(10) > 4)
                )
                then
                    return A.ShurikenTornado:Show(icon)
                end
                --cds->add_action( this, "Shadow Dance", "if= not buff.shadow_dance.up and fight_remains<=8+talent.subterfuge.enabled" );
                if A.ShadowDance:IsReady(player)
                and inMelee
                and (Unit(unitID):TimeToDie() > 8 or Unit(unitID):IsBoss())
                and
                (
                    Unit(player):HasBuffs(A.ShadowDanceBuff.ID) == 0 and Unit(unitID):TimeToDie() <= 8 + boolnumber(A.Subterfuge:IsTalentLearned())
                )
                then
                    return A.ShadowDance:Show(icon)
                end
                --I dont support Fleshcraft yet, but if i did, this is where it would go
                --cds->add_action( "fleshcraft,if=(soulbind.pustule_eruption or soulbind.volatile_solvent) and energy.deficit>=30 and  not stealthed.all and buff.symbols_of_death.down" );
                --I dont support Potions yet, but if i did, this is where it would go
                --cds->add_action( potion_action );
                --cds->add_action( "blood_fury,if=buff.symbols_of_death.up" );
                if A.BloodFury:IsReady(unitID, true) and inMelee and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 then
                    return A.BloodFury:Show(icon)
                end
                --cds->add_action( "berserking,if=buff.symbols_of_death.up" );
                if A.Berserking:IsReady(unitID, true) and inMelee and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 then
                    return A.Berserking:Show(icon)
                end
                --cds->add_action( "fireblood,if=buff.symbols_of_death.up" );
                if A.Fireblood:IsReady(unitID, true) and inMelee and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 then
                    return A.Fireblood:Show(icon)
                end
                --cds->add_action( "ancestral_call,if=buff.symbols_of_death.up" );
                if A.AncestralCall:IsReady(player) and inMelee and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) ~= 0 then 
                    return A.AncestralCall:Show(icon)
                end 
                --cds->add_action( "use_items,if=buff.symbols_of_death.up or fight_remains<20", "Default fallback for usable items: Use with Symbols of Death." );
            end

            local function StealthCooldowns()
                local shd_combo_points 
                --stealth_cds->add_action( "variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=1.75", "Helper Variable" );
                local shd_threshold = A.ShadowDance:GetSpellChargesFrac() >= 1.75




                
                --stealth_cds->add_action( this, "Vanish", "if=( not variable.shd_threshold or  not talent.nightstalker.enabled and talent.dark_shadow.enabled) and combo_points.deficit>1 and  not runeforge.mark_of_the_master_assassin", "Vanish if we are capping on Dance charges. Early before first dance if we have no Nightstalker but Dark Shadow in order to get Rupture up (no Master Assassin)." );
                    if A.Vanish:IsReady(player)
                    and
                    (
                        (not shd_threshold or not A.Nightstalker:IsTalentLearned() and A.DarkShadow:IsTalentLearned()) 
                        and Player:ComboPointsDeficit() > 1 
                        and not A.MarkoftheMasterAssassin:HasLegendaryCraftingPower()
                    )
                    then
                        return A.Vanish:Show(icon)
                    end
                
                --I refuse to make Shadowmeld work for less than $1000USD
                --stealth_cds->add_action( "pool_resource,for_next=1,extra_amount=40,if=race.night_elf", "Pool for Shadowmeld + Shadowstrike unless we are about to cap on Dance charges. Only when Find Weakness is about to run out." );
                --stealth_cds->add_action( "shadowmeld,if=energy>=40 and energy.deficit>=10 and  not variable.shd_threshold and combo_points.deficit>1 and debuff.find_weakness.remains<1" );

                --stealth_cds->add_action( "variable,name=shd_combo_points,value=combo_points.deficit>=2+buff.shadow_blades.up", "CP thresholds for entering Shadow Dance" );
                shd_combo_points = Player:ComboPointsDeficit() >= 2 + boolnumber(Unit(player):HasBuffs(A.ShadowBlades.ID) ~= 0)
                --stealth_cds->add_action( "variable,name=shd_combo_points,value=combo_points.deficit>=3,if=covenant.kyrian" );                
                if Player:GetCovenant() == 1 then shd_combo_points = Player:ComboPointsDeficit() >= 3 end
                --stealth_cds->add_action( "variable,name=shd_combo_points,value=combo_points.deficit<=1,if=variable.use_priority_rotation and spell_targets.shuriken_storm>=4" );
                if use_priority_rotation and MultiUnits:GetByRange(10) >= 4 then shd_combo_points = Player:ComboPointsDeficit() <= 1 end
                --stealth_cds->add_action( this, "Shadow Dance", "if=variable.shd_combo_points and (variable.shd_threshold or buff.symbols_of_death.remains>=1.2 or spell_targets.shuriken_storm>=4 and cooldown.symbols_of_death.remains>10)", "Dance during Symbols or above threshold." );
                
                
                if A.ShadowDance:IsReady(player)
                and inMelee
                and (Unit(unitID):TimeToDie() > 8 or Unit(unitID):IsBoss())
                and
                (
                    shd_combo_points 
                    and 
                    (
                        (shd_threshold and Unit(player):CombatTime() >= .8 ) 
                    or Unit(player):HasBuffs(A.SymbolsOfDeath.ID) >=1.2 
                    or MultiUnits:GetByRange(10) >= 4 and A.SymbolsOfDeath:GetCooldown() > 10)
                )
                then
                    return A.ShadowDance:Show(icon)
                end


                --TODO this logic may suck in a m+ since simc APL is assuming raid fights probably need to add isboss checks and TTD checks
                --stealth_cds->add_action( this, "Shadow Dance", "if=variable.shd_combo_points and fight_remains<cooldown.symbols_of_death.remains", "Burn remaining Dances before the fight ends if SoD won't be ready in time." );
                if A.ShadowDance:IsReady(player) 
                and (Unit(unitID):TimeToDie() > 8 or Unit(unitID):IsBoss())
                and inMelee
                and
                (shd_combo_points and Unit(unitID):TimeToDie() < A.SymbolsOfDeath:GetCooldown())
                then 
                    return A.ShadowDance:Show(icon)
                end
            end
        
            local function Opener()
        local ignoretimers = (BossMods:HasAnyAddon()~=true) or (BossMods:HasAnyAddon()==true and not GetToggle(1, "BossMods")) -- logic for bossmods toggle returns true if no boss mods installed, need extra hasanyaddon check
        if A.MarkedForDeath:IsReady(unitID) and not Unit(unitID):IsTotem() and Player:ComboPointsDeficit() >=4 + boolnumber(A.DeeperStratagem:IsTalentLearned())
        and ((ignoretimers and TimeOnTarget() <= 2.5) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 7*GetGCD()))
        then
            return A.MarkedForDeath:Show(icon)
        end

        if A.SliceAndDice:IsReady(unitID, true) and Unit(player):HasBuffs(A.SliceAndDice.ID) <= 9 and Player:ComboPoints() >= 5
        and ((ignoretimers and TimeOnTarget() <= 2) or (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 1.1))
        then
            return A.SliceAndDice:Show(icon)
        end

        if A.ShadowBlades:IsReady(unitID) 
        and inMelee
        and isBurst 
        and A.MarkoftheMasterAssassin:HasLegendaryCraftingPower() 
        and (ignoretimers or inCombat or BossMods:IsEngage())
        --and GCDPercentage >= 40
        then
            return A.ShadowBlades:Show(icon)
        end

        -- Tricks with boss mods
        if A.TricksOfTheTrade:IsReady("focus") and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 2.5) then
            return A.TricksOfTheTrade:Show(icon)
        end
        if A.ShroudOfConcealment:IsReady(player) and IsInRaid() and (BossMods:GetPullTimer() > .1 and BossMods:GetPullTimer() <= 6) then
            return A.ShroudOfConcealment:Show(icon)
        end
            end

            local function Finishers()
            --finish->add_action( "variable,name=premed_snd_condition,value=talent.premeditation.enabled and spell_targets.shuriken_storm<(5-covenant.necrolord) and  not covenant.kyrian", "While using Premeditation, avoid casting Slice and Dice when Shadow Dance is soon to be used, except for Kyrian" )
            local premed_snd_condition = 
            (
            A.Premeditation:IsTalentLearned()
            and MultiUnits:GetByRange(10) < (5-boolnumber(Player:GetCovenant()==4)) 
            and  Player:GetCovenant() ~= 1
            )
            --finish->add_action( this, "Slice and Dice", "if= not variable.premed_snd_condition and spell_targets.shuriken_storm<6 and  not buff.shadow_dance.up and buff.slice_and_dice.remains<fight_remains and refreshable" );
            if A.SliceAndDice:IsReady(player) 
            and inMelee
            and
            (
            not premed_snd_condition 
            and MultiUnits:GetByRange(10) < 6 
            and Unit(player):HasBuffs(A.ShadowDance.ID) == 0
            and Unit(player):HasBuffs(A.SliceAndDice.ID) < Unit(unitID):TimeToDie() 
            and Unit(player):PT(A.SliceAndDice.ID)
            ) then
                return A.SliceAndDice:Show(icon)
            end
            --finish->add_action( this, "Slice and Dice", "if=variable.premed_snd_condition and cooldown.shadow_dance.charges_fractional<1.75 and buff.slice_and_dice.remains<cooldown.symbols_of_death.remains and (cooldown.shadow_dance.ready and buff.symbols_of_death.remains-buff.shadow_dance.remains<1.2)" );
            if A.SliceAndDice:IsReady(player) 
            and inMelee
            and
            (
            premed_snd_condition 
            and A.ShadowDance:GetSpellChargesFrac() < 1.75 
            and Unit(player):HasBuffs(A.SliceAndDice.ID) < A.SymbolsOfDeath:GetCooldown() 
            and (A.ShadowDance:IsReady(player)
            and Unit(player):HasBuffs(A.SymbolsOfDeath.ID) - Unit(player):HasBuffs(A.ShadowDance.ID) < 1.2)
            ) then
                return A.SliceAndDice:Show(icon)
            end
            --finish->add_action( "variable,name=skip_rupture,value=master_assassin_remains>0 or  not talent.nightstalker.enabled and talent.dark_shadow.enabled and buff.shadow_dance.up or spell_targets.shuriken_storm>=(5-runeforge.finality)", "Helper Variable for Rupture. Skip during Master Assassin or during Dance with Dark and no Nightstalker." );
            local skip_rupture = 
            (Unit(player):HasBuffs(A.MasterAssassinsMark.ID) ~= 0 
            or  not A.Nightstalker:IsTalentLearned() 
            and A.DarkShadow:IsTalentLearned()
            and Unit(player):HasBuffs(A.ShadowDance.ID) ~= 0 
            or MultiUnits:GetByRange(10) >= (5-boolnumber(A.Finality:HasLegendaryCraftingPower())))

            --finish->add_action( this, "Rupture", "if=( not variable.skip_rupture or variable.use_priority_rotation) and target.time_to_die-remains>6 and refreshable", "Keep up Rupture if it is about to run out." );
            if A.Rupture:IsReady(unitID) and
            (
            (not skip_rupture or use_priority_rotation) 
            and Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > 6 
            and Unit(unitID):PT(A.Rupture.ID, true)
            ) then
                return A.Rupture:Show(icon)
            end
            --finish->add_talent( this, "Secret Technique" );
            if A.SecretTechnique:IsReady(unitID) then
                return A.SecretTechnique:Show(icon)
            end

            --TODO if there are problems this is old code review first for bugs
            if A.Rupture:IsReady(unitID) 
            and not skip_rupture
            and Unit(unitID):PT(A.Rupture.ID, true) -- current unit is not in Pandemic window
            and Action.GetToggle(1, "AutoTarget") 
            and Unit(player):CombatTime() > .8 
            and GetCurrentGCD() ~= 0 --prevent rotation from getting completlely stuck
            and ValidKeeptarget(unitID) --Target is something we swap off of
			then
				for val in pairs(ActiveUnitPlates) do
					if 	Unit(val):PT(A.Rupture.ID, true) --Checks Pandemic Threshold based on DOT duration
                        and Unit(val):TimeToDie() > (5+(2*Player:ComboPoints())) -- nameplate will live long enough
                        and A.Kick:IsInRange(val) -- in range
                        and ValidAutotarget(val) --Valid for auto targeting
						and	(( UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --in combat with nameplate or comabt dummy 
                        then
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
					end
				end
			end
            --finish->add_action( this, "Rupture", "if= not variable.skip_rupture and remains<cooldown.symbols_of_death.remains+10 and cooldown.symbols_of_death.remains<=5 and target.time_to_die-remains>cooldown.symbols_of_death.remains+5", "Refresh Rupture early if it will expire during Symbols. Do that refresh if SoD gets ready in the next 5s." );
            if A.Rupture:IsReady(unitID) and
            (
            not skip_rupture 
            and Unit(unitID):HasDeBuffs(A.Rupture.ID, true) < A.SymbolsOfDeath:GetCooldown() +10 
            and A.SymbolsOfDeath:GetCooldown() <= 5 
            and Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.Rupture.ID, true) > A.SymbolsOfDeath:GetCooldown() + 5
            ) then
                return A.Rupture:Show(icon)
            end
            --finish->add_action( this, "Black Powder", "if= not variable.use_priority_rotation and spell_targets>=3" );
            if A.BlackPowder:IsReady(unitID) 
            and GetToggle(2, "AoE")
            and
                (
                not use_priority_rotation 
                and MultiUnits:GetByRange(10) >= 3
                ) then
                    return A.BlackPowder:Show(icon)
                end
            --finish->add_action( this, "Eviscerate" );
            if A.Eviscerate:IsReady(unitID)
                then return A.Eviscerate:Show(icon)
            end
            end

            local function StealthedRotation()
                --stealthed->add_action( this, "Shadowstrike", "if=(buff.stealth.up or buff.vanish.up) and master_assassin_remains=0", "If Stealth/vanish are up, use Shadowstrike to benefit from the passive bonus and Find Weakness, even if we are at max CP (unless using Master Assassin)" );
                if A.Shadowstrike:IsReady(unitID)
                and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                and
                ((Unit(player):HasBuffs(A.Stealth.ID) ~= 0 or Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0) and Unit(player):HasBuffs(A.MasterAssassinsMark.ID) ==0) 
                then
                    return A.Shadowstrike:Show(icon)
                end
                --stealthed->add_action( "call_action_list,name=finish,if=effective_combo_points>=cp_max_spend" );
                if (effective_combo_points>=Player:ComboPointsMax()) and Finishers()
                then
                    return true
                end
                --stealthed->add_action( "call_action_list,name=finish,if=buff.shuriken_tornado.up and combo_points.deficit<=2", "Finish at 3+ CP without DS / 4+ with DS with Shuriken Tornado buff up to avoid some CP waste situations." );
                if (Unit(player):HasBuffs(A.ShurikenTornado.ID) ~= 0 and Player:ComboPointsDeficit() <=2) and Finishers() then
                  return true  
                end
                --stealthed->add_action( "call_action_list,name=finish,if=spell_targets.shuriken_storm>=4 and effective_combo_points>=4", "Also safe to finish at 4+ CP with exactly 4 targets. (Same as outside stealth.)" );
                if  (MultiUnits:GetByRange(10) >= 4 and effective_combo_points >=4) and Finishers() 
                then
                   return true 
                end
                --stealthed->add_action( "call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled and buff.vanish.up)", "Finish at 4+ CP without DS, 5+ with DS, and 6 with DS after Vanish" );;
                if (Player:ComboPointsDeficit() <= 1-(boolnumber(A.DeeperStratagem:IsTalentLearned() and Unit(player):HasBuffs(A.VanishStealth.ID) ~= 0))) and Finishers()
                then
                    return true
                end
                --stealthed->add_action( this, "Shadowstrike", "if=stealthed.sepsis and spell_targets.shuriken_storm<4" );
                if A.Shadowstrike:IsReady(unitID)
                and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                and

                (
                    Unit(player):HasBuffs(A.SepsisStealth.ID, _, true) ~= 0 and MultiUnits:GetByRange(10) < 4
                ) then
                    return A.Shadowstrike:Show(icon)
                end
                --stealthed->add_action( this, "Shiv", "if=talent.nightstalker.enabled and runeforge.tiny_toxic_blade and spell_targets.shuriken_storm<5" );
                if A.Shiv:IsReady(unitID)
                and
                (
                    A.Nightstalker:IsTalentLearned() and A.TinyToxicBlade:HasLegendaryCraftingPower() and MultiUnits:GetByRange(10) < 5
                ) then
                    return A.Shiv:Show(icon)
                end
                --stealthed->add_action( this, "Shadowstrike", "cycle_targets=1,if= not variable.use_priority_rotation and debuff.find_weakness.remains<1 and spell_targets.shuriken_storm<=3 and target.time_to_die-remains>6", "Up to 3 targets (no prio) keep up Find Weakness by cycling Shadowstrike." );
                if A.Shadowstrike:IsReady(unitID)
                and inCombat
                and not use_priority_rotation 
                and Unit(unitID):HasDeBuffs(A.FindWeakness.ID, true) < 1 
                and MultiUnits:GetByRange(10) <=3 
                and (Unit(unitID):TimeToDie() - Unit(unitID):HasDeBuffs(A.FindWeakness.ID, true)) > 6
                and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                then
                    return A.Shadowstrike:Show(icon)
                end
                if A.Shadowstrike:IsReady(unitID)
                and inCombat
                and not use_priority_rotation 
                and Unit(unitID):HasDeBuffs(A.FindWeakness.ID, true) >= 1 
                and MultiUnits:GetByRange(10) <=3 
                and Action.GetToggle(1, "AutoTarget")  
                and GetCurrentGCD() ~= 0 --prevent rotation from getting stuck
                and ValidKeeptarget(unitID) --Target is something we swap off of
                then
                    for val in pairs(ActiveUnitPlates) do
                        if 	(Unit(val):HasDeBuffs(A.FindWeakness.ID, true) <= 1 --Checck FindWeakenss
                            and Unit(val):TimeToDie() - Unit(val):HasDeBuffs(A.FindWeakness.ID, true) > 6-- nameplate will live long enough
                            and A.Kick:IsInRange(val)) -- in range
                            and ValidAutotarget(val) --Valid for auto targeting
                            and	(( UnitCanAttack("player", val) and UnitThreatSituation("player", val) ~= nil) or Unit(val):IsDummy()) --in combat with nameplate or comabt dummy 
                            then
                                return A:Show(icon, ACTION_CONST_AUTOTARGET)
                        end
                    end
                end 
                --stealthed->add_action( this, "Shadowstrike", "if=variable.use_priority_rotation and (debuff.find_weakness.remains<1 or talent.weaponmaster.enabled and spell_targets.shuriken_storm<=4)", "For priority rotation, use Shadowstrike over Storm with WM against up to 4 targets or if FW is running off (on any amount of targets)" );
                if A.Shadowstrike:IsReady(unitID)
                and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                and
                (
                use_priority_rotation 
                and (Unit(unitID):HasDeBuffs(A.FindWeakness.ID, true) < 1 or A.Weaponmaster:IsTalentLearned() and MultiUnits:GetByRange(10) <= 4)
                ) then
                    return A.Shadowstrike:Show(icon)
                end
                --stealthed->add_action( this, "Shuriken Storm", "if=spell_targets>=3+(buff.the_rotten.up or runeforge.akaaris_soul_fragment) and (buff.symbols_of_death_autocrit.up or  not buff.premeditation.up or spell_targets>=5)" );
                if A.ShurikenStorm:IsReady(unitID)
                and GetToggle(2, "AoE")
                and Unit(player):CombatTime() >0
                and
                (
                    MultiUnits:GetByRange(10) >= 3 + (
                        boolnumber(Unit(player):HasBuffs(A.TheRotten.ID) ~= 0) 
                     or boolnumber(A.AkaarisSoulFragment:HasLegendaryCraftingPower())
                     )  
                    and (Unit(player):HasBuffs(A.SymbolsOfDeathCrit.ID, _, true) ~= 0 or  Unit(player):HasBuffs(A.Premeditation.ID) == 0 or MultiUnits:GetByRange(10) >= 5)
                ) 
                then
                    return A.ShurikenStorm:Show(icon)
                end
                --stealthed->add_action( this, "Shadowstrike", "if=debuff.find_weakness.remains<=1 or cooldown.symbols_of_death.remains<18 and debuff.find_weakness.remains<cooldown.symbols_of_death.remains", "Shadowstrike to refresh Find Weakness and to ensure we can carry over a full FW into the next SoD if possible." );
                if A.Shadowstrike:IsReady(unitID) 
                and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                and
                (
                Unit(unitID):HasDeBuffs(A.FindWeakness.ID, true) <=1 
                or A.SymbolsOfDeath:GetCooldown() < 18 
                and Unit(unitID):HasDeBuffs(A.FindWeakness.ID, true) < A.SymbolsOfDeath:GetCooldown()
                ) then
                    return A.Shadowstrike:Show(icon)
                end
                --stealthed->add_talent( this, "Gloomblade", "if=buff.perforated_veins.stack>=5 and conduit.perforated_veins.rank>=13" );
                if A.Gloomblade:IsReady(unitID) 
                and inMelee
                and
                (
                    Unit(player):HasBuffsStacks(A.PerforatedVeins.ID) >= 5 
                    -- TODO and conduit.perforated_veins.rank>=13
                ) then
                    return A.Gloomblade:Show(icon)
                end
                --stealthed->add_action( this, "Shadowstrike" );
                if A.Shadowstrike:IsReady(unitID) 
                and ((GetToggle(2, "ShadowstrikeRange") <= 6 and inMelee) or (GetToggle(2, "ShadowstrikeRange") >= 6))
                then
                    return A.Shadowstrike:Show(icon)
                end

                --stealthed->add_action( this, "Cheap Shot", "if= not target.is_boss and combo_points.deficit>=1 and buff.shot_in_the_dark.up and energy.time_to_40>gcd.max" );
                if A.CheapShot:IsReady(unitID) and
                (
                    -- TODO not target.is_boss and 
                    Player:ComboPointsDeficit() >= 1 
                    and Unit(player):HasBuffs(A.ShotInTheDark.ID) ~= 0 
                    and Player:EnergyTimeToX(40) > GetGCD()
                ) then
                    return A.CheapShot:Show(icon)
                end
                --this forces rotation to pool energy while stealth buff is up and nothing else avaliable
                if true then return A.PoolResource:Show(icon) end

            end

            local function Builders()
                --build->add_action( this, "Shiv", "if= not talent.nightstalker.enabled and runeforge.tiny_toxic_blade and spell_targets.shuriken_storm<5" );
                if A.Shiv:IsReady(unitID) 
                and
                (
                not A.Nightstalker:IsTalentLearned() 
                and A.TinyToxicBlade:HasLegendaryCraftingPower()
                and MultiUnits:GetByRange(10) < 5
                ) then
                    return A.Shiv:Show(icon)
                end
                --build->add_action( this, "Shuriken Storm", "if=spell_targets>=2 and ( not covenant.necrolord or cooldown.serrated_bone_spike.max_charges-charges_fractional>=0.25 or spell_targets.shuriken_storm>4)" );
                if A.ShurikenStorm:IsReady(unitID) 
                and MultiUnits:GetByRange(10) >= 2 
                and GetToggle(2, "AoE")
                and 
                (
                    Player:GetCovenant() ~= 4
                    or A.SerratedBoneSpike:GetSpellChargesMax()-A.SerratedBoneSpike:GetSpellChargesFrac() >= 0.25 
                    or MultiUnits:GetByRange(10) > 4
                ) then
                    return A.ShurikenStorm:Show(icon)
                end
                --build->add_action( "serrated_bone_spike,if=cooldown.serrated_bone_spike.max_charges-charges_fractional<=0.25 or soulbind.lead_by_example.enabled and  not buff.lead_by_example.up or soulbind.kevins_oozeling.enabled and  not debuff.kevins_wrath.up" );
                if A.SerratedBoneSpike:IsReady(unitID) and 
                (
                    A.SerratedBoneSpike:GetSpellChargesMax()-A.SerratedBoneSpike:GetSpellChargesFrac() <= 0.25 
                --TODO: or soulbind.lead_by_example.enabled and not buff.lead_by_example.up 
                --TODO: or soulbind.kevins_oozeling.enabled and not debuff.kevins_wrath.up
                ) then
                    return A.SerratedBoneSpike:Show(icon) 
                end

                --build->add_talent( this, "Gloomblade" );
                if A.Gloomblade:IsReady(unitID)
                and inMelee
                then
                    return A.Gloomblade:Show(icon)
                end
                --build->add_action( this, "Backstab" );
                if A.Backstab:IsReady(unitID)
                and InMelee
                then
                    return A.Backstab:Show(icon)
                end

                --TODO check this first if there are bugs
                --In combat ranged GCD filler
                if A.ShurikenToss:IsReady(unitID) and Player:Energy() >=90 and Unit(unitID):HealthPercent() < 100 and not inMelee then
                    return A.ShurikenToss:Show(icon)
                end

            end
-----------------------------------------------
--Functional Main Rotation Calls             --
-----------------------------------------------
        --INTERRUPTS
        if Interrupts() then return true end
        --DEFENSIVES
        if Defensives() then return true end
        -- OPENER
        if Unit(player):HasBuffs(A.Stealth.ID) ~= 0 and GetToggle(2, "Opener") ~= "OFF" and Opener() then return true end


            --def->add_action( "call_action_list,name=cds", "Check CDs at first" );
            if isBurst and CDs() then return true end
            
            --def->add_action( "run_action_list,name=stealthed,if=stealthed.all", "Run fully switches to the Stealthed Rotation (by doing so, it forces pooling if nothing is available)." );
            if (Player:IsStealthed()) and StealthedRotation() then
                return true
            end
            --def->add_action( this, "Slice and Dice", "if=spell_targets.shuriken_storm<6 and fight_remains>6 and buff.slice_and_dice.remains<gcd.max and combo_points>=4-(time<10)*2", "Apply Slice and Dice at 2+ CP during the first 10 seconds, after that 4+ CP if it expires within the next GCD or is not up" );
            if A.SliceAndDice:IsReady(player)
            and inMelee
            and
            (
                MultiUnits:GetByRange(10) < 6 and Unit(unitID):TimeToDie() > 6 and Unit(player):HasBuffs(A.SliceAndDice.ID) < GetGCD() and Player:ComboPoints() >= 4 - boolnumber((Unit(player):CombatTime() < 10)) * 2 
            )
            then
                return A.SliceAndDice:Show(icon)
            end
            --def->add_action( "call_action_list,name=stealth_cds,if=variable.use_priority_rotation", "Priority Rotation? Let's give a crap about energy for the stealth CDs (builder still respect it). Yup, it can be that simple." );
            if isBurst and (use_priority_rotation) and StealthCooldowns() then return true end
            --def->add_action( "call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold", "Consider using a Stealth CD when reaching the energy threshold" );
            if isBurst and (Player:EnergyDeficit() <= stealth_threshold) and StealthCooldowns() then return true end
            --def->add_action( "call_action_list,name=finish,if=effective_combo_points>=cp_max_spend" );
            if (effective_combo_points>=Player:ComboPointsMax()) and Finishers() then return true end
            --def->add_action( "call_action_list,name=finish,if=combo_points.deficit<=1 or fight_remains<=1 and effective_combo_points>=3 or buff.symbols_of_death_autocrit.up and effective_combo_points>=4", "Finish at 4+ without DS or with SoD crit buff, 5+ with DS (outside stealth)" );
            if (Player:ComboPointsDeficit() <=1 or Unit(unitID):TimeToDie() <= 1 and effective_combo_points>=3 or Unit(player):HasBuffs(A.SymbolsOfDeathCrit.ID, _, true) ~= 0 and effective_combo_points >= 4) and Finishers() then return true end
            --def->add_action( "call_action_list,name=finish,if=spell_targets.shuriken_storm>=4 and effective_combo_points>=4", "With DS also finish at 4+ against 4 targets (outside stealth)" );
            if (MultiUnits:GetByRange(10) >= 4 and effective_combo_points>=4) and Finishers() then return true end
            --def->add_action( "call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold", "Use a builder when reaching the energy threshold" );
            if (Player:EnergyDeficit() <= stealth_threshold) and Builders() then return true end
            --Lowest priority in all of the APL because it causes a GCD
            --def->add_action( "arcane_torrent,if=energy.deficit>=15+energy.regen", "Lowest priority in all of the APL because it causes a GCD" );
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
            -- GiftofNaaru
            if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then 
                return A.GiftofNaaru:Show(icon)
            end
            --TODO re-enable after testing
            if ReTabTarget() then return A:Show(icon, ACTION_CONST_AUTOTARGET) end -- if there is nothing to do, and a target we are in combat with is in melee, tab target
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
	    --Attempt to stop recasts of stealth/poisons by waiting for 4 times ping after a cast is over
    if  Player:IsCasting() then
        Temp.CastStartTime[1] = TMW.time
    elseif TMW.time - (Temp.CastStartTime[1] or 0) < (4*A.GetPing()) then
        return true
    end
    --OOC Stealth
    if GetToggle(2, "OOCStealth") and A.Stealth:IsReady(unitID, true) and not IsResting() and Player:GetStance() == 0 and Unit(player):CombatTime() == 0 and not IsMounted() then --and Unit(player):HasBuffs(A.Soulshape.ID) == 0 apparently the wow API is shit and soulshape is also getstance == 2
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

