extends MarginContainer

@export var weaponList : Dictionary [ String , String ]
@export var weaponShopUi : Control
@export var moneyText : Label
@export var moneyContainer : PanelContainer
@export var leftWeaponItem : PanelContainer
@export var centerWeaponItem : PanelContainer
@export var rightWeaponItem : PanelContainer
@export var changeWeaponButton :  Button
@export var weaponInventoryButton : Button
@export var weaponInventoryContainer : PanelContainer

const MIN_CHANGE_MONEY : int = 5
var shopMoney : int = 0

func EnterWeaponShop(money : int) -> void:
	owner.GetPlayerWeapons.emit(self)
	HelperScript.PlayUiSlideAnimation(weaponShopUi , HelperScript.TweenLeft)
	shopMoney = money
	SetWeaponItems()
	weaponShopUi.show()

func ExitWeaponShop() -> void :
	weaponInventoryContainer.ClearInventory()
	owner.PlayerMoneyChanged(shopMoney)
	owner.WeaponShopEnd.emit(shopMoney)
	HelperScript.PlayUiSlideAnimation(weaponShopUi , HelperScript.TweenDown , true)

func PickRandomWeapon() -> WeaponData :
	var weaponListArray : Array = weaponList.keys()
	var randomNumber = weaponListArray[randi() % weaponListArray.size()]
	var randomWeapon = weaponList[randomNumber]
	return ResourceLoader.load(randomWeapon)

func SetWeaponItems() -> void:
	changeWeaponButton.disabled = shopMoney < MIN_CHANGE_MONEY
	moneyText.text = ": $%03d"%[shopMoney]
	var leftItem : WeaponData = PickRandomWeapon()
	var centerItem : WeaponData = PickRandomWeapon()
	while  centerItem == leftItem :
		centerItem = PickRandomWeapon()
	var rightItem : WeaponData = PickRandomWeapon()
	while  rightItem == centerItem or rightItem == leftItem :
		rightItem = PickRandomWeapon()
	leftWeaponItem.show()
	leftWeaponItem.GetItemProperties(leftItem)
	centerWeaponItem.show()
	centerWeaponItem.GetItemProperties(centerItem)
	rightWeaponItem.show()
	rightWeaponItem.GetItemProperties(rightItem)

func BuySelectedWeapon(price : int , weaponData : WeaponData , weaponItem : PanelContainer) -> void:
	if price > shopMoney :
		HelperScript.PlayUiErrorAnimation(moneyContainer)
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		return
	if weaponInventoryContainer.weaponCount >= weaponInventoryContainer.MAX_WEAPONS :
		HelperScript.PlayUiErrorAnimation(weaponInventoryButton)
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		return
	else:
		UiSoundManager.PlayUiSound(UiSoundManager.uiAcceptSFX)
		shopMoney -= price
		moneyText.text = ": $%03d"%[shopMoney]
		weaponItem.hide()
		if weaponData.WeaponAchievement :
			AchievementManager.unlock_achievement(weaponData.WeaponAchievement.id)
		weaponInventoryContainer.AddToWeaponInventory(weaponData)
		weaponInventoryContainer.SetInventoryButtonStyleBox(weaponInventoryButton)
		owner.BuyWeapon.emit(weaponData)
		return

func GetPlayerWeapons(weapons : Array[WeaponData]) -> void:
	weaponInventoryContainer.SetWeaponsInventory(weapons)

func WeaponItemPressed( price : int ,  weaponData : WeaponData  , weaponItem : PanelContainer) -> void:
	BuySelectedWeapon(price , weaponData , weaponItem)

func ChangeButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	shopMoney -= MIN_CHANGE_MONEY
	SetWeaponItems()

func ExitButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	ExitWeaponShop()

func ShowWeaponInventoryButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	weaponInventoryContainer.EnterWeaponInventory()
