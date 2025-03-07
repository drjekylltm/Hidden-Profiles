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

--This table is used to identify nameplates that should not be swapped to if they are on screen.
KeepTarget	= {
    [165913] = true, --Ghastly Parishioner --HOA
    [170483] = true, --Atal'ai Deathwalker's Spirit --DOS
    [165251] = true, --Illusionary Vulpin --Mists
    [164567] = true, --Ingra Maloch --Mists first boss
    [164578] = true, --Stitchflesh's Creation --NW
    [170927] = true, --Erupting Ooze --PF
    [164463] = true, --Paceran the Virulent --ToP
    [164461] = true, --Sathel the Accursed --ToP
    [174175] = true, --Loyal Stoneborn --HOA
    [334757] = true, --Shades of Bargast --Castle Nathria
    [165560] = true, --Gormling Larva --Mists
    [164363] = true, --Undying Stonefiend --HoA
    [176581] = true, --Spiked Ball --SoD Painsmith
    [176523] = true, --Painsmith --SoD Painsmith
    --[] = true, --
    --[] = true, --
    --[] = true, --
    --[] = true, --
    --[] = true, --
    --[31146] = true, -- Target dummy in Org for testing
}

--This table is used to identify targets that should not be swapped off for any reason
--Once you target these, Auto target is essentially turned off
IgnoreNameplates = {
    [168318] = true, --Forsworn Goliath --SoA
    [165137] = true, --Zolramus Gatekeeper NW
    [163618] = true, --Zolramus Necromancer --NW
    [163157] = true, --Amarth --NW
    [169498] = true, --Plague Bomb, --PF
    [176581] = true, --Spiked Ball --SoD Painsmith
    [176523] = true, --Painsmith --SoD Painsmith
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
--Used to dertmine Enemy NPC_IDs (from wowhead) that can not be CC'd ever
IsNotCCAble= {
    --Sanctum of Domination
    [152253] = true, --The Tarragrue
    [180018] = true, --Eye of the Jailer
    [179942] = true, --Deathseeker Eye 
    [176524] = true, --Stygian Abductors
    [178738] = true, --Kyra
    [178736] = true, --Signe
    [175726] = true, --Skyja
    [175727] = true, --Soulrender Dormazain
    [175729] = true, --Remnant of Ner'zhul
    [177117] = true, --Orb of Torment
    [176523] = true, --Painsmith Raznal
    [176581] = true, --Spiked Ball
    [175731] = true, --Guardian of the First Ones
    [179390] = true, --Fatescribe Roh-Kalo
    [15990] = true, --Kel'Thuzad 
    [180473] = true, --Unstoppable Abomination --todo  verify
    [180474] = true, --Soul Reaver
    [176929] = true, --Remnant of Kel'Thuzad
    [180828] = true, --Sylvanas Windrunner
    [176920] = true, --Domination Arrows 
    [177889] = true, --Mawforged Souljudge
    [177891] = true, --Mawforged Summoner
    [177892] = true, --Mawforged Goliath
    --From Johan
    [170850] = true, --Raging Bloodhorn TOP
    [164506] = true, --Ancient Captain TOP
    [167532] = true, --Heavin the Breaker TOP
    [168310] = true, --Plagueroc PF
    [169159] = true, --Unstable Canister PF
--this list is sourced from the CantTouchThis addon
    --discovered
    [177444] = true,
	[178631] = true,
	[180780] = true,
	[164267] = true,
	[176539] = true,
	[180779] = true,
	[162849] = true,
	[176538] = true,
	[177950] = true,
	[167524] = true,
	[164707] = true,
	[166301] = true,
	[166275] = true,
	[174197] = true,
	[179890] = true,
	[179892] = true,
	[179891] = true,
	[179802] = true,
    [179760] = true,
	[172523] = true,
	[174861] = true,
    [180070] = true,
    [177094] = true,
    [180323] = true,
    [176953] = true,
    [176520] = true,
    [177095] = true,
    [180427] = true,
    [178041] = true,
    [175611] = true,
    [176940] = true,
    [176956] = true,
    [178862] = true,
    [179894] = true,
    [177004] = true,
    [176957] = true,
    [179446] = true,
    [178824] = true,
    [176879] = true,
    [180864] = true,
    [179124] = true,
    [180392] = true,
    [180407] = true,
    [176531] = true,
    [180865] = true,
    [178731] = true,
    [175730] = true,
--Included
    [000089] = true,
    [005709] = true,
    [005710] = true,
    [005711] = true,
    [005721] = true,
    [005775] = true,
    [007267] = true,
    [007273] = true,
    [007795] = true,
    [007800] = true,
    [007915] = true,
    [008317] = true,
    [008983] = true,
    [009016] = true,
    [009017] = true,
    [009018] = true,
    [009156] = true,
    [010436] = true,
    [010437] = true,
    [010438] = true,
    [010808] = true,
    [010811] = true,
    [010813] = true,
    [011082] = true,
    [011486] = true,
    [011487] = true,
    [011489] = true,
    [011490] = true,
    [011492] = true,
    [011496] = true,
    [011501] = true,
    [012201] = true,
    [012203] = true,
    [012206] = true,
    [012236] = true,
    [012258] = true,
    [013280] = true,
    [013282] = true,
    [013601] = true,
    [014349] = true,
    [015936] = true,
    [016700] = true,
    [016808] = true,
    [016809] = true,
    [017670] = true,
    [017975] = true,
    [017976] = true,
    [017977] = true,
    [017978] = true,
    [017980] = true,
    [017991] = true,
    [018259] = true,
    [021102] = true,
    [021979] = true,
    [022012] = true,
    [023953] = true,
    [023954] = true,
    [024029] = true,
    [024084] = true,
    [024200] = true,
    [024201] = true,
    [024207] = true,
    [024547] = true,
    [025301] = true,
    [026529] = true,
    [026530] = true,
    [026532] = true,
    [026533] = true,
    [026555] = true,
    [026630] = true,
    [026631] = true,
    [026632] = true,
    [026633] = true,
    [026668] = true,
    [026672] = true,
    [026683] = true,
    [026684] = true,
    [026685] = true,
    [026686] = true,
    [026687] = true,
    [026693] = true,
    [026716] = true,
    [026722] = true,
    [026723] = true,
    [026731] = true,
    [026763] = true,
    [026792] = true,
    [026794] = true,
    [026796] = true,
    [026861] = true,
    [026918] = true,
    [027447] = true,
    [027483] = true,
    [027654] = true,
    [027655] = true,
    [027969] = true,
    [027975] = true,
    [027977] = true,
    [027978] = true,
    [028546] = true,
    [028586] = true,
    [028587] = true,
    [028684] = true,
    [028838] = true,
    [028878] = true,
    [028920] = true,
    [028921] = true,
    [028923] = true,
    [029063] = true,
    [029120] = true,
    [029128] = true,
    [029304] = true,
    [029305] = true,
    [029307] = true,
    [029308] = true,
    [029309] = true,
    [029310] = true,
    [029311] = true,
    [029312] = true,
    [029314] = true,
    [029573] = true,
    [029829] = true,
    [029832] = true,
    [030178] = true,
    [030284] = true,
    [030385] = true,
    [030414] = true,
    [030660] = true,
    [030695] = true,
    [030892] = true,
    [030893] = true,
    [031134] = true,
    [031146] = true,
    [034564] = true,
    [036494] = true,
    [036597] = true,
    [036658] = true,
    [036701] = true,
    [036879] = true,
    [039392] = true,
    [039625] = true,
    [039873] = true,
    [040023] = true,
    [040166] = true,
    [040319] = true,
    [040484] = true,
    [040600] = true,
    [040925] = true,
    [040936] = true,
    [041095] = true,
    [041376] = true,
    [042570] = true,
    [042692] = true,
    [042810] = true,
    [043214] = true,
    [043391] = true,
    [043438] = true,
    [043537] = true,
    [043612] = true,
    [043614] = true,
    [043622] = true,
    [043778] = true,
    [043873] = true,
    [043875] = true,
    [043878] = true,
    [043927] = true,
    [044704] = true,
    [044752] = true,
    [045122] = true,
    [045259] = true,
    [045412] = true,
    [045917] = true,
    [045919] = true,
    [046254] = true,
    [046383] = true,
    [047162] = true,
    [047296] = true,
    [047626] = true,
    [048906] = true,
    [049045] = true,
    [052409] = true,
    [054123] = true,
    [054191] = true,
    [054432] = true,
    [054445] = true,
    [054544] = true,
    [055786] = true,
    [056473] = true,
    [056637] = true,
    [056717] = true,
    [056719] = true,
    [056747] = true,
    [056754] = true,
    [056867] = true,
    [056884] = true,
    [058633] = true,
    [058722] = true,
    [058791] = true,
    [058812] = true,
    [058826] = true,
    [059080] = true,
    [059150] = true,
    [059153] = true,
    [059184] = true,
    [059193] = true,
    [059220] = true,
    [059303] = true,
    [059487] = true,
    [059551] = true,
    [059613] = true,
    [059684] = true,
    [061243] = true,
    [061338] = true,
    [061398] = true,
    [061399] = true,
    [061442] = true,
    [061444] = true,
    [061485] = true,
    [061634] = true,
    [061699] = true,
    [062205] = true,
    [063508] = true,
    [064587] = true,
    [065310] = true,
    [072656] = true,
    [073967] = true,
    [074446] = true,
    [074462] = true,
    [074476] = true,
    [074505] = true,
    [074508] = true,
    [074518] = true,
    [074555] = true,
    [074570] = true,
    [074728] = true,
    [074790] = true,
    [074900] = true,
    [074948] = true,
    [075001] = true,
    [075247] = true,
    [075358] = true,
    [075927] = true,
    [076143] = true,
    [076146] = true,
    [076172] = true,
    [076266] = true,
    [076292] = true,
    [076306] = true,
    [076307] = true,
    [076309] = true,
    [076310] = true,
    [076846] = true,
    [077349] = true,
    [077431] = true,
    [077684] = true,
    [079505] = true,
    [080250] = true,
    [081528] = true,
    [085653] = true,
    [090435] = true,
    [090705] = true,
    [091657] = true,
    [091782] = true,
    [091784] = true,
    [091789] = true,
    [091797] = true,
    [091808] = true,
    [092911] = true,
    [093023] = true,
    [093093] = true,
    [093813] = true,
    [093968] = true,
    [094283] = true,
    [094284] = true,
    [094285] = true,
    [095813] = true,
    [095843] = true,
    [095852] = true,
    [095939] = true,
    [096028] = true,
    [097171] = true,
    [097202] = true,
    [100248] = true,
    [100249] = true,
    [100250] = true,
    [100497] = true,
    [102672] = true,
    [102679] = true,
    [103685] = true,
    [103758] = true,
    [104288] = true,
    [104415] = true,
    [104534] = true,
    [104636] = true,
    [105304] = true,
    [105393] = true,
    [105591] = true,
    [105906] = true,
    [106087] = true,
    [109038] = true,
    [109040] = true,
    [109041] = true,
    [111004] = true,
    [111022] = true,
    [111151] = true,
    [111164] = true,
    [111166] = true,
    [111170] = true,
    [111331] = true,
    [111398] = true,
    [111528] = true,
    [111852] = true,
    [111933] = true,
    [111980] = true,
    [112596] = true,
    [112973] = true,
    [113043] = true,
    [113920] = true,
    [115905] = true,
    [116407] = true,
    [116691] = true,
    [117047] = true,
    [117059] = true,
    [117269] = true,
    [118022] = true,
    [118289] = true,
    [118460] = true,
    [118462] = true,
    [118523] = true,
    [118729] = true,
    [119107] = true,
    [120019] = true,
    [120021] = true,
    [120354] = true,
    [120463] = true,
    [120651] = true,
    [120777] = true,
    [120850] = true,
    [121399] = true,
    [121400] = true,
    [121975] = true,
    [122104] = true,
    [122135] = true,
    [122366] = true,
    [122367] = true,
    [122369] = true,
    [122467] = true,
    [122468] = true,
    [122477] = true,
    [122965] = true,
    [122968] = true,
    [122971] = true,
    [122984] = true,
    [123398] = true,
    [123402] = true,
    [123502] = true,
    [123533] = true,
    [123680] = true,
    [123726] = true,
    [123760] = true,
    [124158] = true,
    [124159] = true,
    [124207] = true,
    [124227] = true,
    [124719] = true,
    [124828] = true,
    [125254] = true,
    [125479] = true,
    [125535] = true,
    [125570] = true,
    [125587] = true,
    [125977] = true,
    [126199] = true,
    [126338] = true,
    [126767] = true,
    [126776] = true,
    [126832] = true,
    [126845] = true,
    [126848] = true,
    [126864] = true,
    [126888] = true,
    [126910] = true,
    [126963] = true,
    [126983] = true,
    [127021] = true,
    [127050] = true,
    [127072] = true,
    [127106] = true,
    [127192] = true,
    [127231] = true,
    [127235] = true,
    [127315] = true,
    [127479] = true,
    [127484] = true,
    [127490] = true,
    [127503] = true,
    [127723] = true,
    [127732] = true,
    [127810] = true,
    [128060] = true,
    [128074] = true,
    [128184] = true,
    [128455] = true,
    [128584] = true,
    [128610] = true,
    [128649] = true,
    [128650] = true,
    [128651] = true,
    [128652] = true,
    [128930] = true,
    [128969] = true,
    [129208] = true,
    [129214] = true,
    [129227] = true,
    [129231] = true,
    [129369] = true,
    [129486] = true,
    [129552] = true,
    [129553] = true,
    [129602] = true,
    [129699] = true,
    [129802] = true,
    [130025] = true,
    [130400] = true,
    [130404] = true,
    [130655] = true,
    [130912] = true,
    [131156] = true,
    [131157] = true,
    [131318] = true,
    [131383] = true,
    [131436] = true,
    [131486] = true,
    [131527] = true,
    [131545] = true,
    [131577] = true,
    [131667] = true,
    [131670] = true,
    [131677] = true,
    [131789] = true,
    [131812] = true,
    [131817] = true,
    [131823] = true,
    [131824] = true,
    [131825] = true,
    [131863] = true,
    [131864] = true,
    [131974] = true,
    [132047] = true,
    [132056] = true,
    [132074] = true,
    [132253] = true,
    [132701] = true,
    [132713] = true,
    [132998] = true,
    [133007] = true,
    [133172] = true,
    [133298] = true,
    [133379] = true,
    [133384] = true,
    [133389] = true,
    [133430] = true,
    [133436] = true,
    [133439] = true,
    [133463] = true,
    [133482] = true,
    [133492] = true,
    [133510] = true,
    [133912] = true,
    [133935] = true,
    [134002] = true,
    [134010] = true,
    [134012] = true,
    [134034] = true,
    [134056] = true,
    [134058] = true,
    [134060] = true,
    [134063] = true,
    [134069] = true,
    [134112] = true,
    [134144] = true,
    [134150] = true,
    [134158] = true,
    [134174] = true,
    [134176] = true,
    [134251] = true,
    [134331] = true,
    [134417] = true,
    [134442] = true,
    [134445] = true,
    [134590] = true,
    [134629] = true,
    [134635] = true,
    [134637] = true,
    [134691] = true,
    [134701] = true,
    [134717] = true,
    [134739] = true,
    [134828] = true,
    [134991] = true,
    [134993] = true,
    [135016] = true,
    [135164] = true,
    [135231] = true,
    [135245] = true,
    [135263] = true,
    [135322] = true,
    [135329] = true,
    [135365] = true,
    [135452] = true,
    [135470] = true,
    [135472] = true,
    [135475] = true,
    [135706] = true,
    [135759] = true,
    [135761] = true,
    [135764] = true,
    [135765] = true,
    [135770] = true,
    [136076] = true,
    [136083] = true,
    [136100] = true,
    [136160] = true,
    [136203] = true,
    [136214] = true,
    [136249] = true,
    [136250] = true,
    [136254] = true,
    [136270] = true,
    [136295] = true,
    [136297] = true,
    [136323] = true,
    [136330] = true,
    [136353] = true,
    [136385] = true,
    [136391] = true,
    [136493] = true,
    [136502] = true,
    [136510] = true,
    [136549] = true,
    [136601] = true,
    [136613] = true,
    [136633] = true,
    [136684] = true,
    [136984] = true,
    [137068] = true,
    [137098] = true,
    [137119] = true,
    [137197] = true,
    [137204] = true,
    [137321] = true,
    [137442] = true,
    [137443] = true,
    [137474] = true,
    [137478] = true,
    [137484] = true,
    [137486] = true,
    [137487] = true,
    [137573] = true,
    [137591] = true,
    [137614] = true,
    [137625] = true,
    [137649] = true,
    [137665] = true,
    [137704] = true,
    [137708] = true,
    [137881] = true,
    [137969] = true,
    [137983] = true,
    [138027] = true,
    [138129] = true,
    [138130] = true,
    [138132] = true,
    [138201] = true,
    [138255] = true,
    [138279] = true,
    [138281] = true,
    [138288] = true,
    [138299] = true,
    [138338] = true,
    [138465] = true,
    [138489] = true,
    [138529] = true,
    [138967] = true,
    [139051] = true,
    [139110] = true,
    [139233] = true,
    [139270] = true,
    [139381] = true,
    [139422] = true,
    [139425] = true,
    [139487] = true,
    [139946] = true,
    [140163] = true,
    [140252] = true,
    [140393] = true,
    [140398] = true,
    [140447] = true,
    [140599] = true,
    [140603] = true,
    [140615] = true,
    [140768] = true,
    [140769] = true,
    [140770] = true,
    [140773] = true,
    [140777] = true,
    [140902] = true,
    [140949] = true,
    [141264] = true,
    [141266] = true,
    [141354] = true,
    [141668] = true,
    [141780] = true,
    [141806] = true,
    [142148] = true,
    [142207] = true,
    [142219] = true,
    [142242] = true,
    [142243] = true,
    [142308] = true,
    [142423] = true,
    [142433] = true,
    [142440] = true,
    [142508] = true,
    [142802] = true,
    [144086] = true,
    [144137] = true,
    [144246] = true,
    [144248] = true,
    [144293] = true,
    [144298] = true,
    [144680] = true,
    [144722] = true,
    [144733] = true,
    [144747] = true,
    [144754] = true,
    [144755] = true,
    [144759] = true,
    [144765] = true,
    [144767] = true,
    [144855] = true,
    [144860] = true,
    [144876] = true,
    [144941] = true,
    [144946] = true,
    [144963] = true,
    [144975] = true,
    [145000] = true,
    [145123] = true,
    [145185] = true,
    [145261] = true,
    [145273] = true,
    [145274] = true,
    [145371] = true,
    [145391] = true,
    [145408] = true,
    [145898] = true,
    [145903] = true,
    [146125] = true,
    [146253] = true,
    [146256] = true,
    [146322] = true,
    [146367] = true,
    [146436] = true,
    [146485] = true,
    [146505] = true,
    [146731] = true,
    [146756] = true,
    [146829] = true,
    [146942] = true,
    [147032] = true,
    [147033] = true,
    [147376] = true,
    [147411] = true,
    [147708] = true,
    [147745] = true,
    [147828] = true,
    [147897] = true,
    [148243] = true,
    [148262] = true,
    [148308] = true,
    [148343] = true,
    [148403] = true,
    [148443] = true,
    [148522] = true,
    [148534] = true,
    [148550] = true,
    [148597] = true,
    [148607] = true,
    [148611] = true,
    [148613] = true,
    [148615] = true,
    [148617] = true,
    [148618] = true,
    [148619] = true,
    [148621] = true,
    [148631] = true,
    [148667] = true,
    [148673] = true,
    [148782] = true,
    [148890] = true,
    [148907] = true,
    [148962] = true,
    [149098] = true,
    [149144] = true,
    [149164] = true,
    [149311] = true,
    [149508] = true,
    [149555] = true,
    [149911] = true,
    [150159] = true,
    [150160] = true,
    [150222] = true,
    [150276] = true,
    [150292] = true,
    [150295] = true,
    [150394] = true,
    [150397] = true,
    [150653] = true,
    [150712] = true,
    [150773] = true,
    [150846] = true,
    [150848] = true,
    [151041] = true,
    [151059] = true,
    [151124] = true,
    [151157] = true,
    [151202] = true,
    [151301] = true,
    [151640] = true,
    [151739] = true,
    [151740] = true,
    [151832] = true,
    [151852] = true,
    [151881] = true,
    [151900] = true,
    [151933] = true,
    [151934] = true,
    [151940] = true,
    [152009] = true,
    [152089] = true,
    [152199] = true,
    [152312] = true,
    [152313] = true,
    [152364] = true,
    [152397] = true,
    [152512] = true,
    [152566] = true,
    [152567] = true,
    [152568] = true,
    [152671] = true,
    [152697] = true,
    [152718] = true,
    [152729] = true,
    [152736] = true,
    [152958] = true,
    [152961] = true,
    [152969] = true,
    [153261] = true,
    [153307] = true,
    [153309] = true,
    [153310] = true,
    [153327] = true,
    [153377] = true,
    [153500] = true,
    [153501] = true,
    [153502] = true,
    [153532] = true,
    [153534] = true,
    [153541] = true,
    [153755] = true,
    [153942] = true,
    [154087] = true,
    [154175] = true,
    [154330] = true,
    [154332] = true,
    [154342] = true,
    [154414] = true,
    [154457] = true,
    [154459] = true,
    [154495] = true,
    [154564] = true,
    [154565] = true,
    [154583] = true,
    [154641] = true,
    [154727] = true,
    [154816] = true,
    [154968] = true,
    [155098] = true,
    [155110] = true,
    [155139] = true,
    [155273] = true,
    [155275] = true,
    [155278] = true,
    [155432] = true,
    [155433] = true,
    [155616] = true,
    [155634] = true,
    [155702] = true,
    [155723] = true,
    [155764] = true,
    [155767] = true,
    [155768] = true,
    [155859] = true,
    [155873] = true,
    [155899] = true,
    [155900] = true,
    [155958] = true,
    [156523] = true,
    [156575] = true,
    [156650] = true,
    [156818] = true,
    [156849] = true,
    [156865] = true,
    [156884] = true,
    [156949] = true,
    [156980] = true,
    [157231] = true,
    [157238] = true,
    [157253] = true,
    [157254] = true,
    [157279] = true,
    [157354] = true,
    [157366] = true,
    [157461] = true,
    [157467] = true,
    [157475] = true,
    [157486] = true,
    [157620] = true,
    [158035] = true,
    [158041] = true,
    [158136] = true,
    [158157] = true,
    [158158] = true,
    [158314] = true,
    [158315] = true,
    [158327] = true,
    [158328] = true,
    [158343] = true,
    [158367] = true,
    [158371] = true,
    [158376] = true,
    [158406] = true,
    [158568] = true,
    [158636] = true,
    [158642] = true,
    [158781] = true,
    [158790] = true,
    [158891] = true,
    [159219] = true,
    [159224] = true,
    [159303] = true,
    [159320] = true,
    [159321] = true,
    [159503] = true,
    [159510] = true,
    [159578] = true,
    [159764] = true,
    [159767] = true,
    [159768] = true,
    [160249] = true,
    [160770] = true,
    [160970] = true,
    [161112] = true,
    [161113] = true,
    [161124] = true,
    [161173] = true,
    [161218] = true,
    [161241] = true,
    [161243] = true,
    [161244] = true,
    [161286] = true,
    [161312] = true,
    [161334] = true,
    [161335] = true,
    [161416] = true,
    [161571] = true,
    [161745] = true,
    [161746] = true,
    [162038] = true,
    [162040] = true,
    [162047] = true,
    [162057] = true,
    [162058] = true,
    [162059] = true,
    [162060] = true,
    [162061] = true,
    [162099] = true,
    [162100] = true,
    [162102] = true,
    [162103] = true,
    [162133] = true,
    [162163] = true,
    [162170] = true,
    [162181] = true,
    [162303] = true,
    [162305] = true,
    [162306] = true,
    [162309] = true,
    [162317] = true,
    [162329] = true,
    [162417] = true,
    [162452] = true,
    [162508] = true,
    [162534] = true,
    [162647] = true,
    [162689] = true,
    [162691] = true,
    [162693] = true,
    [162718] = true,
    [162719] = true,
    [162744] = true,
    [162763] = true,
    [162829] = true,
    [162845] = true,
    [162853] = true,
    [162872] = true,
    [162873] = true,
    [162880] = true,
    [162933] = true,
    [162965] = true,
    [163077] = true,
    [163086] = true,
    [163304] = true,
    [163520] = true,
    [163620] = true,
    [163621] = true,
    [163708] = true,
    [163882] = true,
    [163894] = true,
    [164185] = true,
    [164218] = true,
    [164255] = true,
    [164266] = true,
    [164406] = true,
    [164407] = true,
    [164450] = true,
    [164461] = true,
    [164463] = true,
    [164501] = true,
    [164517] = true,
    [164547] = true,
    [164555] = true,
    [164556] = true,
    [164557] = true,
    [164558] = true,
    [164567] = true,
    [164578] = true,
    [164698] = true,
    [164804] = true,
    [164926] = true,
    [164929] = true,
    [164967] = true,
    [165066] = true,
    [165067] = true,
    [165108] = true,
    [165137] = true,
    [165197] = true,
    [165315] = true,
    [165408] = true,
    [165410] = true,
    [165430] = true,
    [165479] = true,
    [165481] = true,
    [165483] = true,
    [165764] = true,
    [165805] = true,
    [165824] = true,
    [165830] = true,
    [165919] = true,
    [165946] = true,
    [166135] = true,
    [166140] = true,
    [166142] = true,
    [166146] = true,
    [166393] = true,
    [166521] = true,
    [166644] = true,
    [166969] = true,
    [166970] = true,
    [167111] = true,
    [167527] = true,
    [167533] = true,
    [167534] = true,
    [167536] = true,
    [167538] = true,
    [167566] = true,
    [167607] = true,
    [167612] = true,
    [167731] = true,
    [167876] = true,
    [167962] = true,
    [167964] = true,
    [167998] = true,
    [168058] = true,
    [168113] = true,
    [168153] = true,
    [168318] = true,
    [168326] = true,
    [168337] = true,
    [168393] = true,
    [168396] = true,
    [168681] = true,
    [168693] = true,
    [168843] = true,
    [168844] = true,
    [168845] = true,
    [168886] = true,
    [168934] = true,
    [168942] = true,
    [168973] = true,
    [169035] = true,
    [169102] = true,
    [169157] = true,
    [169175] = true,
    [169286] = true,
    [169457] = true,
    [169458] = true,
    [169498] = true,
    [169630] = true,
    [169861] = true,
    [169893] = true,
    [169905] = true,
    [170160] = true,
    [170199] = true,
    [170234] = true,
    [170301] = true,
    [170302] = true,
    [170483] = true,
    [170572] = true,
    [170634] = true,
    [170692] = true,
    [170711] = true,
    [170774] = true,
    [171184] = true,
    [171316] = true,
    [171317] = true,
    [171343] = true,
    [171376] = true,
    [171455] = true,
    [171799] = true,
    [172112] = true,
    [172981] = true,
    [173044] = true,
    [173142] = true,
    [173178] = true,
    [173190] = true,
    [173195] = true,
    [173276] = true,
    [173280] = true,
    [173444] = true,
    [173445] = true,
    [173446] = true,
    [173448] = true,
    [173464] = true,
    [173484] = true,
    [173604] = true,
    [173613] = true,
    [173655] = true,
    [173714] = true,
    [173720] = true,
    [173798] = true,
    [174012] = true,
    [174062] = true,
    [174063] = true,
    [174064] = true,
    [174066] = true,
    [174069] = true,
    [174070] = true,
    [174175] = true,
    [174194] = true,
    [174307] = true,
    [174336] = true,
    [175605] = true,
    [175821] = true,
    [175846] = true,
    [175877] = true,
    [175992] = true,
    [176173] = true,
   
    
    --[[
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [174175 ] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
    [] = true, --
   --]] 
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
            [332329] = { useKick = false, useCC = true, useRacial = true,                           }, --Devoted Sacrifice;         CC
            [332671] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Bladestorm;                CC
            [332666] = { useKick = true, useCC = false, useRacial = false,                          }, --Renew;                     Kick
            [332706] = { useKick = true, useCC = false, useRacial = false,                          }, --Heal;                      Kick
            [332612] = { useKick = true, useCC = false, useRacial = false,                          }, --Healing Wave;              Kick
            [332084] = { useKick = true, useCC = true, useRacial = true, ignoreInterval = true,  	}, --Self-Cleaning Cycle;       Kick
            [340026] = { useKick = false, useCC = true, useRacial = true,                           }, --Wailing Grief;             CC
            [321764] = { useKick = true, useCC = false, useRacial = false,                          }, --Bark Armor;         		Kick	
            [320008] = { useKick = true, useCC = false, useRacial = false,                          }, --Frostbolt;         		Kick
            [332608] = { useKick = true, useCC = false, useRacial = false,                          }, --Lightning Discharge;       Kick	
            [328729] = { useKick = true, useCC = false, useRacial = false,                          }, --Dark Lotus;         		Kick	
            [332605] = { useKick = true, useCC = true, useRacial = true,                            }, --Hex;                 		Kick+CC
            [332234] = { useKick = true, useCC = true, useRacial = true,                            }, --Essential Oil;        		Kick+CC
			[334664] = { useKick = false, useCC = true, useRacial = true,                           }, --Frightened Cries;         CC	
            [331379] = { useKick = true, useCC = false, useRacial = false,                          }, --Lubricate;        		Kick+CC
			[332156] = { useKick = false, useCC = true, useRacial = true,                           }, --Spinning Up;          	CC
            [332705] = { useKick = true, useCC = false, useRacial = false,                          }, --Smite;         			Kick			
            [333875] = { useKick = true, useCC = true, useRacial = true,                            }, --Death's Embrace;    		Kick+CC			
			-- Halls of Attonement
            [325523] = { useKick = false, useCC = true, useRacial = true,                           }, --Deadly Thrust;             CC
            [326450] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Loyal Beasts;              CC
            [325700] = { useKick = true, useCC = false, useRacial = false,                          }, --Collect Sins;              Kick
            [325701] = { useKick = true, useCC = true, useRacial = true,                            }, --Siphon Life;               Kick+CC
            [326607] = { useKick = true, useCC = false, useRacial = false,                          }, --Turn to Stone;             Kick
            [323552] = { useKick = true, useCC = false, useRacial = false,                          }, --Volley of Power;			Kick			
            [323538] = { useKick = true, useCC = false, useRacial = false,                          }, --Bolt of Power; 			Kick
            [301680] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Rapid Fire;             	CC			
            [326829] = { useKick = true, useCC = false, useRacial = false,                          }, --Wicked Bolt; 				Kick   
            [325876] = { useKick = true, useCC = false, useRacial = false,                          }, --Curse of Obliteration; 	Kick  			
			-- Mists of Tirna Scithe
            [322938] = { useKick = true, useCC = true, useRacial = true,                            }, --Harvest Essence;           Kick+CC 
            [324914] = { useKick = true, useCC = false, useRacial = false,                          }, --Nourish the Forest;        Kick
            [324776] = { useKick = true, useCC = false, useRacial = false,                          }, --Bramblethorn Coat;         Kick
            [326046] = { useKick = true, useCC = true, useRacial = true, ignoreInterval = true,     }, --Stimulate Resistance;      Kick+CC            
            [340544] = { useKick = true, useCC = true, useRacial = true, ignoreInterval = true,     }, --Stimulate Regeneration;    Kick+CC    
            [337235] = { useKick = true, useCC = false, useRacial = false,                          }, --Parasitic Pacification;    Kick
            [337251] = { useKick = true, useCC = false, useRacial = false                           }, --Parasitic Incapacitation;  Kick
            [337253] = { useKick = true, useCC = false, useRacial = false                           }, --Parasitic Domination;      Kick
            [326021] = { useKick = false, useCC = true, useRacial = true                            }, --Acid Globule;              CC			
            [331718] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Spear Flurry;              CC					
            [331743] = { useKick = false, useCC = true, useRacial = true                            }, --Bucking Rampage;           CC	
            [322450] = { useKick = true, useCC = false, useRacial = false                           }, --Consumption;      			Kick
            [322767] = { useKick = true, useCC = true, useRacial = true                             }, --Spirit Bolt;    			Kick+CC 			
            [324987] = { useKick = false, useCC = true, useRacial = true                            }, --Mistveil Bite;           	CC			
            [325021] = { useKick = false, useCC = true, useRacial = true                            }, --Mistveil Tear;           	CC				
            -- Necrotic Wake
            [320462] = { useKick = true, useCC = false, useRacial = false                           }, --Necrotic Bolt;             Kick            
            [324293] = { useKick = true, useCC = true, useRacial = true                             }, --Rasping Scream;            Kick+CC            
            [320170] = { useKick = true, useCC = false, useRacial = false                           }, --Necrotic Bolt;             Kick            
            [338353] = { useKick = true, useCC = true, useRacial = true                             }, --Goresplatter;              Kick+CC
            [334748] = { useKick = true, useCC = true, useRacial = true, ignoreInterval = true,     }, --Drain Fluids;              Kick+CC
            [323190] = { useKick = true, useCC = true, useRacial = true, ignoreInterval = true,     }, --meat shield;               Kick+CC			
            [335143] = { useKick = true, useCC = true, useRacial = true		                        }, --Bonemend;				    Kick+CC
            [327130] = { useKick = true, useCC = false, useRacial = false, ignoreInterval = true,   }, --Repair Flesh;              Kick
            [320822] = { useKick = false, useCC = true, useRacial = true                            }, --Final Bargain;             CC	
            [327240] = { useKick = false, useCC = true, useRacial = true                            }, --Spine Crush;             	CC
            [328667] = { useKick = true, useCC = true, useRacial = true		                        }, --Frostbolt Volley;		    Kick+CC
            [320571] = { useKick = true, useCC = false, useRacial = false                           }, --Shadow Well;             	Kick
            [321807] = { useKick = false, useCC = true, useRacial = true                            }, --Boneflay;             		CC   
            [322274] = { useKick = true, useCC = false, useRacial = false                           }, --Enfeeble                   Kick
            --Plaguefall
            [328177] = { useKick = false, useCC = true, useRacial = true,  ignoreInterval = true,   }, --Fungistorm;                CC                                   
            [330423] = { useKick = false, useCC = true, useRacial = true,  ignoreInterval = true,   }, --Fungistorm;                CC                                   
            [319070] = { useKick = true, useCC = false, useRacial = false                           }, --Corrosive Gunk;            Kick            
            [336451] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Bulwark of Maldraxxus;     CC            
            [328400] = { useKick = false, useCC = true, useRacial = true                            }, --Stealthlings;             	CC 
            [328180] = { useKick = true, useCC = true, useRacial = true                             }, --Gripping Infection; 		Kick+CC
            [321999] = { useKick = true, useCC = false, useRacial = false                           }, --Viral Globs;            	Kick
            [328429] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Crushing Embrace;         	CC
            [328094] = { useKick = true, useCC = false, useRacial = false                           }, --Pestilence Bolt;           Kick 	
            [329239] = { useKick = true, useCC = false, useRacial = false                           }, --Creepy Crawlers;           Kick 
            [321935] = { useKick = false, useCC = true, useRacial = true                            }, --Withering Filth;          	CC  
            [328016] = { useKick = true, useCC = true, useRacial = true                             }, --Wonder Grow                Kick+CC
            [327995] = { useKick = true, useCC = true, useRacial = true                             }, --Doomshroom                 Kick+CC
            --Sanguine Depths
            [319654] = { useKick = true, useCC = false, useRacial = false                           }, --Hungering Drain;           Kick
            [322433] = { useKick = true, useCC = false, useRacial = false                           }, --Stoneskin;                 Kick
            [321038] = { useKick = true, useCC = false, useRacial = false                           }, --Wrack Soul;                Kick 
            [334653] = { useKick = true, useCC = false, useRacial = false, ignoreInterval = true,   }, --Engorge; 					Kick
            [335305] = { useKick = true, useCC = false, useRacial = false                           }, --Barbed Shackles; 			Kick
            [336277] = { useKick = true, useCC = false, useRacial = false                           }, --Explosive Anger; 			Kick			
            [326952] = { useKick = true, useCC = false, useRacial = false                           }, --Fiery Cantrip 				Kick
            [324609] = { useKick = false, useCC = true, useRacial = true                            }, --Animate Weapon; 			CC
			[326836] = { useKick = true, useCC = true, useRacial = true                             }, --Curse of Suppression 		Kick+CC
            [326712] = { useKick = true, useCC = false, useRacial = false                           }, --Dark Bolt 					Kick
            [320861] = { useKick = true, useCC = false, useRacial = false                           }, --Drain Essence				Kick			
            [326837] = { useKick = true, useCC = false, useRacial = false                           }, --Gloom Burst				Kick				
            [321105] = { useKick = true, useCC = false, useRacial = false                           }, --Sap Lifeblood				Kick				
            --Spires of Ascension
            [327413] = { useKick = true, useCC = false, useRacial = false                           }, --Rebellious Fist;           Kick            
            [317936] = { useKick = true, useCC = false, useRacial = false                           }, --Forsworn Doctrine;         Kick            
            [317963] = { useKick = true, useCC = false, useRacial = false                           }, --Burden of Knowledge;       Kick
            [328295] = { useKick = true, useCC = true, useRacial = true                             }, --Greater Mending;           Kick+CC
            [328137] = { useKick = true, useCC = false, useRacial = false                           }, --Dark Pulse;                Kick
            [328331] = { useKick = true, useCC = false, useRacial = false                           }, --Forced Confession;         Kick
			[317661] = { useKick = true, useCC = false, useRacial = false                           }, --Insidious Venom;         	Kick
            [323804] = { useKick = false, useCC = true, useRacial = true                            }, --Dark Seeker;             	CC
            [327648] = { useKick = true, useCC = false, useRacial = false                           }, --Internal Strife;           Kick
            [327481] = { useKick = false, useCC = true, useRacial = true                            }, --Dark Lance;             	CC
            --Theater of Pain
            [341902] = { useKick = true, useCC = false, useRacial = false                           }, --Unholy Fervor;         	Kick            
            [341969] = { useKick = true, useCC = true, useRacial = true                             }, --Withering Discharge		Kick+CC
            [342139] = { useKick = true, useCC = false, useRacial = false                           }, --Battle Trance;         	Kick        
            [330562] = { useKick = true, useCC = false, useRacial = false                           }, --Demoralizing Shout;    	Kick
            [330810] = { useKick = true, useCC = true, useRacial = true                             }, --Bind Soul;             	Kick+CC  
            [330586] = { useKick = false, useCC = true, useRacial = true, ignoreInterval = true,    }, --Devour Flesh				CC 
            [342675] = { useKick = true, useCC = true, useRacial = true                             }, --Bone Spear;            	Kick+CC  
            [330868] = { useKick = true, useCC = true, useRacial = true                             }, --Necrotic Bolt volley;  	Kick+CC  
            [341771] = { useKick = true, useCC = false, useRacial = false                           }, --Grave Spike;				Kick			
			[330532] = { useKick = false, useCC = true, useRacial = true                            }, --Jagged Quarrel 			CC						
            [330875] = { useKick = true, useCC = false, useRacial = false                           }, --Spirit Frost;				Kick	
            [319669] = { useKick = true, useCC = false, useRacial = false                           }, --Spectral Reach;			Kick	
            [320300] = { useKick = true, useCC = false, useRacial = false                           }, --Necromantic Bolt;			Kick
            [320120] = { useKick = true, useCC = false, useRacial = false                           }, --Plague Bolt;				Kick			
            [341977] = { useKick = true, useCC = true, useRacial = true, ignoreInterval = true,     }, --Meat Shield;  				Kick+CC			
			-- Castle Nathria
            [325590] = { useKick = true, useCC = false, useRacial = false                           }, --Scornful Blast;			Kick
            [328254] = { useKick = true, useCC = false, useRacial = false                           }, --Shattering Ruby;			Kick
            [333002] = { useKick = true, useCC = false, useRacial = false                           }, --Vulgar Brand;				Kick
            [337110] = { useKick = true, useCC = false, useRacial = false                           }, --Dreadbolt Volley;			Kick
            --Tazavesh
            [354297] = { useKick = true, useCC = false, useRacial = false                           }, --Hyperlight Bolt           Kick
            [356537] = { useKick = true, useCC = false, useRacial = false                           }, --Empowered Glyph of Restraint         Kick
            [357404] = { useKick = true, useCC = false, useRacial = false                           }, --Dischordant Song          Kick
            [357188] = { useKick = true, useCC = false, useRacial = false                           }, --Double Technique          Kick
            [347150] = { useKick = true, useCC = false, useRacial = false                           }, --Triple Technique          Kick
            [358131] = { useKick = true, useCC = false, useRacial = false                           }, --Lightning Nova            Kick
            --Sanctum of Domination
            [350283] = { useKick = true, useCC = false, useRacial = false                           }, -- Kick Soulful Blast
            [350286] = { useKick = true, useCC = false, useRacial = false, ignoreInterval = true,   }, -- Kick Song of Dissolution
            [351779] = { useKick = true, useCC = false, useRacial = false                           }, -- Kick    --Agonizing Nova
            [348428] = { useKick = true, useCC = false, useRacial = false                           }, -- Kick Piercing Wail
            [355540] = { useKick = true, useCC = false, useRacial = false, ignoreInterval = true,   }, -- Kick    --Ruin

            --[[ Templates
            [] = { useKick = false, useCC = false, useRacial = false}    , -- Block
            [] = { useKick = true, useCC = true, useRacial = true    }, -- Kick+CC
            [] = { useKick = true, useCC = false, useRacial = false    }, -- Kick
            [] = { useKick = false, useCC = true, useRacial = true    }, -- CC
            --]]
            
        },
    }, 43, 70, math_random(87, 95), true)

