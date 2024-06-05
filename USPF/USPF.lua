if USPF == nil then USPF = {} end
USPF.AddonName = "USPF"
USPF.version = 1.0
USPF.active = false
USPF.cache = {}
USPF.GUI = {}
local selectedChar = GetCurrentCharacterId()
local currentCharName = nil
local GZNBId, GCCId, GCQI = GetZoneNameById, GetCurrentCharacterId, GetCompletedQuestInfo
local IAchC = IsAchievementComplete
local GS, zf, strF = GetString, zo_strformat, string.format

local USPF_LTF = LibTableFunctions
if not USPF_LTF then return end

local USPF_LIST_DATA_TYPE = 1
local USPF_LIST_SEPARATOR_TYPE = 2

USPF.settings = {
	title = {font = "ProseAntique",},
	GSP = {
		font = "Univers 57",
		doneColor = {1, 1, 1},
		needColor = {1, 1, 1},
		progColor = {1, 1, 1},
	},
	SQS = {
		font = "Univers 57",
		doneColorSS = {1, 1, 1},
		doneColorZQ = {1, 1, 1},
		needColorSS = {1, 0, 0},
		needColorZQ = {1, 0, 0},
		progColorSS = {0.7843, 0.3922, 0},
		progColorZQ = {0.7843, 0.3922, 0},
		sortCol = 1,
	},
	GDQ = {
		font = "Univers 57",
		doneColor = {1, 1, 1},
		needColor = {1, 0, 0},
		sortCol = 1,
	},
	PDB = {
		font = "Univers 57",
		doneColor = {1, 1, 1},
		needColor = {1, 0, 0},
		sortCol = 1,
	},
	FD = {
		override = false,
		charHasFD = false,
	},
	MWC = false,
	SSC = false,
	EWC = false,
	GMC = false,
	BWC = false,
}

USPF.defaults = {
	charInfo = {},
	settings = {},
	ptsData = {},
}


USPF.ptsData = {
	Tot	= 0, GenTot	= 0, ZQTot	= 0, numSSTot	= 0, SSTot	= 0,
	GDTot	= 0, PDTot	= 0, Level	= 0, MainQ	= 0, FolDis	= 0,
	MWChar	= 0, SUChar	= 0, EWChar	= 0, GMChar	= 0, BWChar = 0,
	PvPRank	= 0, MaelAr	= 0, EndlArch	= 0, Unassigned = nil,
	ZQ = {
		AD0 = 0, AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5  = 0, DC0a = 0, DC0b = 0,
		DC1 = 0, DC2 = 0, DC3 = 0, DC4 = 0, DC5 = 0, EP0a = 0, EP0b = 0, EP1  = 0,
		EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL = 0, CC  = 0, GC  = 0, IC   = 0, VV   = 0, WR   = 0,
		HB  = 0, SU  = 0, MM  = 0, NE  = 0, WP  = 0, SE   = 0, WS   = 0, TR   = 0,
		BW  = 0, TD  = 0, HI  = 0, GY  = 0, AP  = 0, WW   = 0,
	},
	SS = {
		AD0 = 0, AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5  = 0, DC0a = 0, DC0b = 0,
		DC1 = 0, DC2 = 0, DC3 = 0, DC4 = 0, DC5 = 0, EP0a = 0, EP0b = 0, EP1  = 0,
		EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL = 0, IC  = 0, WR  = 0, HB   = 0, GC   = 0, VV   = 0,
		CC  = 0, WP  = 0, SU  = 0, MM  = 0, NE  = 0, SE   = 0, WS   = 0, TR   = 0,
		BW  = 0, TD  = 0, HI  = 0, GY  = 0, AP  = 0, WW   = 0,
	},
	GD = {
		BC1 = 0, BC2 = 0, EH1 = 0, EH2 = 0, CA1 = 0, CA2 = 0, TI = 0, SW = 0,
		SC1 = 0, SC2 = 0, WS1 = 0, WS2 = 0, CH1 = 0, CH2 = 0, VF = 0, BH = 0,
		FG1 = 0, FG2 = 0, DC1 = 0, DC2 = 0, AC  = 0, DK  = 0, BC = 0, VM = 0,
		WGT = 0, ICP = 0, RM  = 0, CS  = 0, BF  = 0, FH  = 0, FL = 0, SP = 0,
		MHK = 0, MOS = 0, DoM = 0, FV  = 0, LM  = 0, MF  = 0, IR = 0, UG = 0,
		SG  = 0, CT  = 0, BDV = 0, TC  = 0, RPB = 0, TDC = 0, CA = 0, SR = 0,
		ERE = 0, GD  = 0, BS  = 0, SH  = 0, OP  = 0, BV  = 0,
	},
	PD = {
		AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5 = 0, DC1 = 0, DC2 = 0, DC3 = 0,
		DC4 = 0, DC5 = 0, EP1 = 0, EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0,
		VFW = 0, VNC = 0, WOO = 0, WRK = 0, SKW = 0, SSH = 0, RN  = 0, OC  = 0,
		LT  = 0, NK  = 0, SH  = 0, ZA  = 0, GHB = 0, SCC = 0, GO  = 0, TU  = 0,
		LW  = 0, SI  = 0,
	},
}

local function USPF_CalculateTotalPoints()
	local quests = 0
	local skyshards = 0
	for _, zi in ipairs(USPF.data.zones) do
		quests = quests + #zi.quests
		skyshards = skyshards + zi.skyshards[2]
	end

	local points = {
		ZQTot = quests,
		numSSTot = skyshards,
		SSTot = math.floor(skyshards / 3),
		GDTot = #USPF.data.GD,
		PDTot = #USPF.data.PD,
		Level = 64,
		MainQ = #USPF.data.MQ,
		FolDis = 2,
		PvPRank = 50,
		MaelAr = 1,
		EndlArch = 1
	}

	local tutorial = 1
	points.GenTot = points.Level + points.MainQ + points.FolDis + tutorial + points.PvPRank + points.MaelAr + points.EndlArch
	points.Tot = points.GenTot + points.GDTot + points.ZQTot + points.SSTot + points.PDTot

	return points
end

local tempZId = {
	ZN = {
		AD0  =  537, AD1  =  381, AD2  =  383, AD3 =  108, AD4 =  58, AD5 =  382,
		DC0a =  535, DC0b =  534, DC1  =    3, DC2 =   19, DC3 =  20, DC4 =  104,
		DC5  =   92, EP0b =  280, EP0a =  281, EP1 =   41, EP2 =  57, EP3 =  117,
		EP4  =  101, EP5  =  103, CH   =  347, CYD =  181, CAD = 181, CDC =  181,
		CEP  =  181, CMT  =  181, CL   =  888, LCL =  888, UCL = 888, IC  =  584,
		WR   =  684, HB   =  816, GC   =  823, VV  =  849, CC  = 980, SU  = 1011,
		MM   =  726, NE   = 1086, WP   =  586, SE  = 1133, WS = 1160, BGC = 1161,
		TR   = 1207, BW   = 1261, TD   = 1286, HI  = 1318, GY = 1383, AP  = 1413,
		TP   = 1414, EA   = 1436, WW   = 1443,
	},
}

