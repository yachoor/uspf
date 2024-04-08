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
		CMT = 0, LCL = 0, UCL = 0, CC  = 0, DB  = 0, IC   = 0, MW   = 0, RO   = 0,
		TG  = 0, SU  = 0, MM  = 0, NE  = 0, WP  = 0, SE   = 0, WS   = 0, TR   = 0,
		BW  = 0, TD  = 0, HI  = 0, GY  = 0, AP  = 0,
	},
	SS = {
		AD0 = 0, AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5  = 0, DC0a = 0, DC0b = 0,
		DC1 = 0, DC2 = 0, DC3 = 0, DC4 = 0, DC5 = 0, EP0a = 0, EP0b = 0, EP1  = 0,
		EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL = 0, IC  = 0, WR  = 0, HB   = 0, GC   = 0, VV   = 0,
		CC  = 0, MQ  = 0, SU  = 0, MM  = 0, NE  = 0, SE   = 0, WS   = 0, TR   = 0,
		BW  = 0, TD  = 0, HI  = 0, GY  = 0, AP  = 0,
	},
	GD = {
		BC1 = 0, BC2 = 0, EH1 = 0, EH2 = 0, CA1 = 0, CA2 = 0, TI = 0, SW = 0,
		SC1 = 0, SC2 = 0, WS1 = 0, WS2 = 0, CH1 = 0, CH2 = 0, VF = 0, BH = 0,
		FG1 = 0, FG2 = 0, DC1 = 0, DC2 = 0, AC  = 0, DK  = 0, BC = 0, VM = 0,
		WGT = 0, ICP = 0, RM  = 0, CS  = 0, BF  = 0, FH  = 0, FL = 0, SP = 0,
		MHK = 0, MOS = 0, DoM = 0, FV  = 0, LM  = 0, MF  = 0, IR = 0, UG = 0,
		SG  = 0, CT  = 0, BDV = 0, TC  = 0, RPB = 0, TDC = 0, CA = 0, SR = 0,
		ERE = 0, GD  = 0, BS  = 0, SH  = 0, OP  = 0, BV  = 0
	},
	PD = {
		AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5 = 0, DC1 = 0, DC2 = 0, DC3 = 0,
		DC4 = 0, DC5 = 0, EP1 = 0, EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0,
		VFW = 0, VNC = 0, WOO = 0, WRK = 0, SKW = 0, SSH = 0, RN  = 0, OC  = 0,
		LT  = 0, NK  = 0, SH  = 0, ZA  = 0, GHB = 0, SCC = 0, GO  = 0, TU  = 0,
	},
}

USPF.ptsTots = {	--Tot and GenTot are 494 and 129 because you can't do more than one DLC tutorial.
	Tot		= 544, GenTot = 130, ZQTot	= 147, numSSTot	= 543, SSTot  = 181,
	GDTot	=  54, PDTot  =  32, Level	=  64, MainQ	=  11, FolDis =   2,
	MWChar	=   1, SUChar =   1, EWChar	=   1, GMChar	=   1, BWChar =   1,
	PvPRank	=  50, MaelAr =   1, EndlArch	=   1,
	ZQ = {
		AD0 = 0, AD1 = 3, AD2 =  3, AD3 = 3, AD4 = 3, AD5  = 3, DC0a = 0, DC0b = 0,
		DC1 = 4, DC2 = 3, DC3 =  3, DC4 = 3, DC5 = 3, EP0a = 0, EP0b = 0, EP1  = 3,
		EP2 = 3, EP3 = 3, EP4 =  3, EP5 = 3, CH  = 3, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL =  0, CC  = 8, DB  = 8, IC   = 1, MW   = 3, RO   = 3,
		TG  = 6, SU  = 3, MM  =  7, NE  = 3, WP  = 0, SE   = 9, WS   = 3, TR   = 9,
		BW  = 3, TD  = 9, HI  =  5, GY  = 9, AP  = 9
	},
	SS = {
		AD0  = 6,  AD1 = 16, AD2 = 16, AD3 = 16, AD4 = 16, AD5 = 16, DC0a = 3,
		DC0b = 3,  DC1 = 16, DC2 = 16, DC3 = 16, DC4 = 16, DC5 = 16, EP0a = 3,
		EP0b = 3,  EP1 = 16, EP2 = 16, EP3 = 16, EP4 = 16, EP5 = 16, CH   = 16,
		CAD  = 15, CDC = 15, CEP = 15, CMT = 1,  LCL = 12, UCL = 6,  IC   = 13,
		WR   = 17, HB  = 6,  GC  = 6,  VV  = 18, CC  = 6,  MQ  = 1,  SU   = 18,
		MM   = 6,  NE  = 18, SE  = 6,  WS  = 18, TR  = 6,  BW  = 18, TD   = 6,
		HI   = 18, GY  = 6,  AP  = 18,
	},
	GD = {
		BC1 = 1, BC2 = 1, EH1 = 1, EH2 = 1, CA1 = 1, CA2 = 1, TI = 1, SW = 1,
		SC1 = 1, SC2 = 1, WS1 = 1, WS2 = 1, CH1 = 1, CH2 = 1, VF = 1, BH = 1,
		FG1 = 1, FG2 = 1, DC1 = 1, DC2 = 1, AC  = 1, DK  = 1, BC = 1, VM = 1,
		WGT = 1, ICP = 1, RM  = 1, CS  = 1, BF  = 1, FH  = 1, FL = 1, SP = 1,
		MHK = 1, MOS = 1, DoM = 1, FV  = 1, LM  = 1, MF  = 1, IR = 1, UG = 1,
		SG  = 1, CT  = 1, BDV = 1, TC  = 1, RPB = 1, TDC = 1, CA = 1, SR = 1,
		ERE = 1, GD  = 1, BS  = 1, SH  = 1, OP  = 1, BV  = 1
	},
	PD = {
		AD1 = 1, AD2 = 1, AD3 = 1, AD4 = 1, AD5 = 1, DC1 = 1, DC2 = 1, DC3 = 1,
		DC4 = 1, DC5 = 1, EP1 = 1, EP2 = 1, EP3 = 1, EP4 = 1, EP5 = 1, CH  = 1,
		VFW = 1, VNC = 1, WOO = 1, WRK = 1, SKW = 1, SSH = 1, RN  = 1, OC  = 1,
		LT  = 1, NK  = 1, SH  = 1, ZA  = 1, GHB = 1, SCC = 1, GO  = 1, TU  = 1,
	},
}

