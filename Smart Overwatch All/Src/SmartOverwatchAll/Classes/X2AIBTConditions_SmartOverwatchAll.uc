class X2AIBTConditions_SmartOverwatchAll extends X2AIBTDefaultConditions;

function bt_status ShouldReload()
{
	local XComGameState_Item WeaponState;
	local array<X2WeaponUpgradeTemplate> WeaponUpgrades;
	local int TotalFreeReloads;
	local UnitValue FreeReloadValue;
	local int i;

	WeaponState = m_kUnitState.GetItemInSlot(EInvSlot_PrimaryWeapon);
	if (WeaponState == none)
		return BTS_FAILURE;

	// Reload if out of ammo
	if (WeaponState.Ammo == 0)
		return BTS_SUCCESS;

	// Don't reload if we have free reloads remaining
	WeaponUpgrades = WeaponState.GetMyWeaponUpgradeTemplates();
	for (i = 0; i < WeaponUpgrades.Length; ++i)
	{
		TotalFreeReloads += WeaponUpgrades[i].NumFreeReloads;
	}
	m_kUnitState.GetUnitValue('FreeReload', FreeReloadValue);
	if (FreeReloadValue.fValue < TotalFreeReloads)
		return BTS_FAILURE;

	// Try to reload, just in case
	return BTS_SUCCESS;
}