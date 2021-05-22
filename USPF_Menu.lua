if USPF == nil then USPF = {} end

local ADDON_NAME = GetString(USPF_GUI_TITLE)
local ADDON_AUTHOR = "Urich"
local ADDON_VERSION = "5.7.0"

-- Original 5.2.0 
		-- Fonts = {
			-- ["ProseAntique"]			= "/EsoUI/Common/Fonts/ProseAntiquePSMT.otf",		--ANTIQUE_FONT
			-- ["Consolas"]				= "/EsoUI/Common/Fonts/consola.ttf",				--
			-- ["Futura Condensed"]		= "/EsoUI/Common/Fonts/FTN57.otf",					--GAMEPAD_MEDIUM_FONT
			-- ["Futura Condensed Bold"]	= "/EsoUI/Common/Fonts/FTN87.otf",					--GAMEPAD_BOLD_FONT
			-- ["Futura Condensed Light"]	= "/EsoUI/Common/Fonts/FTN47.otf",					--GAMEPAD_LIGHT_FONT
			-- ["Skyrim Handwritten"]		= "/EsoUI/Common/Fonts/Handwritten_Bold.otf",		--HANDWRITTEN_FONT
			-- ["Trajan Pro"]				= "/EsoUI/Common/Fonts/trajanpro-regular.otf",		--STONE_TABLET_FONT
			-- ["Univers 55"]				= "/EsoUI/Common/Fonts/univers55.otf",				--
			-- ["Univers 57"]				= "/EsoUI/Common/Fonts/univers57.otf",				--MEDIUM_FONT/CHAT_FONT
			-- ["Univers 67"]				= "/EsoUI/Common/Fonts/univers67.otf",				--BOLD_FONT
		-- },

-- Font code changed for v 5.3.0
USPF.Options = {
	Font = {
		Fonts = {
			["ProseAntique"]			= ZoFontBookPaper:GetFontInfo(),					--ANTIQUE_FONT
			["Consolas"]				= "/EsoUI/Common/Fonts/consola.ttf",				--
			["Futura Condensed"]		= "/EsoUI/Common/Fonts/FTN57.otf",					--GAMEPAD_MEDIUM_FONT
			["Futura Condensed Bold"]	= "/EsoUI/Common/Fonts/FTN87.otf",					--GAMEPAD_BOLD_FONT
			["Futura Condensed Light"]	= "/EsoUI/Common/Fonts/FTN47.otf",					--GAMEPAD_LIGHT_FONT
			["Skyrim Handwritten"]		= ZoFontBookLetter:GetFontInfo(),					--HANDWRITTEN_FONT
			["Trajan Pro"]				= ZoFontBookTablet:GetFontInfo(),					--STONE_TABLET_FONT
			["Univers 55"]				= "/EsoUI/Common/Fonts/univers55.otf",				--
			["Univers 57"]				= ZoFontGame:GetFontInfo(),							--MEDIUM_FONT/CHAT_FONT
			["Univers 67"]				= ZoFontGameBold:GetFontInfo(),						--BOLD_FONT
		},
		Names = {"ProseAntique", "Consolas", "Futura Condensed", "Futura Condensed Bold", "Futura Condensed Light", "Skyrim Handwritten", "Trajan Pro", "Univers 55", "Univers 57", "Univers 67"},
	},
	Sort = {
		SQS = {
			["Legacy Zone"]		= 1,
			["Zone Name"]		= 2,
		},
		D = {
			["Legacy Zone"]		= 1,
			["Zone Name"]		= 2,
			["Dungeon Name"]	= 3,
		},
		Names_SQS = {"Legacy Zone", "Zone Name"},
		Names_D = {"Legacy Zone", "Zone Name", "Dungeon Name"},
	},
}

