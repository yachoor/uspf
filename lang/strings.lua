local strings = {
	USPF_SETTINGS_FONT_TITLE = "Font Settings",
	
	USPF_SETTINGS_FONT_TITLE_HEADER = "Title/Footer Font",
	USPF_SETTINGS_FONT_TITLE_DESC = "Set the table header and footer fonts.",
	
	USPF_SETTINGS_FONT_GSP_TITLE = "General Skill Points Font",
	USPF_SETTINGS_FONT_GSP_ROWS = "Set the General Skill Points table row font.",
	
	USPF_SETTINGS_FONT_SQS_TITLE = "Quests & Skyshards Font",
	USPF_SETTINGS_FONT_SQS_ROWS = "Set the Zone Quests & Skyshards table row font.",
	
	USPF_SETTINGS_FONT_GDQ_TITLE = "Group Dungeon Quests Font",
	USPF_SETTINGS_FONT_GDQ_ROWS = "Set the Group Dungeon Quests table row font.",
	
	USPF_SETTINGS_FONT_PDB_TITLE = "Public Dungeon Group Events Font",
	USPF_SETTINGS_FONT_PDB_ROWS = "Set the Public Dungeon Group Boss Events table row font.",
	
	USPF_SETTINGS_RELOAD_WARNING = "Will need to reload the UI.",
	
	
	USPF_SETTINGS_COLOR_TITLE = "Color Settings",
	USPF_SETTINGS_COLOR_GSP_DONE = "General - Done",
	USPF_SETTINGS_COLOR_GSP_PROG = "General - In Progress",
	USPF_SETTINGS_COLOR_GSP_NOT_DONE = "General - Not Done",
	USPF_SETTINGS_COLOR_ZQ_DONE = "Zone Quests - Done",
	USPF_SETTINGS_COLOR_ZQ_PROG = "Zone Quests - In Progress",
	USPF_SETTINGS_COLOR_ZQ_NOT_DONE = "Zone Quests - Not Done",
	USPF_SETTINGS_COLOR_SS_DONE = "Skyshards - Done",
	USPF_SETTINGS_COLOR_SS_PROG = "Skyshards - In Progress",
	USPF_SETTINGS_COLOR_SS_NOT_DONE = "Skyshards - Not Done",
	USPF_SETTINGS_COLOR_GDQ_DONE = "Group Dungeons - Done",
	USPF_SETTINGS_COLOR_GDQ_NOT_DONE = "Group Dungeons - Not Done",
	USPF_SETTINGS_COLOR_PDB_DONE = "Public Dungeons - Done",
	USPF_SETTINGS_COLOR_PDB_NOT_DONE = "Public Dungeons - Not Done",
	USPF_SETTINGS_COLOR_DESC_DONE = "Set the color for complete skill points.",
	USPF_SETTINGS_COLOR_DESC_PROG = "Set the color for incomplete, started skill points.",
	USPF_SETTINGS_COLOR_DESC_NOT_DONE = "Set the color for incomplete skill points.",
	
	
	USPF_SETTINGS_SORT_TITLE = "Sort Option Settings",
	USPF_SETTINGS_SORT_SQS = "Quest and Skyshard Sorting",
	USPF_SETTINGS_SORT_SQS_DESC = "Set the sort order for the Storyline Quests and Skyshards table.",
	USPF_SETTINGS_SORT_GDQ = "Group Dungeon Sorting",
	USPF_SETTINGS_SORT_GDQ_DESC = "Set the sort order for the Group Dungeon Quests table.",
	USPF_SETTINGS_SORT_PDB = "Public Dungeon Sorting",
	USPF_SETTINGS_SORT_PDB_DESC = "Set the sort order for the Public Dungeon Group Boss Events table.",
	
	USPF_SETTINGS_OVERRIDE_TITLE = "Override Settings",
	USPF_SETTINGS_OVERRIDE_FOLIUM = "Folium Discognitum Override",
	USPF_SETTINGS_OVERRIDE_FOLIUM_DESC = "This setting allows you to override the USPF's built-in Folium Discognitum logic. This is usually only necessary if you've not received skill points that you've actually earned.",
	USPF_SETTINGS_OVERRIDE_WARN = "May result in an incorrect total amount of skill points in USPF.",
	USPF_SETTINGS_OVERRIDE_FOLIUM_SET = "Character Has Folium Discognitum",
	USPF_SETTINGS_OVERRIDE_FOLIUM_SET_DESC = "This setting forces the USPF's built-in Folium Discognitum points. You must select the Folium Discognitum Override option for this to have any effect.",
	
	USPF_SETTINGS_OVERRIDE_MWC_SET = "Morrowind Quest Override",
	USPF_SETTINGS_OVERRIDE_MWC_SET_DESC = "This setting allows you to override the USPF's built-in Morrowind intro quest logic. This is usually only necessary if you've created a character after the release of Morrowind and skipped the \"Broken Bonds\" introduction quest.",
	
	USPF_SETTINGS_OVERRIDE_SSC_SET = "Summerset Quest Override",
	USPF_SETTINGS_OVERRIDE_SSC_SET_DESC = "This setting allows you to override the USPF's built-in Summerset intro quest logic. This is usually only necessary if you've created a character after the release of Summerset and skipped the \"The Mind Trap\" introduction quest.",
	
	USPF_SETTINGS_OVERRIDE_EWC_SET = "Elsweyr Quest Override",
	USPF_SETTINGS_OVERRIDE_EWC_SET_DESC = "This setting allows you to override the USPF's built-in Elsweyr intro quest logic. This is usually only necessary if you've created a character after the release of Elsweyr and skipped the \"Bright Moons, Warm Sands\" introduction quest.",
	
	USPF_SETTINGS_OVERRIDE_GMC_SET = "Greymoor Quest Override",
	USPF_SETTINGS_OVERRIDE_GMC_SET_DESC = "This setting allows you to override the USPF's built-in Greymoor intro quest logic. This is usually only necessary if you've created a character after the release of Elsweyr and skipped the \"Bound in Blood\" introduction quest.",
  
	USPF_SETTINGS_OVERRIDE_BWC_SET = "Blackwood Quest Override",
	USPF_SETTINGS_OVERRIDE_BWC_SET_DESC = "This setting allows you to override the USPF's built-in Blackwood intro quest logic. This is usually only necessary if you've created a character after the release of Blackwood and skipped the \"The Gates of Adamant\" introduction quest.",

	USPF_GUI_CHAR_LEVEL	= "Character Level",
	USPF_GUI_MAIN_QUEST	= "Main Quest",
	USPF_GUI_FOLIUM		= "Folium Discognitum",
	USPF_GUI_MW_CHAR	= "Morrowind Character",
	USPF_GUI_SU_CHAR	= "Summerset Character",
	USPF_GUI_EW_CHAR	= "Elsweyr Character",
	USPF_GUI_GM_CHAR	= "Greymoor Character",
	USPF_GUI_BW_CHAR	= "Blackwood Character",
	USPF_GUI_AVA_RANK	= "Alliance War Rank",
	USPF_GUI_MAEL_ARENA	= "Maelstrom Arena",
	
	
	USPF_GUI_TITLE		= "Urich's Skill Point Finder",
	
	USPF_GUI_GSP		= "General Skill Points",
	USPF_GUI_SQS		= "Storyline Quests & Skyshards",
	USPF_GUI_GDQ		= "Group Dungeon Quests",
	USPF_GUI_PDB		= "Public Dungeon Group Boss Events",
	USPF_GUI_SOURCE		= "Source",
	USPF_GUI_PROGRESS	= "Progress",
	USPF_GUI_ZONE		= "Zone",
	USPF_GUI_STORYLINE	= "Storyline",
	USPF_GUI_SKYSHARDS	= "Skyshards",
	USPF_GUI_GROUP_DUNGEON = "Group Dungeon",
	USPF_GUI_PUBLIC_DUNGEON = "Public Dungeon",
	USPF_GUI_DUNGEON_NAME = "Dungeon Name",
	
	USPF_GUI_TOTAL		= "Total",
	USPF_GUI_CHAR_TOTAL	= "Character Total",
	
	
	SI_BINDING_NAME_USPF_TOGGLE = "Show/Hide the USPF window.",
	USPF_GUI_ZN_LCL		= "Lower",
	USPF_GUI_ZN_UCL		= "Upper",
	USPF_GUI_ZN_MQ		= "Main Quest",
	
	USPF_MSG_SHOW_GUI	= "USPF displayed.",
	USPF_MSG_HIDE_GUI	= "USPF hidden.",
	
	USPF_MSG_BAD_SLASH	= "USPF invalid command.",
	USPF_MSG_CMD_TITLE	= "USPF slash commands:",
	USPF_MSG_CMD_OPTION	= "    /uspf - To %s the addon. This can be keybound.",
	USPF_MSG_ACTIVATE	= "activate",
	USPF_MSG_DEACTVATE	= "deactivate",
	
	USPF_MSG_INIT		= "Running USPF for the first time!",
	USPF_MSG_HELP		= "USPF Activated!",
	
	USPF_QUEST_NA		= "These skill points are not quest based.",
	USPF_QUEST_NONE		= "There are no skill point quests in this zone.",
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
