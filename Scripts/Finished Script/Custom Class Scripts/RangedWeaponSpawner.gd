class_name RangedWeaponSpawner extends Node2D

@export var longRangeWeaponSFXPlayer : AudioStreamPlayer2D
@export var bulletPackedScenes :  Array[PackedScene] = []
@export var playerWeaponComposition : Node

@onready var sceneRoot : Node2D  = get_tree().current_scene

var bulletsFired : int = 0
var fireRate : float
var cooldownTime : float 
var gunTimer: float = 1.0
var isTimerStarted : bool = false

func FireBullet()->void:
	if bulletsFired >= ceil(fireRate): 
		bulletsFired = 0
		await get_tree().create_timer(cooldownTime).timeout
	var target : EnemyCharacterAi = GetEnemyToFire()
	if target:
		var weaponBulletScene : PackedScene = bulletPackedScenes.pop_front()
		bulletPackedScenes.push_back(weaponBulletScene)
		var rangeBulletNode : LongRangeWeapon = weaponBulletScene.instantiate()
		rangeBulletNode.global_position = global_position
		rangeBulletNode.GetTarget(target)
		rangeBulletNode.rangeSpeed += playerWeaponComposition.rangedSpeed
		rangeBulletNode.weaponDamage +=  playerWeaponComposition.rangedDamage
		sceneRoot.add_child(rangeBulletNode)
		HelperScript.PlayRandomPitchAudio(longRangeWeaponSFXPlayer.stream, longRangeWeaponSFXPlayer , 0.75 , 1.35)
		bulletsFired += 1
	SetTimerReset()

func GetEnemyToFire() -> EnemyCharacterAi :
	var selectedEnemy : EnemyCharacterAi = null
	var minDistance = INF
	for enemy : EnemyCharacterAi in get_tree().get_nodes_in_group("Enemy"):
		var distance = global_position.distance_to(enemy.global_position)
		if distance < minDistance:
			minDistance = distance
			selectedEnemy = enemy
	return selectedEnemy

func GetFireRateCoolDown(
	fireRateValue : float = 3 ,
	cooldDownTimeValue : float = 0.5 )->void:
		self.fireRate = fireRateValue
		self.cooldownTime = cooldDownTimeValue
		SetTimerReset()

func SetTimerReset()->void:
	gunTimer = 1 / fireRate
	isTimerStarted = true

func SetBulletScene(bulletScene : PackedScene) -> void:
	bulletPackedScenes.append(bulletScene)

func RemoveBulletScene(bulletScene : PackedScene) -> void:
	if bulletScene in bulletPackedScenes:
		bulletPackedScenes.erase(bulletScene)

func _ready() -> void:
	isTimerStarted = true
	GetFireRateCoolDown()

func _process(delta: float) -> void:
	if isTimerStarted:
		gunTimer -= delta
		if gunTimer <= 0.0 :
			isTimerStarted = false
			gunTimer = 1.0
			RangedWeaponFireRateReady()

func RangedWeaponFireRateReady() -> void:
	if !bulletPackedScenes.is_empty():
		FireBullet()