local zones = {
	{
		key = "WP",
		quests = {}, -- none
		skyshards = { 259, 1 },
	},
	{
		key = "AD0",
		quests = {}, -- none
		skyshards = { 87,  6},
	},
	{
		key = "AD1",
		quests = {
			4222,
			4345,
			4261,
		},
		skyshards = { 93, 16},
	},
	{
		key = "AD2",
		quests = {
			4868,
			4386,
			4885,
		},
		skyshards = {109, 16},
	},
	{
		key = "AD3",
		quests = {
			4750,
			4765,
			4690,
		},
		skyshards = {125, 16},
	},
	{
		key = "AD4",
		quests = {
			4337,
			4452,
			4143,
		},
		skyshards = {141, 16},
	},
	{
		key = "AD5",
		quests = {
			4712,
			4479,
			4720,
		},
		skyshards = {157, 16},
	},
	{
		key = "DC0b",
		quests = {}, -- none
		skyshards = {173,  3},
	},
	{
		key = "DC0a",
		quests = {}, -- none
		skyshards = {176,  3},
	},
	{
		key = "DC1",
		quests = {
			3006,
			3235,
			3267,
			3379,
		},
		skyshards = {179, 16},
	},
	{
		key = "DC2",
		quests = {
			467,
			1633,
			575,
		},
		skyshards = {195, 16},
	},
	{
		key = "DC3",
		quests = {
			465,
			4972,
			4884,
		},
		skyshards = {211, 16},
	},
	{
		key = "DC4",
		quests = {
			2192,
			2222,
			2997,
		},
		skyshards = {227, 16},
	},
	{
		key = "DC5",
		quests = {
			4891,
			4912,
			4960,
		},
		skyshards = {243, 16},
	},
	{
		key = "EP0b",
		quests = {}, -- none
		skyshards = {  1,  3},
	},
	{
		key = "EP0a",
		quests = {}, -- none
		skyshards = {  4,  3},
	},
	{
		key = "EP1",
		quests = {
			3735,
			3634,
			3868,
		},
		skyshards = {  7, 16},
	},
	{
		key = "EP2",
		quests = {
			3797,
			3817,
			3831,
		},
		skyshards = { 23, 16},
	},
	{
		key = "EP3",
		quests = {
			4590,
			4606,
			3910,
		},
		skyshards = { 39, 16},
	},
	{
		key = "EP4",
		quests = {
			4061,
			4115,
			4117,
		},
		skyshards = { 55, 16},
	},
	{
		key = "EP5",
		quests = {
			3968,
			4139,
			4188,
		},
		skyshards = { 71, 16},
	},
	{
		key = "CH",
		quests = {
			4602,
			4730,
			4758,
		},
		skyshards = {260, 16},
	},
	{
		key = "CAD",
		quests = {}, -- none
		skyshards = {306, 15},
	},
	{
		key = "CDC",
		quests = {}, -- none
		skyshards = {291, 15},
	},
	{
		key = "CEP",
		quests = {}, -- none
		skyshards = {276, 15},
	},
	{
		key = "CMT",
		quests = {}, -- none
		skyshards = {321,  1},
	},
	{
		key = "LCL",
		quests = {}, -- none
		skyshards = {322, 12},
	},
	{
		key = "UCL",
		quests = {}, -- none
		skyshards = {334,  6},
	},
	{
		key = "IC",
		quests = {
			5482,
		},
		skyshards = {340, 13},
	},
	{
		key = "WR",
		quests = {
			5447,
			5468,
			5481,
		},
		skyshards = {353, 17},
	},
	{
		key = "HB",
		quests = {
			5531,
			5534,
			5532,
			5556,
			5549,
			5545,
		},
		skyshards = {370,  6},
	},
	{
		key = "GC",
		quests = {
			5540,
			5595,
			5599,
			5596,
			5567,
			5597,
			5598,
			5600,
		},
		skyshards = {376,  6},
	},
	{
		key = "VV",
		quests = {
			6003,
			5922,
			5948,
		},
		skyshards = {382, 18},
	},
	{
		key = "CC",
		quests = {
			6050,
			6057,
			6063,
			6025,
			6052,
			6046,
			6047,
			6048,
		},
		skyshards = {400,  6},
	},
	{
		key = "SU",
		quests = {
			6132,
			6113,
			6126,
		},
		skyshards = {406, 18},
	},
	{
		key = "MM",
		quests = {
			6246,
			6266,
			6241,
			6259,
			6243,
			6244,
			6245,
		},
		skyshards = {424,  6},
	},
	{
		key = "NE",
		quests = {
			6336,
			6304,
			6315,
		},
		skyshards = {430, 18},
	},
	{
		key = "SE",
		quests = {
			6401,
			6409,
			6394,
			6399,
			6403,
			6404,
			6393,
			6397,
			6402,
		},
		skyshards = {448,  6},
	},
	{
		key = "WS",
		quests = {
			6476,
			6466,
			6481,
		},
		skyshards = {454, 18},
	},
	{
		key = "TR",
		quests = {
			6550,
			6551,
			6547,
			6548,
			6554,
			6566,
			6552,
			6560,
			6570,
		},
		skyshards = {472,  6},
	},
	{
		key = "BW",
		quests = {
			6616,
			6619,
			6660,
		},
		skyshards = {478, 18},
	},
	{
		key = "TD",
		quests = {
			6723,
			6724,
			6707,
			6708,
			6699,
			6700,
			6696,
			6697,
			6693,
		},
		skyshards = {496,  6},
	},
	{
		key = "HI",
		quests = {
			6753, -- Peaople of Import
			6765, -- To Catch a Magus
			6781, -- A Chance for Peace
			6762, -- Buried at the Bay - PD quest
			6768, -- Blood, Books, and Steel - PD quest
		},
		skyshards = {504, 18},
	},
	{
		key = "GY",
		quests = {
			6849, -- A Sea of Troubles - MQ 1
			6850, -- Tides of Ruin - MQ 2
			6855, -- Seeds of Destruction - MQ 3
			6859, -- City Under Siege - MQ 4
			6852, -- The Dream of Kasorayn - MQ 5
			6853, -- Guardian of Y'ffelon - MQ 6
			6847, -- The Hidden Lord - Epilogue 1
			6848, -- The Ivy Throne - Epilogue 2
			6894, -- And Now, Perhaps, Peace - Epilogue 3
		},
		skyshards = {522,  6},
	},
	{
		key = "AP",
		quests = {
			6971, -- Fate's Proxy
			6972, -- Keeper Of the Fate
			6973, -- Spirit Of Fate
			6974, -- Fate's Lost dream
			6975, -- A Hidden Fate
			6976, -- Conclave of Fate
			7025, -- A Calamity of Fate
			6991, -- An Unhealthy Fate
			6977, -- Chronicle of Fate
		},
		skyshards = {528, 18},
	},
	{
		key = "WW",
		quests = {
			7071, -- Paths of Chaos
			7072, -- Seeds of Suspicion
			7073, -- Relics of the Three Princes
			7074, -- King Nantharion's Gambit
			7075, -- The Untraveled Road
			7076, -- Ithelia's Fury
			7077, -- Fate of the Forgotten Prince
			7078, -- In Memory Of
		},
		skyshards = {546, 18},
	},
}

