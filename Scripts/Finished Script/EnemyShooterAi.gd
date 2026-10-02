class_name EnemyCharacterShooterAi extends EnemyCharacterWanderAi

@export var bulletScene : PackedScene
@export var fireRate : float =  0.0
@export var bulletPerSecondMax : int = 0
@export var cooldownTimeMax : float = 0.0
@export var bulletTimer : Timer

var bulletHolder : Node2D 
var bulletFiredCount : int = 0
var isFiring : bool = false

func _ready() -> void:
	bulletTimer.timeout.connect(EnemyStartFiring)
	bulletTimer.wait_time = 1.0 / fireRate
	PlayEnemyAnimation()

func _physics_process(delta: float) -> void:
	if !isKnockback:
		Wander()
	ApplyKnockBack(delta)
	move_and_slide()
 
func Wander() -> void:
	if isFiring:
			velocity = Vector2.ZERO
			return
	if global_position.distance_to(wanderPosition) < DistanceLimit:
		var wanderPositionX : float = randf_range(WanderLimit.x,WanderLimit.y)
		var wanderPositionY : float = randf_range(WanderLimit.z,WanderLimit.w)
		wanderPosition = Vector2(wanderPositionX,wanderPositionY)
	var wanderPositionNormalized : Vector2 = (wanderPosition - global_position).normalized()
	velocity = speed * wanderPositionNormalized

func FireBullet() -> void:
	if bulletFiredCount >= bulletPerSecondMax :
		bulletFiredCount = 0
		var cooldownTime = randi_range(1,ceil(cooldownTimeMax))
		await get_tree().create_timer(cooldownTime).timeout
	spriteComposition.FireBulletFlash()
	isFiring = true
	var bulletSceneNode : EnemyBullet = bulletScene.instantiate()
	bulletSceneNode.global_position = global_position
	bulletSceneNode.SetTarget(target.global_position)
	bulletHolder.add_child(bulletSceneNode)
	bulletFiredCount += 1
	bulletTimer.start()

func EnemyStartFiring() -> void:
	if isAlive:
		isFiring = false
		bulletTimer.stop()
		FireBullet()

func GetBulletHolderNode(node : Node2D) -> void:
	bulletHolder = node
