class_name EnemyCharacterBossAi extends EnemyCharacterAi

@export var chargeSFX : AudioStream
@export var chargingSFX : AudioStream
@export var attackTimer : Timer
@export var healthBar : EnemyHealthbar
@export var enemySoundPlayer : AudioStreamPlayer2D
@export var bulletScenes : Array[PackedScene] = []
@export var fireRate : float =  0.0
@export var attackcooldownTimeMax : float = 0.0
@export var bulletPerSecondMax : int = 0

signal Bossbeated

const WanderLimit : Vector4i = Vector4i(-800,800,-350,400)
const DistanceLimit : int = 128
const ChargeTimeMax : float = 1
const AttackTypes : Array[String] = ["RangeAttack" , "SetChargeAttack"]
var bulletFiredCount : int = 0
var chargeTime : float = 0
var isCharging : bool = false
var isAttaking : bool = false
var chargePosition : Vector2 = Vector2.ZERO
var chargeDirection: Vector2 
var wanderPosition : Vector2 = Vector2.ZERO
var bulletHolder : Node2D

func EnemyGetHit( _damage : float) -> void:
	const MinHealth : float = 0.0
	health -= _damage
	healthBar.ChangeHealthbarValue(health , fullHealth)
	if health <= MinHealth :
		isAlive = false
		Bossbeated.emit()
		call_deferred("EnemyDeath")

func _ready() -> void:
	attackTimer.timeout.connect(EnemyStartAttaking)
	attackTimer.wait_time = attackcooldownTimeMax
	healthBar.SetEnemyHealthbar(self)
	PlayEnemyAnimation()

func _physics_process(delta: float) -> void:
	if !isAttaking:
		Wander()
	if isCharging:
		ChargeAttack(delta)
	move_and_slide()

func SetChargeAttack() -> void:
	enemySoundPlayer.stream = chargingSFX
	enemySoundPlayer.play()
	isCharging = true
	chargeTime = ChargeTimeMax

func ChargeAttack(delta : float) -> void:
	spriteComposition.BossChargeFlash()
	velocity = Vector2.ZERO
	chargeTime -= delta
	if chargeTime < 0.0 :
		if chargePosition == Vector2.ZERO:
			enemySoundPlayer.stream = chargeSFX
			enemySoundPlayer.play()
			chargePosition =  target.global_position
			chargeDirection = (chargePosition - global_position).normalized()
		velocity = velocity.move_toward(chargeDirection * speed * 6, 2000)
		if global_position.distance_to(chargePosition) < DistanceLimit:
			isCharging = false
			velocity = Vector2.ZERO
			chargePosition = Vector2.ZERO
			spriteComposition.ResetFlash()
			await get_tree().create_timer(ChargeTimeMax).timeout
			isAttaking = false
			attackTimer.start()

func Wander() -> void:
	if global_position.distance_to(wanderPosition) < DistanceLimit:
		var wanderPositionX : float = randf_range(WanderLimit.x,WanderLimit.y)
		var wanderPositionY : float = randf_range(WanderLimit.z,WanderLimit.w)
		wanderPosition = Vector2(wanderPositionX,wanderPositionY)
	var wanderPositionNormalized : Vector2 = (wanderPosition - global_position).normalized()
	velocity = speed * wanderPositionNormalized

func RangeAttack() -> void:
	var rangeAttackTime : float = 1 / fireRate
	velocity = Vector2.ZERO
	for bullets in bulletPerSecondMax:
		await get_tree().create_timer(rangeAttackTime).timeout
		var bulletScene = bulletScenes.pop_front()
		bulletScenes.push_back(bulletScene)
		var bulletSceneNode : EnemyBullet = bulletScene.instantiate()
		bulletSceneNode.global_position = global_position
		var leadPosition : Vector2 = PredictTargetPosition(target , bulletSceneNode)
		bulletSceneNode.SetTarget(leadPosition)
		bulletHolder.add_child(bulletSceneNode)
		spriteComposition.BossBulletFlash()
	isAttaking = false
	attackTimer.start()

func PredictTargetPosition( _target : CharacterBody2D , bullet : EnemyBullet = null) -> Vector2:
	var attackSpeed : float = bullet.speed if bullet else speed
	var toTarget : Vector2 = _target.global_position - global_position
	var targetVelocity = Vector2.ZERO
	targetVelocity = _target.velocity
	var distance : float = toTarget.length()
	var timeToTarget = distance / attackSpeed
	var predictedPosition = _target.global_position + (targetVelocity * timeToTarget)
	return predictedPosition

func EnemyStartAttaking() -> void:
	if isAlive:
		isAttaking = true
		var attackType : String = AttackTypes.pick_random()
		call(attackType)
		attackTimer.stop()

func GetBulletHolderNode(node : Node2D) -> void:
	bulletHolder = node
