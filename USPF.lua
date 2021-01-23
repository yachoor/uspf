if USPF == nil then USPF = {} end
USPF.AddonName = "USPF"
USPF.version = 1.0
USPF.active = false
USPF.cache = {}
USPF.GUI = {}
local selectedChar = GetCurrentCharacterId()
local currentCharName = nil
local debugMode = false
local EM = EVENT_MANAGER
local GZNBId, GCCId, GCQI = GetZoneNameById, GetCurrentCharacterId, GetCompletedQuestInfo
local IAchC, GAchNCr, GAchCr = IsAchievementComplete, GetAchievementNumCriteria, GetAchievementCriterion
local GS, zf, strF = GetString, zo_strformat, string.format
local _

local USPF_LTF = LibTableFunctions
if (not USPF_LTF) then return end

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
}

USPF.defaults = {
	firstRun = true,
	numChars = 0,
	charInfo = {},
	settings = {},
	ptsData = {},
}


USPF.ptsData = {
	Tot		= 0, GenTot	 = 0, ZQTot	  = 0, numSSTot	= 0, SSTot	= 0,
	GDTot	= 0, PDTot	 = 0, Level	  = 0, MainQ	= 0, FolDis	= 0,
	MWChar	= 0, SUChar  = 0, EWChar  = 0, GMChar  = 0,
  PvPRank	= 0, MaelAr	= 0,
	ZQ = {
		AD0 = 0, AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5  = 0, DC0a = 0, DC0b = 0,
		DC1 = 0, DC2 = 0, DC3 = 0, DC4 = 0, DC5 = 0, EP0a = 0, EP0b = 0, EP1  = 0,
		EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL = 0, CC  = 0, DB  = 0, IC   = 0, MW   = 0, RO   = 0,
		TG  = 0, SU  = 0, MM  = 0, NE  = 0, WP  = 0, SE   = 0, WS = 0,
	},
	SS = {
		AD0 = 0, AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5  = 0, DC0a = 0, DC0b = 0,
		DC1 = 0, DC2 = 0, DC3 = 0, DC4 = 0, DC5 = 0, EP0a = 0, EP0b = 0, EP1  = 0,
		EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL = 0, IC  = 0, WR  = 0, HB   = 0, GC   = 0, VV   = 0,
		CC  = 0, MQ  = 0, SU  = 0, MM  = 0, NE  = 0, SE   = 0, WS = 0,
	},
	GD = {
		BC1 = 0, BC2 = 0, EH1 = 0, EH2 = 0, CA1 = 0, CA2 = 0, TI = 0, SW = 0,
		SC1 = 0, SC2 = 0, WS1 = 0, WS2 = 0, CH1 = 0, CH2 = 0, VF = 0, BH = 0,
		FG1 = 0, FG2 = 0, DC1 = 0, DC2 = 0, AC  = 0, DK  = 0, BC = 0, VM = 0,
		WGT = 0, ICP = 0, RM  = 0, CS  = 0, BF  = 0, FH  = 0, FL = 0, SP = 0,
		MHK = 0, MOS = 0, DoM = 0, FV  = 0, LM  = 0, MF  = 0, IR = 0, UG = 0,
		SG  = 0, CT  = 0,
	},
	PD = {
		AD1 = 0, AD2 = 0, AD3 = 0, AD4 = 0, AD5 = 0, DC1 = 0, DC2 = 0, DC3 = 0,
		DC4 = 0, DC5 = 0, EP1 = 0, EP2 = 0, EP3 = 0, EP4 = 0, EP5 = 0, CH  = 0,
		VFW = 0, VNC = 0, WOO = 0, WRK = 0, SKW = 0, SSH = 0, RN  = 0, OC  = 0,
    LT = 0, NK = 0,
	},
}

USPF.ptsTots = {	--Tot and GenTot are 444 and 129 because you can't do more than one DLC tutorial.
	Tot		= 457, GenTot = 129, ZQTot	= 103, numSSTot	= 471, SSTot  = 157,
	GDTot	=  42, PDTot  =  26, Level	=  64, MainQ	=  11, FolDis =   2,
	MWChar	=   1, SUChar =   1, EWChar =   1, GMChar = 1,
  PvPRank  =  50, MaelAr =   1,
	ZQ = {
		AD0 = 0, AD1 = 3, AD2 =  3, AD3 = 3, AD4 = 3, AD5  = 3, DC0a = 0, DC0b = 0,
		DC1 = 4, DC2 = 3, DC3 =  3, DC4 = 3, DC5 = 3, EP0a = 0, EP0b = 0, EP1  = 3,
		EP2 = 3, EP3 = 3, EP4 =  3, EP5 = 3, CH  = 3, CAD  = 0, CDC  = 0, CEP  = 0,
		CMT = 0, LCL = 0, UCL =  0, CC  = 8, DB  = 8, IC   = 1, MW   = 3, RO   = 3,
		TG  = 6, SU  = 3, MM  =  7, NE  = 3, WP  = 0, SE   = 9, WS = 3,
	},
	SS = {
		AD0  = 6,  AD1 = 16, AD2 = 16, AD3 = 16, AD4 = 16, AD5 = 16, DC0a = 3,
		DC0b = 3,  DC1 = 16, DC2 = 16, DC3 = 16, DC4 = 16, DC5 = 16, EP0a = 3,
		EP0b = 3,  EP1 = 16, EP2 = 16, EP3 = 16, EP4 = 16, EP5 = 16, CH   = 16,
		CAD  = 15, CDC = 15, CEP = 15, CMT = 1,  LCL = 12, UCL = 6,  IC   = 13,
		WR   = 17, HB  = 6,  GC  = 6,  VV  = 18, CC  = 6,  MQ  = 1,  SU   = 18,
		MM   = 6,  NE  = 18, SE  = 6, WS = 18,
	},
	GD = {
		BC1 = 1, BC2 = 1, EH1 = 1, EH2 = 1, CA1 = 1, CA2 = 1, TI = 1, SW = 1,
		SC1 = 1, SC2 = 1, WS1 = 1, WS2 = 1, CH1 = 1, CH2 = 1, VF = 1, BH = 1,
		FG1 = 1, FG2 = 1, DC1 = 1, DC2 = 1, AC  = 1, DK  = 1, BC = 1, VM = 1,
		WGT = 1, ICP = 1, RM  = 1, CS  = 1, BF  = 1, FH  = 1, FL = 1, SP = 1,
		MHK = 1, MOS = 1, DoM = 1, FV  = 1, LM  = 1, MF  = 1, IR = 1, UG = 1,
		SG  = 1, CT  = 1
	},
	PD = {
		AD1 = 1, AD2 = 1, AD3 = 1, AD4 = 1, AD5 = 1, DC1 = 1, DC2 = 1, DC3 = 1,
		DC4 = 1, DC5 = 1, EP1 = 1, EP2 = 1, EP3 = 1, EP4 = 1, EP5 = 1, CH  = 1,
		VFW = 1, VNC = 1, WOO = 1, WRK = 1, SKW = 1, SSH = 1, RN  = 1, OC  = 1,
    LT = 1, NK = 1,
	},
}

local tempZId = {
	ZN = {
		AD0  = 537, AD1  =  381, AD2  = 383, AD3 =  108, AD4 =  58, AD5 =  382, 
		DC0A = 535, DC0B =  534, DC1  =   3, DC2 =   19, DC3 =  20, DC4 =  104,
		DC5  =  92, EP0B =  280, EP0A = 281, EP1 =   41, EP2 =  57, EP3 =  117,
		EP4  = 101, EP5  =  103, CH   = 347, CYD =  181, CAD = 181, CDC =  181,
		CEP  = 181, CMT  =  181, CL   = 888, LCL =  888, UCL = 888, IC  =  584,
		RO   = 684, HB   =  816, GC   = 823, VV  =  849, CC  = 980, SU  = 1011,
		MM   = 726, NE   = 1086, WP   = 586, SE  = 1133, WS = 1160, BGC = 1161,
	},
	GDN = {
		BC1 =  380, BC2 =  935, EH1 =  126, EH2 =  931, CA1 =  176, CA2 =  681,
		TI  =  131, SW  =   31, SC1 =  144, SC2 =  936, WS1 =  146, WS2 =  933,
		CH1 =  130, CH2 =  932, VF  =   22, BH  =   38, FG1 =  283, FG2 =  934,
		DC1 =   63, DC2 =  930, AC  =  148, DK  =  449, BC  =   64, VM  =   11,
		ICP =  678, WGT =  688, CS  =  848, RM  =  843, BF  =  973, FH  =  974,
		FL  = 1009, SP	= 1010, MHK = 1052, MOS = 1055, DoM = 1081, FV  = 1080,
		LM  = 1123, MF  = 1122, IR  = 1152, UG  = 1153, SG  = 1197, CT  = 1201,
	},
	PDN = {
		AD1 = 486, AD2 = 124, AD3 =  137, AD4 =  138, AD5 =  487, DC1 =  284,
		DC2 = 142, DC3 = 162, DC4 =  308, DC5 =  169, EP1 =  216, EP2 =  306,
		EP3 = 134, EP4 = 339, EP5 =  341, CH  =  557, WOO =  706, WRK =  705,
		VFW = 919, VNC = 918, SKW = 1020, SSH = 1021, RN  = 1089, OC  = 1090,
    LT = 1186, NK = 1187,
	},
}

