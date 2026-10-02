class_name EnemyCharacterHealerAi extends EnemyCharacterWanderAi

@export var enemyHealbox : ShapeCast2D
@export var enemyHealerSFX : AudioStreamPlayer2D

var currentHealTarget : EnemyCharacterAi
var healTargetCheckTime : float = 0.0
var healTargetCheckTimeMax : float = 1.5

func SetEnemiesCollisions() -> void:
	Hitbox.monitorable = true
	Hurtbox.monitorable = true
	Hurtbox.monitoring = true
	Hurtbox.area_entered.connect(PlayerHitEnemy)
	Hitbox.damage = damage
	enemyHealbox.add_exception(Hurtbox)

func SetHealTarget() -> void:
	if currentHealTarget:
		return
	if enemyHandler.damagedEnemies.size() > 0:
		if is_instance_valid(enemyHandler.damagedEnemies.front()):
			var healtarget = enemyHandler.damagedEnemies.pop_front()
			currentHealTarget = healtarget
			enemyHealbox.enabled = true

func ClearHealTarget() -> void:
	currentHealTarget = null
	enemyHealbox.enabled = false

func MoveToHeal() -> void:
	if currentHealTarget == null or !is_instance_valid(currentHealTarget):
		return
	if global_position.distance_to(currentHealTarget.global_position) <= DistanceLimit:
		ClearHealTarget()
		return
	var targetPositionNormalized = (currentHealTarget.global_position - global_position).normalized()
	velocity = targetPositionNormalized * speed

func CheckHealCollisions() -> void:
	if currentHealTarget == null or !is_instance_valid(currentHealTarget):
		return
	enemyHealbox.force_update_transform()
	for i in enemyHealbox.get_collision_count():
		var collider = enemyHealbox.get_collider(i)
		if  collider != null and collider.get_parent() == currentHealTarget:
			spriteComposition.NecromanceFlash()
			HelperScript.PlayRandomPitchAudio(enemyHealerSFX.stream , enemyHealerSFX , 1 , 1.5)
			collider.get_parent().EnemyGetHeal()
			health -= 50
			ClearHealTarget()
			break

func Wander() -> void:
	if global_position.distance_to(wanderPosition) < DistanceLimit:
		var wanderPositionX : float = randf_range(WanderLimit.x,WanderLimit.y)
		var wanderPositionY : float = randf_range(WanderLimit.z,WanderLimit.w)
		wanderPosition = Vector2(wanderPositionX,wanderPositionY)
	var wanderPositionNormalized : Vector2 = (wanderPosition - global_position).normalized()
	velocity = speed * wanderPositionNormalized

func _ready() -> void:
	PlayEnemyAnimation()

func _physics_process(delta: float) -> void:
	if !isKnockback:
		if currentHealTarget:
			MoveToHeal()
			CheckHealCollisions()
		else:
			Wander()
			healTargetCheckTime += delta
			if healTargetCheckTime >= healTargetCheckTimeMax:
				healTargetCheckTime = 0.0 + randi_range(0,1)
				SetHealTarget()
	ApplyKnockBack(delta)
	move_and_slide()