local tempZId = {
	ZN = {
		AD0  =  537, AD1  =  381, AD2  =  383, AD3 =  108, AD4 =  58, AD5 =  382,
		DC0A =  535, DC0B =  534, DC1  =    3, DC2 =   19, DC3 =  20, DC4 =  104,
		DC5  =   92, EP0B =  280, EP0A =  281, EP1 =   41, EP2 =  57, EP3 =  117,
		EP4  =  101, EP5  =  103, CH   =  347, CYD =  181, CAD = 181, CDC =  181,
		CEP  =  181, CMT  =  181, CL   =  888, LCL =  888, UCL = 888, IC  =  584,
		RO   =  684, HB   =  816, GC   =  823, VV  =  849, CC  = 980, SU  = 1011,
		MM   =  726, NE   = 1086, WP   =  586, SE  = 1133, WS = 1160, BGC = 1161,
		TR   = 1207, BW   = 1261, TD   = 1286, HI  = 1318, GY = 1383, AP  = 1413,
		EA   = 1436,
	},
	GDN = {
		BC1 =  380, BC2 =  935, EH1 =  126, EH2 =  931, CA1 =  176, CA2 =  681,
		TI  =  131, SW  =   31, SC1 =  144, SC2 =  936, WS1 =  146, WS2 =  933,
		CH1 =  130, CH2 =  932, VF  =   22, BH  =   38, FG1 =  283, FG2 =  934,
		DC1 =   63, DC2 =  930, AC  =  148, DK  =  449, BC  =   64, VM  =   11,
		ICP =  678, WGT =  688, CS  =  848, RM  =  843, BF  =  973, FH  =  974,
		FL  = 1009, SP  = 1010, MHK = 1052, MOS = 1055, DoM = 1081, FV  = 1080,
		LM  = 1123, MF  = 1122, IR  = 1152, UG  = 1153, SG  = 1197, CT  = 1201,
		BDV = 1228, TC  = 1229, RPB = 1267, TDC = 1268, CA  = 1301, SR  = 1302,
		ERE = 1360, GD  = 1361, BS  = 1389, SH =  1390, OP  = 1470, BV  = 1471
	},
	PDN = {
		AD1 =  486, AD2 =  124, AD3 =  137, AD4 =  138, AD5 =  487, DC1 =  284,
		DC2 =  142, DC3 =  162, DC4 =  308, DC5 =  169, EP1 =  216, EP2 =  306,
		EP3 =  134, EP4 =  339, EP5 =  341, CH  =  557, WOO =  706, WRK =  705,
		VFW =  919, VNC =  918, SKW = 1020, SSH = 1021, RN  = 1089, OC  = 1090,
		LT  = 1186, NK  = 1187, SH  = 1260, ZA  = 1259, GHB = 1338, SCC = 1337,
		GO  = 1415, TU  = 1416,
	},
}