USPF.data = {
	ZId = tempZId,
	MAAch = 1304,
	MQAch = 1003,
	ZQAch = {
		AD1 =  943, AD2 =  944, AD3 =  945, AD4 =  946, AD5 =  947, CC  = 2064,
		CH  =  957, DB  = 1444, DC1 =  953, DC2 =  954, DC3 =  955, DC4 =  956,
		DC5 =  958, EP1 =  948, EP2 =  949, EP3 =  950, EP4 =  951, EP5 =  952,
		IC  = 1175, RO  = 1260, TG  = 1363, SU  = 2208, MM  = 2339, NE  = 2488,
		SE  = 2604, WS = 2722,
	},
	AD1 = {	--943
		{4222,  360, zf("<<t:1>>", GS(USPF_QUEST_AD1_1)),	1},
		{4345,  361, zf("<<t:1>>", GS(USPF_QUEST_AD1_2)),	1},
		{4261,  362, zf("<<t:1>>", GS(USPF_QUEST_AD1_3)),	1},
	},
	AD2 = {	--944	(1-2 only)
		{4868,  605, zf("<<t:1>>", GS(USPF_QUEST_AD2_1)),	1},
		{4386,  606, zf("<<t:1>>", GS(USPF_QUEST_AD2_2)),	1},
		{4885,  607, zf("<<t:1>>", GS(USPF_QUEST_AD2_3)),	1},
	},
	AD3 = {	--945
		{4750,  510, zf("<<t:1>>", GS(USPF_QUEST_AD3_1)),	1},
		{4765,  511, zf("<<t:1>>", GS(USPF_QUEST_AD3_2)),	1},
		{4690,  512, zf("<<t:1>>", GS(USPF_QUEST_AD3_3)),	1},
	},
	AD4 = {	--946
		{4337,    0, zf("<<t:1>>", GS(USPF_QUEST_AD4_1)),	1},
		{4452,  283, zf("<<t:1>>", GS(USPF_QUEST_AD4_2)),	1},
		{4143,  285, zf("<<t:1>>", GS(USPF_QUEST_AD4_3)),	1},
	},
	AD5 = {	--947
		{4712,    0, zf("<<t:1>>", GS(USPF_QUEST_AD5_1)),	1},
		{4479,  537, zf("<<t:1>>", GS(USPF_QUEST_AD5_2)),	1},
		{4720,  538, zf("<<t:1>>", GS(USPF_QUEST_AD5_3)),	1},
	},
	CC = {	--2064
		{6050, 2050, zf("<<t:1>>", GS(USPF_QUEST_CC_1)),	1},
		{6057, 2058, zf("<<t:1>>", GS(USPF_QUEST_CC_2)),	1},
		{6063, 2059, zf("<<t:1>>", GS(USPF_QUEST_CC_3)),	1},
		{6025, 2060, zf("<<t:1>>", GS(USPF_QUEST_CC_4)),	1},
		{6052, 2061, zf("<<t:1>>", GS(USPF_QUEST_CC_5)),	1},
		{6046, 2062, zf("<<t:1>>", GS(USPF_QUEST_CC_6)),	1},
		{6047, 2063, zf("<<t:1>>", GS(USPF_QUEST_CC_7)),	1},
		{6048, 2064, zf("<<t:1>>", GS(USPF_QUEST_CC_8)),	1},
	},
	CH = {	--957
		{4602,  612, zf("<<t:1>>", GS(USPF_QUEST_CH_1)),	1},
		{4730,  613, zf("<<t:1>>", GS(USPF_QUEST_CH_2)),	1},
		{4758,  614, zf("<<t:1>>", GS(USPF_QUEST_CH_3)),	1},
	},
	DB = {	--1444
		{5540, 1436, zf("<<t:1>>", GS(USPF_QUEST_DB_1)),	1},
		{5595, 1438, zf("<<t:1>>", GS(USPF_QUEST_DB_2)),	1},
		{5599, 1439, zf("<<t:1>>", GS(USPF_QUEST_DB_3)),	1},
		{5596, 1440, zf("<<t:1>>", GS(USPF_QUEST_DB_4)),	1},
		{5567, 1441, zf("<<t:1>>", GS(USPF_QUEST_DB_5)),	1},
		{5597, 1442, zf("<<t:1>>", GS(USPF_QUEST_DB_6)),	1},
		{5598, 1443, zf("<<t:1>>", GS(USPF_QUEST_DB_7)),	1},
		{5600, 1444, zf("<<t:1>>", GS(USPF_QUEST_DB_8)),	1},
	},
	DC1 = {	--953
		{3006,    0, zf("<<t:1>>", GS(USPF_QUEST_DC1_1)),	1},
		{3235,   30, zf("<<t:1>>", GS(USPF_QUEST_DC1_2)),	1},
		{3267,   28, zf("<<t:1>>", GS(USPF_QUEST_DC1_3)),	1},
		{3379,   31, zf("<<t:1>>", GS(USPF_QUEST_DC1_4)),	1},
	},
	DC2 = {	--954
		{ 467,  154, zf("<<t:1>>", GS(USPF_QUEST_DC2_1)),	1},
		{1633,  155, zf("<<t:1>>", GS(USPF_QUEST_DC2_2)),	1},
		{ 575,    0, zf("<<t:1>>", GS(USPF_QUEST_DC2_3)),	1},
	},
	DC3 = {	--955
		{ 465,  589, zf("<<t:1>>", GS(USPF_QUEST_DC3_1)),	1},
		{4972,  590, zf("<<t:1>>", GS(USPF_QUEST_DC3_2)),	1},
		{4884,  591, zf("<<t:1>>", GS(USPF_QUEST_DC3_3)),	1},
	},
	DC4 = {	--956
		{2192,  516, zf("<<t:1>>", GS(USPF_QUEST_DC4_1)),	1},
		{2222,  517, zf("<<t:1>>", GS(USPF_QUEST_DC4_2)),	1},
		{2997,  956, zf("<<t:1>>", GS(USPF_QUEST_DC4_3)),	1},
	},
	DC5 = {	--958
		{4891,    0, zf("<<t:1>>", GS(USPF_QUEST_DC5_1)),	1},
		{4912,  146, zf("<<t:1>>", GS(USPF_QUEST_DC5_2)),	1},
		{4960,  147, zf("<<t:1>>", GS(USPF_QUEST_DC5_3)),	1},
	},
	EO = {
		{6324,    0, zf("<<t:1>>", GS(USPF_QUEST_EO)),		1},
	},
	EP1 = {	--948
		{3735,  201, zf("<<t:1>>", GS(USPF_QUEST_EP1_1)),	1},
		{3634,  204, zf("<<t:1>>", GS(USPF_QUEST_EP1_2)),	1},
		{3868,  209, zf("<<t:1>>", GS(USPF_QUEST_EP1_3)),	1},
	},
	EP2 = {	--949
		{3797,  363, zf("<<t:1>>", GS(USPF_QUEST_EP2_1)),	1},
		{3817,  364, zf("<<t:1>>", GS(USPF_QUEST_EP2_2)),	1},
		{3831,  365, zf("<<t:1>>", GS(USPF_QUEST_EP2_3)),	1},
	},
	EP3 = {	--950
		{4590,  184, zf("<<t:1>>", GS(USPF_QUEST_EP3_1)),	1},
		{4606,  185, zf("<<t:1>>", GS(USPF_QUEST_EP3_2)),	1},
		{3910,  186, zf("<<t:1>>", GS(USPF_QUEST_EP3_2)),	1},
	},
	EP4 = {	--951
		{4061,    0, zf("<<t:1>>", GS(USPF_QUEST_EP4_1)),	1},
		{4115,    0, zf("<<t:1>>", GS(USPF_QUEST_EP4_2)),	1},
		{4117,  599, zf("<<t:1>>", GS(USPF_QUEST_EP4_3)),	1},
	},
	EP5 = {	--952
		{3968,  335, zf("<<t:1>>", GS(USPF_QUEST_EP5_1)),	1},
		{4139,  336, zf("<<t:1>>", GS(USPF_QUEST_EP5_2)),	1},
		{4188,  337, zf("<<t:1>>", GS(USPF_QUEST_EP5_3)),	1},
	},
	GD = {
		BC1 = { 1, 4107,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_BC1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(tempZId.GDN.BC1))},
		BC2 = { 2, 4597,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_BC2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(tempZId.GDN.BC2))},
		EH1 = { 3, 4336,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_EH1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.EH1))},
		EH2 = { 4, 4675,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_EH2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.EH2))},
		CA1 = { 5, 4778,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_CA1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.CA1))},
		CA2 = { 6, 5120,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_CA2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.CA2))},
		TI  = { 7, 4538,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_TI)),		zf("<<C:1>>", GZNBId(tempZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(tempZId.GDN.TI))},
		SW  = { 8, 4733,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_SW)),		zf("<<C:1>>", GZNBId(tempZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(tempZId.GDN.SW))},
		SC1 = { 9, 4054,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_SC1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(tempZId.GDN.SC1))},
		SC2 = {10, 4555,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_SC2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(tempZId.GDN.SC2))},
		WS1 = {11, 4246,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_WS1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.WS1))},
		WS2 = {12, 4813,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_WS2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.WS2))},
		CH1 = {13, 4379,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_CH1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.CH1))},
		CH2 = {14, 5113,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_CH2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.CH2))},
		VF  = {15, 4432,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_VF)),		zf("<<C:1>>", GZNBId(tempZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(tempZId.GDN.VF))},
		BH  = {16, 4589,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_BH)),		zf("<<C:1>>", GZNBId(tempZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(tempZId.GDN.BH))},
		FG1 = {17, 3993,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_FG1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(tempZId.GDN.FG1))},
		FG2 = {18, 4303,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_FG2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(tempZId.GDN.FG2))},
		DC1 = {19, 4145,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_DC1)),	zf("<<C:1>>", GZNBId(tempZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.DC1))},
		DC2 = {20, 4641,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_DC2)),	zf("<<C:1>>", GZNBId(tempZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.DC2))},
		AC  = {21, 4202,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_AC)),		zf("<<C:1>>", GZNBId(tempZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.AC))},
		DK  = {22, 4346,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_DK)),		zf("<<C:1>>", GZNBId(tempZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(tempZId.GDN.DK))},
		BC  = {23, 4469,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_BC)),		zf("<<C:1>>", GZNBId(tempZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(tempZId.GDN.BC))},
		VM  = {24, 4822,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_VM)),		zf("<<C:1>>", GZNBId(tempZId.ZN.CH)),	zf("<<C:1>>", GZNBId(tempZId.GDN.VM))},
		ICP = {25, 5136,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_ICP)),	zf("<<C:1>>", GZNBId(tempZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(tempZId.GDN.ICP))},
		WGT = {26, 5342,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_WGT)),	zf("<<C:1>>", GZNBId(tempZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(tempZId.GDN.WGT))},
		CS  = {27, 5702,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_CS)),		zf("<<C:1>>", GZNBId(tempZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.CS))},
		RM  = {28, 5403,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_RM)),		zf("<<C:1>>", GZNBId(tempZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.RM))},
		BF  = {29, 5889,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_BF)),		zf("<<C:1>>", GZNBId(tempZId.ZN.CL)),	zf("<<C:1>>", GZNBId(tempZId.GDN.BF))},
		FH  = {30, 5891,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_FH)),		zf("<<C:1>>", GZNBId(tempZId.ZN.CL)),	zf("<<C:1>>", GZNBId(tempZId.GDN.FH))},
		FL	= {31, 6064,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_FL)),		zf("<<C:1>>", GZNBId(tempZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(tempZId.GDN.FL))},
		SP	= {32, 6065,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_SP)),		zf("<<C:1>>", GZNBId(tempZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.SP))},
		MHK = {33, 6186,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_MHK)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(tempZId.GDN.MHK))},
		MOS = {34, 6188,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_MOS)),	zf("<<C:1>>", GZNBId(tempZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(tempZId.GDN.MOS))},
		DoM = {35, 6251,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_DoM)),	zf("<<C:1>>", GZNBId(tempZId.ZN.GC)),	zf("<<C:1>>", GZNBId(tempZId.GDN.DoM))},
		FV  = {36, 6249,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_FV)),		zf("<<C:1>>", GZNBId(tempZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(tempZId.GDN.FV))},
		LM  = {37, 6351,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_LM)),		zf("<<C:1>>", GZNBId(tempZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(tempZId.GDN.LM))},
		MF  = {38, 6349,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_MF)),		zf("<<C:1>>", GZNBId(tempZId.ZN.NE)),	zf("<<C:1>>", GZNBId(tempZId.GDN.MF))},
		IR  = {39, 6414,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_IR)),		zf("<<C:1>>", GZNBId(tempZId.ZN.RO)),	zf("<<C:1>>", GZNBId(tempZId.GDN.IR))},
		UG  = {40, 6416,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_UG)),		zf("<<C:1>>", GZNBId(tempZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(tempZId.GDN.UG))},
		SG  = {41, 6505,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_SG)),		zf("<<C:1>>", GZNBId(tempZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(tempZId.GDN.SG))},
		CT  = {42, 6507,    0, zf("<<t:1>>", GS(USPF_QUEST_GD_CT)),		zf("<<C:1>>", GZNBId(tempZId.ZN.WS)),	zf("<<C:1>>", GZNBId(tempZId.GDN.CT))},
	},
	IC = {	--1175
		{5482, 1175, zf("<<t:1>>", GS(USPF_QUEST_IC)),		1},
	},
	MM = {	--2339
		{6246, 2333, zf("<<t:1>>", GS(USPF_QUEST_MM_1)),	1},
		{6266, 2334, zf("<<t:1>>", GS(USPF_QUEST_MM_2)),	1},
		{6241, 2335, zf("<<t:1>>", GS(USPF_QUEST_MM_3)),	1},
		{6259, 2336, zf("<<t:1>>", GS(USPF_QUEST_MM_4)),	1},
		{6243, 2337, zf("<<t:1>>", GS(USPF_QUEST_MM_5)),	1},
		{6244, 2338, zf("<<t:1>>", GS(USPF_QUEST_MM_6)),	1},
		{6245, 2339, zf("<<t:1>>", GS(USPF_QUEST_MM_7)),	1},
	},
	MW = {
		{6003, 1852, zf("<<t:1>>", GS(USPF_QUEST_MW_1)),	1},
		{5922, 1869, zf("<<t:1>>", GS(USPF_QUEST_MW_2)),	1},
		{5948, 1870, zf("<<t:1>>", GS(USPF_QUEST_MW_3)),	1},
	},
	MO = {
		{5804,    0, zf("<<t:1>>", GS(USPF_QUEST_MO)),		1},
	},
	MQ = {	--1003
		{4296,  993, zf("<<t:1>>", GS(USPF_QUEST_MQ_1)),	1},
		{4831,  994, zf("<<t:1>>", GS(USPF_QUEST_MQ_2)),	1},
		{4474,  995, zf("<<t:1>>", GS(USPF_QUEST_MQ_3)),	1},
		{4552,  996, zf("<<t:1>>", GS(USPF_QUEST_MQ_4)),	1},
		{4607,  997, zf("<<t:1>>", GS(USPF_QUEST_MQ_5)),	1},
		{4764,  998, zf("<<t:1>>", GS(USPF_QUEST_MQ_6)),	1},
		{4836,  999, zf("<<t:1>>", GS(USPF_QUEST_MQ_7)),	1},
		{4837, 1000, zf("<<t:1>>", GS(USPF_QUEST_MQ_8)),	1},
		{4867, 1001, zf("<<t:1>>", GS(USPF_QUEST_MQ_9)),	1},
		{4832, 1002, zf("<<t:1>>", GS(USPF_QUEST_MQ_10)),	1},
		{4847, 1003, zf("<<t:1>>", GS(USPF_QUEST_MQ_11)),	1},
	},
	NE = {	--2488
		{6336, 2482, zf("<<t:1>>", GS(USPF_QUEST_NE_1)),	1},
		{6304, 2485, zf("<<t:1>>", GS(USPF_QUEST_NE_2)),	1},
		{6315, 2488, zf("<<t:1>>", GS(USPF_QUEST_NE_3)),	1},
	},
	RO = {	--1260
		{5447, 1325, zf("<<t:1>>", GS(USPF_QUEST_RO_1)),	1},
		{5468, 1326, zf("<<t:1>>", GS(USPF_QUEST_RO_2)),	1},
		{5481, 1327, zf("<<t:1>>", GS(USPF_QUEST_RO_3)),	1},
	},
	TG = {	--1363
		{5531, 1371, zf("<<t:1>>", GS(USPF_QUEST_TG_1)),	1},
		{5534, 1360, zf("<<t:1>>", GS(USPF_QUEST_TG_2)),	1},
		{5532, 1370, zf("<<t:1>>", GS(USPF_QUEST_TG_3)),	1},
		{5556, 1361, zf("<<t:1>>", GS(USPF_QUEST_TG_4)),	1},
		{5549, 1362, zf("<<t:1>>", GS(USPF_QUEST_TG_5)),	1},
		{5545, 1363, zf("<<t:1>>", GS(USPF_QUEST_TG_6)),	1},
	},
	SE = {	--2604
		{6401, 2596, zf("<<t:1>>", GS(USPF_QUEST_SE_1)),	1},
		{6409,    0, zf("<<t:1>>", GS(USPF_QUEST_SE_2)),	1},
		{6394, 2597, zf("<<t:1>>", GS(USPF_QUEST_SE_3)),	1},
		{6399, 2598, zf("<<t:1>>", GS(USPF_QUEST_SE_4)),	1},
		{6403, 2599, zf("<<t:1>>", GS(USPF_QUEST_SE_5)),	1},
		{6404, 2600, zf("<<t:1>>", GS(USPF_QUEST_SE_6)),	1},
		{6393, 2602, zf("<<t:1>>", GS(USPF_QUEST_SE_7)),	1},
		{6397, 2603, zf("<<t:1>>", GS(USPF_QUEST_SE_8)),	1},
		{6402, 2604, zf("<<t:1>>", GS(USPF_QUEST_SE_9)),	1},
	},
	SO = {
		{6143,    0, zf("<<t:1>>", GS(USPF_QUEST_SO)),		1},
	},
	SU = {	--2208
		{6132, 2203, zf("<<t:1>>", GS(USPF_QUEST_SU_1)),	1},
		{6113, 2206, zf("<<t:1>>", GS(USPF_QUEST_SU_2)),	1},
		{6126, 2208, zf("<<t:1>>", GS(USPF_QUEST_SU_3)),	1},
	},
	WS = {	--2722
		{6476, 2720, zf("<<t:1>>", GS(USPF_QUEST_WS_1)),	1},
		{6466, 2722, zf("<<t:1>>", GS(USPF_QUEST_WS_2)),	1},
		{6481, 2725, zf("<<t:1>>", GS(USPF_QUEST_WS_3)),	1},
	},
  GO = {
    {6455,    0, zf("<<t:1>>", GS(USPF_QUEST_GO)),		1},
	},
	PD = {
		AD1	= { 1,  468, zf("<<C:1>>", GZNBId(tempZId.ZN.AD1)), zf("<<C:1>>", GZNBId(tempZId.PDN.AD1))},
		AD2	= { 2,  470, zf("<<C:1>>", GZNBId(tempZId.ZN.AD2)), zf("<<C:1>>", GZNBId(tempZId.PDN.AD2))},
		AD3	= { 3,  445, zf("<<C:1>>", GZNBId(tempZId.ZN.AD3)), zf("<<C:1>>", GZNBId(tempZId.PDN.AD3))},
		AD4	= { 4,  460, zf("<<C:1>>", GZNBId(tempZId.ZN.AD4)), zf("<<C:1>>", GZNBId(tempZId.PDN.AD4))},
		AD5	= { 5,  469, zf("<<C:1>>", GZNBId(tempZId.ZN.AD5)), zf("<<C:1>>", GZNBId(tempZId.PDN.AD5))},
		DC1	= { 6,  380, zf("<<C:1>>", GZNBId(tempZId.ZN.DC1)), zf("<<C:1>>", GZNBId(tempZId.PDN.DC1))},
		DC2	= { 7,  714, zf("<<C:1>>", GZNBId(tempZId.ZN.DC2)), zf("<<C:1>>", GZNBId(tempZId.PDN.DC2))},
		DC3	= { 8,  713, zf("<<C:1>>", GZNBId(tempZId.ZN.DC3)), zf("<<C:1>>", GZNBId(tempZId.PDN.DC3))},
		DC4	= { 9,  707, zf("<<C:1>>", GZNBId(tempZId.ZN.DC4)), zf("<<C:1>>", GZNBId(tempZId.PDN.DC4))},
		DC5	= {10,  708, zf("<<C:1>>", GZNBId(tempZId.ZN.DC5)), zf("<<C:1>>", GZNBId(tempZId.PDN.DC5))},
		EP1	= {11,  379, zf("<<C:1>>", GZNBId(tempZId.ZN.EP1)), zf("<<C:1>>", GZNBId(tempZId.PDN.EP1))},
		EP2	= {12,  388, zf("<<C:1>>", GZNBId(tempZId.ZN.EP2)), zf("<<C:1>>", GZNBId(tempZId.PDN.EP2))},
		EP3	= {13,  372, zf("<<C:1>>", GZNBId(tempZId.ZN.EP3)), zf("<<C:1>>", GZNBId(tempZId.PDN.EP3))},
		EP4	= {14,  381, zf("<<C:1>>", GZNBId(tempZId.ZN.EP4)), zf("<<C:1>>", GZNBId(tempZId.PDN.EP4))},
		EP5	= {15,  371, zf("<<C:1>>", GZNBId(tempZId.ZN.EP5)), zf("<<C:1>>", GZNBId(tempZId.PDN.EP5))},
		CH	= {16,  874, zf("<<C:1>>", GZNBId(tempZId.ZN.CH)),  zf("<<C:1>>", GZNBId(tempZId.PDN.CH))},
		VFW	= {17, 1855, zf("<<C:1>>", GZNBId(tempZId.ZN.VV)),  zf("<<C:1>>", GZNBId(tempZId.PDN.VFW))},
		VNC	= {18, 1846, zf("<<C:1>>", GZNBId(tempZId.ZN.VV)),  zf("<<C:1>>", GZNBId(tempZId.PDN.VNC))},
		WOO	= {19, 1238, zf("<<C:1>>", GZNBId(tempZId.ZN.RO)),  zf("<<C:1>>", GZNBId(tempZId.PDN.WOO))},
		WRK	= {20, 1235, zf("<<C:1>>", GZNBId(tempZId.ZN.RO)),  zf("<<C:1>>", GZNBId(tempZId.PDN.WRK))},
		SKW	= {21, 2096, zf("<<C:1>>", GZNBId(tempZId.ZN.SU)),  zf("<<C:1>>", GZNBId(tempZId.PDN.SKW))},
		SSH	= {22, 2095, zf("<<C:1>>", GZNBId(tempZId.ZN.SU)),  zf("<<C:1>>", GZNBId(tempZId.PDN.SSH))},
		RN	= {23, 2444, zf("<<C:1>>", GZNBId(tempZId.ZN.NE)),  zf("<<C:1>>", GZNBId(tempZId.PDN.RN))},
		OC	= {24, 2445, zf("<<C:1>>", GZNBId(tempZId.ZN.NE)),  zf("<<C:1>>", GZNBId(tempZId.PDN.OC))},
    LT  = {25, 2714, zf("<<C:1>>", GZNBId(tempZId.ZN.WS)),  zf("<<C:1>>", GZNBId(tempZId.PDN.LT))},
    NK  = {26, 2715, zf("<<C:1>>", GZNBId(tempZId.ZN.BGC)),  zf("<<C:1>>", GZNBId(tempZId.PDN.NK))},
	},
	SS = {
		MQ	 = { 1, 2521, zf("<<C:1>>", GZNBId(tempZId.ZN.WP))},
		AD0	 = { 2,  431, zf("<<C:1>>", GZNBId(tempZId.ZN.AD0))},
		AD1	 = { 3,  695, zf("<<C:1>>", GZNBId(tempZId.ZN.AD1))},
		AD2	 = { 4,  682, zf("<<C:1>>", GZNBId(tempZId.ZN.AD2))},
		AD3	 = { 5,  683, zf("<<C:1>>", GZNBId(tempZId.ZN.AD3))},
		AD4	 = { 6,  684, zf("<<C:1>>", GZNBId(tempZId.ZN.AD4))},
		AD5	 = { 7,  685, zf("<<C:1>>", GZNBId(tempZId.ZN.AD5))},
		DC0a = { 8,  408, zf("<<C:1>>", GZNBId(tempZId.ZN.DC0A))},
		DC0b = { 9,  407, zf("<<C:1>>", GZNBId(tempZId.ZN.DC0B))},
		DC1	 = {10,  409, zf("<<C:1>>", GZNBId(tempZId.ZN.DC1))},
		DC2	 = {11,  515, zf("<<C:1>>", GZNBId(tempZId.ZN.DC2))},
		DC3	 = {12,  554, zf("<<C:1>>", GZNBId(tempZId.ZN.DC3))},
		DC4	 = {13,  556, zf("<<C:1>>", GZNBId(tempZId.ZN.DC4))},
		DC5	 = {14,  557, zf("<<C:1>>", GZNBId(tempZId.ZN.DC5))},
		EP0a = {15,  405, zf("<<C:1>>", GZNBId(tempZId.ZN.EP0A))},
		EP0b = {16,  398, zf("<<C:1>>", GZNBId(tempZId.ZN.EP0B))},
		EP1	 = {17,  397, zf("<<C:1>>", GZNBId(tempZId.ZN.EP1))},
		EP2	 = {18,  547, zf("<<C:1>>", GZNBId(tempZId.ZN.EP2))},
		EP3	 = {19,  687, zf("<<C:1>>", GZNBId(tempZId.ZN.EP3))},
		EP4	 = {20,  688, zf("<<C:1>>", GZNBId(tempZId.ZN.EP4))},
		EP5	 = {21,  689, zf("<<C:1>>", GZNBId(tempZId.ZN.EP5))},
		CH	 = {22,  686, zf("<<C:1>>", GZNBId(tempZId.ZN.CH))},
		CAD	 = {23,  694, zf("<<C:1>>", GZNBId(tempZId.ZN.CAD))},
		CDC	 = {24,  693, zf("<<C:1>>", GZNBId(tempZId.ZN.CDC))},
		CEP	 = {25,  692, zf("<<C:1>>", GZNBId(tempZId.ZN.CEP))},
		CMT	 = {26,  748, zf("<<C:1>>", GZNBId(tempZId.ZN.CMT))},
		LCL	 = {27,  727, zf("<<C:1>>", GZNBId(tempZId.ZN.LCL))},
		UCL	 = {28,  912, zf("<<C:1>>", GZNBId(tempZId.ZN.UCL))},
		IC	 = {29, 1160, zf("<<C:1>>", GZNBId(tempZId.ZN.IC))},
		WR	 = {30, 1320, zf("<<C:1>>", GZNBId(tempZId.ZN.RO))},
		HB	 = {31, 1347, zf("<<C:1>>", GZNBId(tempZId.ZN.HB))},
		GC	 = {32, 1342, zf("<<C:1>>", GZNBId(tempZId.ZN.GC))},
		VV	 = {33, 1843, zf("<<C:1>>", GZNBId(tempZId.ZN.VV))},
		CC	 = {34, 1844, zf("<<C:1>>", GZNBId(tempZId.ZN.CC))},
		SU	 = {35, 1845, zf("<<C:1>>", GZNBId(tempZId.ZN.SU))},
		MM	 = {36, 2291, zf("<<C:1>>", GZNBId(tempZId.ZN.MM))},
		NE	 = {37, 2461, zf("<<C:1>>", GZNBId(tempZId.ZN.NE))},
		SE	 = {38, 2562, zf("<<C:1>>", GZNBId(tempZId.ZN.SE))},
    WS   = {39, 2687, zf("<<C:1>>", GZNBId(tempZId.ZN.WS))},
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
local function USPF_BlueText(text)	return "|c0000FF"..tostring(text).."|r" end

local function USPF_rgbToHex(rgb)
	local hexStr = '|c'
	for _, v in pairs(rgb) do
		local hex = ''
		local tmpV = math.floor((255 * v) + 0.5)
		while(tmpV > 0) do
			local idx = math.fmod(tmpV, 16) + 1
			tmpV = math.floor(tmpV / 16)
			hex = string.sub('0123456789ABCDEF', idx, idx) .. hex
		end
		hex = (string.len(hex) == 0 and '00' or (string.len(hex) == 1 and '0' .. hex or hex))
		hexStr = hexStr .. hex
	end
	return hexStr
end

local function USPF_UpdateAllSavedVars()
	if(USPF.sVar.ptsData[selectedChar] == nil) then USPF.sVar.ptsData[selectedChar] = {} end
	USPF.sVar.ptsData[selectedChar] = USPF_LTF:CopyTable(USPF.ptsData)
end

local function USPF_ResetSelectedCharacter()
	if(selectedChar ~= GCCId()) then
		USPF_GUI_Header_CharList.comboBox = USPF_GUI_Header_CharList.comboBox or ZO_ComboBox_ObjectFromContainer(USPF_GUI_Header_CharList)
		local USPF_comboBox = USPF_GUI_Header_CharList.comboBox
		
		local name, id = nil, nil
		for k,_ in ipairs(USPF.charData) do
			name, _, _, _, _, _, id, _ = GetCharacterInfo(k)
			if(GCCId() == USPF.charData[k].charId) then
				currentCharName = USPF.charData[k].charName
				selectedChar = USPF.charData[k].charId
				USPF_comboBox:SetSelectedItem(currentCharName)
			end
		end
	end
end

local function GetQuestTooltipText(zone)
	quests = ""
	for i = 1, #USPF.data[zone] do
		quests = quests..(selectedChar == GCCId() and (USPF.data[zone][i][2] == 0 and GCQI(USPF.data[zone][i][1]) ~= "" or IAchC(USPF.data[zone][i][2]))
					and "|l0:1:0:-25%:2:ffffff|l"..USPF.data[zone][i][3].."|l"
					or USPF.data[zone][i][3])..(i < #USPF.data[zone] and "\n" or "")
	end
	return quests
end

local function GetGDQuestTooltipText(dungeon)
	if(selectedChar == GCCId() and GCQI(USPF.data.GD[dungeon][2]) ~= "") then
		return "|l0:1:0:-25%:2:ffffff|l"..USPF.data.GD[dungeon][4].."|l"
	else
		return USPF.data.GD[dungeon][4]
	end
end

local function GetAchLink(achId)
	return GetAchievementLink(achId, LINK_TYPE_ACHIEVEMENT)
end

local function USPF_UpdateGUITable()
	questTooltips = {
		WP	 = GS(USPF_QUEST_NONE),
		AD0	 = GS(USPF_QUEST_NONE),
		AD1  = GetQuestTooltipText("AD1"),
		AD2  = GetQuestTooltipText("AD2"),
		AD3  = GetQuestTooltipText("AD3"),
		AD4  = GetQuestTooltipText("AD4"),
		AD5  = GetQuestTooltipText("AD5"),
		CC   = GetQuestTooltipText("CC"),
		CH   = GetQuestTooltipText("CH"),
		CAD	 = GS(USPF_QUEST_NONE),
		CDC	 = GS(USPF_QUEST_NONE),
		CEP	 = GS(USPF_QUEST_NONE),
		CMT	 = GS(USPF_QUEST_NONE),
		DB   = GetQuestTooltipText("DB"),
		DC0a = GS(USPF_QUEST_NONE),
		DC0b = GS(USPF_QUEST_NONE),
		DC1	 = GetQuestTooltipText("DC1"),
		DC2	 = GetQuestTooltipText("DC2"),
		DC3	 = GetQuestTooltipText("DC3"),
		DC4	 = GetQuestTooltipText("DC4"),
		DC5	 = GetQuestTooltipText("DC5"),
		EO	 = GetQuestTooltipText("EO"),
		EP0a = GS(USPF_QUEST_NONE),
		EP0b = GS(USPF_QUEST_NONE),
		EP1	 = GetQuestTooltipText("EP1"),
		EP2	 = GetQuestTooltipText("EP2"),
		EP3	 = GetQuestTooltipText("EP3"),
		EP4	 = GetQuestTooltipText("EP4"),
		EP5	 = GetQuestTooltipText("EP5"),
		IC	 = GetQuestTooltipText("IC"),
		LCL	 = GS(USPF_QUEST_NONE),
		UCL	 = GS(USPF_QUEST_NONE),
		MM	 = GetQuestTooltipText("MM"),
		MO	 = GetQuestTooltipText("MO"),
		MW	 = GetQuestTooltipText("MW"),
		MQ	 = GetQuestTooltipText("MQ"),
		NE	 = GetQuestTooltipText("NE"),
		RO	 = GetQuestTooltipText("RO"),
		SE	 = GetQuestTooltipText("SE"),
		SO	 = GetQuestTooltipText("SO"),
		TG	 = GetQuestTooltipText("TG"),
		SU	 = GetQuestTooltipText("SU"),
    WS   = GetQuestTooltipText("WS"),
    GO   = GetQuestTooltipText("GO"),
	}
	
	USPF.GUI = {
		GSP = {
			{1, GS(USPF_GUI_CHAR_LEVEL),	USPF.ptsData.Level,		USPF.ptsTots.Level,		GS(USPF_QUEST_NA)},
			{2, GS(USPF_GUI_MAIN_QUEST),	USPF.ptsData.MainQ,		USPF.ptsTots.MainQ,		questTooltips.MQ},
			{3, GS(USPF_GUI_FOLIUM),		USPF.ptsData.FolDis,	USPF.ptsTots.FolDis,	GS(USPF_QUEST_NA)},
			{4, GS(USPF_GUI_MW_CHAR),		USPF.ptsData.MWChar,	USPF.ptsTots.MWChar,	questTooltips.MO},
			{5, GS(USPF_GUI_SU_CHAR),		USPF.ptsData.SUChar,	USPF.ptsTots.SUChar,	questTooltips.SO},
			{6, GS(USPF_GUI_EW_CHAR),		USPF.ptsData.EWChar,	USPF.ptsTots.EWChar,	questTooltips.EO},
			{7, GS(USPF_GUI_GM_CHAR),		USPF.ptsData.GMChar,	USPF.ptsTots.GMChar,	questTooltips.GO},
			{8, GS(USPF_GUI_AVA_RANK),		USPF.ptsData.PvPRank,	USPF.ptsTots.PvPRank,	GS(USPF_QUEST_NA)},
			{9, GS(USPF_GUI_MAEL_ARENA),	USPF.ptsData.MaelAr,	USPF.ptsTots.MaelAr,	GS(USPF_QUEST_NA)},
		},
		GSP_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), USPF.ptsData.GenTot, USPF.ptsTots.GenTot),
		SQS = {
			{ 1, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.WP)),						USPF.ptsData.ZQ.WP,		USPF.ptsTots.ZQ.WP,		USPF.ptsData.SS.MQ,		USPF.ptsTots.SS.MQ,		questTooltips.WP},
			{ 2, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD0)),						USPF.ptsData.ZQ.AD0,	USPF.ptsTots.ZQ.AD0,	USPF.ptsData.SS.AD0,	USPF.ptsTots.SS.AD0,	questTooltips.AD0},
			{ 3, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD1)),						USPF.ptsData.ZQ.AD1,	USPF.ptsTots.ZQ.AD1,	USPF.ptsData.SS.AD1,	USPF.ptsTots.SS.AD1,	questTooltips.AD1},
			{ 4, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD2)),						USPF.ptsData.ZQ.AD2,	USPF.ptsTots.ZQ.AD2,	USPF.ptsData.SS.AD2,	USPF.ptsTots.SS.AD2,	questTooltips.AD2},
			{ 5, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD3)),						USPF.ptsData.ZQ.AD3,	USPF.ptsTots.ZQ.AD3,	USPF.ptsData.SS.AD3,	USPF.ptsTots.SS.AD3,	questTooltips.AD3},
			{ 6, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD4)),						USPF.ptsData.ZQ.AD4,	USPF.ptsTots.ZQ.AD4,	USPF.ptsData.SS.AD4,	USPF.ptsTots.SS.AD4,	questTooltips.AD4},
			{ 7, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.AD5)),						USPF.ptsData.ZQ.AD5,	USPF.ptsTots.ZQ.AD5,	USPF.ptsData.SS.AD5,	USPF.ptsTots.SS.AD5,	questTooltips.AD5},
			{ 8, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC0B)),						USPF.ptsData.ZQ.DC0b,	USPF.ptsTots.ZQ.DC0b,	USPF.ptsData.SS.DC0b,	USPF.ptsTots.SS.DC0b,	questTooltips.DC0b},
			{ 9, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC0A)),						USPF.ptsData.ZQ.DC0a,	USPF.ptsTots.ZQ.DC0a,	USPF.ptsData.SS.DC0a,	USPF.ptsTots.SS.DC0a,	questTooltips.DC0a},
			{10, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC1)),						USPF.ptsData.ZQ.DC1,	USPF.ptsTots.ZQ.DC1,	USPF.ptsData.SS.DC1,	USPF.ptsTots.SS.DC1,	questTooltips.DC1},
			{11, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC2)),						USPF.ptsData.ZQ.DC2,	USPF.ptsTots.ZQ.DC2,	USPF.ptsData.SS.DC2,	USPF.ptsTots.SS.DC2,	questTooltips.DC2},
			{12, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC3)),						USPF.ptsData.ZQ.DC3,	USPF.ptsTots.ZQ.DC3,	USPF.ptsData.SS.DC3,	USPF.ptsTots.SS.DC3,	questTooltips.DC3},
			{13, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC4)),						USPF.ptsData.ZQ.DC4,	USPF.ptsTots.ZQ.DC4,	USPF.ptsData.SS.DC4,	USPF.ptsTots.SS.DC4,	questTooltips.DC4},
			{14, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.DC5)),						USPF.ptsData.ZQ.DC5,	USPF.ptsTots.ZQ.DC5,	USPF.ptsData.SS.DC5,	USPF.ptsTots.SS.DC5,	questTooltips.DC5},
			{15, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP0B)),						USPF.ptsData.ZQ.EP0b,	USPF.ptsTots.ZQ.EP0b,	USPF.ptsData.SS.EP0b,	USPF.ptsTots.SS.EP0b,	questTooltips.EP0b},
			{16, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP0A)),						USPF.ptsData.ZQ.EP0a,	USPF.ptsTots.ZQ.EP0a,	USPF.ptsData.SS.EP0a,	USPF.ptsTots.SS.EP0a,	questTooltips.EP0a},
			{17, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP1)),						USPF.ptsData.ZQ.EP1,	USPF.ptsTots.ZQ.EP1,	USPF.ptsData.SS.EP1,	USPF.ptsTots.SS.EP1,	questTooltips.EP1},
			{18, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP2)),						USPF.ptsData.ZQ.EP2,	USPF.ptsTots.ZQ.EP2,	USPF.ptsData.SS.EP2,	USPF.ptsTots.SS.EP2,	questTooltips.EP2},
			{19, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP3)),						USPF.ptsData.ZQ.EP3,	USPF.ptsTots.ZQ.EP3,	USPF.ptsData.SS.EP3,	USPF.ptsTots.SS.EP3,	questTooltips.EP3},
			{20, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP4)),						USPF.ptsData.ZQ.EP4,	USPF.ptsTots.ZQ.EP4,	USPF.ptsData.SS.EP4,	USPF.ptsTots.SS.EP4,	questTooltips.EP4},
			{21, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.EP5)),						USPF.ptsData.ZQ.EP5,	USPF.ptsTots.ZQ.EP5,	USPF.ptsData.SS.EP5,	USPF.ptsTots.SS.EP5,	questTooltips.EP5},
			{22, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.CH)),						USPF.ptsData.ZQ.CH,		USPF.ptsTots.ZQ.CH,		USPF.ptsData.SS.CH,		USPF.ptsTots.SS.CH,		questTooltips.CH},
			{23, zf("<<C:1>> <<2>>",	GZNBId(USPF.data.ZId.ZN.CAD), "AD"),				USPF.ptsData.ZQ.CAD,	USPF.ptsTots.ZQ.CAD,	USPF.ptsData.SS.CAD,	USPF.ptsTots.SS.CAD,	questTooltips.CAD},
			{24, zf("<<C:1>> <<2>>",	GZNBId(USPF.data.ZId.ZN.CDC), "DC"),				USPF.ptsData.ZQ.CDC,	USPF.ptsTots.ZQ.CDC,	USPF.ptsData.SS.CDC,	USPF.ptsTots.SS.CDC,	questTooltips.CDC},
			{25, zf("<<C:1>> <<2>>",	GZNBId(USPF.data.ZId.ZN.CEP), "EP"),				USPF.ptsData.ZQ.CEP,	USPF.ptsTots.ZQ.CEP,	USPF.ptsData.SS.CEP,	USPF.ptsTots.SS.CEP,	questTooltips.CEP},
			{26, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.CMT)),						USPF.ptsData.ZQ.CMT,	USPF.ptsTots.ZQ.CMT,	USPF.ptsData.SS.CMT,	USPF.ptsTots.SS.CMT,	questTooltips.CMT},
			{27, zf("<<C:1>> <<C:2>>",	GS(USPF_GUI_ZN_LCL), GZNBId(USPF.data.ZId.ZN.CL)),	USPF.ptsData.ZQ.LCL,	USPF.ptsTots.ZQ.LCL,	USPF.ptsData.SS.LCL,	USPF.ptsTots.SS.LCL,	questTooltips.LCL},
			{28, zf("<<C:1>> <<C:2>>",	GS(USPF_GUI_ZN_UCL), GZNBId(USPF.data.ZId.ZN.CL)),	USPF.ptsData.ZQ.UCL,	USPF.ptsTots.ZQ.UCL,	USPF.ptsData.SS.UCL,	USPF.ptsTots.SS.UCL,	questTooltips.UCL},
			{29, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.IC)),						USPF.ptsData.ZQ.IC,		USPF.ptsTots.ZQ.IC,		USPF.ptsData.SS.IC,		USPF.ptsTots.SS.IC,		questTooltips.IC},
			{30, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.RO)),						USPF.ptsData.ZQ.RO,		USPF.ptsTots.ZQ.RO,		USPF.ptsData.SS.WR,		USPF.ptsTots.SS.WR,		questTooltips.RO},
			{31, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.HB)),						USPF.ptsData.ZQ.TG,		USPF.ptsTots.ZQ.TG,		USPF.ptsData.SS.HB,		USPF.ptsTots.SS.HB,		questTooltips.TG},
			{32, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.GC)),						USPF.ptsData.ZQ.DB,		USPF.ptsTots.ZQ.DB,		USPF.ptsData.SS.GC,		USPF.ptsTots.SS.GC,		questTooltips.DB},
			{33, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.VV)),						USPF.ptsData.ZQ.MW,		USPF.ptsTots.ZQ.MW,		USPF.ptsData.SS.VV,		USPF.ptsTots.SS.VV,		questTooltips.MW},
			{34, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.CC)),						USPF.ptsData.ZQ.CC,		USPF.ptsTots.ZQ.CC,		USPF.ptsData.SS.CC,		USPF.ptsTots.SS.CC,		questTooltips.CC},
			{35, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.SU)),						USPF.ptsData.ZQ.SU,		USPF.ptsTots.ZQ.SU,		USPF.ptsData.SS.SU,		USPF.ptsTots.SS.SU,		questTooltips.SU},
			{36, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.MM)),						USPF.ptsData.ZQ.MM,		USPF.ptsTots.ZQ.MM,		USPF.ptsData.SS.MM,		USPF.ptsTots.SS.MM,		questTooltips.MM},
			{37, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.NE)),						USPF.ptsData.ZQ.NE,		USPF.ptsTots.ZQ.NE,		USPF.ptsData.SS.NE,		USPF.ptsTots.SS.NE,		questTooltips.NE},
			{38, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.SE)),						USPF.ptsData.ZQ.SE,		USPF.ptsTots.ZQ.SE,		USPF.ptsData.SS.SE,		USPF.ptsTots.SS.SE,		questTooltips.SE},
      {39, zf("<<C:1>>",			GZNBId(USPF.data.ZId.ZN.WS)),						USPF.ptsData.ZQ.WS,		USPF.ptsTots.ZQ.WS,		USPF.ptsData.SS.WS,		USPF.ptsTots.SS.WS,		questTooltips.WS},
		},
		SQS_SL_T = strF("%d/%d", USPF.ptsData.ZQTot, USPF.ptsTots.ZQTot),
		SQS_SS_T = strF("%d/%d", USPF.ptsData.SSTot, USPF.ptsTots.SSTot),
		GDQ = {
			{ 1, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC1)),	USPF.ptsData.GD.BC1,	USPF.ptsTots.GD.BC1,	GetGDQuestTooltipText("BC1")},
			{ 2, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC2)),	USPF.ptsData.GD.BC2,	USPF.ptsTots.GD.BC2,	GetGDQuestTooltipText("BC2")},
			{ 3, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.EH1)),	USPF.ptsData.GD.EH1,	USPF.ptsTots.GD.EH1,	GetGDQuestTooltipText("EH1")},
			{ 4, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.EH2)),	USPF.ptsData.GD.EH2,	USPF.ptsTots.GD.EH2,	GetGDQuestTooltipText("EH2")},
			{ 5, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA1)),	USPF.ptsData.GD.CA1,	USPF.ptsTots.GD.CA1,	GetGDQuestTooltipText("CA1")},
			{ 6, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA2)),	USPF.ptsData.GD.CA2,	USPF.ptsTots.GD.CA2,	GetGDQuestTooltipText("CA2")},
			{ 7, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.TI)),	USPF.ptsData.GD.TI,		USPF.ptsTots.GD.TI,		GetGDQuestTooltipText("TI")},
			{ 8, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SW)),	USPF.ptsData.GD.SW,		USPF.ptsTots.GD.SW,		GetGDQuestTooltipText("SW")},
			{ 9, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SC1)),	USPF.ptsData.GD.SC1,	USPF.ptsTots.GD.SC1,	GetGDQuestTooltipText("SC1")},
			{10, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SC2)),	USPF.ptsData.GD.SC2,	USPF.ptsTots.GD.SC2,	GetGDQuestTooltipText("SC2")},
			{11, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WS1)),	USPF.ptsData.GD.WS1,	USPF.ptsTots.GD.WS1,	GetGDQuestTooltipText("WS1")},
			{12, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WS2)),	USPF.ptsData.GD.WS2,	USPF.ptsTots.GD.WS2,	GetGDQuestTooltipText("WS2")},
			{13, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CH1)),	USPF.ptsData.GD.CH1,	USPF.ptsTots.GD.CH1,	GetGDQuestTooltipText("CH1")},
			{14, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CH2)),	USPF.ptsData.GD.CH2,	USPF.ptsTots.GD.CH2,	GetGDQuestTooltipText("CH2")},
			{15, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.VF)),	USPF.ptsData.GD.VF,		USPF.ptsTots.GD.VF,		GetGDQuestTooltipText("VF")},
			{16, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BH)),	USPF.ptsData.GD.BH,		USPF.ptsTots.GD.BH,		GetGDQuestTooltipText("BH")},
			{17, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FG1)),	USPF.ptsData.GD.FG1,	USPF.ptsTots.GD.FG1,	GetGDQuestTooltipText("FG1")},
			{18, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FG2)),	USPF.ptsData.GD.FG2,	USPF.ptsTots.GD.FG2,	GetGDQuestTooltipText("FG2")},
			{19, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DC1)),	USPF.ptsData.GD.DC1,	USPF.ptsTots.GD.DC1,	GetGDQuestTooltipText("DC1")},
			{20, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DC2)),	USPF.ptsData.GD.DC2,	USPF.ptsTots.GD.DC2,	GetGDQuestTooltipText("DC2")},
			{21, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.AC)),	USPF.ptsData.GD.AC,		USPF.ptsTots.GD.AC,		GetGDQuestTooltipText("AC")},
			{22, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DK)),	USPF.ptsData.GD.DK,		USPF.ptsTots.GD.DK,		GetGDQuestTooltipText("DK")},
			{23, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC)),	USPF.ptsData.GD.BC,		USPF.ptsTots.GD.BC,		GetGDQuestTooltipText("BC")},
			{24, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CH)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.VM)),	USPF.ptsData.GD.VM,		USPF.ptsTots.GD.VM,		GetGDQuestTooltipText("VM")},
			{25, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.ICP)),	USPF.ptsData.GD.ICP,	USPF.ptsTots.GD.ICP,	GetGDQuestTooltipText("ICP")},
			{26, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WGT)),	USPF.ptsData.GD.WGT,	USPF.ptsTots.GD.WGT,	GetGDQuestTooltipText("WGT")},
			{27, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CS)),	USPF.ptsData.GD.CS,		USPF.ptsTots.GD.CS,		GetGDQuestTooltipText("CS")},
			{28, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.RM)),	USPF.ptsData.GD.RM,		USPF.ptsTots.GD.RM,		GetGDQuestTooltipText("RM")},
			{29, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CL)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BF)),	USPF.ptsData.GD.BF,		USPF.ptsTots.GD.BF,		GetGDQuestTooltipText("BF")},
			{30, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CL)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FH)),	USPF.ptsData.GD.FH,		USPF.ptsTots.GD.FH,		GetGDQuestTooltipText("FH")},
			{31, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FL)),	USPF.ptsData.GD.FL,		USPF.ptsTots.GD.FL,		GetGDQuestTooltipText("FL")},
			{32, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SP)),	USPF.ptsData.GD.SP,		USPF.ptsTots.GD.SP,		GetGDQuestTooltipText("SP")},
			{33, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MHK)),	USPF.ptsData.GD.MHK,	USPF.ptsTots.GD.MHK,	GetGDQuestTooltipText("MHK")},
			{34, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MOS)),	USPF.ptsData.GD.MOS,	USPF.ptsTots.GD.MOS,	GetGDQuestTooltipText("MOS")},
			{35, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.GC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DoM)),	USPF.ptsData.GD.DoM,	USPF.ptsTots.GD.DoM,	GetGDQuestTooltipText("DoM")},
			{36, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FV)),	USPF.ptsData.GD.FV,		USPF.ptsTots.GD.FV,		GetGDQuestTooltipText("FV")},
			{37, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.LM)),	USPF.ptsData.GD.LM,		USPF.ptsTots.GD.LM,		GetGDQuestTooltipText("LM")},
			{38, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MF)),	USPF.ptsData.GD.MF,		USPF.ptsTots.GD.MF,		GetGDQuestTooltipText("MF")},
			{39, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.IR)),	USPF.ptsData.GD.IR,		USPF.ptsTots.GD.IR,		GetGDQuestTooltipText("IR")},
			{40, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.UG)),	USPF.ptsData.GD.UG,		USPF.ptsTots.GD.UG,		GetGDQuestTooltipText("UG")},
			{41, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SG)),	USPF.ptsData.GD.SG,		USPF.ptsTots.GD.SG,		GetGDQuestTooltipText("SG")},
			{42, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.WS)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CT)),	USPF.ptsData.GD.CT,		USPF.ptsTots.GD.CT,		GetGDQuestTooltipText("CT")},
		},
		GDQ_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), USPF.ptsData.GDTot, USPF.ptsTots.GDTot),
		PDGBE = {
			{ 1, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD1)),	USPF.ptsData.PD.AD1,	USPF.ptsTots.PD.AD1,	GetAchLink(USPF.data.PD.AD1[2])},
			{ 2, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD2)),	USPF.ptsData.PD.AD2,	USPF.ptsTots.PD.AD2,	GetAchLink(USPF.data.PD.AD2[2])},
			{ 3, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD3)),	USPF.ptsData.PD.AD3,	USPF.ptsTots.PD.AD3,	GetAchLink(USPF.data.PD.AD3[2])},
			{ 4, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD4)),	USPF.ptsData.PD.AD4,	USPF.ptsTots.PD.AD4,	GetAchLink(USPF.data.PD.AD4[2])},
			{ 5, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD5)),	USPF.ptsData.PD.AD5,	USPF.ptsTots.PD.AD5,	GetAchLink(USPF.data.PD.AD5[2])},
			{ 6, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC1)),	USPF.ptsData.PD.DC1,	USPF.ptsTots.PD.DC1,	GetAchLink(USPF.data.PD.DC1[2])},
			{ 7, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC2)),	USPF.ptsData.PD.DC2,	USPF.ptsTots.PD.DC2,	GetAchLink(USPF.data.PD.DC2[2])},
			{ 8, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC3)),	USPF.ptsData.PD.DC3,	USPF.ptsTots.PD.DC3,	GetAchLink(USPF.data.PD.DC3[2])},
			{ 9, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC4)),	USPF.ptsData.PD.DC4,	USPF.ptsTots.PD.DC4,	GetAchLink(USPF.data.PD.DC4[2])},
			{10, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC5)),	USPF.ptsData.PD.DC5,	USPF.ptsTots.PD.DC5,	GetAchLink(USPF.data.PD.DC5[2])},
			{11, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP1)),	USPF.ptsData.PD.EP1,	USPF.ptsTots.PD.EP1,	GetAchLink(USPF.data.PD.EP1[2])},
			{12, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP2)),	USPF.ptsData.PD.EP2,	USPF.ptsTots.PD.EP2,	GetAchLink(USPF.data.PD.EP2[2])},
			{13, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP3)),	USPF.ptsData.PD.EP3,	USPF.ptsTots.PD.EP3,	GetAchLink(USPF.data.PD.EP3[2])},
			{14, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP4)),	USPF.ptsData.PD.EP4,	USPF.ptsTots.PD.EP4,	GetAchLink(USPF.data.PD.EP4[2])},
			{15, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP5)),	USPF.ptsData.PD.EP5,	USPF.ptsTots.PD.EP5,	GetAchLink(USPF.data.PD.EP5[2])},
			{16, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CH)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.CH)),	USPF.ptsData.PD.CH,		USPF.ptsTots.PD.CH,		GetAchLink(USPF.data.PD.CH[2])},
			{17, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.WOO)),	USPF.ptsData.PD.WOO,	USPF.ptsTots.PD.WOO,	GetAchLink(USPF.data.PD.WOO[2])},
			{18, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.WRK)),	USPF.ptsData.PD.WRK,	USPF.ptsTots.PD.WRK,	GetAchLink(USPF.data.PD.WRK[2])},
			{19, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.VV)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.VFW)),	USPF.ptsData.PD.VFW,	USPF.ptsTots.PD.VFW,	GetAchLink(USPF.data.PD.VFW[2])},
			{20, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.VV)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.VNC)),	USPF.ptsData.PD.VNC,	USPF.ptsTots.PD.VNC,	GetAchLink(USPF.data.PD.VNC[2])},
			{21, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SKW)),	USPF.ptsData.PD.SKW,	USPF.ptsTots.PD.SKW,	GetAchLink(USPF.data.PD.SKW[2])},
			{22, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SSH)),	USPF.ptsData.PD.SSH,	USPF.ptsTots.PD.SSH,	GetAchLink(USPF.data.PD.SSH[2])},
			{23, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.OC)),	USPF.ptsData.PD.OC,		USPF.ptsTots.PD.OC,		GetAchLink(USPF.data.PD.OC[2])},
			{24, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.RN)),	USPF.ptsData.PD.RN,		USPF.ptsTots.PD.RN,		GetAchLink(USPF.data.PD.RN[2])},
			{25, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.WS)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.LT)),	USPF.ptsData.PD.LT,		USPF.ptsTots.PD.LT,		GetAchLink(USPF.data.PD.LT[2])},
			{26, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.NK)),	USPF.ptsData.PD.NK,		USPF.ptsTots.PD.NK,		GetAchLink(USPF.data.PD.NK[2])},
		},
		PDGBE_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), USPF.ptsData.PDTot, USPF.ptsTots.PDTot),
		CharacterTot = strF("%s: %d/%d", GS(USPF_GUI_CHAR_TOTAL), USPF.ptsData.Tot, USPF.ptsTots.Tot),
	}
