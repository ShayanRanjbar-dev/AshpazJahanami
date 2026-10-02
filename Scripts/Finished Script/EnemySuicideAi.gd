class_name EnemyCharacterSuicideAi extends EnemyCharacterFollowAi

@export var explosionSFX : AudioStream
@export var explosionTriggerSFX : AudioStream
@export var explosionSFXPlayer : AudioStreamPlayer2D
@export var explosionTriggerArea : Area2D
@export var enemyExplodeRangeBox : Area2D
@export var enemyExplostionParticle : GPUParticles2D
@export var enemyExplotionTimer : Timer
@export var enemyExplotionMaxTime : float = 0.0

var explodedHitboxes : Array[Area2D]
var isExploding : bool = false

func EnemyGetHit( _damage : float) -> void:
	if !isExploding:
		const MinHealth : float = 0.0
		health -= _damage
		if health <= MinHealth :
			EnemyDeath()
			return
		spriteComposition.HitFlash()

func _ready() -> void:
	PlayEnemyAnimation()

func _physics_process(delta: float) -> void:
	if !isKnockback:
		FollowTarget()
	ApplyKnockBack(delta)
	move_and_slide()

func SetEnemiesCollisions()-> void:
	enemyExplotionTimer.wait_time = randf_range(1,enemyExplotionMaxTime)
	enemyExplotionTimer.timeout.connect(EnemyExploded)
	Hitbox.monitorable = true
	Hurtbox.monitorable = true
	Hurtbox.monitoring = true
	Hitbox.damage = damage
	Hurtbox.area_entered.connect(PlayerHitEnemy)
	explosionTriggerArea.area_entered.connect(PlayerEnterExplodeArea)
	enemyExplodeRangeBox.area_entered.connect(BodyEnterExplodeRange)
	enemyExplodeRangeBox.area_exited.connect(BodyExitExplodeRange)
	enemyExplodeRangeBox.monitoring = false

func PlayerEnterExplodeArea(area : Area2D) -> void:
	if area is EnemyHitbox or area is EnemyBullet:
		return
	if !isExploding:
		isExploding = true
		HelperScript.PlayRandomPitchAudio(explosionTriggerSFX , explosionSFXPlayer , 0.89 , 1.25)
		speed += round(speed * 0.25)
		enemyExplotionTimer.start()
		spriteComposition.ExplodeFlash()
		enemyExplodeRangeBox.monitoring = true

func BodyEnterExplodeRange(area : Area2D) -> void:
	if area.get_parent() == self:
		return
	explodedHitboxes.append(area)

func BodyExitExplodeRange(area : Area2D) -> void:
	explodedHitboxes.erase(area)

func EnemyExploded() -> void:
	remove_from_group("Enemy")
	enemyHandler.EnemyCameraShake.emit(0.15, 10)
	enemyExplostionParticle.emitting = true
	HelperScript.PlayRandomPitchAudio(explosionSFX , explosionSFXPlayer , 1.5 , 2)
	explosionSFXPlayer.reparent(get_tree().current_scene)
	speed = 0
	for exploded in explodedHitboxes:
		if exploded.get_parent() == target:
			target.PlayerGetHit(damage)
			continue
		if exploded.get_parent() is EnemyCharacterAi:
			exploded.get_parent().EnemyDeath()
	spriteComposition.DeathTween()
	await  explosionSFXPlayer.finished
	queue_free()
