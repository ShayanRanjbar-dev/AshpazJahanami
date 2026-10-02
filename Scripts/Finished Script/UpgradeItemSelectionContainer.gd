extends PanelContainer

@export var itemNameText : Label
@export var itemProsText : RichTextLabel
@export var itemConsText : RichTextLabel
@export var itemPriceText : RichTextLabel
@export var itemTexture : TextureRect
@export var itemSelectionButton : Button
@export var mainFont : Font
@export var numberFont : Font

signal ItemButtonPressed( price : int)

const NEGATIVE_PREFIX : String = " 10%-"
const POSITIVE_PREFIX : String = " 10%+"
var upgrade : UpgradeItem
var price : int = 0

func ItemButtonSelected() -> void:
	ItemButtonPressed.emit(price)
	upgrade.ApplyUpgrade()

func GetItemProperties(upgradeItem : UpgradeItem) -> void:
	itemTexture.texture = upgradeItem.texture
	itemNameText.text = upgradeItem.Name
	SetUpgradeText(upgradeItem.ProsList , itemProsText , Color.LIME_GREEN)
	SetUpgradeText(upgradeItem.ConsList , itemConsText , Color.RED)
	SetPriceText(upgradeItem.Price)
	price = upgradeItem.Price
	upgrade = upgradeItem.duplicate()

func SetItemText(itemList: Array[String]) -> String:
	var text : String = "\n".join(itemList)
	return text

func SetUpgradeText(itemList : Dictionary[String , BaseModifiers] , itemText : RichTextLabel , fontColor : Color) -> void :
	itemText.clear()
	itemText.push_color(fontColor)
	itemText.push_outline_color(Color.BLACK)
	itemText.push_outline_size(8)
	for item : String in itemList.keys() :
		var Itemtype : int = itemList[item].modifierType if itemList[item].modifierType else 0
		var preFix : String = NEGATIVE_PREFIX if Itemtype < 0 else POSITIVE_PREFIX
		itemText.push_font(mainFont)
		itemText.push_font_size(52)
		itemText.add_text(item)
		itemText.pop()
		itemText.pop()
		itemText.push_font(numberFont)
		itemText.push_font_size(48)
		itemText.add_text(preFix)
		itemText.pop()
		itemText.pop()
		itemText.add_text("\n")
	itemText.pop()
	itemText.pop()
	itemText.pop()

func SetPriceText(_price: int) -> void:
	itemPriceText.clear()
	itemPriceText.push_color(Color.YELLOW)
	itemPriceText.push_outline_color(Color.BLACK)
	itemPriceText.push_outline_size(8)
	itemPriceText.push_font(mainFont)
	itemPriceText.push_font_size(64)
	itemPriceText.add_text("قیمت: ")
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.push_font(numberFont)
	itemPriceText.push_font_size(64)
	itemPriceText.add_text("%d$" % _price)
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.pop()

func _ready() -> void:
	itemSelectionButton.pressed.connect(ItemButtonSelected)