end

local function USPF_CheckSavedVars(value)
	local charId = GCCId()
	if(selectedChar ~= charId) then return false end
	if(value == nil) then
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
	USPF.ptsData.Level = math.floor(GetUnitLevel("player")/5) + math.floor(GetUnitLevel("player")/10) + (GetUnitLevel("player") - 1)
	
	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].Level = USPF.ptsData.Level
	end
end

local function USPF_SetQuestPoints()
	--Main Quest Skill Points
	for i=1, #USPF.data.MQ do
		USPF.ptsData.MainQ = USPF.ptsData.MainQ + (IAchC(USPF.data.MQ[i][2]) and USPF.data.MQ[i][4] or 0)
	end
	
	--Morrowind Only Character Quest Skill Points
	USPF.ptsData.MWChar = ((GCQI(USPF.data.MO[1][1]) ~= "" or USPF.settings.MWC) and USPF.data.MO[1][4] or 0)
	
	--Summerset Only Character Quest Skill Points
	USPF.ptsData.SUChar = ((GCQI(USPF.data.SO[1][1]) ~= "" or USPF.settings.SSC) and USPF.data.SO[1][4] or 0)
	
	--Elsweyr Only Character Quest Skill Points
	USPF.ptsData.EWChar = ((GCQI(USPF.data.EO[1][1]) ~= "" or USPF.settings.EWC) and USPF.data.EO[1][4] or 0)
  
  	--Greymoor Only Character Quest Skill Points
	USPF.ptsData.GMChar = ((GCQI(USPF.data.GO[1][1]) ~= "" or USPF.settings.GWC) and USPF.data.GO[1][4] or 0)
	
	for k,_ in pairs(USPF.ptsData.ZQ) do
		if(USPF.data[k] ~= nil) then
			for i=1, #USPF.data[k] do
				USPF.ptsData.ZQ[k] = USPF.ptsData.ZQ[k] + ((USPF.data[k][i][2] == 0 and (GCQI(USPF.data[k][i][1]) ~= "") or IAchC(USPF.data[k][i][2])) and USPF.data[k][i][4] or 0)
			end
			USPF.ptsData.ZQTot = USPF.ptsData.ZQTot + USPF.ptsData.ZQ[k]
		end
	end
	
	--Group Dungeon Quest Skill Points
	for k,_ in pairs(USPF.ptsData.GD) do
		USPF.ptsData.GD[k] = (GCQI(USPF.data.GD[k][2]) ~= "" and 1 or 0)
		USPF.ptsData.GDTot = USPF.ptsData.GDTot + USPF.ptsData.GD[k]
	end
	
	--Update saved variables for all.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].MainQ = USPF.ptsData.MainQ
		USPF.sVar.ptsData[selectedChar].MWChar = USPF.ptsData.MWChar
		USPF.sVar.ptsData[selectedChar].SUChar = USPF.ptsData.SUChar
		USPF.sVar.ptsData[selectedChar].EWChar = USPF.ptsData.EWChar
		USPF.sVar.ptsData[selectedChar].GMChar = USPF.ptsData.GMChar		

		USPF.sVar.ptsData[selectedChar].ZQ = USPF_LTF:CopyTable(USPF.ptsData.ZQ)
		USPF.sVar.ptsData[selectedChar].GD = USPF_LTF:CopyTable(USPF.ptsData.GD)
		
		USPF.sVar.ptsData[selectedChar].ZQTot = USPF.ptsData.ZQTot
		USPF.sVar.ptsData[selectedChar].GDTot = USPF.ptsData.GDTot
	end