USPF.data = {
	ZId = tempZId,
	MAAch = 1304,
	zones = zones,
	tutorials = {
		EO = 6324,
		MO = 5804,
		SO = 6143,
		GO = 6455,
		BO = 6646,
	},
	GD = {
		{ key = "BC1", id = 380, zone = "AD1", quest = 4107 },
		{ key = "BC2", id = 935, zone = "AD1", quest = 4597 },
		{ key = "EH1", id = 126, zone = "AD2", quest = 4336 },
		{ key = "EH2", id = 931, zone = "AD2", quest = 4675 },
		{ key = "CA1", id = 176, zone = "AD3", quest = 4778 },
		{ key = "CA2", id = 681, zone = "AD3", quest = 5120 },
		{ key = "TI", id = 131, zone = "AD4", quest = 4538 },
		{ key = "SW", id = 31, zone = "AD5", quest = 4733 },
		{ key = "SC1", id = 144, zone = "DC1", quest = 4054 },
		{ key = "SC2", id = 936, zone = "DC1", quest = 4555 },
		{ key = "WS1", id = 146, zone = "DC2", quest = 4246 },
		{ key = "WS2", id = 933, zone = "DC2", quest = 4813 },
		{ key = "CH1", id = 130, zone = "DC3", quest = 4379 },
		{ key = "CH2", id = 932, zone = "DC3", quest = 5113 },
		{ key = "VF", id = 22, zone = "DC4", quest = 4432 },
		{ key = "BH", id = 38, zone = "DC5", quest = 4589 },
		{ key = "FG1", id = 283, zone = "EP1", quest = 3993 },
		{ key = "FG2", id = 934, zone = "EP1", quest = 4303 },
		{ key = "DC1", id = 63, zone = "EP2", quest = 4145 },
		{ key = "DC2", id = 930, zone = "EP2", quest = 4641 },
		{ key = "AC", id = 148, zone = "EP3", quest = 4202 },
		{ key = "DK", id = 449, zone = "EP4", quest = 4346 },
		{ key = "BC", id = 64, zone = "EP5", quest = 4469 },
		{ key = "VM", id = 11, zone = "CH", quest = 4822 },
		{ key = "ICP", id = 678, zone = "CYD", quest = 5136 },
		{ key = "WGT", id = 688, zone = "CYD", quest = 5342 },
		{ key = "CS", id = 848, zone = "EP3", quest = 5702 },
		{ key = "RM", id = 843, zone = "EP3", quest = 5403 },
		{ key = "BF", id = 973, zone = "LCL", quest = 5889 },
		{ key = "FH", id = 974, zone = "LCL", quest = 5891 },
		{ key = "FL", id = 1009, zone = "DC5", quest = 6064 },
		{ key = "SP", id = 1010, zone = "DC2", quest = 6065 },
		{ key = "MHK", id = 1052, zone = "AD5", quest = 6186 },
		{ key = "MOS", id = 1055, zone = "AD3", quest = 6188 },
		{ key = "DoM", id = 1081, zone = "GC", quest = 6251 },
		{ key = "FV", id = 1080, zone = "EP4", quest = 6249 },
		{ key = "LM", id = 1123, zone = "AD2", quest = 6351 },
		{ key = "MF", id = 1122, zone = "NE", quest = 6349 },
		{ key = "IR", id = 1152, zone = "WR", quest = 6414 },
		{ key = "UG", id = 1153, zone = "DC5", quest = 6416 },
		{ key = "SG", id = 1197, zone = "BGC", quest = 6505 },
		{ key = "CT", id = 1201, zone = "WS", quest = 6507 },
		{ key = "BDV", id = 1228, zone = "GC", quest = 6576 },
		{ key = "TC", id = 1229, zone = "EP2", quest = 6578 },
		{ key = "RPB", id = 1267, zone = "DC1", quest = 6683 },
		{ key = "TDC", id = 1268, zone = "BW", quest = 6685 },
		{ key = "CA", id = 1301, zone = "SU", quest = 6740 },
		{ key = "SR", id = 1302, zone = "DC3", quest = 6742 },
		{ key = "ERE", id = 1360, zone = "HI", quest = 6835 },
		{ key = "GD", id = 1361, zone = "HI", quest = 6837 },
		{ key = "BS", id = 1389, zone = "EP1", quest = 6896 },
		{ key = "SH", id = 1390, zone = "EP5", quest = 7027 },
		{ key = "OP", id = 1470, zone = "TR", quest = 7105, },
		{ key = "BV", id = 1471, zone = "WR", quest = 7155, },
	},
	MQ = {	--1003
		4296,
		4831,
		4474,
		4552,
		4607,
		4764,
		4836,
		4837,
		4867,
		4832,
		4847,
	},
	EA = { 7061 },
	PD = {
		{ key = "AD1", id = 486, zone = "AD1", achievement = 468 },
		{ key = "AD2", id = 124, zone = "AD2", achievement = 470 },
		{ key = "AD3", id = 137, zone = "AD3", achievement = 445 },
		{ key = "AD4", id = 138, zone = "AD4", achievement = 460 },
		{ key = "AD5", id = 487, zone = "AD5", achievement = 469 },
		{ key = "DC1", id = 284, zone = "DC1", achievement = 380 },
		{ key = "DC2", id = 142, zone = "DC2", achievement = 714 },
		{ key = "DC3", id = 162, zone = "DC3", achievement = 713 },
		{ key = "DC4", id = 308, zone = "DC4", achievement = 707 },
		{ key = "DC5", id = 169, zone = "DC5", achievement = 708 },
		{ key = "EP1", id = 216, zone = "EP1", achievement = 379 },
		{ key = "EP2", id = 306, zone = "EP2", achievement = 388 },
		{ key = "EP3", id = 134, zone = "EP3", achievement = 372 },
		{ key = "EP4", id = 339, zone = "EP4", achievement = 381 },
		{ key = "EP5", id = 341, zone = "EP5", achievement = 371 },
		{ key = "CH", id = 557, zone = "CH", achievement = 874 },
		{ key = "VFW", id = 919, zone = "VV", achievement = 1855 },
		{ key = "VNC", id = 918, zone = "VV", achievement = 1846 },
		{ key = "WOO", id = 706, zone = "WR", achievement = 1238 },
		{ key = "WRK", id = 705, zone = "WR", achievement = 1235 },
		{ key = "SKW", id = 1020, zone = "SU", achievement = 2096 },
		{ key = "SSH", id = 1021, zone = "SU", achievement = 2095 },
		{ key = "RN", id = 1089, zone = "NE", achievement = 2444 },
		{ key = "OC", id = 1090, zone = "NE", achievement = 2445 },
		{ key = "LT", id = 1186, zone = "WS", achievement = 2714 },
		{ key = "NK", id = 1187, zone = "BGC", achievement = 2715 },
		{ key = "SH", id = 1260, zone = "BW", achievement = 2994 },
		{ key = "ZA", id = 1259, zone = "BW", achievement = 2995 },
		{ key = "GHB", id = 1338, zone = "HI", achievement = 3281 },
		{ key = "SCC", id = 1337, zone = "HI", achievement = 3283 },
		{ key = "GO", id = 1415, zone = "TP", achievement = 3658 },
		{ key = "TU", id = 1416, zone = "AP", achievement = 3657 },
		{ key = "LW", id = 1444, zone = "WW", achievement = 4000 },
		{ key = "SI", id = 1467, zone = "WW", achievement = 4002 },
	},
	racialLineIds = {
		--RaceId	SkillLineId	Race
		[1]  = 60,		--Breton
		[2]  = 62,		--Redguard
		[3]  = 52,		--Orc
		[4]  = 64,		--Dark Elf
		[5]  = 65,		--Nord
		[6]  = 63,		--Argonian
		[7]  = 56,		--High Elf
		[8]  = 57,		--Wood Elf
		[9]  = 58,		--Khajiit
		[10] = 59,		--Imperial
	},
}


local function USPF_RedText(text)	return "|cFF0000"..tostring(text).."|r" end
local function USPF_GreenText(text)	return "|c00FF00"..tostring(text).."|r" end

local function USPF_rgbToHex(rgb)
	local hexStr = '|c'
	for _, v in pairs(rgb) do
		local hex = ''
		local tmpV = math.floor((255 * v) + 0.5)
		while tmpV > 0 do
			local idx = math.fmod(tmpV, 16) + 1
			tmpV = math.floor(tmpV / 16)
			hex = string.sub('0123456789ABCDEF', idx, idx) .. hex
		end
		hex = string.len(hex) == 0 and '00' or (string.len(hex) == 1 and '0' .. hex or hex)
		hexStr = hexStr .. hex
	end
	return hexStr
end

local function USPF_UpdateAllSavedVars()
	if USPF.sVar.ptsData[selectedChar] == nil then USPF.sVar.ptsData[selectedChar] = {} end
	USPF.sVar.ptsData[selectedChar] = USPF_LTF:CopyTable(USPF.ptsData)
end

local function FormatQuestName(questName, completed)
	return completed and "|l0:1:0:-25%:2:ffffff|l"..questName.."|l" or questName
end

local function ColorCompletion(text, completed)
	if completed then
		return USPF_GreenText(text)
	else
		return USPF_RedText(text)
	end
end

local function GetQuestTooltipText(questIds)
	if questIds == nil or #questIds == 0 then
		return GS(USPF_QUEST_NONE)
	end
	local quests = {}
	local isCurrentCharacter = GCCId() == selectedChar
	for _, questId in ipairs(questIds) do
		local questName = GetQuestName(questId)
		local earned = GCQI(questId) ~= ""
		table.insert(quests, FormatQuestName(questName, isCurrentCharacter and earned))
	end
	return table.concat(quests, "\n")
end

local function GetMainQuestTooltip()
	local function FormatProgress(points, total)
		return ColorCompletion(points .."/".. total, points ~= "?" and points >= total)
	end
	local quests = { GetQuestTooltipText(USPF.data.MQ).."\n" }
	for _, char in ipairs(USPF.charData) do
		local charPointsData = USPF.sVar.ptsData[char.charId]
		local questPoints = charPointsData.MainQ or "?"
		local questTotal = USPF.ptsTots.MainQ
		table.insert(quests, FormatProgress(questPoints, questTotal) .. "  " .. char.charName)
	end
	return table.concat(quests, "\n")
end

local function GetZoneTooltipText(zone)
    local function FormatProgress(points, total)
        return ColorCompletion(points .."/".. total, points ~= "?" and points >= total)
	end
	local quests = { GetQuestTooltipText(zone.quests).."\n" }
	for _, char in ipairs(USPF.charData) do
		local charPointsData = USPF.sVar.ptsData[char.charId]
		local questPoints = charPointsData.ZQ[zone.key] or "?"
		local questTotal = #zone.quests
		local skyShardPoints = charPointsData.SS[zone.key] or "?"
		local skyShardTotal = zone.skyshards[2]
		local txt = questTotal ~= 0 and FormatProgress(questPoints, questTotal) .. "  " or ""
		table.insert(quests, txt .. FormatProgress(skyShardPoints, skyShardTotal) .. "  " .. char.charName)
	end
	return table.concat(quests, "\n")
end

