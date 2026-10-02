class_name PlayerCharacter extends CharacterBody2D

@export var inputHanlder : Node
@export var weaponComposition : Node
@export var spriteComposition : PlayerSpriteHandler

@export_group("Player Collisions")
@export var hurtbox : Area2D

@export_group("Player Stats")
@export var playerDataCable : Cable
@export var speed : float = 350 
@export var fullHealth : float  = 250 

@export var hurtSFX : AudioStreamPlayer2D

@onready var health : float = fullHealth

signal PlayerHealthChanged(health : float, maxhealth : float)
signal PlayerHitCameraShake
signal PlayerDied

var moveVector : Vector2 = Vector2.ZERO

func PlayerHealthValueChanged(value : float) -> void:
	health += value
	health = clamp(health,0,fullHealth)
	PlayerHealthChanged.emit(health,fullHealth)

func PlayerHealed(heal : float) -> void:
	PlayerHealthValueChanged(heal)

func PlayerGetHit(rawdamage : float) -> void:
	spriteComposition.HitFlash()
	var damage : float = -1 * rawdamage
	PlayerHealthValueChanged(damage)
	if health <= 0:
		PlayerDeath()
		return
	PlayerHitCameraShake.emit()
	HelperScript.PlayRandomPitchAudio(hurtSFX.stream , hurtSFX , 0.85 , 1.25)
	await spriteComposition.InvulnerabilityAnimation()
	hurtbox.set_deferred("monitoring" , true)

func EnemyHitPlayer( area : Area2D) -> void:
	hurtbox.set_deferred("monitoring" , false)
	PlayerGetHit(area.damage)
	if area is EnemyBullet:
		area.queue_free()

func PlayerDeath()  -> void:
	hide()
	PlayerDied.emit()

func PlayerRevive() -> void:
	health = fullHealth
	PlayerHealthChanged.emit(health,fullHealth)
	show()

func SetFullHealth(value : float) -> void:
	var rawhealth : float = fullHealth
	fullHealth = rawhealth * ( 1 + value) 
	PlayerHealed(fullHealth)

func SetPlayerSpeed(value : float) -> void:
	var rawSpeed : float = speed
	speed = rawSpeed *  (1 + value)

func PlayerDataUpdated( playerData : PlayerData ) -> void :
	SetPlayerSpeed(playerData.Speed)
	SetFullHealth( playerData.Health)
	weaponComposition.UpdateWeaponStats(playerData)

func _ready() -> void:
	var playerData : PlayerData = playerDataCable.current_value
	PlayerDataUpdated(playerData)
	spriteComposition.SetPlayerSprite(playerData.PlayerTexture)
	weaponComposition.SpawnWeapon(playerData.StartingWeapon)
	playerDataCable.link(PlayerDataUpdated)
	PlayerHealthChanged.emit(health,fullHealth)
	hurtbox.area_entered.connect(EnemyHitPlayer)

func _process(_delta: float) -> void:
	moveVector = inputHanlder.GetInputVector()
	spriteComposition.MoveAnimation(moveVector)
	spriteComposition.TurnAnimation(moveVector)

func _physics_process(_delta: float) -> void :
	if inputHanlder != null:
		velocity = speed * moveVector 
	move_and_slide()

func PlayerPickUpChefHat(value: float) -> void:
	spriteComposition.ChefHatFlash()
	var healValue : float = (fullHealth * 0.1 ) + value
	PlayerHealed(healValue)

func GetPlayerWeapons(weaponShop: MarginContainer) -> void:
	var weaponlist : Array[WeaponData] = weaponComposition.GetWeapons()
	weaponShop.GetPlayerWeapons(weaponlist)

func SellWeapon(weaponName: String) -> void:
	weaponComposition.RemoveWeapon(weaponName)

func BuyWeapon(weaponData: WeaponData) -> void:
	if weaponData:
		weaponComposition.SpawnWeapon(weaponData)
