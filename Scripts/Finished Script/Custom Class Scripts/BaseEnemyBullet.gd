class_name EnemyBullet extends Area2D

@export var enemyBulletSprite : Sprite2D
@export var enemyBulletOnScreenNoitfier : VisibleOnScreenNotifier2D
@export var bulletSFX : AudioStreamPlayer2D
@export var damage : float = 0
@export var speed : float = 0

var target : Vector2 = Vector2.ZERO

func _ready() -> void:
	HelperScript.PlayRandomPitchAudio(bulletSFX.stream , bulletSFX , 0.89 , 1.20)
	enemyBulletOnScreenNoitfier.screen_exited.connect(EnemyBulletExitScreen)

func _physics_process(delta: float) -> void:
	global_position += Vector2.RIGHT.rotated(rotation) * delta * speed

func SetTarget(_target : Vector2) ->void:
	target = _target
	look_at(target)

func EnemyBulletExitScreen() -> void:
	queue_free()