end

local function USPF_SetPublicDungeonPoints()
	for k,_ in pairs(USPF.ptsData.PD) do
		USPF.ptsData.PD[k] = (IAchC(USPF.data.PD[k][2]) and 1 or 0)
		USPF.ptsData.PDTot = USPF.ptsData.PDTot + USPF.ptsData.PD[k]
	end
	
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		--Update saved variables.
		USPF.sVar.ptsData[selectedChar].PD		= USPF_LTF:CopyTable(USPF.ptsData.PD)
		USPF.sVar.ptsData[selectedChar].PDTot	= USPF.ptsData.PDTot
	end
end

local function USPF_SetSkyshardPoints()
	for k,_ in pairs(USPF.ptsData.SS) do
		if(IAchC(USPF.data.SS[k][2])) then USPF.ptsData.SS[k] = GAchNCr(USPF.data.SS[k][2])
		else
			for i = 1, GAchNCr(USPF.data.SS[k][2]) do
				local _, numCompleted = GAchCr(USPF.data.SS[k][2], i)
				if(numCompleted > 0) then USPF.ptsData.SS[k] = USPF.ptsData.SS[k] + 1 end
			end
		end
		USPF.ptsData.numSSTot = USPF.ptsData.numSSTot + USPF.ptsData.SS[k]
	end
	
	--Calculate the total and round for points.
	USPF.ptsData.SSTot = math.floor(USPF.ptsData.numSSTot/3)
	
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		--Update saved variables for all.
		USPF.sVar.ptsData[selectedChar].SS			= USPF_LTF:CopyTable(USPF.ptsData.SS)
		USPF.sVar.ptsData[selectedChar].numSSTot	= USPF.ptsData.numSSTot
		USPF.sVar.ptsData[selectedChar].SSTot		= USPF.ptsData.SSTot
	end
