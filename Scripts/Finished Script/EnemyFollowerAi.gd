class_name EnemyCharacterFollowAi extends EnemyCharacterAi

const DistanceLimit : int = 32

func _ready() -> void:
	PlayEnemyAnimation()

func _physics_process(delta: float) -> void:
	if is_instance_valid(target) and !isKnockback:
		FollowTarget()
	ApplyKnockBack(delta)
	move_and_slide()

func FollowTarget() ->void :
	if global_position.distance_to(target.global_position) < DistanceLimit:
		velocity = Vector2.ZERO
		return
	var targetPositionNormalized = (target.global_position - global_position).normalized()
	velocity = targetPositionNormalized * speed
