extends PanelContainer

@export var nameText : Label
@export var texture : TextureRect

signal WeaponSelected(weaponData : Dictionary)

var sellValue : int = 0

func SetValues(weaponName : String , weaponTexture : Texture2D , value : int) -> void:
	nameText.text = weaponName
	texture.texture = weaponTexture
	sellValue = value

func WeaponSelectButtonPressed() -> void:
	WeaponSelected.emit({"Item" : self , "Price" : sellValue , "Name" : nameText.text})