end

--Temporary fix for ZOS' 4.3.7 bug.
--EsoUI/Ingame/Skills/SkillsDataManager.lua:1202: attempt to index a nil value
function USPF_GetCraftingSkillLineIndices(tradeskillType)
	local skillLineData = SKILLS_DATA_MANAGER:GetCraftingSkillLineData(tradeskillType)
	if skillLineData then
		return skillLineData:GetIndices()
	end
	return 0, 0, 0
end

local enchantingSkillType, enchantingSkillLine = USPF_GetCraftingSkillLineIndices(CRAFTING_TYPE_ENCHANTING)
local provisionSkillType, provisionSkillLine = USPF_GetCraftingSkillLineIndices(CRAFTING_TYPE_PROVISIONING)
local DARK_BROTHERHOOD, FIGHTERS_GUILD, MAGES_GUILD, THIEVES_GUILD, UNDAUNTED, SOUL_MAGIC, LEGERDEMAIN, PSIJIC_ORDER = 118, 45, 44, 117, 55, 72, 111, 130
local VAMPIRE, SCRYING, EXCAVATION = 51, 155, 157

local function USPF_IsValidRacialLine(skillType, skillLine)
	if (skillType == SKILL_TYPE_RACIAL) then
		local _, _, _, skillLineId = GetSkillLineInfo(skillType, skillLine)
		return skillLineId == USPF.data.racialLineIds[GetUnitRaceId("player")]
	end
	return false
end

local function USPF_GetReduceAbility(skillType, skillLine, skillIndex)
	local val = 0
	if skillType == SKILL_TYPE_WORLD then
		local name, _, _, skillLineId = GetSkillLineInfo(skillType, skillLine)
		val = ((skillLineId == SOUL_MAGIC and skillIndex == 2) and 1 or val) -- Soul Magic - Soul Trap
		val = ((skillLineId == SCRYING and skillIndex == 1) and 1 or val) -- Scrying - Scry
		val = ((skillLineId == SCRYING and skillIndex == 2) and 1 or val) -- Scrying - Antiquarian Insight
		val = ((skillLineId == EXCAVATION and skillIndex == 1) and 1 or val) -- Excavation - Hand Brush
		val = ((skillLineId == EXCAVATION and skillIndex == 2) and 1 or val) -- Excavation - Augur
		val = ((skillLineId == VAMPIRE and skillIndex == 7) and 1 or val) -- Vampire - Feed
		val = ((IsWerewolfSkillLine(skillType, skillLine) and skillIndex == 1) and 1 or val) -- Werewolf - Transformation
		val = ((IsWerewolfSkillLine(skillType, skillLine) and skillIndex == 7) and 1 or val) -- Werewolf - Devour
	end
	if skillType == SKILL_TYPE_TRADESKILL then
		val = (skillIndex == 1 and 1 or val)
		val = ((skillIndex == 2 and skillType == enchantingSkillType and skillLine == enchantingSkillLine) and 1 or val)
		val = ((skillIndex == 2 and skillType == provisionSkillType and skillLine == provisionSkillLine) and 1 or val)
	end
	
	val = ((USPF_IsValidRacialLine(skillType, skillLine) and skillIndex == 1) and 1 or val)
	
	if skillType == SKILL_TYPE_GUILD then
		local name, _, _, skillLineId = GetSkillLineInfo(skillType, skillLine)
		val = (skillLineId == DARK_BROTHERHOOD and (skillIndex == 1 and 1 or val) or val)
		val = (skillLineId == THIEVES_GUILD and (skillIndex == 1 and 1 or val) or val)
		val = (skillLineId == PSIJIC_ORDER and (skillIndex == 7 and 1 or val) or val)
	end
	return val
end

local function USPF_GetSkillSpentPoints(skillType, skillLine, skillIndex)
	local skills = USPF.cache.skillTypes[skillType].lines[skillLine].skills
	local _, _, _, _, _, purchased, progressionIndex = GetSkillAbilityInfo(skillType, skillLine, skillIndex)
	local spent, possible, reduction
	
	if not purchased then spent = 0 end
	reduction = USPF_GetReduceAbility(skillType, skillLine, skillIndex)
	
	if progressionIndex then
		local _, morph = GetAbilityProgressionInfo(progressionIndex)
		if not spent then
			spent = (morph > 0 and (2 - reduction) or (1 - reduction))
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
	if(skillType ~= SKILL_TYPE_RACIAL or USPF_IsValidRacialLine(skillType, skillLine)) then
		USPF.cache.skillTypes[skillType].lines[skillLine] = {}
		local line = USPF.cache.skillTypes[skillType].lines[skillLine]
		line.skills = {}
		line.total = 0
		line.possible = 0
		local numSkillAbilities = GetNumSkillAbilities(skillType, skillLine)
		local spent
		for ability = 1, numSkillAbilities do
			spent = USPF_GetSkillSpentPoints(skillType, skillLine, ability)
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
	if(USPF.settings.FD.override) then
		USPF.ptsData.FolDis = (USPF.settings.FD.charHasFD and 2 or 0)
	else
		local skillPoints = USPF_GetTotSkillPoints()
		local skillPointsDiff =	USPF.ptsData.Level + USPF.ptsData.MainQ + USPF.ptsData.MWChar +
								USPF.ptsData.SUChar + USPF.ptsData.EWChar + USPF.ptsData.PvPRank +
								USPF.ptsData.MaelAr + USPF.ptsData.ZQTot + USPF.ptsData.SSTot +
								USPF.ptsData.GDTot + USPF.ptsData.PDTot
		USPF.ptsData.FolDis = (skillPoints == skillPointsDiff + 2 and 2 or 0)
	end
	
	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].FolDis = USPF.ptsData.FolDis
	end
end

local function USPF_SetAllianceWarRankPoints()
	USPF.ptsData.PvPRank = (GetUnitAvARank("player") == nil and 0 or GetUnitAvARank("player"))
	
	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].PvPRank = USPF.ptsData.PvPRank
	end
end

local function USPF_SetMaelArPoints()
	USPF.ptsData.MaelAr = (IAchC(USPF.data.MAAch) and 1 or 0)
	
	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].MaelAr = USPF.ptsData.MaelAr
	end
end

local function USPF_SetGeneralPoints()
	USPF.ptsData.GenTot =	USPF.ptsData.Level + USPF.ptsData.MainQ + USPF.ptsData.FolDis + USPF.ptsData.MWChar + 
							USPF.ptsData.SUChar + USPF.ptsData.EWChar + USPF.ptsData.PvPRank + USPF.ptsData.MaelAr
	
	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].GenTot = USPF.ptsData.GenTot
	end
end

local function USPF_SetTotPoints()
	USPF.ptsData.Tot =	USPF.ptsData.GenTot + USPF.ptsData.ZQTot + USPF.ptsData.SSTot +
						USPF.ptsData.GDTot + USPF.ptsData.PDTot
	
	--Update saved variables.
	if(USPF_CheckSavedVars(USPF.sVar.ptsData[selectedChar])) then
		USPF.sVar.ptsData[selectedChar].Tot = USPF.ptsData.Tot
	end
end

local function GetSV(value)
	return  value ~= nil and value or 0
end

