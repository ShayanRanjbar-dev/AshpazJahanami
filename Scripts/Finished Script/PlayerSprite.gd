class_name PlayerSpriteHandler extends Node

@export var playerSprite : Sprite2D
@export var playerMoveAnimation : AnimationPlayer
@export var playerTurnAnimation : AnimationTree
@export var hitFlashColor : Color
@export var moneyFlashColor : Color
@export var chefHatFlashColor : Color

func SetPlayerSprite(texture : Texture2D) -> void:
	playerSprite.texture = texture

func MoveAnimation(moveVector : Vector2) -> void:
	if moveVector != Vector2.ZERO :
		if not playerMoveAnimation.is_playing() :
			playerMoveAnimation.play("MoveAnimation")
	else :
		playerMoveAnimation.stop()

func TurnAnimation(moveVector : Vector2) -> void:
	var direction : Vector2 = Vector2.ZERO
	if abs(moveVector.x) > abs(moveVector.y) :
		direction = Vector2( sign(moveVector.x) , 0)
	else:
		direction = Vector2( 0 , sign(moveVector.y))
	playerTurnAnimation.set("parameters/blend_position" , direction)

func InvulnerabilityAnimation() -> bool :
	var invulnerabilityTween : Tween = playerSprite.create_tween().set_loops()
	playerSprite.modulate.a = 1
	invulnerabilityTween.tween_property(playerSprite , "modulate:a" , 0 ,0.05)
	invulnerabilityTween.tween_property(playerSprite , "modulate:a" , 1 ,0.05).set_delay(0.1)
	await  get_tree().create_timer(1.25).timeout
	invulnerabilityTween.kill()
	playerSprite.modulate.a = 1
	return true

func SetFlash(flashColor : Color , flashValue : float , flashTime: float , temporary : bool)-> void:
	var material : ShaderMaterial = playerSprite.material as ShaderMaterial
	material.set_shader_parameter("flashValue", 0.0)
	material.set_shader_parameter("flashColor" , flashColor)
	var materialTween : Tween = create_tween().bind_node(playerSprite)
	if temporary:
		material.set_shader_parameter("flashValue", flashValue)
		materialTween.tween_property(material,"shader_parameter/flashValue" , 0.0 , flashTime).set_delay(0.10)
	else:
		materialTween.tween_property(material,"shader_parameter/flashValue" , flashValue , flashTime)

func HitFlash() -> void:
	SetFlash(hitFlashColor , 1.0 , 0.15 , true)

func MoneyFlash() ->void:
	SetFlash(moneyFlashColor , 0.6 , 0.15 , true)

func ChefHatFlash() -> void:
	SetFlash(chefHatFlashColor , 0.6 , 0.15 , true)
