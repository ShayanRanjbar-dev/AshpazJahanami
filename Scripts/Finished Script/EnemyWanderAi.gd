class_name EnemyCharacterWanderAi extends EnemyCharacterAi

const WanderLimit : Vector4i = Vector4i(-800,800,-350,400)
const DistanceLimit : int = 32
var wanderPosition : Vector2 = Vector2.ZERO

func Wander() -> void:
	if global_position.distance_to(wanderPosition) < DistanceLimit:
		var wanderPositionX : float = randf_range(WanderLimit.x,WanderLimit.y)
		var wanderPositionY : float = randf_range(WanderLimit.z,WanderLimit.w)
		wanderPosition = Vector2(wanderPositionX,wanderPositionY)
	var wanderPositionNormalized : Vector2 = (wanderPosition - global_position).normalized()
	velocity = speed * wanderPositionNormalized

func _physics_process(delta: float) -> void:
	if !isKnockback:
		Wander()
	ApplyKnockBack(delta)
	move_and_slide()