local function USPF_LoadData(charId)
	sVarPtsData = USPF.sVar.ptsData[charId]
	
	if(USPF.sVar.ptsData[charId] == nil) then
		--Write the character settings table.
		USPF.sVar.settings[charId] = {}
		USPF.sVar.settings[charId] = USPF_LTF:CopyTable(USPF.settings)
		
		--Write the character points data table.
		USPF.sVar.ptsData[charId] = {}
		USPF.sVar.ptsData[charId] = USPF_LTF:CopyTable(USPF.ptsData)
	end
	
	questTooltips = {
		WP	 = GS(USPF_QUEST_NONE),
		AD0	 = GS(USPF_QUEST_NONE),
		AD1  = GetQuestTooltipText("AD1"),
		AD2  = GetQuestTooltipText("AD2"),
		AD3  = GetQuestTooltipText("AD3"),
		AD4  = GetQuestTooltipText("AD4"),
		AD5  = GetQuestTooltipText("AD5"),
		CC   = GetQuestTooltipText("CC"),
		CH   = GetQuestTooltipText("CH"),
		CAD	 = GS(USPF_QUEST_NONE),
		CDC	 = GS(USPF_QUEST_NONE),
		CEP	 = GS(USPF_QUEST_NONE),
		CMT	 = GS(USPF_QUEST_NONE),
		DB   = GetQuestTooltipText("DB"),
		DC0a = GS(USPF_QUEST_NONE),
		DC0b = GS(USPF_QUEST_NONE),
		DC1	 = GetQuestTooltipText("DC1"),
		DC2	 = GetQuestTooltipText("DC2"),
		DC3	 = GetQuestTooltipText("DC3"),
		DC4	 = GetQuestTooltipText("DC4"),
		DC5	 = GetQuestTooltipText("DC5"),
		EO	 = GetQuestTooltipText("EO"),
		EP0a = GS(USPF_QUEST_NONE),
		EP0b = GS(USPF_QUEST_NONE),
		EP1	 = GetQuestTooltipText("EP1"),
		EP2	 = GetQuestTooltipText("EP2"),
		EP3	 = GetQuestTooltipText("EP3"),
		EP4	 = GetQuestTooltipText("EP4"),
		EP5	 = GetQuestTooltipText("EP5"),
		IC	 = GetQuestTooltipText("IC"),
		LCL	 = GS(USPF_QUEST_NONE),
		UCL	 = GS(USPF_QUEST_NONE),
		MM	 = GetQuestTooltipText("MM"),
		MO	 = GetQuestTooltipText("MO"),
		MW	 = GetQuestTooltipText("MW"),
		MQ	 = GetQuestTooltipText("MQ"),
		NE	 = GetQuestTooltipText("NE"),
		RO	 = GetQuestTooltipText("RO"),
		SE	 = GetQuestTooltipText("SE"),
		SO	 = GetQuestTooltipText("SO"),
		TG	 = GetQuestTooltipText("TG"),
		SU	 = GetQuestTooltipText("SU"),
    WS   = GetQuestTooltipText("WS"),
    GO   = GetQuestTooltipText("GO"),
	}
	
	USPF.GUI = {
		GSP = {
			{1, GS(USPF_GUI_CHAR_LEVEL),	GetSV(sVarPtsData.Level),	USPF.ptsTots.Level,		GS(USPF_QUEST_NA)},
			{2, GS(USPF_GUI_MAIN_QUEST),	GetSV(sVarPtsData.MainQ),	USPF.ptsTots.MainQ,		questTooltips.MQ},
			{3, GS(USPF_GUI_FOLIUM),		GetSV(sVarPtsData.FolDis),	USPF.ptsTots.FolDis,	GS(USPF_QUEST_NA)},
			{4, GS(USPF_GUI_MW_CHAR),		GetSV(sVarPtsData.MWChar),	USPF.ptsTots.MWChar,	questTooltips.MO},
			{5, GS(USPF_GUI_SU_CHAR),		GetSV(sVarPtsData.SUChar),	USPF.ptsTots.SUChar,	questTooltips.SO},
			{6, GS(USPF_GUI_EW_CHAR),		GetSV(sVarPtsData.EWChar),	USPF.ptsTots.EWChar,	questTooltips.EO},
			{7, GS(USPF_GUI_GM_CHAR),		GetSV(sVarPtsData.GMChar),	USPF.ptsTots.GMChar,	questTooltips.GO},
			{8, GS(USPF_GUI_AVA_RANK),		GetSV(sVarPtsData.PvPRank),	USPF.ptsTots.PvPRank,	GS(USPF_QUEST_NA)},
			{9, GS(USPF_GUI_MAEL_ARENA),	GetSV(sVarPtsData.MaelAr),	USPF.ptsTots.MaelAr,	GS(USPF_QUEST_NA)},
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
		},
		SQS_SL_T = strF("%d/%d", sVarPtsData.ZQTot, USPF.ptsTots.ZQTot),
		SQS_SS_T = strF("%d/%d", sVarPtsData.SSTot, USPF.ptsTots.SSTot),
		GDQ = {
			{ 1, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC1)),	GetSV(sVarPtsData.GD.BC1),	USPF.ptsTots.GD.BC1,	USPF.data.GD.BC1[4]},
			{ 2, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC2)),	GetSV(sVarPtsData.GD.BC2),	USPF.ptsTots.GD.BC2,	USPF.data.GD.BC2[4]},
			{ 3, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.EH1)),	GetSV(sVarPtsData.GD.EH1),	USPF.ptsTots.GD.EH1,	USPF.data.GD.EH1[4]},
			{ 4, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.EH2)),	GetSV(sVarPtsData.GD.EH2),	USPF.ptsTots.GD.EH2,	USPF.data.GD.EH2[4]},
			{ 5, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA1)),	GetSV(sVarPtsData.GD.CA1),	USPF.ptsTots.GD.CA1,	USPF.data.GD.CA1[4]},
			{ 6, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CA2)),	GetSV(sVarPtsData.GD.CA2),	USPF.ptsTots.GD.CA2,	USPF.data.GD.CA2[4]},
			{ 7, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.TI)),	GetSV(sVarPtsData.GD.TI),	USPF.ptsTots.GD.TI,		USPF.data.GD.TI[4]},
			{ 8, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SW)),	GetSV(sVarPtsData.GD.SW),	USPF.ptsTots.GD.SW,		USPF.data.GD.SW[4]},
			{ 9, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SC1)),	GetSV(sVarPtsData.GD.SC1),	USPF.ptsTots.GD.SC1,	USPF.data.GD.SC1[4]},
			{10, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SC2)),	GetSV(sVarPtsData.GD.SC2),	USPF.ptsTots.GD.SC2,	USPF.data.GD.SC2[4]},
			{11, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WS1)),	GetSV(sVarPtsData.GD.WS1),	USPF.ptsTots.GD.WS1,	USPF.data.GD.WS1[4]},
			{12, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WS2)),	GetSV(sVarPtsData.GD.WS2),	USPF.ptsTots.GD.WS2,	USPF.data.GD.WS2[4]},
			{13, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CH1)),	GetSV(sVarPtsData.GD.CH1),	USPF.ptsTots.GD.CH1,	USPF.data.GD.CH1[4]},
			{14, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CH2)),	GetSV(sVarPtsData.GD.CH2),	USPF.ptsTots.GD.CH2,	USPF.data.GD.CH2[4]},
			{15, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.VF)),	GetSV(sVarPtsData.GD.VF),	USPF.ptsTots.GD.VF,		USPF.data.GD.VF[4]},
			{16, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BH)),	GetSV(sVarPtsData.GD.BH),	USPF.ptsTots.GD.BH,		USPF.data.GD.BH[4]},
			{17, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FG1)),	GetSV(sVarPtsData.GD.FG1),	USPF.ptsTots.GD.FG1,	USPF.data.GD.FG1[4]},
			{18, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FG2)),	GetSV(sVarPtsData.GD.FG2),	USPF.ptsTots.GD.FG2,	USPF.data.GD.FG2[4]},
			{19, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DC1)),	GetSV(sVarPtsData.GD.DC1),	USPF.ptsTots.GD.DC1,	USPF.data.GD.DC1[4]},
			{20, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DC2)),	GetSV(sVarPtsData.GD.DC2),	USPF.ptsTots.GD.DC2,	USPF.data.GD.DC2[4]},
			{21, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.AC)),	GetSV(sVarPtsData.GD.AC),	USPF.ptsTots.GD.AC,		USPF.data.GD.AC[4]},
			{22, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DK)),	GetSV(sVarPtsData.GD.DK),	USPF.ptsTots.GD.DK,		USPF.data.GD.DK[4]},
			{23, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BC)),	GetSV(sVarPtsData.GD.BC),	USPF.ptsTots.GD.BC,		USPF.data.GD.BC[4]},
			{24, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CH)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.VM)),	GetSV(sVarPtsData.GD.VM),	USPF.ptsTots.GD.VM,		USPF.data.GD.VM[4]},
			{25, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.ICP)),	GetSV(sVarPtsData.GD.ICP),	USPF.ptsTots.GD.ICP,	USPF.data.GD.ICP[4]},
			{26, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CYD)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.WGT)),	GetSV(sVarPtsData.GD.WGT),	USPF.ptsTots.GD.WGT,	USPF.data.GD.WGT[4]},
			{27, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CS)),	GetSV(sVarPtsData.GD.CS),	USPF.ptsTots.GD.CS,		USPF.data.GD.CS[4]},
			{28, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.RM)),	GetSV(sVarPtsData.GD.RM),	USPF.ptsTots.GD.RM,		USPF.data.GD.RM[4]},
			{29, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CL)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.BF)),	GetSV(sVarPtsData.GD.BF),	USPF.ptsTots.GD.BF,		USPF.data.GD.BF[4]},
			{30, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CL)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FH)),	GetSV(sVarPtsData.GD.FH),	USPF.ptsTots.GD.FH,		USPF.data.GD.FH[4]},
			{31, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FL)),	GetSV(sVarPtsData.GD.FL),	USPF.ptsTots.GD.FL,		USPF.data.GD.FL[4]},
			{32, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SP)),	GetSV(sVarPtsData.GD.SP),	USPF.ptsTots.GD.SP,		USPF.data.GD.SP[4]},
			{33, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MHK)),	GetSV(sVarPtsData.GD.MHK),	USPF.ptsTots.GD.MHK,	USPF.data.GD.MHK[4]},
			{34, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MOS)),	GetSV(sVarPtsData.GD.MOS),	USPF.ptsTots.GD.MOS,	USPF.data.GD.MOS[4]},
			{35, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.GC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.DoM)),	GetSV(sVarPtsData.GD.DoM),	USPF.ptsTots.GD.DoM,	USPF.data.GD.DoM[4]},
			{36, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.FV)),	GetSV(sVarPtsData.GD.FV),	USPF.ptsTots.GD.FV,		USPF.data.GD.FV[4]},
			{37, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.LM)),	GetSV(sVarPtsData.GD.LM),	USPF.ptsTots.GD.LM,		USPF.data.GD.LM[4]},
			{38, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.MF)),	GetSV(sVarPtsData.GD.MF),	USPF.ptsTots.GD.MF,		USPF.data.GD.MF[4]},
			{39, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.IR)),	GetSV(sVarPtsData.GD.IR),	USPF.ptsTots.GD.IR,		USPF.data.GD.IR[4]},
			{40, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.UG)),	GetSV(sVarPtsData.GD.UG),	USPF.ptsTots.GD.UG,		USPF.data.GD.UG[4]},
			{41, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.SG)),	GetSV(sVarPtsData.GD.SG),	USPF.ptsTots.GD.SG,		USPF.data.GD.SG[4]},
			{42, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.WS)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.GDN.CT)),	GetSV(sVarPtsData.GD.CT),	USPF.ptsTots.GD.CT,		USPF.data.GD.CT[4]},
		},
		GDQ_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.GDTot, USPF.ptsTots.GDTot),
		PDGBE = {
			{ 1, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD1)),	GetSV(sVarPtsData.PD.AD1),	USPF.ptsTots.PD.AD1,	GetAchLink(USPF.data.PD.AD1[2])},
			{ 2, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD2)),	GetSV(sVarPtsData.PD.AD2),	USPF.ptsTots.PD.AD2,	GetAchLink(USPF.data.PD.AD2[2])},
			{ 3, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD3)),	GetSV(sVarPtsData.PD.AD3),	USPF.ptsTots.PD.AD3,	GetAchLink(USPF.data.PD.AD3[2])},
			{ 4, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD4)),	GetSV(sVarPtsData.PD.AD4),	USPF.ptsTots.PD.AD4,	GetAchLink(USPF.data.PD.AD4[2])},
			{ 5, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.AD5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.AD5)),	GetSV(sVarPtsData.PD.AD5),	USPF.ptsTots.PD.AD5,	GetAchLink(USPF.data.PD.AD5[2])},
			{ 6, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC1)),	GetSV(sVarPtsData.PD.DC1),	USPF.ptsTots.PD.DC1,	GetAchLink(USPF.data.PD.DC1[2])},
			{ 7, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC2)),	GetSV(sVarPtsData.PD.DC2),	USPF.ptsTots.PD.DC2,	GetAchLink(USPF.data.PD.DC2[2])},
			{ 8, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC3)),	GetSV(sVarPtsData.PD.DC3),	USPF.ptsTots.PD.DC3,	GetAchLink(USPF.data.PD.DC3[2])},
			{ 9, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC4)),	GetSV(sVarPtsData.PD.DC4),	USPF.ptsTots.PD.DC4,	GetAchLink(USPF.data.PD.DC4[2])},
			{10, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.DC5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.DC5)),	GetSV(sVarPtsData.PD.DC5),	USPF.ptsTots.PD.DC5,	GetAchLink(USPF.data.PD.DC5[2])},
			{11, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP1)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP1)),	GetSV(sVarPtsData.PD.EP1),	USPF.ptsTots.PD.EP1,	GetAchLink(USPF.data.PD.EP1[2])},
			{12, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP2)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP2)),	GetSV(sVarPtsData.PD.EP2),	USPF.ptsTots.PD.EP2,	GetAchLink(USPF.data.PD.EP2[2])},
			{13, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP3)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP3)),	GetSV(sVarPtsData.PD.EP3),	USPF.ptsTots.PD.EP3,	GetAchLink(USPF.data.PD.EP3[2])},
			{14, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP4)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP4)),	GetSV(sVarPtsData.PD.EP4),	USPF.ptsTots.PD.EP4,	GetAchLink(USPF.data.PD.EP4[2])},
			{15, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.EP5)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.EP5)),	GetSV(sVarPtsData.PD.EP5),	USPF.ptsTots.PD.EP5,	GetAchLink(USPF.data.PD.EP5[2])},
			{16, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.CH)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.CH)),	GetSV(sVarPtsData.PD.CH),	USPF.ptsTots.PD.CH,		GetAchLink(USPF.data.PD.CH[2])},
			{17, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.WOO)),	GetSV(sVarPtsData.PD.WOO),	USPF.ptsTots.PD.WOO,	GetAchLink(USPF.data.PD.WOO[2])},
			{18, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.RO)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.WRK)),	GetSV(sVarPtsData.PD.WRK),	USPF.ptsTots.PD.WRK,	GetAchLink(USPF.data.PD.WRK[2])},
			{19, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.VV)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.VFW)),	GetSV(sVarPtsData.PD.VFW),	USPF.ptsTots.PD.VFW,	GetAchLink(USPF.data.PD.VFW[2])},
			{20, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.VV)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.VNC)),	GetSV(sVarPtsData.PD.VNC),	USPF.ptsTots.PD.VNC,	GetAchLink(USPF.data.PD.VNC[2])},
			{21, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SKW)),	GetSV(sVarPtsData.PD.SKW),	USPF.ptsTots.PD.SKW,	GetAchLink(USPF.data.PD.SKW[2])},
			{22, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.SU)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.SSH)),	GetSV(sVarPtsData.PD.SSH),	USPF.ptsTots.PD.SSH,	GetAchLink(USPF.data.PD.SSH[2])},
			{23, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.OC)),	GetSV(sVarPtsData.PD.OC),	USPF.ptsTots.PD.OC,		GetAchLink(USPF.data.PD.OC[2])},
			{24, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.NE)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.RN)),	GetSV(sVarPtsData.PD.RN),	USPF.ptsTots.PD.RN,		GetAchLink(USPF.data.PD.RN[2])},
			{25, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.WS)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.LT)),	GetSV(sVarPtsData.PD.LT),	USPF.ptsTots.PD.LT,		GetAchLink(USPF.data.PD.LT[2])},
			{26, zf("<<C:1>>", GZNBId(USPF.data.ZId.ZN.BGC)),	zf("<<C:1>>", GZNBId(USPF.data.ZId.PDN.NK)),	GetSV(sVarPtsData.PD.NK),	USPF.ptsTots.PD.NK,		GetAchLink(USPF.data.PD.NK[2])},
		},
		PDGBE_T = strF("%s: %d/%d", GS(USPF_GUI_TOTAL), sVarPtsData.PDTot, USPF.ptsTots.PDTot),
		CharacterTot = strF("%s: %d/%d", GS(USPF_GUI_CHAR_TOTAL), sVarPtsData.Tot, USPF.ptsTots.Tot),
	}
end

local function USPF_SetupData(charId)
	if(charId == GCCId()) then
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
		USPF_UpdateGUITable()
		
		--Update the saved variables.
		USPF_UpdateAllSavedVars()
	else
		--Load selected character data.
		USPF_LoadData(charId)
	end
end

