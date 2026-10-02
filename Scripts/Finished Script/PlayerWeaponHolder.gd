extends Node

@export var playerBody : PlayerCharacter
@export var playerWeaponHolder : Node2D

@export_group("CloseRange Weapons")
@export var closeWeaponHolder : Node2D
@export var closeWeaponRadius : float = 128
@export var closeWeaponRotation : float = 2.5
@export var knockBackStrength : float = 600

@export_group("LongRange Weapons")
@export var rangedWeaponHolder : RangedWeaponSpawner
@export var rangedSpeed : float = 0
@export var rangedDamage : float = 0

var weaponsList : Dictionary[ String , Array] = {
	"CloseRanges" : [] ,
	"LongRanges" : []
}

func GetWeapons() -> Array[WeaponData] :
	var weaponDataArray : Array[WeaponData] = []
	for closeWeapons : Dictionary in weaponsList["CloseRanges"] :
		weaponDataArray.append(closeWeapons["WeaponData"])
	for longWeapons : Dictionary in weaponsList["LongRanges"] :
		weaponDataArray.append(longWeapons["WeaponData"])
	return weaponDataArray

func UpdateWeaponStats(modifier : PlayerData) -> void:
	closeWeaponRotation += modifier.CloseRotation
	rangedSpeed += modifier.LongSpeed
	rangedDamage += modifier.LongDamage
	knockBackStrength += modifier.Knockback
	for weaponData in weaponsList["CloseRanges"]:
		var weaponNode : CloseRangeWeapon = weaponData["WeaponNode"]
		weaponNode.weaponDamage += modifier.CloseDamage
		weaponNode.knockbackStrength = knockBackStrength

func SpawnWeapon(weapon : WeaponData) -> void:
	if weapon.Type == "CloseRange":
		SpawnCloseRangeWeapon(weapon)
	else:
		SpawnLongRangeWeapon(weapon)

func SpawnCloseRangeWeapon(weaponData : WeaponData) -> void:
	var weaponScene : PackedScene = weaponData.Scene
	var weaponNode : CloseRangeWeapon = weaponScene.instantiate()
	weaponNode.SetPlayer(playerBody)
	closeWeaponHolder.add_child(weaponNode)
	var newWeaponData : Dictionary = {
		"Name": weaponData.Name ,
		"WeaponNode": weaponNode ,
		"WeaponData" : weaponData ,
		"Angle": 0.0
	}
	weaponsList["CloseRanges"].append(newWeaponData)
	var weaponCount = weaponsList["CloseRanges"].size()
	for index in weaponCount:
		weaponsList["CloseRanges"][index]["Angle"] = (TAU / weaponCount) * index

func SpawnLongRangeWeapon(weaponData : WeaponData) -> void:
	rangedWeaponHolder.SetBulletScene(weaponData.Scene)
	rangedWeaponHolder.isTimerStarted = true
	var newWeaponData : Dictionary = {
		"Name": weaponData.Name ,
		"WeaponScene": weaponData.Scene ,
		"WeaponData" : weaponData
	}
	weaponsList["LongRanges"].append(newWeaponData)

func RemoveWeapon(weaponName : String) -> void:
	for index in weaponsList["CloseRanges"].size():
		var weaponData = weaponsList["CloseRanges"][index]
		if weaponData["Name"] == weaponName:
			weaponData["WeaponNode"].queue_free()
			weaponsList["CloseRanges"].remove_at(index)
			return
	for index in weaponsList["LongRanges"].size():
		var weaponData = weaponsList["LongRanges"][index]
		if weaponData["Name"] == weaponName:
			rangedWeaponHolder.RemoveBulletScene(weaponData["WeaponScene"])
			weaponsList["LongRanges"].remove_at(index)
			return

func RemoveAll() -> void:
	for weaponData in weaponsList["CloseRanges"]:
		weaponData["WeaponNode"].queue_free()
	weaponsList["CloseRanges"].clear()
	for weaponData in weaponsList["LongRanges"]:
		rangedWeaponHolder.RemoveBulletScene(weaponData["WeaponScene"])
	weaponsList["LongRanges"].clear()

func _physics_process(delta: float) -> void:
	for weaponData in weaponsList["CloseRanges"]:
		weaponData["Angle"] += closeWeaponRotation * delta
		weaponData["Angle"] = fmod(weaponData["Angle"], TAU)
		weaponData["WeaponNode"].position = closeWeaponHolder.position + Vector2(
			cos(weaponData["Angle"]), sin(weaponData["Angle"])
		) * closeWeaponRadius
