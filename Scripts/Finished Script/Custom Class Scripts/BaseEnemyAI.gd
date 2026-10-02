class_name EnemyCharacterAi extends CharacterBody2D

@export_group("Enemy Stats")
@export var fullHealth :float
@export var damage : float 
@export var speed : float

@export_group("Enemy Nodes")
@export var Hitbox : EnemyHitbox
@export var Hurtbox : Area2D
@export var spriteComposition : EnemySpriteHandler

@onready var health : float = fullHealth

const KnockbackTimeMax : float = 0.2
const KnockbackTimeMin : float = 0.0
const KnockbackFreezeTime : float = 0.1
var knockbackTime : float = 0.2
var isKnockback : bool = false
var isAlive: bool = true
var enemyHandler : Node
var target : CharacterBody2D

func SetFullHealth(value : float) -> void:
	var rawHealth : float = fullHealth
	fullHealth = rawHealth * (1 + value)

func SetDamage(value : float) -> void:
	var rawDamage : float = damage
	damage = rawDamage * (1 + value)

func SetSpeed(value : float) -> void:
	var rawSpeed : float = speed
	speed = rawSpeed * (1 + value)

func UpdateEnemyStats(statModifier : EnemyData) -> void:
	SetDamage(statModifier.Damage)
	SetSpeed(statModifier.Speed)
	SetFullHealth(statModifier.Health)

func SetEnemiesCollisions() ->void:
	Hitbox.monitorable = true
	Hurtbox.monitorable = true
	Hurtbox.monitoring = true
	Hurtbox.area_entered.connect(PlayerHitEnemy)
	Hitbox.damage = damage

func PlayEnemyAnimation() -> void:
	await  spriteComposition.SpawnAnimation()
	add_to_group("Enemy")
	SetEnemiesCollisions()

func SetTarget(_target : CharacterBody2D) ->void:
	target = _target

func SetEnemyHandler(node : Node) -> void:
	enemyHandler = node

func EnemyGetHeal() -> void:
	spriteComposition.HealFlash()
	health = fullHealth

func CalculateKnockBack(weaponPosition : Vector2 , knockbackStrength : float) -> void:
	if !isKnockback:
		var knockbackPosition : Vector2 = ( global_position - weaponPosition).normalized()
		velocity = knockbackPosition *  knockbackStrength
		isKnockback = true

func ApplyKnockBack(delta : float) -> void :
	if isKnockback:
		knockbackTime -= delta
		if knockbackTime <= KnockbackTimeMin:
			velocity = Vector2.ZERO
			await get_tree().create_timer(KnockbackFreezeTime).timeout
			knockbackTime = KnockbackTimeMax
			isKnockback = false

func SpawnHitParticle(particle : GPUParticles2D , hitposition : Vector2) -> void:
	particle.reparent(self)
	particle.global_position = hitposition
	particle.emitting = not particle.emitting
	await particle.finished
	particle.queue_free()

func EnemyGetHit( damageValue : float) -> void:
	spriteComposition.HitFlash()
	const MinHealth : float = 0.0
	health -= damageValue
	if health <= MinHealth :
		AchievementManager.progress_achievement("kill_100_enemy")
		CheckSpawnMoney()
		EnemyDeath()
		return
	if self is not EnemyCharacterHealerAi:
		enemyHandler.SetDamagedEnemy(self)

func EnemyDeath() -> void:
	Hitbox.set_deferred("monitorable" , false)
	isAlive = false
	remove_from_group("Enemy")
	speed = 0
	Hurtbox.set_deferred("monitoring" , false)
	enemyHandler.RemoveFromDamaged(self)
	await spriteComposition.DeathTween()
	queue_free()

func CheckSpawnMoney() -> void:
	var  canSpawn : bool = randi_range(0,100) <= 20
	if canSpawn :
		enemyHandler.SpawnKillMoney.emit(global_position)

func PlayerHitEnemy(area : Area2D) -> void:
	if area is not BaseWeapon:
		return
	EnemyGetHit(area.weaponDamage)
	if area is LongRangeWeapon:
		SpawnHitParticle(area.GetParticle() , area.global_position)
		area.call_deferred("queue_free")
		return
	HelperScript.PlayRandomPitchAudio(area.closeRangeHitSFX.stream , area.closeRangeHitSFX , 3 , 4)
	CalculateKnockBack(area.GetKnockbackPosition() , area.GetKnockBackStrength())
