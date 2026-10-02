extends PanelContainer

@export var weaponSelectionInfoContainer : PanelContainer
@export var weaponSelectionInfo : Label
@export var nextWeaponSelectionButton : Button

var weaponData : WeaponData
var lastSelectedWeapon : PanelContainer

func OnWeaponSelected(weapon : Dictionary)->void:
	var selectedContainer : PanelContainer = weapon["Container"]
	var hasWeapon : bool = weapon["Unlocked"]
	nextWeaponSelectionButton.disabled = not hasWeapon
	if lastSelectedWeapon and lastSelectedWeapon != selectedContainer :
		lastSelectedWeapon.UnSelect()
	lastSelectedWeapon = selectedContainer
	weaponSelectionInfoContainer.show()
	if hasWeapon :
		UiSoundManager.PlayUiSound(UiSoundManager.uiSelectSFX)
		weaponData = weapon["Data"]
		weaponSelectionInfo.text = "%s\nانتخاب شده" % [weaponData.Name]
	else :
		var achievement : Achievement = weapon["Data"].WeaponAchievement
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		weaponSelectionInfo.text = "برای بازشدن\n%s" % achievement.description
		HelperScript.PlayUiErrorAnimation(weaponSelectionInfoContainer)

func NextWeaponSelectionButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	var gameMode : MarginContainer = get_parent()
	gameMode.UpdatePlayerWeapon(weaponData)
	Loading.load_scene( HelperScript.SceneList.GameScene  , true)

func CancelWeaponSelectionButtonPressed() -> void:
	if lastSelectedWeapon:
		lastSelectedWeapon.UnSelect()
		weaponSelectionInfoContainer.hide()
		nextWeaponSelectionButton.disabled =true
	var gameMode : MarginContainer = get_parent()
	gameMode.ChangeSelection(true)