local function GetGDQuestTooltipText(dungeon)
	local questName = GetQuestName(dungeon.quest)
	local list = {FormatQuestName(questName, selectedChar == GCCId() and GCQI(dungeon.quest) ~= "").."\n"}
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].GD[dungeon.key]
		table.insert(list, ColorCompletion(char.charName, val == 1))
	end
	return table.concat(list, "\n")
end

local function GetAchLink(achId)
	return GetAchievementLink(achId, LINK_TYPE_ACHIEVEMENT)
end

local function GetSV(value)
	return  value ~= nil and value or 0
end

local function GetPDTooltipText(pdung)
	local list = { GetAchLink(pdung.achievement) .. "\n" }
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].PD[pdung.key]
		table.insert(list, ColorCompletion(char.charName, val == 1))
	end
	return table.concat(list, "\n")
end

local function getTooltipCharacterTotal()
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local total = USPF.sVar.ptsData[char.charId].Tot
		local unassigned = USPF.sVar.ptsData[char.charId].Unassigned or "?"
		table.insert(list, ColorCompletion(total, total == USPF.ptsTots.Tot) .. "  (" .. unassigned .. ")  " .. char.charName)
	end
	return table.concat(list, "\n")
end

local function getTooltipPDTotal()
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local total = USPF.sVar.ptsData[char.charId].PDTot
		table.insert(list, ColorCompletion(total, total == USPF.ptsTots.PDTot) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end

local function getTooltipZoneTotal()
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local questTotal = USPF.sVar.ptsData[char.charId].ZQTot
		local skyShardTotal = USPF.sVar.ptsData[char.charId].SSTot
		table.insert(list, ColorCompletion(questTotal, questTotal == USPF.ptsTots.ZQTot) .. "  " ..
				ColorCompletion(skyShardTotal, skyShardTotal == USPF.ptsTots.SSTot) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end

local function getTooltipGDTotal()
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local dungeonTotal = USPF.sVar.ptsData[char.charId].GDTot
		table.insert(list, ColorCompletion(dungeonTotal, dungeonTotal == USPF.ptsTots.GDTot) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end


local function getTooltipPvPRank()
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].PvPRank
		table.insert(list, ColorCompletion(val, val == USPF.ptsTots.PvPRank) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end


local function getTooltipMaelstrom()
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].MaelAr
		table.insert(list, ColorCompletion(val, val == 1) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end

local function getTooltipEndlessArchive()
	local list = { GetQuestTooltipText(USPF.data.EA).."\n" }
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].EndlArch
		table.insert(list, ColorCompletion(val, val == 1) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end

local function USPF_GetZoneName(zone)
	if zone == "CAD" then
		return zf("<<C:1>> AD", GZNBId(USPF.data.ZId.ZN.CAD))
	elseif zone == "CEP" then
		return zf("<<C:1>> EP", GZNBId(USPF.data.ZId.ZN.CEP))
	elseif zone == "CDC" then
		return zf("<<C:1>> DC", GZNBId(USPF.data.ZId.ZN.CDC))
	elseif zone == "LCL" then
		return zf("<<C:1>> <<C:2>>", GS(USPF_GUI_ZN_LCL), GZNBId(USPF.data.ZId.ZN.CL))
	elseif zone == "UCL" then
		return zf("<<C:1>> <<C:2>>", GS(USPF_GUI_ZN_UCL), GZNBId(USPF.data.ZId.ZN.CL))
	end
	return zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN[zone]))
end

local function USPF_UpdateGUITable(sVarPtsData)
	local tutorial = GetSV(sVarPtsData.MWChar) + GetSV(sVarPtsData.SUChar) + GetSV(sVarPtsData.EWChar) + GetSV(sVarPtsData.GMChar) + GetSV(sVarPtsData.BWChar)

	USPF.GUI = {
		GSP = {
			{ 1, GS(USPF_GUI_CHAR_LEVEL),	GetSV(sVarPtsData.Level),	USPF.ptsTots.Level,		GS(USPF_QUEST_NA) },
			{ 2, GS(USPF_GUI_MAIN_QUEST),	GetSV(sVarPtsData.MainQ),	USPF.ptsTots.MainQ,		GetMainQuestTooltip() },
			{ 3, GS(USPF_GUI_FOLIUM),		GetSV(sVarPtsData.FolDis),	USPF.ptsTots.FolDis,	GS(USPF_QUEST_NA) },
			{ 4, GS(USPF_GUI_TUTORIAL),		tutorial, 1, "" },
			{ 5, GS(USPF_GUI_AVA_RANK),		GetSV(sVarPtsData.PvPRank),	USPF.ptsTots.PvPRank,	getTooltipPvPRank() },
			{ 6, GS(USPF_GUI_MAEL_ARENA),	GetSV(sVarPtsData.MaelAr),	USPF.ptsTots.MaelAr,	getTooltipMaelstrom() },
			{ 7, zf("<<t:1>>", GZNBId(USPF.data.ZId.ZN.EA)),	GetSV(sVarPtsData.EndlArch),	USPF.ptsTots.EndlArch,	getTooltipEndlessArchive() },
		},
		GSP_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.GenTot, USPF.ptsTots.GenTot),
		SQS = {},
		SQS_SL_T = strF("%d/%d", sVarPtsData.ZQTot, USPF.ptsTots.ZQTot),
		SQS_SS_T = strF("%d/%d", sVarPtsData.SSTot, USPF.ptsTots.SSTot),
		GDQ = {},
		GDQ_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.GDTot, USPF.ptsTots.GDTot),
		PDGBE = {},
		PDGBE_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.PDTot, USPF.ptsTots.PDTot),
		CharacterTot = strF("%s: %d/%d (%s %s)", GS(USPF_GUI_CHAR_TOTAL), sVarPtsData.Tot, USPF.ptsTots.Tot, sVarPtsData.Unassigned and tostring(sVarPtsData.Unassigned) or "?", GS(USPF_GUI_UNASSIGNED)),
	}

	for i, z in ipairs(USPF.data.zones) do
        table.insert(USPF.GUI.SQS, {
            i,
            USPF_GetZoneName(z.key),
            GetSV(sVarPtsData.ZQ[z.key]),
            #z.quests,
            GetSV(sVarPtsData.SS[z.key]),
            z.skyshards[2],
            GetZoneTooltipText(z)
        })
	end

	for i, d in ipairs(USPF.data.GD) do
        table.insert(USPF.GUI.GDQ, {
            i,
            zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN[d.zone])),
			zf("<<C:1>>", GZNBId(d.id)),
            GetSV(sVarPtsData.GD[d.key]),
            GetGDQuestTooltipText(d)
        })
	end

	for i, d in ipairs(USPF.data.PD) do
        table.insert(USPF.GUI.PDGBE, {
            i,
            zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN[d.zone])),
			zf("<<C:1>>", GZNBId(d.id)),
            GetSV(sVarPtsData.PD[d.key]),
            GetPDTooltipText(d)
        })
	end

end

local function USPF_CheckSavedVars(value)
	local charId = GCCId()
	if selectedChar ~= charId then return false end
	if value == nil then
		--Write the character settings table.
		USPF.sVar.settings[charId] = {}
		USPF.sVar.settings[charId] = USPF_LTF:CopyTable(USPF.settings)

		--Write the character points data table.
		USPF.sVar.ptsData[charId] = {}
		USPF.sVar.ptsData[charId] = USPF_LTF:CopyTable(USPF.ptsData)
	end
	return true
end

local function USPF_SetLevelPoints()
	local level = GetUnitLevel("player")
	USPF.ptsData.Level = math.floor(level/5) + math.floor(level/10) + (level - 1)

	--Update saved variables.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].Level = USPF.ptsData.Level
	end
end

