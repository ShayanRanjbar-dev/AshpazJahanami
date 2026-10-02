extends Camera2D

var shakeStrength : float = 0
var shakeDuration : float = 0
var IsShaking : bool = false
var canShake : bool =  true


func ShakeCamera( _shakeduration : float = 0.25, _shakeStrength : float = 10) -> void:
	shakeDuration = _shakeduration
	shakeStrength = _shakeStrength
	IsShaking = true

func _ready() -> void:
	CheckHasShake()

func _physics_process(delta: float) -> void:
	if !canShake:
		return
	if !IsShaking:
		return
	var offsetX : float = randf_range(-shakeStrength,shakeStrength)
	var offsetY : float = randf_range(-shakeStrength,shakeStrength)
	offset = Vector2(offsetX,offsetY)
	shakeDuration -= delta
	if shakeDuration <= 0.0:
		ResetShake()


func ResetShake() -> void:
	offset = Vector2.ZERO
	IsShaking = false

func PlayerHitCameraShake() -> void:
	ShakeCamera(0.2,12)

func EnemyCameraShake(duration: float, strength: float) -> void:
	ShakeCamera(duration , strength)

func PlayerDied() -> void:
	ResetShake()

func CheckHasShake() -> void:
	canShake = HelperScript.GetCameraShake()