function USPF:SetupMenu(charId)
	local USPF_LAM2 = LibAddonMenu2
	if (not USPF_LAM2) then return end
	
	USPF.panelData = {
		type = "panel",
		name = ADDON_NAME,
		displayName = ADDON_NAME.." Settings",
		author = ADDON_AUTHOR,
		version = ADDON_VERSION,
		website = "http://www.esoui.com/downloads/info1863-UrichsSkillPointFinder.html",
		slashCommand = "/uspfmenu",
		registerForRefresh = true,
		registerForDefaults = true,
		resetFunc = function() print("USPF settings reset to default.") end,
	}
	USPF_LAM2:RegisterAddonPanel(ADDON_NAME, USPF.panelData)
	
	USPF.optionsTable = {
		--Create the Font Options Header
		{
			type = "submenu",
			name = "|cFF0000"..GetString(USPF_SETTINGS_FONT_TITLE).."|r",
			controls = {
				
				--Select the Section Title/Footer Fonts
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_FONT_TITLE_HEADER),
					choices = USPF.Options.Font.Names,
					getFunc = function() return USPF.sVar.settings[charId].title.font end,
					setFunc = function(value) USPF.sVar.settings[charId].title.font = value; USPF.settings.title.font = value end,
					tooltip = GetString(USPF_SETTINGS_FONT_TITLE_DESC),
					width = "full",
					warning = GetString(USPF_SETTINGS_RELOAD_WARNING),
				},
				
				--Select the GSP Row Font
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_FONT_GSP_TITLE),
					choices = USPF.Options.Font.Names,
					getFunc = function() return USPF.sVar.settings[charId].GSP.font end,
					setFunc = function(value) USPF.sVar.settings[charId].GSP.font = value; USPF.settings.GSP.font = value end,
					tooltip = GetString(USPF_SETTINGS_FONT_GSP_ROWS),
					width = "half",
					warning = GetString(USPF_SETTINGS_RELOAD_WARNING),
				},
				
				--Select the SQS Row Font
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_FONT_SQS_TITLE),
					choices = USPF.Options.Font.Names,
					getFunc = function() return USPF.sVar.settings[charId].SQS.font end,
					setFunc = function(value) USPF.sVar.settings[charId].SQS.font = value; USPF.settings.SQS.font = value end,
					tooltip = GetString(USPF_SETTINGS_FONT_SQS_ROWS),
					width = "half",
					warning = GetString(USPF_SETTINGS_RELOAD_WARNING),
				},
				
				--Select the GDQ Row Font
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_FONT_GDQ_TITLE),
					choices = USPF.Options.Font.Names,
					getFunc = function() return USPF.sVar.settings[charId].GDQ.font end,
					setFunc = function(value) USPF.sVar.settings[charId].GDQ.font = value; USPF.settings.GDQ.font = value end,
					tooltip = GetString(USPF_SETTINGS_FONT_GDQ_ROWS),
					width = "half",
					warning = GetString(USPF_SETTINGS_RELOAD_WARNING),
				},
				
				--Select the PDB Row Font
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_FONT_PDB_TITLE),
					choices = USPF.Options.Font.Names,
					getFunc = function() return USPF.sVar.settings[charId].PDB.font end,
					setFunc = function(value) USPF.sVar.settings[charId].PDB.font = value; USPF.settings.PDB.font = value end,
					tooltip = GetString(USPF_SETTINGS_FONT_PDB_ROWS),
					width = "half",
					warning = GetString(USPF_SETTINGS_RELOAD_WARNING),
				},
			},
		},
		
		--Create the Color Options Header
		{
			type = "submenu",
			name = "|cFF0000"..GetString(USPF_SETTINGS_COLOR_TITLE).."|r",
			controls = {
				
				--Select the GSP Row Color - Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_GSP_DONE),
					getFunc = function() return USPF.sVar.settings[charId].GSP.doneColor[1], USPF.sVar.settings[charId].GSP.doneColor[2], USPF.sVar.settings[charId].GSP.doneColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].GSP.doneColor = {r, g, b}; USPF.settings.GSP.doneColor = {r, g, b} end,
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_DONE),
					width = "half",
				},
				
				--Select the GSP Row Color - Not Done
				{
					type = "colorpicker",
					name = "General - Not Done",
					getFunc = function() return USPF.sVar.settings[charId].GSP.needColor[1], USPF.sVar.settings[charId].GSP.needColor[2], USPF.sVar.settings[charId].GSP.needColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].GSP.needColor = {r, g, b}; USPF.settings.GSP.needColor = {r, g, b} end,
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_NOT_DONE),
					width = "half",
				},
				
				--Select the GSP Row Color - In Progress
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_GSP_PROG),
					getFunc = function() return USPF.sVar.settings[charId].GSP.progColor[1], USPF.sVar.settings[charId].GSP.progColor[2], USPF.sVar.settings[charId].GSP.progColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].GSP.progColor = {r, g, b}; USPF.settings.GSP.progColor = {r, g, b} end,
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_PROG),
					width = "half",
				},
				
				{
					type = "divider",
					width = "full",
					--height = 10, (optional)
					--alpha = 0.25, (optional)
				},
				
				--Select the SQS_Z Row Color - Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_ZQ_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_DONE),
					getFunc = function() return USPF.sVar.settings[charId].SQS.doneColorZQ[1], USPF.sVar.settings[charId].SQS.doneColorZQ[2], USPF.sVar.settings[charId].SQS.doneColorZQ[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].SQS.doneColorZQ = {r, g, b}; USPF.settings.SQS.doneColorZQ = {r, g, b} end,
					width = "half",
				},
				
				--Select the SQS_Z Row Color - Not Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_ZQ_NOT_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_NOT_DONE),
					getFunc = function() return USPF.sVar.settings[charId].SQS.needColorZQ[1], USPF.sVar.settings[charId].SQS.needColorZQ[2], USPF.sVar.settings[charId].SQS.needColorZQ[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].SQS.needColorZQ = {r, g, b}; USPF.settings.SQS.needColorZQ = {r, g, b} end,
					width = "half",
				},
				
				--Select the SQS_Z Row Color - In Progress
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_ZQ_PROG),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_PROG),
					getFunc = function() return USPF.sVar.settings[charId].SQS.progColorZQ[1], USPF.sVar.settings[charId].SQS.progColorZQ[2], USPF.sVar.settings[charId].SQS.progColorZQ[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].SQS.progColorZQ = {r, g, b}; USPF.settings.SQS.progColorZQ = {r, g, b} end,
					width = "half",
				},
				
				{
					type = "divider",
					width = "full",
					--height = 10, (optional)
					--alpha = 0.25, (optional)
				},
				
				--Select the SQS_S Row Color - Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_SS_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_DONE),
					getFunc = function() return USPF.sVar.settings[charId].SQS.doneColorSS[1], USPF.sVar.settings[charId].SQS.doneColorSS[2], USPF.sVar.settings[charId].SQS.doneColorSS[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].SQS.doneColorSS = {r, g, b}; USPF.settings.SQS.doneColorSS = {r, g, b} end,
					width = "half",
				},
				
				--Select the SQS_S Row Color - Not Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_SS_NOT_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_NOT_DONE),
					getFunc = function() return USPF.sVar.settings[charId].SQS.needColorSS[1], USPF.sVar.settings[charId].SQS.needColorSS[2], USPF.sVar.settings[charId].SQS.needColorSS[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].SQS.needColorSS = {r, g, b}; USPF.settings.SQS.needColorSS = {r, g, b} end,
					width = "half",
				},
				
				--Select the SQS_S Row Color - In Progress
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_SS_PROG),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_PROG),
					getFunc = function() return USPF.sVar.settings[charId].SQS.progColorSS[1], USPF.sVar.settings[charId].SQS.progColorSS[2], USPF.sVar.settings[charId].SQS.progColorSS[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].SQS.progColorSS = {r, g, b}; USPF.settings.SQS.progColorSS = {r, g, b} end,
					width = "half",
				},
				
				{
					type = "divider",
					width = "full",
					--height = 10, (optional)
					--alpha = 0.25, (optional)
				},
				
				--Select the GDQ Row Color - Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_GDQ_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_DONE),
					getFunc = function() return USPF.sVar.settings[charId].GDQ.doneColor[1], USPF.sVar.settings[charId].GDQ.doneColor[2], USPF.sVar.settings[charId].GDQ.doneColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].GDQ.doneColor = {r, g, b}; USPF.settings.GDQ.doneColor = {r, g, b} end,
					width = "half",
				},
				
				--Select the GDQ Row Color - Not Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_GDQ_NOT_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_NOT_DONE),
					getFunc = function() return USPF.sVar.settings[charId].GDQ.needColor[1], USPF.sVar.settings[charId].GDQ.needColor[2], USPF.sVar.settings[charId].GDQ.needColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].GDQ.needColor = {r, g, b}; USPF.settings.GDQ.needColor = {r, g, b} end,
					width = "half",
				},
				
				{
					type = "divider",
					width = "full",
					--height = 10, (optional)
					--alpha = 0.25, (optional)
				},
				
				--Select the PDQ Row Color - Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_PDB_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_DONE),
					getFunc = function() return USPF.sVar.settings[charId].PDB.doneColor[1], USPF.sVar.settings[charId].PDB.doneColor[2], USPF.sVar.settings[charId].PDB.doneColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].PDB.doneColor = {r, g, b}; USPF.settings.PDB.doneColor = {r, g, b} end,
					width = "half",
				},
				
				--Select the PDQ Row Color - Not Done
				{
					type = "colorpicker",
					name = GetString(USPF_SETTINGS_COLOR_PDB_NOT_DONE),
					tooltip = GetString(USPF_SETTINGS_COLOR_DESC_NOT_DONE),
					getFunc = function() return USPF.sVar.settings[charId].PDB.needColor[1], USPF.sVar.settings[charId].PDB.needColor[2], USPF.sVar.settings[charId].PDB.needColor[3] end,
					setFunc = function(r,g,b) USPF.sVar.settings[charId].PDB.needColor = {r, g, b}; USPF.settings.PDB.needColor = {r, g, b} end,
					width = "half",
				},
			},
		},
		
		--Create the Sort Options Header
		{
			type = "submenu",
			name = "|cFF0000"..GetString(USPF_SETTINGS_SORT_TITLE).."|r",
			controls = {
				
				--Select the Storyline Quest/Skyshard Table Sort
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_SORT_SQS),
					choices = USPF.Options.Sort.Names_SQS,
					getFunc = function() return USPF.Options.Sort.Names_SQS[USPF.sVar.settings[charId].SQS.sortCol] end,
					setFunc = function(value) USPF.sVar.settings[charId].SQS.sortCol = USPF.Options.Sort.SQS[value]; USPF.settings.SQS.sortCol = USPF.Options.Sort.SQS[value] end,
					tooltip = GetString(USPF_SETTINGS_SORT_SQS_DESC),
					width = "half",
				},
				
				--Select the Group Dungeon Table Sort
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_SORT_GDQ),
					choices = USPF.Options.Sort.Names_D,
					getFunc = function() return USPF.Options.Sort.Names_D[USPF.sVar.settings[charId].GDQ.sortCol] end,
					setFunc = function(value) USPF.sVar.settings[charId].GDQ.sortCol = USPF.Options.Sort.D[value]; USPF.settings.GDQ.sortCol = USPF.Options.Sort.D[value] end,
					tooltip = GetString(USPF_SETTINGS_SORT_GDQ_DESC),
					width = "half",
				},
				
				--Select the Storyline Quest/Skyshard Table Sort
				{
					type = "dropdown",
					name = GetString(USPF_SETTINGS_SORT_PDB),
					choices = USPF.Options.Sort.Names_D,
					getFunc = function() return USPF.Options.Sort.Names_D[USPF.sVar.settings[charId].PDB.sortCol] end,
					setFunc = function(value) USPF.sVar.settings[charId].PDB.sortCol = USPF.Options.Sort.D[value]; USPF.settings.PDB.sortCol = USPF.Options.Sort.D[value] end,
					tooltip = GetString(USPF_SETTINGS_SORT_PDB_DESC),
					width = "half",
				},
			},
		},
		
		--Create the Override Options Header
		{
			type = "submenu",
			name = "|cFF0000"..GetString(USPF_SETTINGS_OVERRIDE_TITLE).."|r",
			controls = {
				
				--Enable/Disable Folium Discognitum Override
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_FOLIUM),
					getFunc = function() return USPF.sVar.settings[charId].FD.override end,
					setFunc = function(value) USPF.sVar.settings[charId].FD.override = value; USPF.settings.FD.override = value end,
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_FOLIUM_DESC),
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
				
				--Character Has Folium Discognitum True/False
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_FOLIUM_SET),
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_FOLIUM_SET_DESC),
					getFunc = function() return USPF.sVar.settings[charId].FD.charHasFD end,
					setFunc = function(value) USPF.sVar.settings[charId].FD.charHasFD = value; USPF.settings.FD.charHasFD = value end,
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
				
				--Character Has Morrowind Broken Bonds Skill Point True/False
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_MWC_SET),
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_MWC_SET_DESC),
					getFunc = function() return (USPF.sVar.settings[charId].MWC ~= nil and USPF.sVar.settings[charId].MWC or false) end,
					setFunc = function(value) USPF.sVar.settings[charId].MWC = value; USPF.settings.MWC = value end,
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
				
				--Character Has Summerset The Mind Trap Skill Point True/False
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_SSC_SET),
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_SSC_SET_DESC),
					getFunc = function() return (USPF.sVar.settings[charId].SSC ~= nil and USPF.sVar.settings[charId].SSC or false) end,
					setFunc = function(value) USPF.sVar.settings[charId].SSC = value; USPF.settings.SSC = value end,
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
				
				--Character Has Elsweyr Bright Moons, Warm Sands Skill Point True/False
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_EWC_SET),
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_EWC_SET_DESC),
					getFunc = function() return (USPF.sVar.settings[charId].EWC ~= nil and USPF.sVar.settings[charId].EWC or false) end,
					setFunc = function(value) USPF.sVar.settings[charId].EWC = value; USPF.settings.EWC = value end,
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
				--Character Has Greymoor Bound in Blood Skill Point True/False
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_GMC_SET),
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_GMC_SET_DESC),
					getFunc = function() return (USPF.sVar.settings[charId].GMC ~= nil and USPF.sVar.settings[charId].GMC or false) end,
					setFunc = function(value) USPF.sVar.settings[charId].GMC = value; USPF.settings.GMC = value end,
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
				--Character Has Blackwood The Gates of Adamant Skill Point True/False
				{
					type = "checkbox",
					name = GetString(USPF_SETTINGS_OVERRIDE_BWC_SET),
					tooltip = GetString(USPF_SETTINGS_OVERRIDE_BWC_SET_DESC),
					getFunc = function() return (USPF.sVar.settings[charId].BWC ~= nil and USPF.sVar.settings[charId].BWC or false) end,
					setFunc = function(value) USPF.sVar.settings[charId].BWC = value; USPF.settings.BWC = value end,
					width = "full", -- or "half" (optional)
					warning = GetString(USPF_SETTINGS_OVERRIDE_WARN),
				},
			},
		},
	}
	
	USPF_LAM2:RegisterOptionControls(ADDON_NAME, USPF.optionsTable)
end