local function USPF_SetQuestPoints()
	--Main Quest Skill Points
	for i=1, #USPF.data.MQ do
		USPF.ptsData.MainQ = USPF.ptsData.MainQ + ((GCQI(USPF.data.MQ[i]) ~= "") and 1 or 0)
	end

	--Morrowind Only Character Quest Skill Points
	USPF.ptsData.MWChar = (GCQI(USPF.data.tutorials.MO) ~= "" or USPF.settings.MWC) and 1 or 0

	--Summerset Only Character Quest Skill Points
	USPF.ptsData.SUChar = (GCQI(USPF.data.tutorials.SO) ~= "" or USPF.settings.SSC) and 1 or 0

	--Elsweyr Only Character Quest Skill Points
	USPF.ptsData.EWChar = (GCQI(USPF.data.tutorials.EO) ~= "" or USPF.settings.EWC) and 1 or 0

	--Greymoor Only Character Quest Skill Points
	USPF.ptsData.GMChar = (GCQI(USPF.data.tutorials.GO) ~= "" or USPF.settings.GMC) and 1 or 0

	--Blackwood Only Character Quest Skill Points
	USPF.ptsData.BWChar = (GCQI(USPF.data.tutorials.BO) ~= "" or USPF.settings.BWC) and 1 or 0

	USPF.ptsData.EndlArch = (GCQI(USPF.data.EA[1]) ~= "") and 1 or 0

	for _, zd in ipairs(USPF.data.zones) do
		USPF.ptsData.ZQ[zd.key] = 0
		for i=1, #zd.quests do
			USPF.ptsData.ZQ[zd.key] = USPF.ptsData.ZQ[zd.key] + ((GCQI(zd.quests[i]) ~= "") and 1 or 0)
		end
		USPF.ptsData.ZQTot = USPF.ptsData.ZQTot + USPF.ptsData.ZQ[zd.key]
	end

	--Group Dungeon Quest Skill Points
	for _,d in pairs(USPF.data.GD) do
		USPF.ptsData.GD[d.key] = GCQI(d.quest) ~= "" and 1 or 0
		USPF.ptsData.GDTot = USPF.ptsData.GDTot + USPF.ptsData.GD[d.key]
	end

	--Update saved variables for all.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].MainQ = USPF.ptsData.MainQ
		USPF.sVar.ptsData[selectedChar].MWChar = USPF.ptsData.MWChar
		USPF.sVar.ptsData[selectedChar].SUChar = USPF.ptsData.SUChar
		USPF.sVar.ptsData[selectedChar].EWChar = USPF.ptsData.EWChar
		USPF.sVar.ptsData[selectedChar].GMChar = USPF.ptsData.GMChar
		USPF.sVar.ptsData[selectedChar].BWChar = USPF.ptsData.BWChar
		USPF.sVar.ptsData[selectedChar].EndlArch = USPF.ptsData.EndlArch

		USPF.sVar.ptsData[selectedChar].ZQ = USPF_LTF:CopyTable(USPF.ptsData.ZQ)
		USPF.sVar.ptsData[selectedChar].GD = USPF_LTF:CopyTable(USPF.ptsData.GD)

		USPF.sVar.ptsData[selectedChar].ZQTot = USPF.ptsData.ZQTot
		USPF.sVar.ptsData[selectedChar].GDTot = USPF.ptsData.GDTot
	end
end

local function USPF_SetPublicDungeonPoints()
	for _,d in ipairs(USPF.data.PD) do
		USPF.ptsData.PD[d.key] = IAchC(d.achievement) and 1 or 0
		USPF.ptsData.PDTot = USPF.ptsData.PDTot + USPF.ptsData.PD[d.key]
	end

	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		--Update saved variables.
		USPF.sVar.ptsData[selectedChar].PD		= USPF_LTF:CopyTable(USPF.ptsData.PD)
		USPF.sVar.ptsData[selectedChar].PDTot	= USPF.ptsData.PDTot
	end
end

local function USPF_SetSkyshardPoints()
	for _, zd in ipairs(USPF.data.zones) do
        local v = zd.skyshards
		for i=v[1], v[1] + v[2] - 1 do
            if GetSkyshardDiscoveryStatus(i) == SKYSHARD_DISCOVERY_STATUS_ACQUIRED then
                USPF.ptsData.SS[zd.key] = USPF.ptsData.SS[zd.key] + 1
            end
		end
		USPF.ptsData.numSSTot = USPF.ptsData.numSSTot + USPF.ptsData.SS[zd.key]
	end

	--Calculate the total and round for points.
	USPF.ptsData.SSTot = math.floor(USPF.ptsData.numSSTot/3)

	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		--Update saved variables for all.
		USPF.sVar.ptsData[selectedChar].SS			= USPF_LTF:CopyTable(USPF.ptsData.SS)
		USPF.sVar.ptsData[selectedChar].numSSTot	= USPF.ptsData.numSSTot
		USPF.sVar.ptsData[selectedChar].SSTot		= USPF.ptsData.SSTot
	end
end

local function USPF_IsValidRacialLine(skillType, skillLine)
	if skillType == SKILL_TYPE_RACIAL then
		local _, _, _, skillLineId = GetSkillLineInfo(skillType, skillLine)
		return skillLineId == USPF.data.racialLineIds[GetUnitRaceId("player")]
	end
	return false
end

local function USPF_GetSkillSpentPoints(skillType, skillLine, skillIndex)
	local skills = USPF.cache.skillTypes[skillType].lines[skillLine].skills
	local _, _, _, _, _, purchased, progressionIndex = GetSkillAbilityInfo(skillType, skillLine, skillIndex)
	local spent, possible, reduction

	if not purchased then spent = 0 end
	reduction = IsSkillAbilityAutoGrant(skillType, skillLine, skillIndex) and 1 or 0

	if progressionIndex then
		local _, morph = GetAbilityProgressionInfo(progressionIndex)
		if not spent then
			spent = morph > 0 and (2 - reduction) or (1 - reduction)
		end
		possible = 2 - reduction
	else
		local currentLevel, maxLevel = GetSkillAbilityUpgradeInfo(skillType, skillLine, skillIndex)
		if currentLevel then
			if not spent then spent = currentLevel - reduction end
			possible = maxLevel - reduction
		else
			if not spent then spent = 1 - reduction end
			possible = 1 - reduction
		end
	end
	skills[skillIndex] = {spent, possible}
	return skills[skillIndex]
end

local function USPF_GetLineSpentPoints(skillType, skillLine)
	if skillType ~= SKILL_TYPE_RACIAL or USPF_IsValidRacialLine(skillType, skillLine) then
		USPF.cache.skillTypes[skillType].lines[skillLine] = {}
		local line = USPF.cache.skillTypes[skillType].lines[skillLine]
		line.skills = {}
		line.total = 0
		line.possible = 0
		local numSkillAbilities = GetNumSkillAbilities(skillType, skillLine)
		for ability = 1, numSkillAbilities do
			local spent = USPF_GetSkillSpentPoints(skillType, skillLine, ability)
			line.total = line.total + spent[1]
			line.possible = line.possible + spent[2]
		end

		return line.total
	end
	return 0
end

local function USPF_GetTypeSpentPoints(skillTypeId)
	USPF.cache.skillTypes[skillTypeId] = {}
	local skillType = USPF.cache.skillTypes[skillTypeId]
	skillType.lines = {}
	skillType.total = 0
	local numSkillLines = GetNumSkillLines(skillTypeId)
	for skillLine = 1, numSkillLines do skillType.total = skillType.total + USPF_GetLineSpentPoints(skillTypeId, skillLine) end
	return skillType.total
end

local function USPF_GetTotSkillPoints()
	USPF.cache.skillTypes = {}
	USPF.cache.total = GetAvailableSkillPoints()

	for skillType = 1, GetNumSkillTypes() do USPF.cache.total = USPF.cache.total + USPF_GetTypeSpentPoints(skillType) end
	return USPF.cache.total
end

local function USPF_SetFoliumDiscognitumPoints()
	if USPF.settings.FD.override then
		USPF.ptsData.FolDis = USPF.settings.FD.charHasFD and 2 or 0
	else
		local skillPoints = USPF_GetTotSkillPoints()
		local skillPointsDiff =	USPF.ptsData.Level + USPF.ptsData.MainQ + USPF.ptsData.MWChar +
								USPF.ptsData.SUChar + USPF.ptsData.EWChar + USPF.ptsData.GMChar +
								USPF.ptsData.BWChar + USPF.ptsData.PvPRank + USPF.ptsData.MaelAr +
								USPF.ptsData.EndlArch + USPF.ptsData.ZQTot + USPF.ptsData.SSTot +
								USPF.ptsData.GDTot + USPF.ptsData.PDTot
		USPF.ptsData.FolDis = skillPoints == skillPointsDiff + 2 and 2 or 0
	end

	--Update saved variables.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].FolDis = USPF.ptsData.FolDis
	end
end

local function USPF_SetAllianceWarRankPoints()
	USPF.ptsData.PvPRank = GetUnitAvARank("player") == nil and 0 or GetUnitAvARank("player")

	--Update saved variables.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].PvPRank = USPF.ptsData.PvPRank
	end
end

local function USPF_SetMaelArPoints()
	USPF.ptsData.MaelAr = IAchC(USPF.data.MAAch) and 1 or 0

	--Update saved variables.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].MaelAr = USPF.ptsData.MaelAr
	end
end

local function USPF_SetUnassigned()
	USPF.ptsData.Unassigned = GetAvailableSkillPoints()

	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].Unassigned = USPF.ptsData.Unassigned
	end
