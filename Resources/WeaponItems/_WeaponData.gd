class_name WeaponData extends Resource

@export var Name : String
@export var WeaponTexture : Texture2D
@export var Scene : PackedScene
@export_enum("CloseRange" , "LongRange") var Type : String :
	set(value) :
		Type = value
@export var Damage : int
@export var BuyPrice : int
@export var SellPrice : int
@export var WeaponAchievement  : Achievement
