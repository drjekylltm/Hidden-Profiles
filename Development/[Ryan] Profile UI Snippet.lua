local _G, select, setmetatable                        = _G, select, setmetatable

local TMW                                             = _G.TMW

local A                                             = _G.Action

local CONST                                         = A.Const
local toNum                                         = A.toNum
local Print                                         = A.Print
local GetSpellInfo                                  = A.GetSpellInfo
local GetToggle                                     = A.GetToggle
local GetLatency                                    = A.GetLatency
local InterruptIsValid                              = A.InterruptIsValid
local Unit                                          = A.Unit

local ACTION_CONST_ROGUE_SUBTLETY                   = CONST.ROGUE_SUBTLETY
local ACTION_CONST_ROGUE_ASSASSINATION             	= CONST.ROGUE_ASSASSINATION
local ACTION_CONST_ROGUE_OUTLAW                     = CONST.ROGUE_OUTLAW

local S                                                = {
    FireElemental                                        	= (GetSpellInfo(198067)),
    EarthElemental                                        	= (GetSpellInfo(198103)),
    FeralSpirits                                        	= (GetSpellInfo(51533)),
    SymbolofDeath                                        	= (GetSpellInfo(212283)),
    Vanish                                        			= (GetSpellInfo(1856)),
    Bloodlust                                        		= (GetSpellInfo(2825)),
    ShadowDance                                        		= (GetSpellInfo(185313)),
    HealingTotem                                        	= (GetSpellInfo(5394)),
    CrimsonVial                                        		= (GetSpellInfo(185311)),
    Evasion                                            		= (GetSpellInfo(5277)),
    CloakofShadows                                    		= (GetSpellInfo(31224)),
    SlowTotem                                        		= (GetSpellInfo(2484)),
    AstralShift                                        		= (GetSpellInfo(108271)),
    Stormkeeper                                        		= (GetSpellInfo(191634)),
    FEINT                                                   = (GetSpellInfo(1966)),
	AR                                                   	= (GetSpellInfo(13750)),
	Echoing													= (GetSpellInfo(323547)),
}

