extends PanelContainer

@export var itemNameText : Label
@export var itemPriceText : RichTextLabel
@export var itemTypeText : Label
@export var itemDamageText : RichTextLabel
@export var itemTexture : TextureRect
@export var itemSelectionButton : Button
@export var textFont : Font
@export var numberFont : Font

signal ItemButtonPressed( price : int , weapon : WeaponData , item : PanelContainer)

var weaponData : WeaponData
var price : int = 0

func ItemButtonSelected() -> void:
	ItemButtonPressed.emit(price , weaponData , self)

func GetItemProperties(Data : WeaponData) -> void:
	itemNameText.text = Data.Name
	itemTypeText.text = "سلاح سرد" if Data.Type == "CloseRange" else "سلاح گرم"
	itemTexture.texture = Data.WeaponTexture
	price = Data.BuyPrice
	SetPriceItemText()
	SetDamageText(Data.Damage)
	weaponData = Data

func SetPriceItemText() -> void:
	itemPriceText.clear()
	itemPriceText.push_color(Color.YELLOW)
	itemPriceText.push_outline_color(Color.BLACK)
	itemPriceText.push_outline_size(8)
	itemPriceText.push_font_size(64)
	itemPriceText.push_font(textFont)
	itemPriceText.add_text("قیمت : ")
	itemPriceText.pop()
	itemPriceText.push_font(numberFont)
	itemPriceText.add_text( "%d$" % [price]) 
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.pop()
	itemPriceText.pop()

func SetDamageText(damage : int) -> void:
	itemDamageText.clear()
	itemDamageText.push_color(Color.RED)
	itemDamageText.push_outline_color(Color.BLACK)
	itemDamageText.push_outline_size(8)
	itemDamageText.push_font_size(64)
	itemDamageText.push_font(textFont)
	itemDamageText.add_text("آسیب ")
	itemDamageText.pop()
	itemDamageText.push_font(numberFont)
	itemDamageText.add_text("%d" % damage) 
	itemDamageText.pop()
	itemDamageText.pop()
	itemDamageText.pop()
	itemDamageText.pop()
	itemDamageText.pop()

func _ready() -> void:
	itemSelectionButton.pressed.connect(ItemButtonSelected)