USPF.data = {
	ZId = tempZId,
	MAAch = 1304,
	AD1 = {	--943
		4222,
		4345,
		4261,
	},
	AD2 = {	--944	(1-2 only)
		4868,
		4386,
		4885,
	},
	AD3 = {	--945
		4750,
		4765,
		4690,
	},
	AD4 = {	--946
		4337,
		4452,
		4143,
	},
	AD5 = {	--947
		4712,
		4479,
		4720,
	},
	CC = {	--2064
		6050,
		6057,
		6063,
		6025,
		6052,
		6046,
		6047,
		6048,
	},
	CH = {	--957
		4602,
		4730,
		4758,
	},
	DB = {	--1444
		5540,
		5595,
		5599,
		5596,
		5567,
		5597,
		5598,
		5600,
	},
	DC1 = {	--953
		3006,
		3235,
		3267,
		3379,
	},
	DC2 = {	--954
		 467,
		1633,
		 575,
	},
	DC3 = {	--955
		 465,
		4972,
		4884,
	},
	DC4 = {	--956
		2192,
		2222,
		2997,
	},
	DC5 = {	--958
		4891,
		4912,
		4960,
	},
	EO = { 6324 },
	EP1 = {	--948
		3735,
		3634,
		3868,
	},
	EP2 = {	--949
		3797,
		3817,
		3831,
	},
	EP3 = {	--950
		4590,
		4606,
		3910,
	},
	EP4 = {	--951
		4061,
		4115,
		4117,
	},
	EP5 = {	--952
		3968,
		4139,
		4188,
	},
	GD = {
		BC1 = 4107,
		BC2 = 4597,
		EH1 = 4336,
		EH2 = 4675,
		CA1 = 4778,
		CA2 = 5120,
		TI  = 4538,
		SW  = 4733,
		SC1 = 4054,
		SC2 = 4555,
		WS1 = 4246,
		WS2 = 4813,
		CH1 = 4379,
		CH2 = 5113,
		VF  = 4432,
		BH  = 4589,
		FG1 = 3993,
		FG2 = 4303,
		DC1 = 4145,
		DC2 = 4641,
		AC  = 4202,
		DK  = 4346,
		BC  = 4469,
		VM  = 4822,
		ICP = 5136,
		WGT = 5342,
		CS  = 5702,
		RM  = 5403,
		BF  = 5889,
		FH  = 5891,
		FL  = 6064,
		SP  = 6065,
		MHK = 6186,
		MOS = 6188,
		DoM = 6251,
		FV  = 6249,
		LM  = 6351,
		MF  = 6349,
		IR  = 6414,
		UG  = 6416,
		SG  = 6505,
		CT  = 6507,
		BDV = 6576,
		TC  = 6578,
		RPB = 6683,
		TDC = 6685,
		CA  = 6740,
		SR  = 6742,
		ERE = 6835,
		GD  = 6837,
		BS  = 6896,
		SH  = 7027,
		OP  = 7105,
		BV  = 7155,
	},
	IC = { 5482 },
	MM = {
		6246,
		6266,
		6241,
		6259,
		6243,
		6244,
		6245,
	},
	MW = {
		6003,
		5922,
		5948,
	},
	MO = { 5804 },
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
	NE = {	--2488
		6336,
		6304,
		6315,
	},
	RO = {	--1260
		5447,
		5468,
		5481,
	},
	TG = {	--1363
		5531,
		5534,
		5532,
		5556,
		5549,
		5545,
	},
	SE = {	--2604
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
	SO = { 6143 },
	SU = {	--2208
		6132,
		6113,
		6126,
	},
	WS = {	--2722
		6476,
		6466,
		6481,
	},
	GO = { 6455 },
	BO = { 6646 },
	EA = { 7061 },
	TR = {
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
	BW = {
		6616,
		6619,
		6660,
	},
	TD = {
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
	HI = {
		6753, -- Peaople of Import
		6765, -- To Catch a Magus
		6781, -- A Chance for Peace
		6762, -- Buried at the Bay - PD quest
		6768, -- Blood, Books, and Steel - PD quest
	},
	GY = {
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
	AP = {
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
	PD = {
		AD1 =  468,
		AD2 =  470,
		AD3 =  445,
		AD4 =  460,
		AD5 =  469,
		DC1 =  380,
		DC2 =  714,
		DC3 =  713,
		DC4 =  707,
		DC5 =  708,
		EP1 =  379,
		EP2 =  388,
		EP3 =  372,
		EP4 =  381,
		EP5 =  371,
		CH  =  874,
		VFW = 1855,
		VNC = 1846,
		WOO = 1238,
		WRK = 1235,
		SKW = 2096,
		SSH = 2095,
		RN  = 2444,
		OC  = 2445,
		LT  = 2714,
		NK  = 2715,
		SH  = 2994,
		ZA  = 2995,
		GHB = 3281,
		SCC = 3283,
		GO  = 3658,
		TU  = 3657,
	},
	SS = {
		-- First skyshard ID, count
		MQ   = {259,  1},
		AD0  = { 87,  6},
		AD1  = { 93, 16},
		AD2  = {109, 16},
		AD3  = {125, 16},
		AD4  = {141, 16},
		AD5  = {157, 16},
		DC0a = {176,  3},
		DC0b = {173,  3},
		DC1  = {179, 16},
		DC2  = {195, 16},
		DC3  = {211, 16},
		DC4  = {227, 16},
		DC5  = {243, 16},
		EP0a = {  4,  3},
		EP0b = {  1,  3},
		EP1  = {  7, 16},
		EP2  = { 23, 16},
		EP3  = { 39, 16},
		EP4  = { 55, 16},
		EP5  = { 71, 16},
		CH   = {260, 16},
		CAD  = {306, 15},
		CDC  = {291, 15},
		CEP  = {276, 15},
		CMT  = {321,  1},
		LCL  = {322, 12},
		UCL  = {334,  6},
		IC   = {340, 13},
		WR   = {353, 17},
		HB   = {370,  6},
		GC   = {376,  6},
		VV   = {382, 18},
		CC   = {400,  6},
		SU   = {406, 18},
		MM   = {424,  6},
		NE   = {430, 18},
		SE   = {448,  6},
		WS   = {454, 18},
		TR   = {472,  6},
		BW   = {478, 18},
		TD   = {496,  6},
		HI   = {504, 18},
		GY   = {522,  6},
		AP   = {528, 18},
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

local function GetQuestTooltipText(zone)
	local quests = {}
	local isCurrentCharacter = GCCId() == selectedChar
	for _, questId in ipairs(USPF.data[zone]) do
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
	local quests = {}
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
	local quests = {}
	local zone2 = zone
	if zone == "TG" then zone2 = "HB" end -- different zone names for quests and skyshards in savedVars :-/
	if zone == "RO" then zone2 = "WR" end -- different zone names for quests and skyshards in savedVars :-/
	if zone == "DB" then zone2 = "GC" end -- different zone names for quests and skyshards in savedVars :-/
	if zone == "MW" then zone2 = "VV" end -- different zone names for quests and skyshards in savedVars :-/
	for _, char in ipairs(USPF.charData) do
		local charPointsData = USPF.sVar.ptsData[char.charId]
		local questPoints = charPointsData.ZQ[zone] or "?"
		local questTotal = USPF.ptsTots.ZQ[zone] or 0
		local skyShardPoints = charPointsData.SS[zone2] or "?"
		local skyShardTotal = USPF.ptsTots.SS[zone2]
		local txt = questTotal ~= 0 and FormatProgress(questPoints, questTotal) .. "  " or ""
		table.insert(quests, txt .. FormatProgress(skyShardPoints, skyShardTotal) .. "  " .. char.charName)
	end
	return table.concat(quests, "\n")
end

local function GetGDQuestTooltipText(dungeon)
	local questName = GetQuestName(USPF.data.GD[dungeon])
	local list = {FormatQuestName(questName, selectedChar == GCCId() and GCQI(USPF.data.GD[dungeon]) ~= "").."\n"}
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].GD[dungeon]
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
	local list = { GetAchLink(USPF.data.PD[pdung]) .. "\n" }
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].PD[pdung]
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
	local list = {}
	for _, char in ipairs(USPF.charData) do
		local val = USPF.sVar.ptsData[char.charId].EndlArch
		table.insert(list, ColorCompletion(val, val == 1) .. "  " .. char.charName)
	end
	return table.concat(list, "\n")
end


local function USPF_UpdateGUITable(sVarPtsData)
	local questTooltips = {
		WP	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("MQ"),
		AD0	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("AD0"),
		AD1  = GetQuestTooltipText("AD1").."\n\n"..GetZoneTooltipText("AD1"),
		AD2  = GetQuestTooltipText("AD2").."\n\n"..GetZoneTooltipText("AD2"),
		AD3  = GetQuestTooltipText("AD3").."\n\n"..GetZoneTooltipText("AD3"),
		AD4  = GetQuestTooltipText("AD4").."\n\n"..GetZoneTooltipText("AD4"),
		AD5  = GetQuestTooltipText("AD5").."\n\n"..GetZoneTooltipText("AD5"),
		CC   = GetQuestTooltipText("CC").."\n\n"..GetZoneTooltipText("CC"),
		CH   = GetQuestTooltipText("CH").."\n\n"..GetZoneTooltipText("CH"),
		CAD	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("CAD"),
		CDC	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("CDC"),
		CEP	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("CEP"),
		CMT	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("CMT"),
		DB   = GetQuestTooltipText("DB").."\n\n"..GetZoneTooltipText("DB"),
		DC0a = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("DC0a"),
		DC0b = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("DC0b"),
		DC1	 = GetQuestTooltipText("DC1").."\n\n"..GetZoneTooltipText("DC1"),
		DC2	 = GetQuestTooltipText("DC2").."\n\n"..GetZoneTooltipText("DC2"),
		DC3	 = GetQuestTooltipText("DC3").."\n\n"..GetZoneTooltipText("DC3"),
		DC4	 = GetQuestTooltipText("DC4").."\n\n"..GetZoneTooltipText("DC4"),
		DC5	 = GetQuestTooltipText("DC5").."\n\n"..GetZoneTooltipText("DC5"),
		EP0a = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("EP0a"),
		EP0b = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("EP0b"),
		EP1	 = GetQuestTooltipText("EP1").."\n\n"..GetZoneTooltipText("EP1"),
		EP2	 = GetQuestTooltipText("EP2").."\n\n"..GetZoneTooltipText("EP2"),
		EP3	 = GetQuestTooltipText("EP3").."\n\n"..GetZoneTooltipText("EP3"),
		EP4	 = GetQuestTooltipText("EP4").."\n\n"..GetZoneTooltipText("EP4"),
		EP5	 = GetQuestTooltipText("EP5").."\n\n"..GetZoneTooltipText("EP5"),
		IC	 = GetQuestTooltipText("IC").."\n\n"..GetZoneTooltipText("IC"),
		LCL	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("LCL"),
		UCL	 = GS(USPF_QUEST_NONE).."\n\n"..GetZoneTooltipText("UCL"),
		MM	 = GetQuestTooltipText("MM").."\n\n"..GetZoneTooltipText("MM"),
		MW	 = GetQuestTooltipText("MW").."\n\n"..GetZoneTooltipText("MW"),
		MQ	 = GetQuestTooltipText("MQ").."\n\n"..GetMainQuestTooltip(),
		NE	 = GetQuestTooltipText("NE").."\n\n"..GetZoneTooltipText("NE"),
		RO	 = GetQuestTooltipText("RO").."\n\n"..GetZoneTooltipText("RO"),
		SE	 = GetQuestTooltipText("SE").."\n\n"..GetZoneTooltipText("SE"),
		TG	 = GetQuestTooltipText("TG").."\n\n"..GetZoneTooltipText("TG"),
		SU	 = GetQuestTooltipText("SU").."\n\n"..GetZoneTooltipText("SU"),
		WS   = GetQuestTooltipText("WS").."\n\n"..GetZoneTooltipText("WS"),
		EA   = GetQuestTooltipText("EA").."\n\n"..getTooltipEndlessArchive(),
		TR   = GetQuestTooltipText("TR").."\n\n"..GetZoneTooltipText("TR"),
		BW   = GetQuestTooltipText("BW").."\n\n"..GetZoneTooltipText("BW"),
		TD   = GetQuestTooltipText("TD").."\n\n"..GetZoneTooltipText("TD"),
		HI   = GetQuestTooltipText("HI").."\n\n"..GetZoneTooltipText("HI"),
		GY   = GetQuestTooltipText("GY").."\n\n"..GetZoneTooltipText("GY"),
		AP   = GetQuestTooltipText("AP").."\n\n"..GetZoneTooltipText("AP"),
	}

	local tutorial = GetSV(sVarPtsData.MWChar) + GetSV(sVarPtsData.SUChar) + GetSV(sVarPtsData.EWChar) + GetSV(sVarPtsData.GMChar) + GetSV(sVarPtsData.BWChar)

	USPF.GUI = {
		GSP = {
			{ 1, GS(USPF_GUI_CHAR_LEVEL),	GetSV(sVarPtsData.Level),	USPF.ptsTots.Level,		GS(USPF_QUEST_NA)},
			{ 2, GS(USPF_GUI_MAIN_QUEST),	GetSV(sVarPtsData.MainQ),	USPF.ptsTots.MainQ,		questTooltips.MQ},
			{ 3, GS(USPF_GUI_FOLIUM),		GetSV(sVarPtsData.FolDis),	USPF.ptsTots.FolDis,	GS(USPF_QUEST_NA)},
			{ 4, GS(USPF_GUI_TUTORIAL),		tutorial, 1, ""},
			{ 9, GS(USPF_GUI_AVA_RANK),		GetSV(sVarPtsData.PvPRank),	USPF.ptsTots.PvPRank,	getTooltipPvPRank()},
			{10, GS(USPF_GUI_MAEL_ARENA),	GetSV(sVarPtsData.MaelAr),	USPF.ptsTots.MaelAr,	getTooltipMaelstrom()},
			{11, zf("<<t:1>>", GZNBId(USPF.data.ZId.ZN.EA)),	GetSV(sVarPtsData.EndlArch),	USPF.ptsTots.EndlArch,	questTooltips.EA},
		},
		GSP_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.GenTot, USPF.ptsTots.GenTot),
		SQS = {
			{ 1, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.WP)),						GetSV(sVarPtsData.ZQ.WP),	USPF.ptsTots.ZQ.WP,		GetSV(sVarPtsData.SS.MQ),	USPF.ptsTots.SS.MQ,		questTooltips.WP},
			{ 2, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD0)),						GetSV(sVarPtsData.ZQ.AD0),	USPF.ptsTots.ZQ.AD0,	GetSV(sVarPtsData.SS.AD0),	USPF.ptsTots.SS.AD0,	questTooltips.AD0},
			{ 3, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD1)),						GetSV(sVarPtsData.ZQ.AD1),	USPF.ptsTots.ZQ.AD1,	GetSV(sVarPtsData.SS.AD1),	USPF.ptsTots.SS.AD1,	questTooltips.AD1},
			{ 4, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD2)),						GetSV(sVarPtsData.ZQ.AD2),	USPF.ptsTots.ZQ.AD2,	GetSV(sVarPtsData.SS.AD2),	USPF.ptsTots.SS.AD2,	questTooltips.AD2},
			{ 5, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD3)),						GetSV(sVarPtsData.ZQ.AD3),	USPF.ptsTots.ZQ.AD3,	GetSV(sVarPtsData.SS.AD3),	USPF.ptsTots.SS.AD3,	questTooltips.AD3},
			{ 6, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD4)),						GetSV(sVarPtsData.ZQ.AD4),	USPF.ptsTots.ZQ.AD4,	GetSV(sVarPtsData.SS.AD4),	USPF.ptsTots.SS.AD4,	questTooltips.AD4},
			{ 7, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD5)),						GetSV(sVarPtsData.ZQ.AD5),	USPF.ptsTots.ZQ.AD5,	GetSV(sVarPtsData.SS.AD5),	USPF.ptsTots.SS.AD5,	questTooltips.AD5},
			{ 8, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC0B)),						GetSV(sVarPtsData.ZQ.DC0b),	USPF.ptsTots.ZQ.DC0b,	GetSV(sVarPtsData.SS.DC0b),	USPF.ptsTots.SS.DC0b,	questTooltips.DC0b},
			{ 9, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC0A)),						GetSV(sVarPtsData.ZQ.DC0a),	USPF.ptsTots.ZQ.DC0a,	GetSV(sVarPtsData.SS.DC0a),	USPF.ptsTots.SS.DC0a,	questTooltips.DC0a},
			{10, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC1)),						GetSV(sVarPtsData.ZQ.DC1),	USPF.ptsTots.ZQ.DC1,	GetSV(sVarPtsData.SS.DC1),	USPF.ptsTots.SS.DC1,	questTooltips.DC1},
			{11, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC2)),						GetSV(sVarPtsData.ZQ.DC2),	USPF.ptsTots.ZQ.DC2,	GetSV(sVarPtsData.SS.DC2),	USPF.ptsTots.SS.DC2,	questTooltips.DC2},
			{12, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC3)),						GetSV(sVarPtsData.ZQ.DC3),	USPF.ptsTots.ZQ.DC3,	GetSV(sVarPtsData.SS.DC3),	USPF.ptsTots.SS.DC3,	questTooltips.DC3},
			{13, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC4)),						GetSV(sVarPtsData.ZQ.DC4),	USPF.ptsTots.ZQ.DC4,	GetSV(sVarPtsData.SS.DC4),	USPF.ptsTots.SS.DC4,	questTooltips.DC4},
			{14, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC5)),						GetSV(sVarPtsData.ZQ.DC5),	USPF.ptsTots.ZQ.DC5,	GetSV(sVarPtsData.SS.DC5),	USPF.ptsTots.SS.DC5,	questTooltips.DC5},
			{15, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP0B)),						GetSV(sVarPtsData.ZQ.EP0b),	USPF.ptsTots.ZQ.EP0b,	GetSV(sVarPtsData.SS.EP0b),	USPF.ptsTots.SS.EP0b,	questTooltips.EP0b},
			{16, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP0A)),						GetSV(sVarPtsData.ZQ.EP0a),	USPF.ptsTots.ZQ.EP0a,	GetSV(sVarPtsData.SS.EP0a),	USPF.ptsTots.SS.EP0a,	questTooltips.EP0a},
			{17, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP1)),						GetSV(sVarPtsData.ZQ.EP1),	USPF.ptsTots.ZQ.EP1,	GetSV(sVarPtsData.SS.EP1),	USPF.ptsTots.SS.EP1,	questTooltips.EP1},
			{18, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP2)),						GetSV(sVarPtsData.ZQ.EP2),	USPF.ptsTots.ZQ.EP2,	GetSV(sVarPtsData.SS.EP2),	USPF.ptsTots.SS.EP2,	questTooltips.EP2},
			{19, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP3)),						GetSV(sVarPtsData.ZQ.EP3),	USPF.ptsTots.ZQ.EP3,	GetSV(sVarPtsData.SS.EP3),	USPF.ptsTots.SS.EP3,	questTooltips.EP3},
			{20, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP4)),						GetSV(sVarPtsData.ZQ.EP4),	USPF.ptsTots.ZQ.EP4,	GetSV(sVarPtsData.SS.EP4),	USPF.ptsTots.SS.EP4,	questTooltips.EP4},
			{21, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP5)),						GetSV(sVarPtsData.ZQ.EP5),	USPF.ptsTots.ZQ.EP5,	GetSV(sVarPtsData.SS.EP5),	USPF.ptsTots.SS.EP5,	questTooltips.EP5},
			{22, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.CH)),						GetSV(sVarPtsData.ZQ.CH),	USPF.ptsTots.ZQ.CH,		GetSV(sVarPtsData.SS.CH),	USPF.ptsTots.SS.CH,		questTooltips.CH},
			{23, zf("<<C:1>> <<2>>",	GZNBId(USPF.data.ZId.ZN.CAD), "AD"),				GetSV(sVarPtsData.ZQ.CAD),	USPF.ptsTots.ZQ.CAD,	GetSV(sVarPtsData.SS.CAD),	USPF.ptsTots.SS.CAD,	questTooltips.CAD},
			{24, zf("<<C:1>> <<2>>",	GZNBId(USPF.data.ZId.ZN.CDC), "DC"),				GetSV(sVarPtsData.ZQ.CDC),	USPF.ptsTots.ZQ.CDC,	GetSV(sVarPtsData.SS.CDC),	USPF.ptsTots.SS.CDC,	questTooltips.CDC},
			{25, zf("<<C:1>> <<2>>",	GZNBId(USPF.data.ZId.ZN.CEP), "EP"),				GetSV(sVarPtsData.ZQ.CEP),	USPF.ptsTots.ZQ.CEP,	GetSV(sVarPtsData.SS.CEP),	USPF.ptsTots.SS.CEP,	questTooltips.CEP},
			{26, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.CMT)),						GetSV(sVarPtsData.ZQ.CMT),	USPF.ptsTots.ZQ.CMT,	GetSV(sVarPtsData.SS.CMT),	USPF.ptsTots.SS.CMT,	questTooltips.CMT},
			{27, zf("<<C:1>> <<C:2>>",	GS(USPF_GUI_ZN_LCL), GZNBId(USPF.data.ZId.ZN.CL)),	GetSV(sVarPtsData.ZQ.LCL),	USPF.ptsTots.ZQ.LCL,	GetSV(sVarPtsData.SS.LCL),	USPF.ptsTots.SS.LCL,	questTooltips.LCL},
			{28, zf("<<C:1>> <<C:2>>",	GS(USPF_GUI_ZN_UCL), GZNBId(USPF.data.ZId.ZN.CL)),	GetSV(sVarPtsData.ZQ.UCL),	USPF.ptsTots.ZQ.UCL,	GetSV(sVarPtsData.SS.UCL),	USPF.ptsTots.SS.UCL,	questTooltips.UCL},
			{29, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.IC)),						GetSV(sVarPtsData.ZQ.IC),	USPF.ptsTots.ZQ.IC,		GetSV(sVarPtsData.SS.IC),	USPF.ptsTots.SS.IC,		questTooltips.IC},
			{30, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.RO)),						GetSV(sVarPtsData.ZQ.RO),	USPF.ptsTots.ZQ.RO,		GetSV(sVarPtsData.SS.WR),	USPF.ptsTots.SS.WR,		questTooltips.RO},
			{31, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.HB)),						GetSV(sVarPtsData.ZQ.TG),	USPF.ptsTots.ZQ.TG,		GetSV(sVarPtsData.SS.HB),	USPF.ptsTots.SS.HB,		questTooltips.TG},
			{32, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.GC)),						GetSV(sVarPtsData.ZQ.DB),	USPF.ptsTots.ZQ.DB,		GetSV(sVarPtsData.SS.GC),	USPF.ptsTots.SS.GC,		questTooltips.DB},
			{33, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.VV)),						GetSV(sVarPtsData.ZQ.MW),	USPF.ptsTots.ZQ.MW,		GetSV(sVarPtsData.SS.VV),	USPF.ptsTots.SS.VV,		questTooltips.MW},
			{34, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.CC)),						GetSV(sVarPtsData.ZQ.CC),	USPF.ptsTots.ZQ.CC,		GetSV(sVarPtsData.SS.CC),	USPF.ptsTots.SS.CC,		questTooltips.CC},
			{35, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.SU)),						GetSV(sVarPtsData.ZQ.SU),	USPF.ptsTots.ZQ.SU,		GetSV(sVarPtsData.SS.SU),	USPF.ptsTots.SS.SU,		questTooltips.SU},
			{36, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.MM)),						GetSV(sVarPtsData.ZQ.MM),	USPF.ptsTots.ZQ.MM,		GetSV(sVarPtsData.SS.MM),	USPF.ptsTots.SS.MM,		questTooltips.MM},
			{37, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.NE)),						GetSV(sVarPtsData.ZQ.NE),	USPF.ptsTots.ZQ.NE,		GetSV(sVarPtsData.SS.NE),	USPF.ptsTots.SS.NE,		questTooltips.NE},
			{38, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.SE)),						GetSV(sVarPtsData.ZQ.SE),	USPF.ptsTots.ZQ.SE,		GetSV(sVarPtsData.SS.SE),	USPF.ptsTots.SS.SE,		questTooltips.SE},
			{39, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.WS)),						GetSV(sVarPtsData.ZQ.WS),	USPF.ptsTots.ZQ.WS,		GetSV(sVarPtsData.SS.WS),	USPF.ptsTots.SS.WS,		questTooltips.WS},
			{40, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.TR)),						GetSV(sVarPtsData.ZQ.TR),	USPF.ptsTots.ZQ.TR,		GetSV(sVarPtsData.SS.TR),	USPF.ptsTots.SS.TR,		questTooltips.TR},
			{41, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.BW)),						GetSV(sVarPtsData.ZQ.BW),	USPF.ptsTots.ZQ.BW,		GetSV(sVarPtsData.SS.BW),	USPF.ptsTots.SS.BW,		questTooltips.BW},
			{42, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.TD)),						GetSV(sVarPtsData.ZQ.TD),	USPF.ptsTots.ZQ.TD,		GetSV(sVarPtsData.SS.TD),	USPF.ptsTots.SS.TD,		questTooltips.TD},
			{43, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.HI)),						GetSV(sVarPtsData.ZQ.HI),	USPF.ptsTots.ZQ.HI,		GetSV(sVarPtsData.SS.HI),	USPF.ptsTots.SS.HI,		questTooltips.HI},
			{44, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.GY)),						GetSV(sVarPtsData.ZQ.GY),	USPF.ptsTots.ZQ.GY,		GetSV(sVarPtsData.SS.GY),	USPF.ptsTots.SS.GY,		questTooltips.GY},
			{45, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AP)),						GetSV(sVarPtsData.ZQ.AP),	USPF.ptsTots.ZQ.AP,		GetSV(sVarPtsData.SS.AP),	USPF.ptsTots.SS.AP,		questTooltips.AP},
		},
		SQS_SL_T = strF("%d/%d", sVarPtsData.ZQTot, USPF.ptsTots.ZQTot),
		SQS_SS_T = strF("%d/%d", sVarPtsData.SSTot, USPF.ptsTots.SSTot),
		GDQ = {
			{ 1, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC1)),	GetSV(sVarPtsData.GD.BC1),	USPF.ptsTots.GD.BC1,	GetGDQuestTooltipText("BC1")},
			{ 2, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC2)),	GetSV(sVarPtsData.GD.BC2),	USPF.ptsTots.GD.BC2,	GetGDQuestTooltipText("BC2")},
			{ 3, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.EH1)),	GetSV(sVarPtsData.GD.EH1),	USPF.ptsTots.GD.EH1,	GetGDQuestTooltipText("EH1")},
			{ 4, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.EH2)),	GetSV(sVarPtsData.GD.EH2),	USPF.ptsTots.GD.EH2,	GetGDQuestTooltipText("EH2")},
			{ 5, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA1)),	GetSV(sVarPtsData.GD.CA1),	USPF.ptsTots.GD.CA1,	GetGDQuestTooltipText("CA1")},
			{ 6, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA2)),	GetSV(sVarPtsData.GD.CA2),	USPF.ptsTots.GD.CA2,	GetGDQuestTooltipText("CA2")},
			{ 7, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.TI)),	GetSV(sVarPtsData.GD.TI),	USPF.ptsTots.GD.TI,		GetGDQuestTooltipText("TI")},
			{ 8, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SW)),	GetSV(sVarPtsData.GD.SW),	USPF.ptsTots.GD.SW,		GetGDQuestTooltipText("SW")},
			{ 9, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SC1)),	GetSV(sVarPtsData.GD.SC1),	USPF.ptsTots.GD.SC1,	GetGDQuestTooltipText("SC1")},
			{10, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SC2)),	GetSV(sVarPtsData.GD.SC2),	USPF.ptsTots.GD.SC2,	GetGDQuestTooltipText("SC2")},
			{11, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WS1)),	GetSV(sVarPtsData.GD.WS1),	USPF.ptsTots.GD.WS1,	GetGDQuestTooltipText("WS1")},
			{12, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WS2)),	GetSV(sVarPtsData.GD.WS2),	USPF.ptsTots.GD.WS2,	GetGDQuestTooltipText("WS2")},
			{13, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CH1)),	GetSV(sVarPtsData.GD.CH1),	USPF.ptsTots.GD.CH1,	GetGDQuestTooltipText("CH1")},
			{14, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CH2)),	GetSV(sVarPtsData.GD.CH2),	USPF.ptsTots.GD.CH2,	GetGDQuestTooltipText("CH2")},
			{15, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.VF)),	GetSV(sVarPtsData.GD.VF),	USPF.ptsTots.GD.VF,		GetGDQuestTooltipText("VF")},
			{16, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BH)),	GetSV(sVarPtsData.GD.BH),	USPF.ptsTots.GD.BH,		GetGDQuestTooltipText("BH")},
			{17, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FG1)),	GetSV(sVarPtsData.GD.FG1),	USPF.ptsTots.GD.FG1,	GetGDQuestTooltipText("FG1")},
			{18, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FG2)),	GetSV(sVarPtsData.GD.FG2),	USPF.ptsTots.GD.FG2,	GetGDQuestTooltipText("FG2")},
			{19, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DC1)),	GetSV(sVarPtsData.GD.DC1),	USPF.ptsTots.GD.DC1,	GetGDQuestTooltipText("DC1")},
			{20, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DC2)),	GetSV(sVarPtsData.GD.DC2),	USPF.ptsTots.GD.DC2,	GetGDQuestTooltipText("DC2")},
			{21, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.AC)),	GetSV(sVarPtsData.GD.AC),	USPF.ptsTots.GD.AC,		GetGDQuestTooltipText("AC")},
			{22, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DK)),	GetSV(sVarPtsData.GD.DK),	USPF.ptsTots.GD.DK,		GetGDQuestTooltipText("DK")},
			{23, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC)),	GetSV(sVarPtsData.GD.BC),	USPF.ptsTots.GD.BC,		GetGDQuestTooltipText("BC")},
			{24, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CH)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.VM)),	GetSV(sVarPtsData.GD.VM),	USPF.ptsTots.GD.VM,		GetGDQuestTooltipText("VM")},
			{25, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.ICP)),	GetSV(sVarPtsData.GD.ICP),	USPF.ptsTots.GD.ICP,	GetGDQuestTooltipText("ICP")},
			{26, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WGT)),	GetSV(sVarPtsData.GD.WGT),	USPF.ptsTots.GD.WGT,	GetGDQuestTooltipText("WGT")},
			{27, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CS)),	GetSV(sVarPtsData.GD.CS),	USPF.ptsTots.GD.CS,		GetGDQuestTooltipText("CS")},
			{28, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.RM)),	GetSV(sVarPtsData.GD.RM),	USPF.ptsTots.GD.RM,		GetGDQuestTooltipText("RM")},
			{29, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CL)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BF)),	GetSV(sVarPtsData.GD.BF),	USPF.ptsTots.GD.BF,		GetGDQuestTooltipText("BF")},
			{30, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CL)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FH)),	GetSV(sVarPtsData.GD.FH),	USPF.ptsTots.GD.FH,		GetGDQuestTooltipText("FH")},
			{31, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FL)),	GetSV(sVarPtsData.GD.FL),	USPF.ptsTots.GD.FL,		GetGDQuestTooltipText("FL")},
			{32, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SP)),	GetSV(sVarPtsData.GD.SP),	USPF.ptsTots.GD.SP,		GetGDQuestTooltipText("SP")},
			{33, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MHK)),	GetSV(sVarPtsData.GD.MHK),	USPF.ptsTots.GD.MHK,	GetGDQuestTooltipText("MHK")},
			{34, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MOS)),	GetSV(sVarPtsData.GD.MOS),	USPF.ptsTots.GD.MOS,	GetGDQuestTooltipText("MOS")},
			{35, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.GC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DoM)),	GetSV(sVarPtsData.GD.DoM),	USPF.ptsTots.GD.DoM,	GetGDQuestTooltipText("DoM")},
			{36, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FV)),	GetSV(sVarPtsData.GD.FV),	USPF.ptsTots.GD.FV,		GetGDQuestTooltipText("FV")},
			{37, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.LM)),	GetSV(sVarPtsData.GD.LM),	USPF.ptsTots.GD.LM,		GetGDQuestTooltipText("LM")},
			{38, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MF)),	GetSV(sVarPtsData.GD.MF),	USPF.ptsTots.GD.MF,		GetGDQuestTooltipText("MF")},
			{39, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.IR)),	GetSV(sVarPtsData.GD.IR),	USPF.ptsTots.GD.IR,		GetGDQuestTooltipText("IR")},
			{40, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.UG)),	GetSV(sVarPtsData.GD.UG),	USPF.ptsTots.GD.UG,		GetGDQuestTooltipText("UG")},
			{41, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SG)),	GetSV(sVarPtsData.GD.SG),	USPF.ptsTots.GD.SG,		GetGDQuestTooltipText("SG")},
			{42, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.WS)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CT)),	GetSV(sVarPtsData.GD.CT),	USPF.ptsTots.GD.CT,		GetGDQuestTooltipText("CT")},
			{43, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.GC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BDV)),	GetSV(sVarPtsData.GD.BDV),	USPF.ptsTots.GD.BDV,	GetGDQuestTooltipText("BDV")},
			{44, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.TC)),	GetSV(sVarPtsData.GD.TC),	USPF.ptsTots.GD.TC,		GetGDQuestTooltipText("TC")},
			{45, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.RPB)),	GetSV(sVarPtsData.GD.RPB),	USPF.ptsTots.GD.RPB,	GetGDQuestTooltipText("RPB")},
			{46, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BW)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.TDC)),	GetSV(sVarPtsData.GD.TDC),	USPF.ptsTots.GD.TDC,	GetGDQuestTooltipText("TDC")},
			{47, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA)),	GetSV(sVarPtsData.GD.CA),	USPF.ptsTots.GD.CA,		GetGDQuestTooltipText("CA")},
			{48, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SR)),	GetSV(sVarPtsData.GD.SR),	USPF.ptsTots.GD.SR,		GetGDQuestTooltipText("SR")},
			{49, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.HI)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.ERE)),	GetSV(sVarPtsData.GD.ERE),	USPF.ptsTots.GD.ERE,		GetGDQuestTooltipText("ERE")},
			{50, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.HI)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.GD)),	GetSV(sVarPtsData.GD.GD),	USPF.ptsTots.GD.GD,		GetGDQuestTooltipText("GD")},
			{51, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BS)),	GetSV(sVarPtsData.GD.BS),	USPF.ptsTots.GD.BS,		GetGDQuestTooltipText("BS")},
			{52, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SH)),	GetSV(sVarPtsData.GD.SH),	USPF.ptsTots.GD.SH,		GetGDQuestTooltipText("SH")},
			{53, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.TR)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.OP)),	GetSV(sVarPtsData.GD.OP),	USPF.ptsTots.GD.OP,		GetGDQuestTooltipText("OP")},
			{54, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BV)),	GetSV(sVarPtsData.GD.BV),	USPF.ptsTots.GD.BV,		GetGDQuestTooltipText("BV")},
		},
		GDQ_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.GDTot, USPF.ptsTots.GDTot),
		PDGBE = {
			{ 1, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD1)),	GetSV(sVarPtsData.PD.AD1),	USPF.ptsTots.PD.AD1,	GetPDTooltipText("AD1")},
			{ 2, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD2)),	GetSV(sVarPtsData.PD.AD2),	USPF.ptsTots.PD.AD2,	GetPDTooltipText("AD2")},
			{ 3, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD3)),	GetSV(sVarPtsData.PD.AD3),	USPF.ptsTots.PD.AD3,	GetPDTooltipText("AD3")},
			{ 4, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD4)),	GetSV(sVarPtsData.PD.AD4),	USPF.ptsTots.PD.AD4,	GetPDTooltipText("AD4")},
			{ 5, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD5)),	GetSV(sVarPtsData.PD.AD5),	USPF.ptsTots.PD.AD5,	GetPDTooltipText("AD5")},
			{ 6, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC1)),	GetSV(sVarPtsData.PD.DC1),	USPF.ptsTots.PD.DC1,	GetPDTooltipText("DC1")},
			{ 7, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC2)),	GetSV(sVarPtsData.PD.DC2),	USPF.ptsTots.PD.DC2,	GetPDTooltipText("DC2")},
			{ 8, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC3)),	GetSV(sVarPtsData.PD.DC3),	USPF.ptsTots.PD.DC3,	GetPDTooltipText("DC3")},
			{ 9, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC4)),	GetSV(sVarPtsData.PD.DC4),	USPF.ptsTots.PD.DC4,	GetPDTooltipText("DC4")},
			{10, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC5)),	GetSV(sVarPtsData.PD.DC5),	USPF.ptsTots.PD.DC5,	GetPDTooltipText("DC5")},
			{11, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP1)),	GetSV(sVarPtsData.PD.EP1),	USPF.ptsTots.PD.EP1,	GetPDTooltipText("EP1")},
			{12, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP2)),	GetSV(sVarPtsData.PD.EP2),	USPF.ptsTots.PD.EP2,	GetPDTooltipText("EP2")},
			{13, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP3)),	GetSV(sVarPtsData.PD.EP3),	USPF.ptsTots.PD.EP3,	GetPDTooltipText("EP3")},
			{14, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP4)),	GetSV(sVarPtsData.PD.EP4),	USPF.ptsTots.PD.EP4,	GetPDTooltipText("EP4")},
			{15, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP5)),	GetSV(sVarPtsData.PD.EP5),	USPF.ptsTots.PD.EP5,	GetPDTooltipText("EP5")},
			{16, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CH)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.CH)),	GetSV(sVarPtsData.PD.CH),		USPF.ptsTots.PD.CH,		GetPDTooltipText("CH")},
			{17, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.WOO)),	GetSV(sVarPtsData.PD.WOO),	USPF.ptsTots.PD.WOO,	GetPDTooltipText("WOO")},
			{18, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.WRK)),	GetSV(sVarPtsData.PD.WRK),	USPF.ptsTots.PD.WRK,	GetPDTooltipText("WRK")},
			{19, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.VV)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.VFW)),	GetSV(sVarPtsData.PD.VFW),	USPF.ptsTots.PD.VFW,	GetPDTooltipText("VFW")},
			{20, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.VV)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.VNC)),	GetSV(sVarPtsData.PD.VNC),	USPF.ptsTots.PD.VNC,	GetPDTooltipText("VNC")},
			{21, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SKW)),	GetSV(sVarPtsData.PD.SKW),	USPF.ptsTots.PD.SKW,	GetPDTooltipText("SKW")},
			{22, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SSH)),	GetSV(sVarPtsData.PD.SSH),	USPF.ptsTots.PD.SSH,	GetPDTooltipText("SSH")},
			{23, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.OC)),	GetSV(sVarPtsData.PD.OC),		USPF.ptsTots.PD.OC,		GetPDTooltipText("OC")},
			{24, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.RN)),	GetSV(sVarPtsData.PD.RN),		USPF.ptsTots.PD.RN,		GetPDTooltipText("RN")},
			{25, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.WS)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.LT)),	GetSV(sVarPtsData.PD.LT),		USPF.ptsTots.PD.LT,		GetPDTooltipText("LT")},
			{26, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.NK)),	GetSV(sVarPtsData.PD.NK),		USPF.ptsTots.PD.NK,		GetPDTooltipText("NK")},
			{27, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BW)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SH)),	GetSV(sVarPtsData.PD.SH),		USPF.ptsTots.PD.SH,		GetPDTooltipText("SH")},
			{28, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BW)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.ZA)),	GetSV(sVarPtsData.PD.ZA),		USPF.ptsTots.PD.ZA,		GetPDTooltipText("ZA")},
			{29, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.HI)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.GHB)),	GetSV(sVarPtsData.PD.GHB),		USPF.ptsTots.PD.GHB,		GetPDTooltipText("GHB")},
			{30, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.HI)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SCC)),	GetSV(sVarPtsData.PD.SCC),		USPF.ptsTots.PD.SCC,		GetPDTooltipText("SCC")},
			{31, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AP)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.GO)),	GetSV(sVarPtsData.PD.GO),		USPF.ptsTots.PD.GO,		GetPDTooltipText("GO")},
			{32, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AP)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.TU)),	GetSV(sVarPtsData.PD.TU),		USPF.ptsTots.PD.TU,		GetPDTooltipText("TU")},
		},
		PDGBE_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.PDTot, USPF.ptsTots.PDTot),
		CharacterTot = strF("%s: %d/%d (%s %s)", GS(USPF_GUI_CHAR_TOTAL), sVarPtsData.Tot, USPF.ptsTots.Tot, sVarPtsData.Unassigned and tostring(sVarPtsData.Unassigned) or "?", GS(USPF_GUI_UNASSIGNED)),
	}
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
	USPF.ptsData.MWChar = (GCQI(USPF.data.MO[1]) ~= "" or USPF.settings.MWC) and 1 or 0

	--Summerset Only Character Quest Skill Points
	USPF.ptsData.SUChar = (GCQI(USPF.data.SO[1]) ~= "" or USPF.settings.SSC) and 1 or 0

	--Elsweyr Only Character Quest Skill Points
	USPF.ptsData.EWChar = (GCQI(USPF.data.EO[1]) ~= "" or USPF.settings.EWC) and 1 or 0

	--Greymoor Only Character Quest Skill Points
	USPF.ptsData.GMChar = (GCQI(USPF.data.GO[1]) ~= "" or USPF.settings.GMC) and 1 or 0

	--Blackwood Only Character Quest Skill Points
	USPF.ptsData.BWChar = (GCQI(USPF.data.BO[1]) ~= "" or USPF.settings.BWC) and 1 or 0

	USPF.ptsData.EndlArch = (GCQI(USPF.data.EA[1]) ~= "") and 1 or 0

	for k,_ in pairs(USPF.ptsData.ZQ) do
		if USPF.data[k] ~= nil then
			for i=1, #USPF.data[k] do
				USPF.ptsData.ZQ[k] = USPF.ptsData.ZQ[k] + ((GCQI(USPF.data[k][i]) ~= "") and 1 or 0)
			end
			USPF.ptsData.ZQTot = USPF.ptsData.ZQTot + USPF.ptsData.ZQ[k]
		end
	end

	--Group Dungeon Quest Skill Points
	for k,_ in pairs(USPF.ptsData.GD) do
		USPF.ptsData.GD[k] = GCQI(USPF.data.GD[k]) ~= "" and 1 or 0
		USPF.ptsData.GDTot = USPF.ptsData.GDTot + USPF.ptsData.GD[k]
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
	for k,_ in pairs(USPF.ptsData.PD) do
		USPF.ptsData.PD[k] = IAchC(USPF.data.PD[k]) and 1 or 0
		USPF.ptsData.PDTot = USPF.ptsData.PDTot + USPF.ptsData.PD[k]
	end

	if USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar]) then
		--Update saved variables.
		USPF.sVar.ptsData[selectedChar].PD		= USPF_LTF:CopyTable(USPF.ptsData.PD)
		USPF.sVar.ptsData[selectedChar].PDTot	= USPF.ptsData.PDTot
	end
end

local function USPF_SetSkyshardPoints()
	for k,_ in pairs(USPF.ptsData.SS) do
        local v = USPF.data.SS[k]
		for i=v[1], v[1] + v[2] - 1 do
            if GetSkyshardDiscoveryStatus(i) == SKYSHARD_DISCOVERY_STATUS_ACQUIRED then
                USPF.ptsData.SS[k] = USPF.ptsData.SS[k] + 1
            end
		end
		USPF.ptsData.numSSTot = USPF.ptsData.numSSTot + USPF.ptsData.SS[k]
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
			progress = USPF_FormatProgress(tempTable[i][4], tempTable[i][5], GDQ_Color),
			tooltipText = tempTable[i][6]
		})
	end

	table.insert(dataLines_GDQ2, gdqHeader)
	for i = splitIndex + 1, #tempTable do
		table.insert(dataLines_GDQ2, {
			zone = tempTable[i][2],
			dungeon = tempTable[i][3],
			progress = USPF_FormatProgress(tempTable[i][4], tempTable[i][5], GDQ_Color),
			tooltipText = tempTable[i][6]
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
			progress = USPF_FormatProgress(tempTable[i][4], tempTable[i][5], PDB_Color),
			tooltipText = tempTable[i][6]
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