local L                                             = {}
L.AUTO                                                = {
    enUS = "Auto",
    ruRU = "Авто ",
}
L.OFF                                                = {
    enUS = "Off",
    ruRU = "Выкл.",
}
L.PVP                                                 = {
    ANY = "PvP",
}
L.MOUSEOVER                                            = {
    enUS = "Interrupt\n@mouseover",
    ruRU = "Использовать\n@mouseover",
}
L.MOUSEOVERTT                                        = {
    enUS = "Will unlock use actions for @mouseover units\nExample: Kick, Kidney Shot\n\nRight click: Create macro",
    ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг\n\nПравая кнопка мышки: Создать макрос",
}
L.target                                            = {
    enUS = "Interrupt\n@target",
    ruRU = "Использовать\n@target",
}
L.targettt                                        = {
    enUS = "Will unlock use actions for @target units\nExample: Kick, Kidney Shot\n\nRight click: Create macro",
    ruRU = "Разблокирует использование действий для @target юнитов\nНапример: Воскрешение, Хилинг\n\nПравая кнопка мышки: Создать макрос",
}
L.AOE                                                = {
    enUS = "Use\nAoE",
    ruRU = "Использовать\nAoE",
}
L.AOETT                                                = {
    enUS = "Enable BladeFlurry in rotation\n\nRight click: Create macro",
    ruRU = "Включает ротацию для нескольких целей\n\nПравая кнопка мышки: Создать макрос",
}
L.REBTE                                                = {
    enUS = "Between the Eyes\nRe-target",
	ruRU = "Промеж глаз\nцель",
}
L.REBTETT                                                = {
    ANY = "Requires Auto Target\nRetarget Enemy with Between The Eyes Debuff\nMay Prevent Manual Targeting\n\nRight click: Create macro",

}
L.OOCStealth                                                = {
    enUS = "Use\nOOC Stealth",
    ruRU = "Скрытность",
}
L.OOCStealthTT                                                = {
    enUS = "Enable OOC Stealth\n\nRight click: Create macro",
    ruRU = "Включает ротацию для нескольких целей\n\nПравая кнопка мышки: Создать макрос",
}
L.CDS                                            = {
    enUS = "Cooldowns",
    ruRU = "Своя Оборона",
}
L.Totems                                            = {
    enUS = "Totems",
	ruRU = "Тотемы",
}
L.selfDefence                                            = {
    enUS = "Self Defence",
	ruRU = "Самооборона",
}
L.Poisons                                            = {
    enUS = "Poisons",
	ruRU = "Яды",
}
L.Padding                                            = {
    enUS = "",
}
L.Interrupting                                            = {
    enUS = "Interrupting",
    ruRU = "Прерывание",
}
L.AutoTargeting                                            = {
    enUS = "Auto Targeting\nRequires Auto Target on General Tab",
	ruRU = "Автоматический таргетинг",
}
L.Opener                                            = {
    enUS = "Opener",
	ruRU = "Открывалка",
}
L.CATCHINVISIBLE                                    = {
    enUS = "Catch Invisible (arena)",
    ruRU = "Поймать Невидимок (арена)",
}
L.CATCHINVISIBLETT                                    = {
    enUS = "Cast when combat around has been begin and enemy team still has unit in invisible\nDoesn't work if you're mounted or in combat!\n\nRight click: Create macro",
    ruRU = "Применять когда бой поблизости начат и команда противника до сих пор имеет юнита в невидимости\nНе работает, когда вы на транспорте или в бою!\n\nПравая кнопка мышки: Создать макрос",
}
L.SymbolofDeath                                        = {
    enUS = S.SymbolofDeath .. "\nUse outside of burst only\n",
}
L.Vanish                                        = {
    enUS = S.Vanish .. "\nUse vanish offensively\n",
}
L.ShadowDance                                        = {
    enUS = S.ShadowDance .. "\nUse outside of burst only\n",
}
L.CrimsonVial = {
    enUS = S.CrimsonVial .. "\nHealth Percent (Self)",
    ruRU = S.CrimsonVial .. "\nЗдоровье Процент (Свое)",
}
L.EVASION                                            = {
    enUS = S.Evasion .. "\nHealth Percent (Self)",
    ruRU = S.Evasion .. "\nЗдоровье Процент (Свое)",
}
L.CLOAKOFSHADOWS                                    = {
    enUS = S.CloakofShadows .. "\nHealth Percent (Self)",
    ruRU = S.CloakofShadows .. "\nЗдоровье Процент (Свое)",
}
L.FEINT                                    = {
    enUS = S.FEINT .. "\nHealth Percent (Self)",
    ruRU = S.FEINT .. "\nЗдоровье Процент (Свое)",
}
L.AR                                    = {
    enUS = S.AR .. "\nMin Targets",
}
L.Echoing                                    = {
    enUS = S.Echoing .. "\nHold for " .. S.Vanish,
}

L.TRINKETDEFENSIVE                                    = {
    enUS = "Protection Trinkets\nHealth Percent (Self)",
    ruRU = "Аксессуары Защиты\nЗдоровье Процент (Свое)",
}



