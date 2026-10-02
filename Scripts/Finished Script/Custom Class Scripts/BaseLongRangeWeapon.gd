class_name LongRangeWeapon extends BaseWeapon

@export var rangeSpeed : float = 700
@export var weaponSprite : Sprite2D
@export var onScreenNotifier : VisibleOnScreenNotifier2D
@export var hitParticle : GPUParticles2D

var target : Vector2 = Vector2.ZERO

func GetTarget(_target : EnemyCharacterAi) ->void:
	target = _target.global_position
	look_at(target)

func GetParticle() -> GPUParticles2D:
	return hitParticle

func _ready() -> void:
	onScreenNotifier.screen_exited.connect(OnScreenExited)

func _physics_process(delta: float) -> void:
	global_position += transform.x * rangeSpeed * delta

func OnScreenExited() -> void:
	queue_free()
