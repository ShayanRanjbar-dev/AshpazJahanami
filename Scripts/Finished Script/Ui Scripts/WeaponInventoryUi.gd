extends PanelContainer

@export var weaponShop : MarginContainer
@export var weaponInventoryContainer : HBoxContainer
@export var sellButtonContainer : VBoxContainer
@export var weaponCounterText : Label
@export var sellPriceText : RichTextLabel
@export var fullInventoryStylebox : StyleBox
@export var notFullInventoryStylebox : StyleBox
@export var textFont : Font
@export var numberFont : Font

const WEAPON_INVENTORY : PackedScene = preload("res://Scenes/Finished Scenes/Tools/WeaponInventoryContainer.tscn")
const MAX_WEAPONS : int = 6
const MIN_WEAPONS : int = 1
var sellData : Dictionary = {}
var shopMoney : int = 0
var weaponCount : int  = 0

func SetWeaponsInventory( weapons :  Array[WeaponData] ) -> void :
	for weapon : WeaponData in weapons :
		LoadInventory(weapon)

func SetInventoryButtonStyleBox( button : Button) -> void:
	if weaponCount == MAX_WEAPONS :
		button.remove_theme_stylebox_override("normal")
		button.add_theme_stylebox_override("normal" , fullInventoryStylebox )
	else :
		button.remove_theme_stylebox_override("normal")
		button.add_theme_stylebox_override("normal" , notFullInventoryStylebox )

func AddToWeaponInventory(weaponData : WeaponData) -> void:
	LoadInventory(weaponData)

func LoadInventory(weapon : WeaponData) -> void:
	weaponCount += 1
	SetWeaponCount()
	var newInventory = WEAPON_INVENTORY.instantiate()
	var texture : Texture2D = weapon.WeaponTexture
	var price : int = weapon.SellPrice
	newInventory.SetValues(weapon.Name , texture  , price)
	newInventory.WeaponSelected.connect(WeaponSelected)
	weaponInventoryContainer.add_child(newInventory)
	if weaponCount == MAX_WEAPONS:
		AchievementManager.unlock_achievement("full_inventory")

func WeaponSelected(weapon : Dictionary) -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiSelectSFX)
	sellButtonContainer.show()
	sellData.clear()
	sellData.set("Item" ,weapon["Item"])
	sellData.set("Price" , weapon["Price"] ) 
	sellData.set("Name" , weapon["Name"])
	SetSellTex(weapon["Price"])

func SetSellTex(price : int) -> void:
	sellPriceText.clear()
	sellPriceText.push_color(Color.YELLOW)
	sellPriceText.push_outline_color(Color.BLACK)
	sellPriceText.push_outline_size(8)
	sellPriceText.push_font_size(64)
	sellPriceText.push_font(textFont)
	sellPriceText.add_text("قیمت:\n")
	sellPriceText.pop()
	sellPriceText.push_font(numberFont)
	sellPriceText.add_text( "$%d" % [price]) 
	sellPriceText.pop()
	sellPriceText.pop()
	sellPriceText.pop()
	sellPriceText.pop()
	sellPriceText.pop()

func EnterWeaponInventory() -> void:
	HelperScript.PlayUiSlideAnimation(self , HelperScript.TweenUp)

func ExitWeaponInventory() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	HelperScript.PlayUiSlideAnimation(self , HelperScript.TweenUp , true)
	SetInventoryButtonStyleBox(weaponShop.weaponInventoryButton)
	sellButtonContainer.hide()
	weaponShop.shopMoney += shopMoney
	weaponShop.changeWeaponButton.disabled = weaponShop.shopMoney < weaponShop.MIN_CHANGE_MONEY
	weaponShop.moneyText.text = ": $%03d"%[weaponShop.shopMoney]
	shopMoney = 0

func SetWeaponCount() -> void:
	weaponCounterText.text = "لیست سلاح ها (%d / %d)" % [MAX_WEAPONS , weaponCount]

func ClearInventory() -> void:
	weaponCount = 0
	for inventory : PanelContainer in weaponInventoryContainer.get_children().duplicate() :
		inventory.queue_free()

func ExitWeaponInventoryButtonPressed() -> void:
	ExitWeaponInventory()

func SellWeaponButtonPressed() -> void:
	if weaponCount > MIN_WEAPONS :
		UiSoundManager.PlayUiSound(UiSoundManager.uiProgressSFX)
		weaponCount -= 1
		SetInventoryButtonStyleBox(weaponShop.weaponInventoryButton)
		SetWeaponCount()
		sellButtonContainer.hide()
		var price : int = sellData["Price"]
		var item : PanelContainer = sellData["Item"]
		var weaponName : String = sellData["Name"]
		sellData.clear()
		shopMoney += price
		item.queue_free()
		owner.SellWeapon.emit(weaponName)
	else :
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		HelperScript.PlayUiErrorAnimation(weaponCounterText)