local SliderMarginOptions = { margin = { top = 10 } }
local LayoutConfigOptions = { gutter = 6, padding = { left = 5, right = 5 } }
A.Data.ProfileEnabled[A.CurrentProfile]             = true
A.Data.ProfileUI                                     = {
    DateTime = "v12.2 (8.8.2021) #Lost",
    [2] = {
        [ACTION_CONST_ROGUE_SUBTLETY] = {
            LayoutOptions = LayoutConfigOptions,
            {
                {
                    E                 = "Checkbox",
                    DB                 = "AoE",
                    DBV             = true,
                    L                 = L.AOE,
                    TT                 = L.AOETT,
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "OOCStealth",
                    DBV             = true,
                    L                 = L.OOCStealth,
                    TT                 = L.OOCStealthTT,
                    M                 = {},
                },
                {
                    E = "Checkbox",

                    DB = "ShadowstrikeRange",
                    DBV = true,
                    L = {
                        ANY = A.GetSpellInfo(185438) .. " In \nMelee Only",
                    },
                    TT = {
                        ANY = "limit" .. A.GetSpellInfo(185438) .. "\n\nRight click: Create macro",
                    },
                    M = {},
                },
            },
            {
                {
                    E                 = "Checkbox",
                    DB                 = "MOExplosive",
                    DBV             = true,
                    L = {
                        ANY = "Mouse Over\nTarget Explosives",
                    },
                    TT = {
                        ANY = "Use Mouse Over to Target Explosives\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "MOTotem",
                    DBV             = true,
                    L = {
                        ANY = "Mouse Over\nTarget Totems",
                    },
                    TT = {
                        ANY = "Use Mouse Over to Target Totems\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
				{
                    E               = "Checkbox",
                    DB              = "InterruptList",
                    DBV             = true,
                    L = {
                        ANY = "Use Ryan's\nInterrupt List",
                    },
                    TT = {
                        ANY = "Use Ryan's Interrupt List\n Otherwise Use Default Action Settings\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E               = "Checkbox",
                    DB              = "usePriorityRotation",
                    DBV             = false,
                    L = {
                        ANY = "Use Priority Rotation",
                    },
                    TT = {
                        ANY = "Use AoE Builders and Single Target Finishers\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
            },
            --[[{ -- [2] Opener
                {
                    E                 = "Header",
                    L                 = L.Opener,
                },
            },--]]
            {

                {
                    E = "Dropdown",
                    OT = {
                        { text = "Manual Open", value = "OFF" },
                        { text = A.GetSpellInfo(185438), value = "Shadowstrike" },
                        { text = A.GetSpellInfo(1833), value = "CheapShot" },
                    },
                    DB = "Opener",
                    DBV = "Shadowstrike",
                    L = {
                        ANY = "Opener",
                    },
                    TT = {
                        ANY = "Select the opener to break stealth\nManual open will not break stealth\n\nRight click: Create macro",
                    },
                    M = {},
                },
                --[[
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = 2 },
                        { text = "Manual", value = 1 },
                        { text = "Off", value = 0 },
                    },
                    DB = "VanishSetting",
                    DBV = 2,
                    L = {
                        ANY = "Vanish + Ambush Usage",
                    },
                    TT = {
                        ANY = "Auto: Vanish & Ambush\nManual: Ambush After Manual Vanish\nStop: Stop Rotation After Vanish\n\nRight click: Create macro",
                    },
                    M = {},
                },
                --]]
            },
			{

			},

            { -- [2] Poisons
                {
                    E                 = "Header",
                    L                 = L.Poisons,
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "OFF", value = "OFF" },
                        { text = A.GetSpellInfo(315584), value = "InstantPoison" },
                        { text = A.GetSpellInfo(8679), value = "WoundPoison" },
                    },
                    DB = "LethalPoison",
                    DBV = "InstantPoison",
                    L = {
                        ANY = "Lethal Poison",
                    },
                    TT = {
                        ANY = "Select the lethal poison the rotation should always maintain\n\nRight click: Create macro",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "OFF", value = "OFF" },
                        { text = A.GetSpellInfo(5761), value = "NumbingPoison" },
                        { text = A.GetSpellInfo(3408), value = "CripplingPoison" },
                    },
                    DB = "NonLethalPoison",
                    DBV = "NumbingPoison",
                    L = {
                        ANY = "Non-Lethal Poison",
                    },
                    TT = {
                        ANY = "Select the non-lethal poison the rotation should always maintain\n\nRight click: Create macro",
                    },
                    M = {},
                },
            },


            { -- [2] Self Defensives
                {
                    E                 = "Header",
                    L                 = L.selfDefence,
                },
            },
            {
                {
                    E                 = "Slider",
                    MIN             = -1,
                    MAX                 = 100,
                    DB                 = "Feint",
                    DBV             = 100,
                    ONOFF             = true,
                    L                 = L.FEINT,
                    M                 = {},
                },
                {
                    E                = "Slider",
                    MIN             = -1,
                    MAX                = 100,
                    DB                 = "CrimsonVial",
                    DBV             = 60,
                    ONOFF             = true,
                    L                 = L.CrimsonVial,
                    M                 = {},
                },
            },
            {
                {
                    E                 = "Slider",
                    MIN             = -1,
                    MAX             = 100,
                    DB                 = "Evasion",
                    DBV             = 100,
                    ONOFF             = true,
                    L                 = L.EVASION,
                    M                 = {},
                },
                {
                    E                 = "Slider",
                    MIN                = -1,
                    MAX                = 100,
                    DB                 = "CloakofShadows",
                    DBV                = 100,
                    ONOFF             = true,
                    L                 = L.CLOAKOFSHADOWS,
                    M                 = {},
                },
            },
        },


        [ACTION_CONST_ROGUE_ASSASSINATION] = {
            LayoutOptions = LayoutConfigOptions,
             {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = 2 },
                        { text = "Manual", value = 1 },
                        { text = "Off", value = 0 },
                    },
                    DB = "VanishSetting",
                    DBV = 2,
                    L = {
                        ANY = "Vanish Usage",
                    },
                    TT = {
                        ANY = "Auto: Vanish + Attack \nManual: Attack After Manual Vanish\nStop: Stop Rotation After Vanish\n\nRight click: Create macro",
                    },
                    M = {},
                },

		    },
			{
			                {
                    E                 = "Checkbox",
                    DB                 = "AoE",
                    DBV             = true,
                    L                 = L.AOE,
                    TT                 = L.AOETT,
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "OOCStealth",
                    DBV             = true,
                    L                 = L.OOCStealth,
                    TT                 = L.OOCStealthTT,
                    M                 = {},
                },
				{
                    E               = "Checkbox",
                    DB              = "InterruptList",
                    DBV             = true,
                    L = {
                        ANY = "Use Ryan's\nInterrupt List",
                    },
                    TT = {
                        ANY = "Use Ryan's Interrupt List\n Otherwise Use Default Action Settings\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E               = "Checkbox",
                    DB              = "usePriorityRotation",
                    DBV             = false,
                    L = {
                        ANY = "Use Priority Rotation",
                    },
                    TT = {
                        ANY = "Use AoE Builders and Single Target Finishers\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
			},
            { -- [2] Auto Targetting
                {
                    E                 = "Header",
                    L                 = L.AutoTargeting,
                },
            },
            {
                {
                    E                 = "Checkbox",
                    DB                 = "MOExplosive",
                    DBV             = true,
                    L = {
                        ANY = "Mouse Over\nTarget Explosives",
                    },
                    TT = {
                        ANY = "Use Mouse Over to Target Explosives\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "MOTotem",
                    DBV             = true,
                    L = {
                        ANY = "Mouse Over\nTarget Totems",
                    },
                    TT = {
                        ANY = "Use Mouse Over to Target Totems\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "ATInterrupt",
                    DBV             = true,
                    L = {
                        ANY = "Auto Target\nTo Interrupt",
                    },
                    TT = {
                        ANY = "Requires Auto Target\nSwap Targets to Interrupt\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
            },
            { -- [2] Poisons
                {
                    E                 = "Header",
                    L                 = L.Poisons,
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "OFF", value = "OFF" },
                        { text = A.GetSpellInfo(2823), value = "DeadlyPoison" },
                        { text = A.GetSpellInfo(8679), value = "WoundPoison" },
                    },
                    DB = "LethalPoison",
                    DBV = "DeadlyPoison",
                    L = {
                        ANY = "Lethal Poison",
                    },
                    TT = {
                        ANY = "Select the lethal poison the rotation should always maintain\n\nRight click: Create macro",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "OFF", value = "OFF" },
                        { text = A.GetSpellInfo(5761), value = "NumbingPoison" },
                        { text = A.GetSpellInfo(3408), value = "CripplingPoison" },
                    },
                    DB = "NonLethalPoison",
                    DBV = "NumbingPoison",
                    L = {
                        ANY = "Non-Lethal Poison",
                    },
                    TT = {
                        ANY = "Select the non-lethal poison the rotation should always maintain\n\nRight click: Create macro",
                    },
                    M = {},
                },
            },
            { -- [2] Self Defensives
                {
                    E                 = "Header",
                    L                 = L.selfDefence,
                },
            },
            {
                {
                    E                 = "Slider",
                    MIN             = -1,
                    MAX                 = 100,
                    DB                 = "Feint",
                    DBV             = 100,
                    ONOFF             = true,
                    L                 = L.FEINT,
                    M                 = {},
                },
                {
                    E                = "Slider",
                    MIN             = -1,
                    MAX                = 100,
                    DB                 = "CrimsonVial",
                    DBV             = 60,
                    ONOFF             = true,
                    L                 = L.CrimsonVial,
                    M                 = {},
                },
            },
            {
                {
                    E                 = "Slider",
                    MIN             = -1,
                    MAX             = 100,
                    DB                 = "Evasion",
                    DBV             = 100,
                    ONOFF             = true,
                    L                 = L.EVASION,
                    M                 = {},
                },
                {
                    E                 = "Slider",
                    MIN                = -1,
                    MAX                = 100,
                    DB                 = "CloakofShadows",
                    DBV                = 100,
                    ONOFF             = true,
                    L                 = L.CLOAKOFSHADOWS,
                    M                 = {},
                },
            },
        },

        [ACTION_CONST_ROGUE_OUTLAW] = {
            LayoutOptions = LayoutConfigOptions,
             {
                {
                    E = "Checkbox",
                    DB = "BladeRushRange",
                    DBV = true,
                    L = {
                        ANY = A.GetSpellInfo(271877) .. " in Melee Only",
                    },
                    TT = {
                        ANY = "Limit the range of " .. A.GetSpellInfo(271877) .."\n\nRight click: Create macro",
                    },
                    M = {},
                },
                {
                    E = "Checkbox",
                    DB = "offensiveGouge",
                    DBV = false,
                    L = {
                        ANY = A.GetSpellInfo(1776) .. " offensively\nWith " .. A.GetSpellInfo(108216),
                    },
                    TT = {
                        ANY = "With " .. A.GetSpellInfo(108216) .. " use " .. A.GetSpellInfo(1776) .. "\nTo generate CP\n\nRight click: Create macro",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Manual Open", value = "OFF" },
                        { text = A.GetSpellInfo(8676), value = "Ambush" },
                        { text = A.GetSpellInfo(1833), value = "CheapShot" },
                    },
                    DB = "Opener",
                    DBV = "Ambush",
                    L = {
                        ANY = "Opener",
                    },
                    TT = {
                        ANY = "Select the opener to break stealth\nManual open will not break stealth\n\nRight click: Create macro",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "Auto", value = 2 },
                        { text = "Manual", value = 1 },
                        { text = "Off", value = 0 },
                    },
                    DB = "VanishSetting",
                    DBV = 0,
                    L = {
                        ANY = "Vanish + Ambush Usage",
                    },
                    TT = {
                        ANY = "Auto: Vanish & Ambush\nManual: Ambush After Manual Vanish\nStop: Stop Rotation After Vanish\n\nRight click: Create macro",
                    },
                    M = {},
                },
            },
			{
				{
                    E               = "Checkbox",
                    DB              = "InterruptList",
                    DBV             = true,
                    L = {
                        ANY = "Use Ryan's\nInterrupt List",
                    },
                    TT = {
                        ANY = "Use Ryan's Interrupt List\n Otherwise Use Default Action Settings\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
				{
                    E                 = "Checkbox",
                    DB                 = "AoE",
                    DBV             = true,
                    L                 = L.AOE,
                    TT                 = L.AOETT,
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "OOCStealth",
                    DBV             = true,
                    L                 = L.OOCStealth,
                    TT                 = L.OOCStealthTT,
                    M                 = {},
                },
				{
                    E                 = "Slider",
                    MIN             = 1,
                    MAX                 = 10,
                    DB                 = "Adrenaline",
                    DBV             = 1,
                    ONOFF             = false,
                    L                 = L.AR,
                    M                 = {},
					TT				={
                        ANY = "Number of Non-Boss units to use Adernanline Rush on\n\nRight click: Create macro",
                    },
                },
            },
           --[[ { -- Padding
                {
                    E                 = "Header",
                    L                 = L.Padding,
                },
            },
			--]]
            { -- [2] Auto Targetting
                {
                    E                 = "Header",
                    L                 = L.AutoTargeting,
                },
            },
            {
                {
                    E                 = "Checkbox",
                    DB                 = "MOExplosive",
                    DBV             = true,
                    L = {
                        ANY = "Mouse Over\nTarget Explosives",
                    },
                    TT = {
                        ANY = "Use Mouse Over to Target Explosives\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "MOTotem",
                    DBV             = true,
                    L = {
                        ANY = "Mouse Over\nTarget Totems",
                    },
                    TT = {
                        ANY = "Use Mouse Over to Target Totems\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
			    {
                    E = "Dropdown",
                    OT = {
                        { text = "Never", value = 0 },
                        { text = "Once", value = 1 },
                        { text = "Always", value = 2 },
                    },
                    DB                 = "REBTE",
                    DBV             = 0,
                    L                 = L.REBTE,
                    TT                 = L.REBTETT,
                    M                 = {},
                },

            },
            {
                {
                    E                   = "Checkbox",
                    DB                  = "SBSTarget",
                    DBV                 = true,
                    L = {
                        ANY = "Spread Serrated Bone Spike",
                    },
                    TT = {
                        ANY = "Auto Spread\nSerrated Bone Spike\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                = "MFDSnipping",
                    DBV               = true,
                    L = {
                        ANY = "MFD Sniping",
                    },
                    TT = {
                        ANY = "Target Enemy based on time to die for MFD\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
                {
                    E                 = "Checkbox",
                    DB                 = "ATInterrupt",
                    DBV             = true,
                    L = {
                        ANY = "Auto Target\nTo Interrupt",
                    },
                    TT = {
                        ANY = "Requires Auto Target\nSwap Targets to Interrupt\n\nRight click: Create macro",
                    },
                    M                 = {},
                },
            },           
           
           
           
           
           
           
           
           
            { -- [2] Poisons
                {
                    E                 = "Header",
                    L                 = L.Poisons,
                },
            },
            {
                {
                    E = "Dropdown",
                    OT = {
                        { text = "OFF", value = "OFF" },
                        { text = A.GetSpellInfo(315584), value = "InstantPoison" },
                        { text = A.GetSpellInfo(8679), value = "WoundPoison" },
                    },
                    DB = "LethalPoison",
                    DBV = "InstantPoison",
                    L = {
                        ANY = "Lethal Poison",
                    },
                    TT = {
                        ANY = "Select the lethal poison the rotation should always maintain\n\nRight click: Create macro",
                    },
                    M = {},
                },
                {
                    E = "Dropdown",
                    OT = {
                        { text = "OFF", value = "OFF" },
                        { text = A.GetSpellInfo(5761), value = "NumbingPoison" },
                        { text = A.GetSpellInfo(3408), value = "CripplingPoison" },
                    },
                    DB = "NonLethalPoison",
                    DBV = "NumbingPoison",
                    L = {
                        ANY = "Non-Lethal Poison",
                    },
                    TT = {
                        ANY = "Select the non-lethal poison the rotation should always maintain\n\nRight click: Create macro",
                    },
                    M = {},
                },
            },
            { -- [2] Self Defensives
                {
                    E                 = "Header",
                    L                 = L.selfDefence,
                },
            },
            {
                {
                    E                 = "Slider",
                    MIN             = -1,
                    MAX                 = 100,
                    DB                 = "Feint",
                    DBV             = 100,
                    ONOFF             = true,
                    L                 = L.FEINT,
                    M                 = {},
                },
                {
                    E                = "Slider",
                    MIN             = -1,
                    MAX                = 100,
                    DB                 = "CrimsonVial",
                    DBV             = 60,
                    ONOFF             = true,
                    L                 = L.CrimsonVial,
                    M                 = {},
                },
            },
            {
                {
                    E                 = "Slider",
                    MIN             = -1,
                    MAX             = 100,
                    DB                 = "Evasion",
                    DBV             = 100,
                    ONOFF             = true,
                    L                 = L.EVASION,
                    M                 = {},
                },
                {
                    E                 = "Slider",
                    MIN                = -1,
                    MAX                = 100,
                    DB                 = "CloakofShadows",
                    DBV                = 100,
                    ONOFF             = true,
                    L                 = L.CLOAKOFSHADOWS,
                    M                 = {},
                },
            },
        },
	},
}
-----------------------------------------
--                   PvP
-----------------------------------------
local DisarmPvPunits     = setmetatable({}, { __index = function(t, v)
            t[v] = GetToggle(2, "DisarmPvPunits")
            return t[v]
end})
local ImunBuffsCC              = {"CCTotalImun", "DamagePhysImun", "TotalImun"}
local ImunBuffsInterrupt     = {"KickImun", "TotalImun", "DamagePhysImun"}

function A.DisarmIsReady(unitID, skipShouldStop, isMsg)
    if A.IsInPvP then
        local isArena = unitID:match("arena")
        if     (
            (unitID == "arena1" and DisarmPvPunits[A.PlayerSpec][1]) or
            (unitID == "arena2" and DisarmPvPunits[A.PlayerSpec][2]) or
            (unitID == "arena3" and DisarmPvPunits[A.PlayerSpec][3]) or
            (not isArena and DisarmPvPunits[A.PlayerSpec][4])
        )
        then
            if (not isArena and Unit(unitID):IsEnemy() and Unit(unitID):IsPlayer()) or (isArena and not Unit(unitID):InLOS() and (A.Zone == "arena" or A.Zone == "pvp")) then
                local Disarm = A[A.PlayerSpec].Disarm
                if  Disarm and
                (
                    (
                        not isMsg and GetToggle(2, "DisarmPvP") ~= "OFF" and ((not isArena and Disarm:IsReady(unitID, nil, nil, skipShouldStop)) or (isArena and Disarm:IsReadyByPassCastGCD(unitID))) and
                        Unit(unitID):IsMelee() and (GetToggle(2, "DisarmPvP") == "ON COOLDOWN" or Unit(unitID):HasBuffs("DamageBuffs") > 8)
                    ) or
                    (
                        isMsg and Disarm:IsReadyM(unitID)
                    )
                ) and
                Disarm:AbsentImun(unitID, ImunBuffsCC, true) and
                Unit(unitID):IsControlAble("disarm") and
                Unit(unitID):InCC() == 0 and
                Unit(unitID):HasDeBuffs("Disarmed") == 0
                then
                    return true
                end
            end
        end
    end
end

function A:CanInterruptPassive(unitID, countGCD)
    if A.IsInPvP and (A.Zone == "arena" or A.Zone == "pvp") then
        if self.isPummel then
            local useKick, _, _, notInterruptable = InterruptIsValid(unitID, "Heal", nil, countGCD)
            if not useKick then
                useKick, _, _, notInterruptable = InterruptIsValid(unitID, "PvP", nil, countGCD)
            end
            if useKick and not notInterruptable and self:IsReadyByPassCastGCD(unitID) and self:AbsentImun(unitID, ImunBuffsInterrupt, true) then
                return true
            end
        end

        if self.isStormBolt then
            local StormBoltPvP = GetToggle(2, "StormBoltPvP")
            if StormBoltPvP and StormBoltPvP ~= "OFF" and self:IsReadyByPassCastGCD(unitID) then
                local _, useCC, castRemainsTime
                if Toggle == "BOTH" then
                    useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, "Heal", nil, countGCD))
                    if not useCC then
                        useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, "PvP", nil, countGCD))
                    end
                else
                    useCC, _, _, castRemainsTime = select(2, InterruptIsValid(unitID, Toggle, nil, countGCD))
                end
                if useCC and castRemainsTime >= GetLatency() and Unit(unitID):IsControlAble("stun") and not Unit(unitID):InLOS() and self:AbsentImun(unitID, ImunBuffsCC, true) then
                    return true
                end
            end
        end
    end
end

