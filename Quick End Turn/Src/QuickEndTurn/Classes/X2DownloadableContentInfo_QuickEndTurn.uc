//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_QuickEndTurn.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_QuickEndTurn extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager CharMgr;
	local X2ItemTemplateManager ItemMgr;
	local array<name> AllTemplateNames;
	local name TemplateName;
	local array<X2DataTemplate> AllTemplates;
	local X2DataTemplate DataTemplate;
	local X2CharacterTemplate CharTemplate;
	local X2WeaponTemplate WeaponTemplate;

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharMgr.GetTemplateNames(AllTemplateNames);
	foreach AllTemplateNames(TemplateName)
	{
		CharMgr.FindDataTemplateAllDifficulties(TemplateName, AllTemplates);
		foreach AllTemplates(DataTemplate)
		{
			CharTemplate = X2CharacterTemplate(DataTemplate);
			if (CharTemplate.bIsSoldier)
				CharTemplate.Abilities.AddItem('QuickEndTurn');
		}
	}

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemMgr.GetTemplateNames(AllTemplateNames);
	foreach AllTemplateNames(TemplateName)
	{
		ItemMgr.FindDataTemplateAllDifficulties(TemplateName, AllTemplates);
		foreach AllTemplates(DataTemplate)
		{
			WeaponTemplate = X2WeaponTemplate(DataTemplate);
			if (WeaponTemplate == none)
				continue;
			if (WeaponTemplate.Abilities.Find('Reload') != INDEX_NONE)
				WeaponTemplate.Abilities.AddItem('FastReload');
		}
	}
}