function USPF:UpdateDataLines()
	local dataLines_GSP, dataLines_SQS, dataLines_GDQ, dataLines_PDGBE, tempTable = {},{},{},{},{}
	
	USPF_SetupData(selectedChar)
	
	for i = 1, #USPF.GUI.GSP do
		table.insert(dataLines_GSP, {
			source = USPF.GUI.GSP[i][2],
			progress = (USPF.GUI.GSP[i][3] == 0 and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.GSP.needColor), USPF.GUI.GSP[i][3], USPF.GUI.GSP[i][4]) or
				(USPF.GUI.GSP[i][3] < USPF.GUI.GSP[i][4] and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.GSP.progColor == nil and USPF.settings.GSP.progColor or USPF.settings.GSP.progColor), USPF.GUI.GSP[i][3], USPF.GUI.GSP[i][4]) or
					strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.GSP.doneColor), USPF.GUI.GSP[i][3], USPF.GUI.GSP[i][4])))
		})
	end
	
	tempTable = USPF_LTF:SortTable(USPF.GUI.SQS, USPF.settings.SQS.sortCol)
	for i = 1, #tempTable do
		table.insert(dataLines_SQS, {
			zone = tempTable[i][2],
			quests = (tempTable[i][4] > 0
				and (tempTable[i][3] == 0 and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.SQS.needColorZQ), tempTable[i][3], tempTable[i][4]) or
					(tempTable[i][3] < tempTable[i][4] and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.SQS.progColorZQ), tempTable[i][3], tempTable[i][4]) or
						strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.SQS.doneColorZQ), tempTable[i][3], tempTable[i][4])))
				or "-"),
			skyshards = (tempTable[i][5] == 0 and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.SQS.needColorSS), tempTable[i][5], tempTable[i][6]) or
				(tempTable[i][5] < tempTable[i][6] and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.SQS.progColorSS), tempTable[i][5], tempTable[i][6]) or
					strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.SQS.doneColorSS), tempTable[i][5], tempTable[i][6]))),
		})
	end
	
	tempTable = USPF_LTF:SortTable(USPF.GUI.GDQ, USPF.settings.GDQ.sortCol)
	for i = 1, #tempTable do
		table.insert(dataLines_GDQ, {
			zone = tempTable[i][2],
			dungeon = tempTable[i][3],
			progress = (tempTable[i][4] < tempTable[i][5] and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.GDQ.needColor), tempTable[i][4], tempTable[i][5]) or strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.GDQ.doneColor), tempTable[i][4], tempTable[i][5])),
		})
	end
	
	tempTable = USPF_LTF:SortTable(USPF.GUI.PDGBE, USPF.settings.PDB.sortCol)
	for i = 1, #tempTable do
		table.insert(dataLines_PDGBE, {
			zone = tempTable[i][2],
			dungeon = tempTable[i][3],
			progress = (tempTable[i][4] < tempTable[i][5] and strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.PDB.needColor), tempTable[i][4], tempTable[i][5]) or strF("%s%d/%d|r", USPF_rgbToHex(USPF.settings.PDB.doneColor), tempTable[i][4], tempTable[i][5])),
		})
	end
	
	
	USPF_GUI_Header_Title:SetText(GS(USPF_GUI_TITLE))
	USPF_GUI_Body_GSP:SetText(GS(USPF_GUI_GSP))
	USPF_GUI_Body_GSP_Source:SetText(GS(USPF_GUI_SOURCE))
	USPF_GUI_Body_GSP_Progress:SetText(GS(USPF_GUI_PROGRESS))
	
	USPF_GUI_Body_SQS:SetText(GS(USPF_GUI_SQS))
	USPF_GUI_Body_SQS_Z:SetText(GS(USPF_GUI_ZONE))
	USPF_GUI_Body_SQS_SL:SetText(GS(USPF_GUI_STORYLINE))
	USPF_GUI_Body_SQS_SS:SetText(GS(USPF_GUI_SKYSHARDS))
	USPF_GUI_Body_SQS_Z_T:SetText(GS(USPF_GUI_TOTAL..":"))
	
	USPF_GUI_Body_GDQ:SetText(GS(USPF_GUI_GDQ))
	USPF_GUI_Body_GDQ_Z:SetText(GS(USPF_GUI_ZONE))
	USPF_GUI_Body_GDQ_D:SetText(GS(USPF_GUI_GROUP_DUNGEON))
	USPF_GUI_Body_GDQ_P:SetText(GS(USPF_GUI_PROGRESS))
	
	USPF_GUI_Body_PDGBE:SetText(GS(USPF_GUI_PDB))
	USPF_GUI_Body_PDGBE_Z:SetText(GS(USPF_GUI_ZONE))
	USPF_GUI_Body_PDGBE_D:SetText(GS(USPF_GUI_PUBLIC_DUNGEON))
	USPF_GUI_Body_PDGBE_P:SetText(GS(USPF_GUI_PROGRESS))
	
	
	USPF_GUI_Body_GSP_ListHolder.dataLines = dataLines_GSP
	USPF_GUI_Body_GSP_ListHolder:SetParent(USPF_GUI_Body)
	USPF_GUI_Body_SQS_ListHolder.dataLines = dataLines_SQS
	USPF_GUI_Body_SQS_ListHolder:SetParent(USPF_GUI_Body)
	USPF_GUI_Body_GDQ_ListHolder.dataLines = dataLines_GDQ
	USPF_GUI_Body_GDQ_ListHolder:SetParent(USPF_GUI_Body)
	USPF_GUI_Body_PDGBE_ListHolder.dataLines = dataLines_PDGBE
	USPF_GUI_Body_PDGBE_ListHolder:SetParent(USPF_GUI_Body)
	
	USPF_GUI_Body_GSP_T:SetText(USPF.GUI.GSP_T)
	USPF_GUI_Body_SQS_SL_T:SetText(USPF.GUI.SQS_SL_T)
	USPF_GUI_Body_SQS_SS_T:SetText(USPF.GUI.SQS_SS_T)
	USPF_GUI_Body_GDQ_T:SetText(USPF.GUI.GDQ_T)
	USPF_GUI_Body_PDGBE_T:SetText(USPF.GUI.PDGBE_T)
	USPF_GUI_Footer_CharacterTotal:SetText(USPF.GUI.CharacterTot)
	
	USPF:InitializeDataLines()
end

function USPF:FillLine(currLine, currItem)
	local cln, clsrc, clz, clq, clss, cld, clp, cisrc, ciz, ciq, ciss, cid, cip = currLine:GetParent():GetName(), currLine.source, currLine.zone, currLine.quests, currLine.skyshards, currLine.dungeon, currLine.progress, currItem.source, currItem.zone, currItem.quests, currItem.skyshards, currItem.dungeon, currItem.progress
	
	if currItem == nil then
		if(cln == "USPF_GUI_Body_GSP_ListHolder") then
			clsrc:SetText("")
			clp:SetText("")
		elseif(cln == "USPF_GUI_Body_SQS_ListHolder") then
			clz:SetText("")
			clq:SetText("")
			clss:SetText("")
		elseif(cln == "USPF_GUI_Body_GDQ_ListHolder") then
			clz:SetText("")
			cld:SetText("")
			clp:SetText("")
		elseif(cln == "USPF_GUI_Body_PDGBE_ListHolder") then
			clz:SetText("")
			cld:SetText("")
			clp:SetText("")
		end
	else
		if(cln == "USPF_GUI_Body_GSP_ListHolder") then
			clsrc:SetText(cisrc)
			clp:SetText(cip)
		elseif(cln == "USPF_GUI_Body_SQS_ListHolder") then
			clz:SetText(ciz)
			clq:SetText(ciq)
			clss:SetText(ciss)
		elseif(cln == "USPF_GUI_Body_GDQ_ListHolder") then
			clz:SetText(ciz)
			cld:SetText(cid)
			clp:SetText(cip)
		elseif(cln == "USPF_GUI_Body_PDGBE_ListHolder") then
			clz:SetText(ciz)
			cld:SetText(cid)
			clp:SetText(cip)
		end
	end
end

function USPF:InitializeDataLines()
	local currLine, currData
	for i = 1, #USPF.GUI.GSP do
		currLine = USPF_GUI_Body_GSP_ListHolder.lines[i]
		currData = USPF_GUI_Body_GSP_ListHolder.dataLines[i]
		USPF:FillLine(currLine, (currData ~= nil and currData or nil))
		
		if(USPF.GUI.GSP[i][5] ~= nil) then
			-- tooltip text
			USPF_GUI_Body_GSP_ListHolder.lines[i].data = {tooltipText = USPF.GUI.GSP[i][5]}
			
			-- tooltip handlers
			USPF_GUI_Body_GSP_ListHolder.lines[i]:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
			USPF_GUI_Body_GSP_ListHolder.lines[i]:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
		end
	end
	
	for i = 1, #USPF.GUI.SQS do
		currLine = USPF_GUI_Body_SQS_ListHolder.lines[i]
		currData = USPF_GUI_Body_SQS_ListHolder.dataLines[i]
		USPF:FillLine(currLine, (currData ~= nil and currData or nil))
		
		if(USPF.GUI.SQS[i][7] ~= nil) then
			-- tooltip text
			USPF_GUI_Body_SQS_ListHolder.lines[i].data = {tooltipText = USPF.GUI.SQS[i][7]}
			
			-- tooltip handlers
			USPF_GUI_Body_SQS_ListHolder.lines[i]:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
			USPF_GUI_Body_SQS_ListHolder.lines[i]:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
		end
	end
	
	for i = 1, #USPF.GUI.GDQ do
		currLine = USPF_GUI_Body_GDQ_ListHolder.lines[i]
		currData = USPF_GUI_Body_GDQ_ListHolder.dataLines[i]
		USPF:FillLine(currLine, (currData ~= nil and currData or nil))
		
		if(USPF.GUI.GDQ[i][6] ~= nil) then
			-- tooltip text
			USPF_GUI_Body_GDQ_ListHolder.lines[i].data = {tooltipText = USPF.GUI.GDQ[i][6]}
			
			-- tooltip handlers
			USPF_GUI_Body_GDQ_ListHolder.lines[i]:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
			USPF_GUI_Body_GDQ_ListHolder.lines[i]:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
		end
	end
	
	for i = 1, #USPF.GUI.PDGBE do
		currLine = USPF_GUI_Body_PDGBE_ListHolder.lines[i]
		currData = USPF_GUI_Body_PDGBE_ListHolder.dataLines[i]
		USPF:FillLine(currLine, (currData ~= nil and currData or nil))
		
		if(USPF.GUI.PDGBE[i][6] ~= nil) then
			-- tooltip text
			USPF_GUI_Body_PDGBE_ListHolder.lines[i].data = {tooltipText = USPF.GUI.PDGBE[i][6]}
			
			-- tooltip handlers
			USPF_GUI_Body_PDGBE_ListHolder.lines[i]:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
			USPF_GUI_Body_PDGBE_ListHolder.lines[i]:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
		end
	end
end

function USPF:ToggleWindow()
	USPF.active = not USPF.active
	if(USPF.active) then USPF:UpdateDataLines() end
	USPF_GUI:SetHidden(not USPF.active)
end


function USPF:CreateLine(i, USPF_predecessor, USPF_parent)
	if(USPF_parent:GetName() == "USPF_GUI_Body_GSP_ListHolder") then
		local USPF_record = CreateControlFromVirtual("USPF_GSP_Row_", USPF_parent, "USPF_GeneralTemplate", i)
		
		USPF_record.source = USPF_record:GetNamedChild("_Source")
		USPF_record.progress = USPF_record:GetNamedChild("_Progress")
		
		USPF_record.source:SetFont(USPF.Options.Font.Fonts[USPF.settings.GSP.font].."|14")
		USPF_record.progress:SetFont(USPF.Options.Font.Fonts[USPF.settings.GSP.font].."|14")
		
		USPF_record:SetHidden(false)
		USPF_record:SetMouseEnabled(true)
		USPF_record:SetHeight("18")
		
		if i == 1 then
			USPF_record:SetAnchor(TOPLEFT, USPF_GUI_Body_GSP_ListHolder, TOPLEFT, 0, 0)
			USPF_record:SetAnchor(TOPRIGHT, USPF_GUI_Body_GSP_ListHolder, TOPRIGHT, 0, 0)
		else
			USPF_record:SetAnchor(TOPLEFT, USPF_predecessor, BOTTOMLEFT, 0, USPF_GUI_Body_GSP_ListHolder.rowHeight)
			USPF_record:SetAnchor(TOPRIGHT, USPF_predecessor, BOTTOMRIGHT, 0, USPF_GUI_Body_GSP_ListHolder.rowHeight)
		end
		USPF_record:SetParent(USPF_GUI_Body_GSP_ListHolder)
		return USPF_record
	elseif(USPF_parent:GetName() == "USPF_GUI_Body_SQS_ListHolder") then
		local USPF_record = CreateControlFromVirtual("USPF_SQS_Row_", USPF_parent, "USPF_SQSSTemplate", i)
		
		USPF_record.zone = USPF_record:GetNamedChild("_Zone")
		USPF_record.quests = USPF_record:GetNamedChild("_Quests")
		USPF_record.skyshards = USPF_record:GetNamedChild("_Skyshards")
		
		USPF_record.zone:SetFont(USPF.Options.Font.Fonts[USPF.settings.SQS.font].."|14")
		USPF_record.quests:SetFont(USPF.Options.Font.Fonts[USPF.settings.SQS.font].."|14")
		USPF_record.skyshards:SetFont(USPF.Options.Font.Fonts[USPF.settings.SQS.font].."|14")
		
		USPF_record:SetHidden(false)
		USPF_record:SetMouseEnabled(true)
		USPF_record:SetHeight("18")
		
		if i == 1 then
			USPF_record:SetAnchor(TOPLEFT, USPF_GUI_Body_SQS_ListHolder, TOPLEFT, 0, 0)
			USPF_record:SetAnchor(TOPRIGHT, USPF_GUI_Body_SQS_ListHolder, TOPRIGHT, 0, 0)
		else
			USPF_record:SetAnchor(TOPLEFT, USPF_predecessor, BOTTOMLEFT, 0, USPF_GUI_Body_SQS_ListHolder.rowHeight)
			USPF_record:SetAnchor(TOPRIGHT, USPF_predecessor, BOTTOMRIGHT, 0, USPF_GUI_Body_SQS_ListHolder.rowHeight)
		end
		USPF_record:SetParent(USPF_GUI_Body_SQS_ListHolder)
		return USPF_record
	elseif(USPF_parent:GetName() == "USPF_GUI_Body_GDQ_ListHolder") then
		local USPF_record = CreateControlFromVirtual("USPF_GDQ_Row_", USPF_parent, "USPF_GDQTemplate", i)
		
		USPF_record.zone = USPF_record:GetNamedChild("_Zone")
		USPF_record.dungeon = USPF_record:GetNamedChild("_Dungeon")
		USPF_record.progress = USPF_record:GetNamedChild("_Progress")
		
		USPF_record.zone:SetFont(USPF.Options.Font.Fonts[USPF.settings.GDQ.font].."|14")
		USPF_record.dungeon:SetFont(USPF.Options.Font.Fonts[USPF.settings.GDQ.font].."|14")
		USPF_record.progress:SetFont(USPF.Options.Font.Fonts[USPF.settings.GDQ.font].."|14")
		
		USPF_record:SetHidden(false)
		USPF_record:SetMouseEnabled(true)
		USPF_record:SetHeight("18")
		
		if i == 1 then
			USPF_record:SetAnchor(TOPLEFT, USPF_GUI_Body_GDQ_ListHolder, TOPLEFT, 0, 0)
			USPF_record:SetAnchor(TOPRIGHT, USPF_GUI_Body_GDQ_ListHolder, TOPRIGHT, 0, 0)
		else
			USPF_record:SetAnchor(TOPLEFT, USPF_predecessor, BOTTOMLEFT, 0, USPF_GUI_Body_GDQ_ListHolder.rowHeight)
			USPF_record:SetAnchor(TOPRIGHT, USPF_predecessor, BOTTOMRIGHT, 0, USPF_GUI_Body_GDQ_ListHolder.rowHeight)
		end
		USPF_record:SetParent(USPF_GUI_Body_GDQ_ListHolder)
		return USPF_record
	elseif(USPF_parent:GetName() == "USPF_GUI_Body_PDGBE_ListHolder") then
		local USPF_record = CreateControlFromVirtual("USPF_PDGBE_Row_", USPF_parent, "USPF_PDGBETemplate", i)
		
		USPF_record.zone = USPF_record:GetNamedChild("_Zone")
		USPF_record.dungeon = USPF_record:GetNamedChild("_Dungeon")
		USPF_record.progress = USPF_record:GetNamedChild("_Progress")
		
		USPF_record.zone:SetFont(USPF.Options.Font.Fonts[USPF.settings.PDB.font].."|14")
		USPF_record.dungeon:SetFont(USPF.Options.Font.Fonts[USPF.settings.PDB.font].."|14")
		USPF_record.progress:SetFont(USPF.Options.Font.Fonts[USPF.settings.PDB.font].."|14")
		
		USPF_record:SetHidden(false)
		USPF_record:SetMouseEnabled(true)
		USPF_record:SetHeight("18")
		
		if i == 1 then
			USPF_record:SetAnchor(TOPLEFT, USPF_GUI_Body_PDGBE_ListHolder, TOPLEFT, 0, 0)
			USPF_record:SetAnchor(TOPRIGHT, USPF_GUI_Body_PDGBE_ListHolder, TOPRIGHT, 0, 0)
		else
			USPF_record:SetAnchor(TOPLEFT, USPF_predecessor, BOTTOMLEFT, 0, USPF_GUI_Body_PDGBE_ListHolder.rowHeight)
			USPF_record:SetAnchor(TOPRIGHT, USPF_predecessor, BOTTOMRIGHT, 0, USPF_GUI_Body_PDGBE_ListHolder.rowHeight)
		end
		USPF_record:SetParent(USPF_GUI_Body_PDGBE_ListHolder)
		return USPF_record
	end
