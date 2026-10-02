class_name CloseRangeWeapon extends BaseWeapon

@export var weaponSprite : Sprite2D
@export var closeRangeHitSFX : AudioStreamPlayer2D

var player : PlayerCharacter = null
var knockbackStrength : float = 600

func _process(delta: float) -> void:
	weaponSprite.rotation += delta * 10
	weaponSprite.rotation = fmod(weaponSprite.rotation  , TAU)

func GetKnockBackStrength() -> float:
	return knockbackStrength

func GetKnockbackPosition() -> Vector2:
	return player.global_position

func SetPlayer(_player : PlayerCharacter) -> void:
	player = _player
