extends MarginContainer

@export var upgradeList : Dictionary [String , String]
@export var upgradeUi : Control
@export var moneyText : Label
@export var moneyContainer : PanelContainer
@export var leftUpgradeItem : PanelContainer
@export var centerUpgradeItem : PanelContainer
@export var rightUpgradeItem : PanelContainer
@export var changeUpgradeButton :  Button

const MIN_CHANGE_MONEY : int = 5
var shopMoney : int = 0

func PickRandomItem() -> UpgradeItem:
	var UpgradeListArray : Array = upgradeList.keys()
	var randomNumber = UpgradeListArray[randi() % UpgradeListArray.size()]
	var randomItem = upgradeList[randomNumber]
	return ResourceLoader.load(randomItem)

func SetUpgradeIems() -> void:
	changeUpgradeButton.disabled = shopMoney < MIN_CHANGE_MONEY
	moneyText.text = ": $%03d" %[shopMoney]
	var leftItem : UpgradeItem = PickRandomItem()
	var centerItem : UpgradeItem = PickRandomItem()
	while  centerItem == leftItem :
		centerItem = PickRandomItem()
	var rightItem : UpgradeItem = PickRandomItem()
	while  rightItem == centerItem or rightItem == leftItem :
		rightItem = PickRandomItem()
	leftUpgradeItem.GetItemProperties(leftItem)
	centerUpgradeItem.GetItemProperties(centerItem)
	rightUpgradeItem.GetItemProperties(rightItem)

func BuySelectedItem(price : int) -> void:
	if price > shopMoney:
		HelperScript.PlayUiErrorAnimation(moneyContainer)
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		return
	UiSoundManager.PlayUiSound(UiSoundManager.uiAcceptSFX)
	shopMoney -= price
	ExitUpgradeShop()

func EnterUpgradeShop(money : int) -> void:
	HelperScript.PlayUiSlideAnimation(upgradeUi , HelperScript.TweenUp)
	shopMoney = money
	SetUpgradeIems()
	upgradeUi.show()

func ExitUpgradeShop() -> void :
	HelperScript.PlayUiSlideAnimation(upgradeUi , HelperScript.TweenRight , true)
	owner.UpgradeShopEnded(shopMoney)

func UpgradeItemPressed( price : int) -> void:
	BuySelectedItem(price)

func ChangeButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiSelectSFX)
	shopMoney -= MIN_CHANGE_MONEY
	SetUpgradeIems()

func ExitButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	ExitUpgradeShop()
