local _G, select, setmetatable                            = _G, select, setmetatable

local TMW                                                 = _G.TMW

local A                                                 = _G.Action

--local Unit                                                = A.Unit
local GameLocale                                        = A.FormatGameLocale(_G.GetLocale())
local StdUi                                                = A.StdUi
local Factory                                            = StdUi.Factory
local math_random                                        = math.random
--local player                                             = "player"
partyIDs                                                = {
    [1] = "party1",
    [2] = "party2",
}
arenaIDs                                            = {
    [1] = "arena1",
    [2] = "arena2",
    [3] = "arena3",
}

--This table is used to identify Target casts should be feinted in the last 4 seconds. 
DefensiveCasts = {
    [330423] = A.Feint, --Fungistorm, PF, Trash
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

--This table is used to identify nameplates that should not be swapped to if they are on screen.
KeepTarget	= {
    [165913] = false, --Ghastly Parishioner --HOA
    [170483] = false, --Atal'ai Deathwalker's Spirit --DOS
    [165251] = false, --Illusionary Vulpin --Mists
    [164567] = false, --Ingra Maloch --Mists first boss
    [164578] = false, --Stitchflesh's Creation --NW
    [170927] = false, --Erupting Ooze --PF
    [164463] = false, --Paceran the Virulent --ToP
    [164461] = false, --Sathel the Accursed --ToP
    [174175] = false, --Loyal Stoneborn --HOA
    [334757] = false, --Shades of Bargast --Castle Nathria
    [165560] = false, --Gormling Larva --Mists
    [164363] = false, --Undying Stonefiend --HoA
    --[] = false, --
    --[] = false, --
    --[] = false, --
    --[] = false, --
    --[] = false, --
    --[] = false, --
    --[31146] = false, -- Target dummy in Org for testing
}

--This table is used to identify targets that should not be swapped off for any reason
--Once you target these, Auto target is essentially turned off
IgnoreNameplates = {
    [168318] = false, --Forsworn Goliath --SoA
    [165137] = false, --Zolramus Gatekeeper NW
    [163618] = false, --Zolramus Necromancer --NW
    [163157] = false, --Amarth --NW
    [169498] = false, --Plague Bomb, --PF
}

--this table is used to identify casts that are a cast followed by a channel and we only want to interrupt the channel
Channels = {
    --[328177] = true, --Fungistorm, PF, Trash --after testing i dont believe Fungistorm is recast if stopped before channel
    --[330423] = true, --Fungistorm, PF, Trash
    --[328176] = true, --Fungistorm, PF, Trash
    --[330422] = true, --Fungistorm, PF, Trash
    --[340481] = true, --Fungistorm, PF, Trash
    --[340633] = true, --Fungistorm, PF, Trash
    [336451] = true, --Bulwark of Maldraxxus, PF, Trash
    [336449] = true, --Bulwark of Maldraxxus, PF, Trash
    [331718] = true, --Spear Flurry --Mists
    --[331743] = true, --Bucking Rampage --Mists -- changed in 9.1 to CD on start
    [332671] = true, --Bladestorm --DoS
    [330810] = true, --Bind Soul -- TOP
    [334653] = true, --Engorge --SD

}
--Table used to identify instance.ID for Ryan's Interrupts
IsInAnInstance = {
    [2284] = true,--Sanguine Depths
    [2285] = true,--Spires of Ascension
    [2286] = true,--The Necrotic Wake
    [2287] = true,--Halls of Atonement
    [2289] = true,--Plaguefall
    [2290] = true,--Mists of Tirna Scithe
    [2291] = true,--De Other Side
    [2293] = true,--Theater of Pain
    [2296] = true,--Castle Nathria
    [2441] = true,--Tazavesh
    [2450] = true,--Sanctum of Domination
}


local L                                                = setmetatable(
    {
        ruRU                                         = {InterruptName         = "SLs Mythic+ (by Ryan)",},
        enUS                                         = {InterruptName         = "SLs Mythic+ (by Ryan)",},
    }, 
    { __index = function(t) return t.enUS end })

TMW:RegisterCallback("TMW_ACTION_INTERRUPTS_UI_CREATE_CATEGORY", function(callbackEvent, Category)
        local CL = Action.GetCL()
        Category.options[#Category.options + 1] = { text = L[GameLocale].InterruptName, value = "RyanInterrupts" }
        Category:SetOptions(Category.options)
end)

Factory[4].RyanInterrupts = StdUi:tGenerateMinMax({
        [GameLocale] = {
            ISINTERRUPT = true,
			--De Other Side
            [332329] = { useKick = false, useCC = true, useRacial = true    }, --Devoted Sacrifice;         CC
            [332671] = { useKick = false, useCC = true, useRacial = true    }, --Bladestorm;                CC
            [332666] = { useKick = true, useCC = false, useRacial = false   }, --Renew;                     Kick
            [332706] = { useKick = true, useCC = false, useRacial = false   }, --Heal;                      Kick
            [332612] = { useKick = true, useCC = false, useRacial = false   }, --Healing Wave;              Kick
            [331927] = { useKick = false, useCC = false, useRacial = false  }, --Haywire;                   Block
            [332084] = { useKick = true, useCC = true, useRacial = true   	}, --Self-Cleaning Cycle;       Kick
            [340026] = { useKick = false, useCC = true, useRacial = true    }, --Wailing Grief;             CC
            [321764] = { useKick = true, useCC = false, useRacial = false   }, --Bark Armor;         		Kick	
            [320008] = { useKick = true, useCC = false, useRacial = false   }, --Frostbolt;         		Kick
            [332608] = { useKick = true, useCC = false, useRacial = false   }, --Lightning Discharge;       Kick	
            [328729] = { useKick = true, useCC = false, useRacial = false   }, --Dark Lotus;         		Kick	
            [332605] = { useKick = true, useCC = true, useRacial = true     }, --Hex;                 		Kick+CC
            [332234] = { useKick = true, useCC = true, useRacial = true     }, --Essential Oil;        		Kick+CC
			[334664] = { useKick = false, useCC = true, useRacial = true    }, --Frightened Cries;          CC	
            [331379] = { useKick = true, useCC = false, useRacial = false   }, --Lubricate;        			Kick+CC
			[332156] = { useKick = false, useCC = true, useRacial = true    }, --Spinning Up;          		CC
            [332705] = { useKick = true, useCC = false, useRacial = false   }, --Smite;         			Kick			
            [333875] = { useKick = true, useCC = true, useRacial = true     }, --Death's Embrace;    		Kick+CC			
			-- Halls of Attonement
            [325523] = { useKick = false, useCC = true, useRacial = true    }, --Deadly Thrust;             CC
            [326450] = { useKick = false, useCC = true, useRacial = true    }, --Loyal Beasts;              CC
            [325700] = { useKick = true, useCC = false, useRacial = false   }, --Collect Sins;              Kick
            [325701] = { useKick = true, useCC = true, useRacial = true     }, --Siphon Life;               Kick+CC
            [326607] = { useKick = true, useCC = false, useRacial = false   }, --Turn to Stone;             Kick
            [323552] = { useKick = true, useCC = false, useRacial = false   }, --Volley of Power;			Kick			
            [323538] = { useKick = true, useCC = false, useRacial = false   }, --Bolt of Power; 			Kick
            [301680] = { useKick = false, useCC = true, useRacial = true    }, --Rapid Fire;             	CC			
            [326829] = { useKick = true, useCC = false, useRacial = false   }, --Wicked Bolt; 				Kick   
            [325876] = { useKick = true, useCC = false, useRacial = false   }, --Curse of Obliteration; 	Kick  			
			-- Mists of Tirna Scithe
            [322938] = { useKick = true, useCC = true, useRacial = true     }, --Harvest Essence;           Kick+CC 
            [324914] = { useKick = true, useCC = false, useRacial = false   }, --Nourish the Forest;        Kick
            [324776] = { useKick = true, useCC = false, useRacial = false   }, --Bramblethorn Coat;         Kick
            [326046] = { useKick = true, useCC = true, useRacial = true     }, --Stimulate Resistance;      Kick+CC            
            [340544] = { useKick = true, useCC = true, useRacial = true     }, --Stimulate Regeneration;    Kick+CC    
            [337235] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Pacification;    Kick
            [337251] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Incapacitation;  Kick
            [337253] = { useKick = true, useCC = false, useRacial = false   }, --Parasitic Domination;      Kick
            [326021] = { useKick = false, useCC = true, useRacial = true    }, --Acid Globule;              CC			
            [331718] = { useKick = false, useCC = true, useRacial = true    }, --Spear Flurry;              CC					
            [331743] = { useKick = false, useCC = true, useRacial = true    }, --Bucking Rampage;           CC	
            [322450] = { useKick = true, useCC = false, useRacial = false   }, --Consumption;      			Kick
            [322767] = { useKick = true, useCC = true, useRacial = true     }, --Spirit Bolt;    			Kick+CC 			
            [324987] = { useKick = false, useCC = true, useRacial = true    }, --Mistveil Bite;           	CC			
            [325021] = { useKick = false, useCC = true, useRacial = true    }, --Mistveil Tear;           	CC				
            -- Necrotic Wake
            [334748] = { useKick = true, useCC = true, useRacial = true     }, --Drain Fluids;              Kick+CC
            [320462] = { useKick = true, useCC = false, useRacial = false   }, --Necrotic Bolt;             Kick            
            [324293] = { useKick = true, useCC = true, useRacial = true     }, --Rasping Scream;            Kick+CC            
            [320170] = { useKick = true, useCC = false, useRacial = false   }, --Necrotic Bolt;             Kick            
            [338353] = { useKick = true, useCC = true, useRacial = true     }, --Goresplatter;              Kick+CC
            [334748] = { useKick = true, useCC = true, useRacial = true     }, --Drain Fluids;              Kick+CC
            [323190] = { useKick = true, useCC = true, useRacial = true     }, --meat shield;               Kick+CC			
            [335143] = { useKick = true, useCC = true, useRacial = true		}, --Bonemend;				    Kick+CC
            [327130] = { useKick = true, useCC = false, useRacial = false   }, --Repair Flesh;              Kick
            [320822] = { useKick = false, useCC = true, useRacial = true    }, --Final Bargain;             CC	
            [327240] = { useKick = false, useCC = true, useRacial = true    }, --Spine Crush;             	CC
            [328667] = { useKick = true, useCC = true, useRacial = true		}, --Frostbolt Volley;		    Kick+CC
            [320571] = { useKick = true, useCC = false, useRacial = false   }, --Shadow Well;             	Kick
            [321807] = { useKick = false, useCC = true, useRacial = true    }, --Boneflay;             		CC   
            [322274] = { useKick = true, useCC = false, useRacial = false   }, --Enfeeble                   Kick
            --Plaguefall
            [328177] = { useKick = false, useCC = true, useRacial = true,   }, --Fungistorm;                CC                                   
            [319070] = { useKick = true, useCC = false, useRacial = false   }, --Corrosive Gunk;            Kick            
            [336451] = { useKick = false, useCC = true, useRacial = true,   }, --Bulwark of Maldraxxus;     CC            
            [328400] = { useKick = false, useCC = true, useRacial = true    }, --Stealthlings;             	CC 
            [328180] = { useKick = true, useCC = true, useRacial = true     }, --Gripping Infection; 		Kick+CC
            [321999] = { useKick = true, useCC = false, useRacial = false   }, --Viral Globs;            	Kick
            [328429] = { useKick = false, useCC = true, useRacial = true    }, --Crushing Embrace;         	CC
            [328094] = { useKick = true, useCC = false, useRacial = false   }, --Pestilence Bolt;           Kick 	
            [329239] = { useKick = true, useCC = false, useRacial = false   }, --Creepy Crawlers;           Kick 
            [321935] = { useKick = false, useCC = true, useRacial = true    }, --Withering Filth;          	CC  
            [328016] = { useKick = true, useCC = true, useRacial = true     }, --Wonder Grow                Kick+CC
            [327995] = { useKick = true, useCC = true, useRacial = true     }, --Doomshroom                 Kick+CC
            --Sanguine Depths
            [319654] = { useKick = true, useCC = false, useRacial = false   }, --Hungering Drain;           Kick
            [322433] = { useKick = true, useCC = false, useRacial = false   }, --Stoneskin;                 Kick
            [321038] = { useKick = true, useCC = false, useRacial = false   }, --Wrack Soul;                Kick 
            [334653] = { useKick = true, useCC = false, useRacial = false   }, --Engorge; 					Kick
            [335305] = { useKick = true, useCC = false, useRacial = false   }, --Barbed Shackles; 			Kick
            [336277] = { useKick = true, useCC = false, useRacial = false   }, --Explosive Anger; 			Kick			
            [326952] = { useKick = true, useCC = false, useRacial = false   }, --Fiery Cantrip 				Kick
            [324609] = { useKick = false, useCC = true, useRacial = true    }, --Animate Weapon; 			CC
			[326836] = { useKick = true, useCC = true, useRacial = true     }, --Curse of Suppression 		Kick+CC
            [322169] = { useKick = false, useCC = true, useRacial = true    }, --Growing Mistrust; 			CC		--This is no longer cast in 9.1	
            [326712] = { useKick = true, useCC = false, useRacial = false   }, --Dark Bolt 					Kick
            [320861] = { useKick = true, useCC = false, useRacial = false   }, --Drain Essence				Kick			
            [326837] = { useKick = true, useCC = false, useRacial = false   }, --Gloom Burst				Kick				
            [321105] = { useKick = true, useCC = false, useRacial = false   }, --Sap Lifeblood				Kick				
            --Spires of Ascension
            [327413] = { useKick = true, useCC = false, useRacial = false   }, --Rebellious Fist;           Kick            
            [317936] = { useKick = true, useCC = false, useRacial = false   }, --Forsworn Doctrine;         Kick            
            [317963] = { useKick = true, useCC = false, useRacial = false   }, --Burden of Knowledge;       Kick
            [328295] = { useKick = true, useCC = true, useRacial = true     }, --Greater Mending;           Kick+CC
            [328137] = { useKick = true, useCC = false, useRacial = false   }, --Dark Pulse;                Kick
            [328331] = { useKick = true, useCC = false, useRacial = false   }, --Forced Confession;         Kick
			[317661] = { useKick = true, useCC = false, useRacial = false   }, --Insidious Venom;         	Kick
            [323804] = { useKick = false, useCC = true, useRacial = true    }, --Dark Seeker;             	CC
            [327648] = { useKick = true, useCC = false, useRacial = false   }, --Internal Strife;           Kick
            [327481] = { useKick = false, useCC = true, useRacial = true    }, --Dark Lance;             	CC
            --Theater of Pain
            [341902] = { useKick = true, useCC = false, useRacial = false   }, --Unholy Fervor;         	Kick            
            [341969] = { useKick = true, useCC = true, useRacial = true     }, --Withering Discharge		Kick+CC
            [342139] = { useKick = true, useCC = false, useRacial = false   }, --Battle Trance;         	Kick        
            [330562] = { useKick = true, useCC = false, useRacial = false   }, --Demoralizing Shout;    	Kick
            [330810] = { useKick = true, useCC = true, useRacial = true     }, --Bind Soul;             	Kick+CC  
            [330586] = { useKick = false, useCC = true, useRacial = true    }, --Devour Flesh				CC 
            [342675] = { useKick = true, useCC = true, useRacial = true     }, --Bone Spear;            	Kick+CC  
            [330868] = { useKick = true, useCC = true, useRacial = true     }, --Necrotic Bolt volley;  	Kick+CC  
            [341771] = { useKick = true, useCC = false, useRacial = false   }, --Grave Spike;				Kick			
			[330532] = { useKick = false, useCC = true, useRacial = true    }, --Jagged Quarrel 			CC						
            [330875] = { useKick = true, useCC = false, useRacial = false   }, --Spirit Frost;				Kick	
            [319669] = { useKick = true, useCC = false, useRacial = false   }, --Spectral Reach;			Kick	
            [320300] = { useKick = true, useCC = false, useRacial = false   }, --Necromantic Bolt;			Kick
            [320120] = { useKick = true, useCC = false, useRacial = false   }, --Plague Bolt;				Kick			
            [341977] = { useKick = true, useCC = true, useRacial = true     }, --Meat Shield;  				Kick+CC			
			-- Castle Nathria
            [325590] = { useKick = true, useCC = false, useRacial = false   }, --Scornful Blast;			Kick
            [328254] = { useKick = true, useCC = false, useRacial = false   }, --Shattering Ruby;			Kick
            [333002] = { useKick = true, useCC = false, useRacial = false   }, --Vulgar Brand;				Kick
            [337110] = { useKick = true, useCC = false, useRacial = false   }, --Dreadbolt Volley;			Kick
            --Tazavesh
            [354297] = { useKick = true, useCC = false, useRacial = false    }, --Hyperlight Bolt           Kick
            [356537] = { useKick = true, useCC = false, useRacial = false    }, --Empowered Glyph of Restraint         Kick
            [357404] = { useKick = true, useCC = false, useRacial = false    }, --Dischordant Song          Kick
            [357188] = { useKick = true, useCC = false, useRacial = false    }, --Double Technique          Kick
            [347150] = { useKick = true, useCC = false, useRacial = false    }, --Triple Technique          Kick
            [358131] = { useKick = true, useCC = false, useRacial = false    }, --Lightning Nova            Kick
            --[[ Templates
            [] = { useKick = false, useCC = false, useRacial = false}    , -- Block
            [] = { useKick = true, useCC = true, useRacial = true    }, -- Kick+CC
            [] = { useKick = true, useCC = false, useRacial = false    }, -- Kick
            [] = { useKick = false, useCC = true, useRacial = true    }, -- CC
            --]]
            
        },
    }, 43, 70, math_random(87, 95), true)