end

function USPF:CreateListHolders()
	local USPF_predecessor = nil
	USPF_GUI_Body_GSP_ListHolder.dataLines = {}
	USPF_GUI_Body_GSP_ListHolder.lines = {}
	for i = 1, #USPF.GUI.GSP do 
		USPF_GUI_Body_GSP_ListHolder.lines[i] = USPF:CreateLine(i, USPF_predecessor, USPF_GUI_Body_GSP_ListHolder)
		USPF_predecessor = USPF_GUI_Body_GSP_ListHolder.lines[i]
	end
	
	USPF_predecessor = nil
	USPF_GUI_Body_SQS_ListHolder.dataLines = {}
	USPF_GUI_Body_SQS_ListHolder.lines = {}
	for i = 1, #USPF.GUI.SQS do
		USPF_GUI_Body_SQS_ListHolder.lines[i] = USPF:CreateLine(i, USPF_predecessor, USPF_GUI_Body_SQS_ListHolder)
		USPF_predecessor = USPF_GUI_Body_SQS_ListHolder.lines[i]
	end
	
	USPF_predecessor = nil
	USPF_GUI_Body_GDQ_ListHolder.dataLines = {}
	USPF_GUI_Body_GDQ_ListHolder.lines = {}
	for i = 1, #USPF.GUI.GDQ do
		USPF_GUI_Body_GDQ_ListHolder.lines[i] = USPF:CreateLine(i, USPF_predecessor, USPF_GUI_Body_GDQ_ListHolder)
		USPF_predecessor = USPF_GUI_Body_GDQ_ListHolder.lines[i]
	end
	
	USPF_predecessor = nil
	USPF_GUI_Body_PDGBE_ListHolder.dataLines = {}
	USPF_GUI_Body_PDGBE_ListHolder.lines = {}
	for i = 1, #USPF.GUI.PDGBE do
		USPF_GUI_Body_PDGBE_ListHolder.lines[i] = USPF:CreateLine(i, USPF_predecessor, USPF_GUI_Body_PDGBE_ListHolder)
		USPF_predecessor = USPF_GUI_Body_PDGBE_ListHolder.lines[i]
	end
	
	USPF:UpdateDataLines()
end

local function USPF_UpdateDataTable()
	USPF:SetupValues()
	USPF_GUI_Body_GSP_T:SetText(strF("%s: %d/%d", GS(USPF_GUI_TOTAL), USPF.ptsData.GenTot, USPF.ptsTots.GenTot))
	USPF_GUI_Body_SQS_SL_T:SetText(strF("%d/%d", USPF.ptsData.ZQTot, USPF.ptsTots.ZQTot))
	USPF_GUI_Body_SQS_SS_T:SetText(strF("%d/%d", USPF.ptsData.SSTot, USPF.ptsTots.SSTot))
	USPF_GUI_Body_GDQ_T:SetText(strF("%s: %d/%d", GS(USPF_GUI_TOTAL), USPF.ptsData.GDTot, USPF.ptsTots.GDTot))
	USPF_GUI_Body_PDGBE_T:SetText(strF("%s: %d/%d", GS(USPF_GUI_TOTAL), USPF.ptsData.PDTot, USPF.ptsTots.PDTot))
	USPF_GUI_Footer_CharacterTotal:SetText(strF("%s: %d/%d", GS(USPF_GUI_CHAR_TOTAL), USPF.ptsData.Tot, USPF.ptsTots.Tot))
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
	USPF_UpdateGUITable()
	
	--Set the window size and position.
	USPF_GUI:ClearAnchors()
	USPF_GUI:SetAnchor(CENTER, GuiRoot, CENTER, 0, 0)
	USPF_GUI:SetHeight(USPF_GUI_Header:GetHeight() + #USPF.GUI.GDQ * 18 + USPF_GUI_Footer:GetHeight() + 18 + 76)
	
	--Add information to window.
	USPF:CreateListHolders()
	
	USPF_GUI_Header:SetParent(USPF_GUI)
	USPF_GUI_Body:SetParent(USPF_GUI)
	USPF_GUI_Footer:SetParent(USPF_GUI)
	
	USPF_GUI_Body_GSP_ListHolder:SetParent(USPF_GUI_Body)
	USPF_GUI_Body_SQS_ListHolder:SetParent(USPF_GUI_Body)
	USPF_GUI_Body_GDQ_ListHolder:SetParent(USPF_GUI_Body)
	USPF_GUI_Body_PDGBE_ListHolder:SetParent(USPF_GUI_Body)
	
	USPF_GUI_Header_Title:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|30")
	USPF_GUI_Body_GSP:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|16")
	USPF_GUI_Body_GSP_Source:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_GSP_Progress:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_GSP_T:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	
	USPF_GUI_Body_SQS:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|16")
	USPF_GUI_Body_SQS_Z:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_SQS_SL:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_SQS_SS:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_SQS_Z_T:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_SQS_SL_T:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_SQS_SS_T:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	
	USPF_GUI_Body_GDQ:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|16")
	USPF_GUI_Body_GDQ_Z:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_GDQ_D:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_GDQ_P:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_GDQ_T:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	
	USPF_GUI_Body_PDGBE:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|16")
	USPF_GUI_Body_PDGBE_Z:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_PDGBE_D:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_PDGBE_P:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	USPF_GUI_Body_PDGBE_T:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|14")
	
	USPF_GUI_Footer_CharacterTotal:SetFont(USPF.Options.Font.Fonts[USPF.settings.title.font].."|24")
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

function USPF:TestHarness()
	d(GS(USPF_MSG_HACK))
end

local function USPF_LoadSettings(charId)
	if(USPF_CheckSavedVars(USPF.sVar.settings[charId])) then
		USPF.settings = USPF_LTF:CopyTable(USPF.sVar.settings[charId])
		
		if(USPF.settings.GSP.progColor == nil) then
			USPF.settings.GSP.progColor = USPF.settings.GSP.progColor == nil and {1, 1, 1} or USPF.settings.GSP.progColor
			USPF.sVar.settings[charId].GSP.progColor = USPF.settings.GSP.progColor
		end
		
		if(USPF.settings.SQS.progColorSS == nil) then
			USPF.settings.SQS.progColorSS = USPF.settings.SQS.progColorSS == nil and {0.7843, 0.3922, 0} or USPF.settings.SQS.progColorSS
			USPF.sVar.settings[charId].SQS.progColorSS = USPF.settings.SQS.progColorSS
		end
		
		if(USPF.settings.SQS.progColorZQ == nil) then
			USPF.settings.SQS.progColorZQ = USPF.settings.SQS.progColorZQ == nil and {0.7843, 0.3922, 0} or USPF.settings.SQS.progColorZQ
			USPF.sVar.settings[charId].SQS.progColorZQ = USPF.settings.SQS.progColorZQ
		end
		
		USPF.settings.MWC = (USPF.sVar.settings[charId].SSC and false or USPF.sVar.settings[charId].MWC)
		USPF.settings.SSC = (USPF.sVar.settings[charId].MWC and false or USPF.sVar.settings[charId].SSC)
		USPF.sVar.settings[charId].MWC = (USPF.settings.SSC and false or USPF.settings.MWC)
		USPF.sVar.settings[charId].SSC = (USPF.settings.MWC and false or USPF.settings.SSC)
	end
end

local function USPF_SetSelectedChar(charName)
	for i = 1, #USPF.charData do
		if(charName == USPF.charData[i].charName) then
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
	
	-- tooltip handlers
	USPF_GUI_Header_CharList:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	USPF_GUI_Header_CharList:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	local name, id = nil, nil
	USPF.charNames = {}
	USPF.charData = {}
	for k,_ in ipairs(USPF.sVar.charInfo) do
		name, _, _, _, _, _, id, _ = GetCharacterInfo(k)
		USPF.charNames[k] = USPF.sVar.charInfo[k].charName
		USPF.charData[k] = {
			charId = USPF.sVar.charInfo[k].charId,
			charName = USPF.sVar.charInfo[k].charName,
		}
		
		if(GCCId() == USPF.charData[k].charId) then
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
		if(USPF.charNames[k] == currentCharName) then
			USPF_comboBox:SetSelectedItem(USPF.charNames[k])
		end
	end
end

local function USPF_UpdateCharList()
	USPF.sVar.charInfo = {}
	local id, name
	for i = 1, GetNumCharacters() do
		name, _, _, _, _, _, id, _ = GetCharacterInfo(i)
		USPF.sVar.charInfo[i] = {charId = id, charName = zf("<<t:1>>", name),}
	end
end

local function USPF_InitSetup()
	local id, name, thisCharId = nil, nil, GCCId()
	local firstRun = ((USPF.sVar.firstRun or USPF.sVar.numChars == 0 or USPF.sVar.charInfo[1] == nil) and true or false)
	--local firstRun = ((USPF.sVar.firstRun or USPF.sVar.numChars == 0 or USPF.sVar.charInfo[1] == nil or USPF.sVar.settings[thisCharId] == nil or USPF.sVar.ptsData[thisCharId] == nil) and true or false)
	
	--If first run then setup the character table
	if(firstRun) then
		d(GS(USPF_MSG_INIT))
		USPF.sVar.numChars = GetNumCharacters()
		for i = 1, GetNumCharacters() do
			name, _, _, _, _, _, id, _ = GetCharacterInfo(i)
			USPF.sVar.charInfo[i] = {charId = id, charName = zf("<<t:1>>", name),}
			
			--Write the character settings table.
			USPF.sVar.settings[id] = {}
			USPF.sVar.settings[id] = USPF_LTF:CopyTable(USPF.settings)
			
			--Write the character points data table.
			USPF.sVar.ptsData[id] = {}
			USPF.sVar.ptsData[id] = USPF_LTF:CopyTable(USPF.ptsData)
		end
		
		--Show the welcome message.
		d(GS(USPF_MSG_HELP))
		
		USPF.sVar.firstRun = false
	end
	
	--Setup the character info table.
	if(not firstRun) then USPF_UpdateCharList() end
	
	--Check for added characters.
	for _,v in pairs(USPF.sVar.charInfo) do
		if(not USPF_LTF:TableContains(USPF.sVar.settings, v.charId, true)) then
			USPF.sVar.settings[v.charId] = USPF_LTF:CopyTable(USPF.settings)
		end
		
		if(not USPF_LTF:TableContains(USPF.sVar.ptsData, v.charId, true)) then
			USPF.sVar.ptsData[v.charId] = USPF_LTF:CopyTable(USPF.ptsData)
		end
	end
	
	--Check for removed characters.
	for k,_ in pairs(USPF.sVar.settings) do
		USPF.sVar.settings[k] = (USPF_LTF:TableContains(USPF.sVar.charInfo, k, false) and USPF.sVar.settings[k] or nil)
	end
	for k,_ in pairs(USPF.sVar.ptsData) do
		USPF.sVar.ptsData[k] = (USPF_LTF:TableContains(USPF.sVar.charInfo, k, false) and USPF.sVar.ptsData[k] or nil)
	end
	
	--Create the character select box.
	USPF_CreateCharList()
end

local function USPF_SkillPointsUpdate(eventCode, pointsBefore, pointsNow, partialPointsBefore, partialPointsNow)
	USPF_ResetSelectedCharacter()
	USPF_SetupData(GCCId())
end

local function USPF_QuestRemoved(eventCode, isCompleted, journalIndex, questName, zoneIndex, poiIndex, questID)
	if(isCompleted) then USPF_ResetSelectedCharacter(); USPF_SetupData(GCCId()) end
end

local function USPF_LevelUp(eventCode, unitTag, level)
	if(unitTag == 'player') then USPF_ResetSelectedCharacter(); USPF_SetupData(GCCId()) end
end

local function USPF_AchComplete(eventCode, name, points, id, link)
	USPF_ResetSelectedCharacter()
	USPF_SetupData(GCCId())
end

local function USPF_AchUpdate(eventCode, id)
	USPF_ResetSelectedCharacter()
	USPF_SetupData(GCCId())
end

local function USPF_PlayerActivated(eventCode)
	USPF_ResetSelectedCharacter()
	USPF_SetupData(GCCId())
end

local function USPF_PlayerDeactivated(eventCode)
	USPF_ResetSelectedCharacter()
	USPF_SetupData(GCCId())
end

local function USPF_Initialized(eventCode, addonName)
	if addonName ~= USPF.AddonName then return end
	
	local world = GetWorldName()
	if(world == "NA Megaserver") then
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
		if(string.lower(keyWord) == "help") then
			USPF:HelpSlash()
		elseif(keyWord == "") then
			USPF:ToggleWindow()
		elseif(string.lower(keyWord) == "test") then
			USPF:TestHarness()
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
	
	--Create the event handlers.
	EM:RegisterForEvent(USPF.AddonName, EVENT_SKILL_POINTS_CHANGED, USPF_SkillPointsUpdate)
	EM:RegisterForEvent(USPF.AddonName, EVENT_QUEST_REMOVED, USPF_QuestRemoved)
	EM:RegisterForEvent(USPF.AddonName, EVENT_LEVEL_UPDATE, USPF_LevelUp)
	EM:RegisterForEvent(USPF.AddonName, EVENT_ACHIEVEMENT_AWARDED, USPF_AchComplete)
	--EM:RegisterForEvent(USPF.AddonName, EVENT_ACHIEVEMENT_UPDATED, USPF_AchUpdate)
	EM:RegisterForEvent(USPF.AddonName, EVENT_PLAYER_ACTIVATED, USPF_PlayerActivated)
	EM:RegisterForEvent(USPF.AddonName, EVENT_PLAYER_DEACTIVATED, USPF_PlayerDeactivated)
	
	--Kill the initial event handler.
	EM:UnregisterForEvent(USPF.AddonName, EVENT_ADD_ON_LOADED)
end

--Register initialization event.
EM:RegisterForEvent(USPF.AddonName, EVENT_ADD_ON_LOADED, USPF_Initialized)