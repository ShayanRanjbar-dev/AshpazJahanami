extends MarginContainer

@export var menuContainer : MarginContainer
@export var characterSelectionContainer : PanelContainer
@export var weaponSelectoinContainer : PanelContainer
@export var playerDataCable : Cable
@export var enemyDataCable : Cable
@export var collectibleDataCable : Cable

func _ready() -> void:
	playerDataCable.notify(PlayerData.new())
	enemyDataCable.notify(EnemyData.new())
	collectibleDataCable.notify(CollectibleData.new())

func ChangeMenu() -> void:
	menuContainer.show()
	hide()

func ChangeSelection(isBackward : bool = false) -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	if isBackward:
		characterSelectionContainer.show()
		weaponSelectoinContainer.hide()
	else:
		characterSelectionContainer.hide()
		weaponSelectoinContainer.show()

func UpdatePlayerData(playerData : PlayerData) -> void:
	playerDataCable.notify(playerData)

func UpdatePlayerWeapon(weaponData : WeaponData) -> void:
	var currentData :  PlayerData = playerDataCable.get_value_or_default(PlayerData.new())
	currentData.StartingWeapon = weaponData
	playerDataCable.notify(currentData)