end

local function USPF_SetGeneralPoints()
	USPF.ptsData.GenTot =	USPF.ptsData.Level + USPF.ptsData.MainQ + USPF.ptsData.FolDis + USPF.ptsData.MWChar +
							USPF.ptsData.SUChar + USPF.ptsData.EWChar + USPF.ptsData.GMChar + USPF.ptsData.BWChar +
							USPF.ptsData.PvPRank + USPF.ptsData.MaelAr + USPF.ptsData.EndlArch

	--Update saved variables.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].GenTot = USPF.ptsData.GenTot
	end
end

local function USPF_SetTotPoints()
	USPF.ptsData.Tot =	USPF.ptsData.GenTot + USPF.ptsData.ZQTot + USPF.ptsData.SSTot +
						USPF.ptsData.GDTot + USPF.ptsData.PDTot

	--Update saved variables.
	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		USPF.sVar.ptsData[selectedChar].Tot = USPF.ptsData.Tot
	end
end

local function USPF_LoadData(charId)
	local sVarPtsData = USPF.sVar.ptsData[charId]

	if USPF.sVar.ptsData[charId] == nil then
		--Write the character settings table.
		USPF.sVar.settings[charId] = {}
		USPF.sVar.settings[charId] = USPF_LTF:CopyTable(USPF.settings)

		--Write the character points data table.
		USPF.sVar.ptsData[charId] = {}
		USPF.sVar.ptsData[charId] = USPF_LTF:CopyTable(USPF.ptsData)
	end
	USPF_UpdateGUITable(sVarPtsData)
end

local function USPF_SetupData(charId)
	if charId == GCCId() then
		--Reset All Points to Zero.
		USPF.ptsData = USPF_LTF:SimpleResetTable(USPF.ptsData, 0)

		--Update Level Points.
		USPF_SetLevelPoints()

		--Update Quest Points.
		USPF_SetQuestPoints()

		--Update Public Dungeon Points.
		USPF_SetPublicDungeonPoints()

		--Update Skyshard Points.
		USPF_SetSkyshardPoints()

		--Update Alliance War Rank Points.
		USPF_SetAllianceWarRankPoints()

		--Update MaelAr Arena Point.
		USPF_SetMaelArPoints()

		--Update Unassigned Skillpoints
		USPF_SetUnassigned()

		--Update Folium Discognitum Points.
		USPF_SetFoliumDiscognitumPoints()

		--Update General Points.
		USPF_SetGeneralPoints()

		--Update Tot Points.
		USPF_SetTotPoints()

		--Update the GUI Table.
		USPF_UpdateGUITable(USPF.ptsData)

		--Update the saved variables.
		USPF_UpdateAllSavedVars()
	else
		--Load selected character data.
		USPF_LoadData(charId)
	end
end

local function USPF_FormatProgress(current, total, colors)
	if total == 0 then return "-" end
	local color
	if current == 0 then
		color = colors.need
	elseif current == total then
		color = colors.done
	else
		color = colors.progress
	end
	return strF("%s%d/%d|r", color, current, total)
end

local function USPF_UpdateListData(control, data)
	local dataList = ZO_ScrollList_GetDataList(control)
	ZO_ScrollList_Clear(control)
	table.insert(dataList, ZO_ScrollList_CreateDataEntry(USPF_LIST_DATA_TYPE, data[1])) -- header
	table.insert(dataList, ZO_ScrollList_CreateDataEntry(USPF_LIST_SEPARATOR_TYPE, {}))
	for i = 2, #data do
		table.insert(dataList, ZO_ScrollList_CreateDataEntry(USPF_LIST_DATA_TYPE, data[i]))
	end
	table.insert(dataList, ZO_ScrollList_CreateDataEntry(USPF_LIST_SEPARATOR_TYPE, {}))
	ZO_ScrollList_Commit(control)
	control:SetHeight(18 * #data + 4)
end

function USPF:UpdateDataLines()
	local dataLines_GSP, dataLines_SQS, dataLines_GDQ, dataLines_GDQ2, dataLines_PDGBE= {},{},{},{},{}

	USPF_SetupData(selectedChar)

	local GSP_Color = {
		need = USPF_rgbToHex(USPF.settings.GSP.needColor),
		progress = USPF_rgbToHex(USPF.settings.GSP.progColor),
		done = USPF_rgbToHex(USPF.settings.GSP.doneColor)
	}
	local SQS_ColorZQ = {
		need =USPF_rgbToHex(USPF.settings.SQS.needColorZQ),
		progress = USPF_rgbToHex(USPF.settings.SQS.progColorZQ),
		done = USPF_rgbToHex(USPF.settings.SQS.doneColorZQ)
	}
	local SQS_ColorSS = {
		need = USPF_rgbToHex(USPF.settings.SQS.needColorSS),
		progress = USPF_rgbToHex(USPF.settings.SQS.progColorSS),
		done = USPF_rgbToHex(USPF.settings.SQS.doneColorSS)
	}
	local GDQ_Color = {
		need = USPF_rgbToHex(USPF.settings.GDQ.needColor),
		done = USPF_rgbToHex(USPF.settings.GDQ.doneColor)
	}
	local PDB_Color = {
		need = USPF_rgbToHex(USPF.settings.PDB.needColor),
		done = USPF_rgbToHex(USPF.settings.PDB.doneColor)
	}

	table.insert(dataLines_GSP, { header = true, source = GS(USPF_GUI_SOURCE), progress = GS(USPF_GUI_PROGRESS) })
	for i = 1, #USPF.GUI.GSP do
		table.insert(dataLines_GSP, {
			source = USPF.GUI.GSP[i][2],
			progress = USPF_FormatProgress(USPF.GUI.GSP[i][3], USPF.GUI.GSP[i][4], GSP_Color),
			tooltipText = USPF.GUI.GSP[i][5]
		})
	end

	table.insert(dataLines_SQS, {
		header = true,
		zone = GS(USPF_GUI_ZONE),
		quests = GS(USPF_GUI_STORYLINE),
		skyshards = GS(USPF_GUI_SKYSHARDS)
	})
	local tempTable = USPF_LTF:SortTable(USPF.GUI.SQS, USPF.settings.SQS.sortCol)
	for i = 1, #tempTable do
		table.insert(dataLines_SQS, {
			zone = tempTable[i][2],
			quests = USPF_FormatProgress(tempTable[i][3], tempTable[i][4], SQS_ColorZQ),
			skyshards = USPF_FormatProgress(tempTable[i][5], tempTable[i][6], SQS_ColorSS),
			tooltipText = tempTable[i][7]
		})
	end

	local gdqHeader = {
		header = true,
		zone = GS(USPF_GUI_ZONE),
		dungeon = GS(USPF_GUI_GROUP_DUNGEON),
		progress = GS(USPF_GUI_PROGRESS)
	}
	tempTable = USPF_LTF:SortTable(USPF.GUI.GDQ, USPF.settings.GDQ.sortCol)
	local splitIndex = #tempTable/2

	table.insert(dataLines_GDQ, gdqHeader)
	for i = 1, splitIndex do
		table.insert(dataLines_GDQ, {
			zone = tempTable[i][2],
			dungeon = tempTable[i][3],
			progress = USPF_FormatProgress(tempTable[i][4], 1, GDQ_Color),
			tooltipText = tempTable[i][5]
		})
	end

	table.insert(dataLines_GDQ2, gdqHeader)
	for i = splitIndex + 1, #tempTable do
		table.insert(dataLines_GDQ2, {
			zone = tempTable[i][2],
			dungeon = tempTable[i][3],
			progress = USPF_FormatProgress(tempTable[i][4], 1, GDQ_Color),
			tooltipText = tempTable[i][5]
		})
	end

	tempTable = USPF_LTF:SortTable(USPF.GUI.PDGBE, USPF.settings.PDB.sortCol)
	table.insert(dataLines_PDGBE, {
		header = true,
		zone = GS(USPF_GUI_ZONE),
		dungeon = GS(USPF_GUI_PUBLIC_DUNGEON),
		progress = GS(USPF_GUI_PROGRESS)
	})
	for i = 1, #tempTable do
		table.insert(dataLines_PDGBE, {
			zone = tempTable[i][2],
			dungeon = tempTable[i][3],
			progress = USPF_FormatProgress(tempTable[i][4], 1, PDB_Color),
			tooltipText = tempTable[i][5]
		})
	end


	USPF_GUI_Body_SQS_Z_T.data = {tooltipText = getTooltipZoneTotal()}

	USPF_UpdateListData(USPF_GUI_Body_GSP_ListHolder, dataLines_GSP)
	USPF_UpdateListData(USPF_GUI_Body_SQS_ListHolder, dataLines_SQS)
	USPF_UpdateListData(USPF_GUI_Body_GDQ_ListHolder, dataLines_GDQ)
	USPF_UpdateListData(USPF_GUI_Body_GDQ2_ListHolder, dataLines_GDQ2)
	USPF_UpdateListData(USPF_GUI_Body_PDGBE_ListHolder, dataLines_PDGBE)

	USPF_GUI_Body_GSP_T:SetText(USPF.GUI.GSP_T)

	USPF_GUI_Body_SQS_SL_T:SetText(USPF.GUI.SQS_SL_T)
	USPF_GUI_Body_SQS_SL_T.data = {tooltipText = getTooltipZoneTotal()}

	USPF_GUI_Body_SQS_SS_T:SetText(USPF.GUI.SQS_SS_T)
	USPF_GUI_Body_SQS_SS_T.data = {tooltipText = getTooltipZoneTotal()}

	USPF_GUI_Body_GDQ_T:SetText(USPF.GUI.GDQ_T)
	USPF_GUI_Body_GDQ_T.data = {tooltipText = getTooltipGDTotal()}

	USPF_GUI_Body_PDGBE_T:SetText(USPF.GUI.PDGBE_T)
	USPF_GUI_Body_PDGBE_T.data = {tooltipText = getTooltipPDTotal()}

	USPF_GUI_Footer_CharacterTotal:SetText(USPF.GUI.CharacterTot)
	USPF_GUI_Footer_CharacterTotal.data = {tooltipText = getTooltipCharacterTotal()}
end

function USPF:ToggleWindow()
	USPF.active = not USPF.active
	if USPF.active then USPF:UpdateDataLines() end
	SCENE_MANAGER:ToggleTopLevel(USPF_GUI)
end


function USPF:SetupValues()
	--Reset All Points to Zero.
	USPF.ptsData = USPF_LTF:SimpleResetTable(USPF.ptsData, 0)

	--Update Level Points.
	USPF_SetLevelPoints()

	--Update Quest Points.
	USPF_SetQuestPoints()

	--Update Public Dungeon Points.
	USPF_SetPublicDungeonPoints()

	--Update Skyshard Points.
	USPF_SetSkyshardPoints()

	--Update Alliance War Rank Points.
	USPF_SetAllianceWarRankPoints()

	--Update MaelAr Arena Point.
	USPF_SetMaelArPoints()

	--Update Folium Discognitum Points.
	USPF_SetFoliumDiscognitumPoints()

	--Update General Points.
	USPF_SetGeneralPoints()

	--Update Tot Points.
	USPF_SetTotPoints()

	--Update the GUI Table.
	USPF_UpdateGUITable(USPF.ptsData)

	--Set the window size and position.
	USPF_GUI:ClearAnchors()
	USPF_GUI:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
	USPF_GUI:SetHeight(USPF_GUI_Header:GetHeight() + #USPF.GUI.SQS * 18 + USPF_GUI_Footer:GetHeight() + 18 + 76)

	--Add information to window.
	local titleFont = USPF.Options.Font.Fonts[USPF.settings.title.font]
	local smallFont = titleFont.."|14"

	USPF_GUI_Header_Title:SetFont(titleFont.."|30")
	USPF_GUI_Body_GSP:SetFont(titleFont.."|16")
	USPF_GUI_Body_GSP_T:SetFont(smallFont)

	USPF_GUI_Body_SQS:SetFont(titleFont.."|16")
	USPF_GUI_Body_SQS_Z_T:SetFont(smallFont)
	USPF_GUI_Body_SQS_SL_T:SetFont(smallFont)
	USPF_GUI_Body_SQS_SS_T:SetFont(smallFont)

	USPF_GUI_Body_GDQ:SetFont(titleFont.."|16")
	USPF_GUI_Body_GDQ_T:SetFont(smallFont)

	USPF_GUI_Body_PDGBE:SetFont(titleFont.."|16")
	USPF_GUI_Body_PDGBE_T:SetFont(smallFont)

	USPF_GUI_Footer_CharacterTotal:SetFont(titleFont.."|24")

	ZO_ScrollList_AddDataType(USPF_GUI_Body_SQS_ListHolder, USPF_LIST_DATA_TYPE, "USPF_SQSSTemplate", 18, function(control, data) self:SetupSqsItem(control, data) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_SQS_ListHolder, USPF_LIST_SEPARATOR_TYPE, "USPF_ListSeparator", 2, function(control, data) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_GDQ_ListHolder, USPF_LIST_DATA_TYPE, "USPF_GDQTemplate", 18, function(control, data) self:SetupGdqItem(control, data, USPF.settings.GDQ.font) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_GDQ_ListHolder, USPF_LIST_SEPARATOR_TYPE, "USPF_ListSeparator", 2, function(control, data) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_GDQ2_ListHolder, USPF_LIST_DATA_TYPE, "USPF_GDQTemplate", 18, function(control, data) self:SetupGdqItem(control, data, USPF.settings.GDQ.font) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_GDQ2_ListHolder, USPF_LIST_SEPARATOR_TYPE, "USPF_ListSeparator", 2, function(control, data) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_PDGBE_ListHolder, USPF_LIST_DATA_TYPE, "USPF_PDGBETemplate", 18, function(control, data) self:SetupGdqItem(control, data, USPF.settings.PDB.font) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_PDGBE_ListHolder, USPF_LIST_SEPARATOR_TYPE, "USPF_ListSeparator", 2, function(control, data) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_GSP_ListHolder, USPF_LIST_DATA_TYPE, "USPF_GeneralTemplate", 18, function(control, data) self:SetupGeneralItem(control, data) end)
	ZO_ScrollList_AddDataType(USPF_GUI_Body_GSP_ListHolder, USPF_LIST_SEPARATOR_TYPE, "USPF_ListSeparator", 2, function(control, data) end)
end

function USPF:SetupSqsItem(control, data)
	control.data = data
	local zone = control:GetNamedChild("_Zone")
	local ss = control:GetNamedChild("_Skyshards")
	local quests = control:GetNamedChild("_Quests")
	local fontName = data.header and USPF.settings.title.font or USPF.settings.SQS.font
	local font = USPF.Options.Font.Fonts[fontName] .. "|14"

	zone:SetFont(font)
	quests:SetFont(font)
	ss:SetFont(font)
	zone:SetText(data.zone)
	ss:SetText(data.skyshards)
	quests:SetText(data.quests)
end

function USPF:SetupGdqItem(control, data, entryFontName)
	control.data = data
	local zone = control:GetNamedChild("_Zone")
	local progress = control:GetNamedChild("_Progress")
	local dungeon = control:GetNamedChild("_Dungeon")
	local fontName = data.header and USPF.settings.title.font or entryFontName
	local font = USPF.Options.Font.Fonts[fontName] .. "|14"
	zone:SetFont(font)
	dungeon:SetFont(font)
	progress:SetFont(font)
	zone:SetText(data.zone)
	progress:SetText(data.progress)
	dungeon:SetText(data.dungeon)
end

function USPF:SetupGeneralItem(control, data)
	control.data = data
	local source = control:GetNamedChild("_Source")
	local progress = control:GetNamedChild("_Progress")
	local fontName = data.header and USPF.settings.title.font or USPF.settings.GSP.font
	local font = USPF.Options.Font.Fonts[fontName] .. "|14"
	source:SetFont(font)
	progress:SetFont(font)
	source:SetText(data.source)
	progress:SetText(data.progress)
end

function USPF:HelpSlash()
	d(GS(USPF_MSG_CMD_TITLE))
	d(strF(GS(USPF_MSG_CMD_OPTION), (USPF.active and GS(USPF_MSG_DEACTVATE) or GS(USPF_MSG_ACTIVATE))))
end

function USPF:BadSlash()
	d(GS(USPF_MSG_BAD_SLASH))
	d(GS(USPF_MSG_CMD_TITLE))
	d(strF(GS(USPF_MSG_CMD_OPTION), (USPF.active and GS(USPF_MSG_DEACTVATE) or GS(USPF_MSG_ACTIVATE))))
end

local function USPF_LoadSettings(charId)
	if USPF_CheckSavedVars(USPF.sVar.settings[charId]) then
		USPF.settings = USPF_LTF:CopyTable(USPF.sVar.settings[charId])

		if USPF.settings.GSP.progColor == nil then
			USPF.settings.GSP.progColor = {1, 1, 1}
			USPF.sVar.settings[charId].GSP.progColor = USPF.settings.GSP.progColor
		end

		if USPF.settings.SQS.progColorSS == nil then
			USPF.settings.SQS.progColorSS = {0.7843, 0.3922, 0}
			USPF.sVar.settings[charId].SQS.progColorSS = USPF.settings.SQS.progColorSS
		end

		if USPF.settings.SQS.progColorZQ == nil then
			USPF.settings.SQS.progColorZQ = {0.7843, 0.3922, 0}
			USPF.sVar.settings[charId].SQS.progColorZQ = USPF.settings.SQS.progColorZQ
		end

		USPF.settings.MWC = USPF.sVar.settings[charId].SSC and false or USPF.sVar.settings[charId].MWC
		USPF.settings.SSC = USPF.sVar.settings[charId].MWC and false or USPF.sVar.settings[charId].SSC
		USPF.sVar.settings[charId].MWC = USPF.settings.SSC and false or USPF.settings.MWC
		USPF.sVar.settings[charId].SSC = USPF.settings.MWC and false or USPF.settings.SSC
	end
end

local function USPF_MigrateSavedVariables()
	local renames = {
		TG = "HB",
		RO = "WR",
		DB = "GC",
		MW = "VV"
	}
	for _, char in ipairs(USPF.charData) do
		local zonePoints = USPF.sVar.ptsData[char.charId].ZQ
		for old, new in pairs(renames) do
			zonePoints[new] = zonePoints[new] or zonePoints[old]
			zonePoints[old] = nil
		end
		local skyshards = USPF.sVar.ptsData[char.charId].SS
		skyshards["WP"] = skyshards["WP"] or skyshards["MQ"]
		skyshards["MQ"] = nil
	end
end

local function USPF_SetSelectedChar(charName)
	for i = 1, #USPF.charData do
		if charName == USPF.charData[i].charName then
			selectedChar = USPF.charData[i].charId
			break
		end
	end
end

local function USPF_CreateCharList()
	USPF_GUI_Header_CharList.comboBox = USPF_GUI_Header_CharList.comboBox or ZO_ComboBox_ObjectFromContainer(USPF_GUI_Header_CharList)
	local USPF_comboBox = USPF_GUI_Header_CharList.comboBox

	-- tooltip text
	USPF_GUI_Header_CharList.data = {tooltipText = "Select a character to view. You must have logged in on the selected character with this addon active for information to populate."}

	USPF.charNames = {}
	USPF.charData = {}
	for k,_ in ipairs(USPF.sVar.charInfo) do
		USPF.charNames[k] = USPF.sVar.charInfo[k].charName
		USPF.charData[k] = {
			charId = USPF.sVar.charInfo[k].charId,
			charName = USPF.sVar.charInfo[k].charName,
		}

		if GCCId() == USPF.charData[k].charId then
			currentCharName = USPF.charData[k].charName
			selectedChar = USPF.charData[k].charId
		end
	end

	function OnItemSelect(_, choiceText, choice)
		USPF_SetSelectedChar(choiceText)
		USPF:UpdateDataLines()
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	USPF_comboBox:SetSortsItems(false)

	for k,_ in ipairs(USPF.charNames) do
		USPF_comboBox:AddItem(USPF_comboBox:CreateItemEntry(USPF.charNames[k], OnItemSelect))
		if USPF.charNames[k] == currentCharName then
			USPF_comboBox:SetSelectedItem(USPF.charNames[k])
		end
	end
end

local function USPF_InitSetup()
	USPF.ptsTots = USPF_CalculateTotalPoints()

	local charIdKnown = {}
	for i = 1, GetNumCharacters() do
		local name, _, _, _, _, _, id, _ = GetCharacterInfo(i)
		charIdKnown[id] = {idx = i, name = name}
	end

	local id = GCCId()

	--Setup the character info table.
	local newChar = true
	local newCharInfo = {}
	for k,v in pairs(USPF.sVar.charInfo) do
		if v.charId == id then
			v.charName = zf("<<1>>", charIdKnown[id].name)
			newChar = false
		end
		if charIdKnown[v.charId] then
			newCharInfo[#newCharInfo + 1] = v
		else
			USPF.sVar.settings[v.charId] = nil
			USPF.sVar.ptsData[v.charId] = nil
		end
	end
	USPF.sVar.charInfo = newCharInfo

	-- Add new char (at the end)
	if newChar then
		table.insert(USPF.sVar.charInfo, {charId = id, charName = zf("<<1>>", charIdKnown[id].name)})
		USPF.sVar.settings[id] = USPF_LTF:CopyTable(USPF.settings)
		USPF.sVar.ptsData[id] = USPF_LTF:CopyTable(USPF.ptsData)
	end

	-- Reorder so characters are always in original order
	table.sort(USPF.sVar.charInfo, function (c1, c2) return charIdKnown[c1.charId].idx < charIdKnown[c2.charId].idx end)

	--Create the character select box.
	USPF_CreateCharList()
end

local function USPF_ResetSelectedCharacter()
	local currentCharId = GCCId()
	if selectedChar ~= currentCharId then
		USPF_GUI_Header_CharList.comboBox = USPF_GUI_Header_CharList.comboBox or ZO_ComboBox_ObjectFromContainer(USPF_GUI_Header_CharList)
		local USPF_comboBox = USPF_GUI_Header_CharList.comboBox

		for k,_ in ipairs(USPF.charData) do
			if currentCharId == USPF.charData[k].charId then
				currentCharName = USPF.charData[k].charName
				selectedChar = USPF.charData[k].charId
				USPF_comboBox:SetSelectedItem(currentCharName)
			end
		end
	end
	USPF_SetupData(currentCharId)
end


local function USPF_SkillPointsUpdate(eventCode, pointsBefore, pointsNow, partialPointsBefore, partialPointsNow)
	USPF_ResetSelectedCharacter()
end

local function USPF_QuestRemoved(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
	if isCompleted then USPF_ResetSelectedCharacter() end
end

local function USPF_LevelUp(eventCode, unitTag, level)
	if unitTag == 'player' then USPF_ResetSelectedCharacter() end
end

local function USPF_AchComplete(eventCode, name, points, id, link)
	USPF_ResetSelectedCharacter()
end

local function USPF_PlayerActivated(eventCode)
	USPF_ResetSelectedCharacter()
end

local function USPF_PlayerDeactivated(eventCode)
	USPF_ResetSelectedCharacter()
end

local function USPF_Initialized(eventCode, addonName)
	if addonName ~= USPF.AddonName then return end

	local world = GetWorldName()
	if world == "NA Megaserver" then
		USPF.sVar = ZO_SavedVars:NewAccountWide("USPF_Settings", USPF.version, nil, USPF.defaults)
	else
		USPF.sVar = ZO_SavedVars:NewAccountWide("USPF_Settings", USPF.version, world, USPF.defaults)
	end

	--Run the startup routine.
	USPF_InitSetup()

	--Create the keybind(s).
	ZO_CreateStringId("SI_BINDING_NAME_USPF_TOGGLE", "Show Skill Point Finder")

	--Register the slash commands.
	SLASH_COMMANDS["/uspf"] = function(keyWord, argument)
		if string.lower(keyWord) == "help" then
			USPF:HelpSlash()
		elseif keyWord == "" then
			USPF:ToggleWindow()
		else
			USPF:BadSlash()
		end
	end

	local charId = GCCId()

	--Load the character settings.
	USPF_LoadSettings(charId)

	-- Migrate old renamed variables
	USPF_MigrateSavedVariables()

	--Create the options menu.
	USPF:SetupMenu(charId)

	--Call startup routine.
	USPF:SetupValues()

	SCENE_MANAGER:RegisterTopLevel(USPF_GUI, locksUIMode)

	--Create the event handlers.
	EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_SKILL_POINTS_CHANGED, USPF_SkillPointsUpdate)
	EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_QUEST_REMOVED, USPF_QuestRemoved)
	EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_LEVEL_UPDATE, USPF_LevelUp)
	EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_ACHIEVEMENT_AWARDED, USPF_AchComplete)
	EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_PLAYER_ACTIVATED, USPF_PlayerActivated)
	EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_PLAYER_DEACTIVATED, USPF_PlayerDeactivated)

	--Kill the initial event handler.
	EVENT_MANAGER:UnregisterForEvent(USPF.AddonName, EVENT_ADD_ON_LOADED)
end

--Register initialization event.
EVENT_MANAGER:RegisterForEvent(USPF.AddonName, EVENT_ADD_ON_LOADED, USPF_Initialized)
