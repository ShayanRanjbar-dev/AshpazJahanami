class_name EnemySpriteHandler extends Node

@export var enemySprite : Sprite2D
@export var hitFlashColor : Color
@export var explodeFlashColor : Color
@export var fireBulletFlashColor : Color
@export var healFlashColor : Color
@export var necromanceFlashColor : Color
@export var bossBulletFlashColor : Color
@export var bossChargeFlashColor : Color

var spriteMotionTween : Tween 

func SpawnAnimation() ->bool:
	enemySprite.scale = Vector2.ZERO
	enemySprite.self_modulate.a = 0
	var spriteSizeTween : Tween = create_tween().bind_node(enemySprite)
	spriteSizeTween.set_parallel()
	spriteSizeTween.tween_property(enemySprite,"self_modulate:a",255,0.25)
	spriteSizeTween.tween_property(enemySprite,"scale",Vector2.ONE,0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	await  spriteSizeTween.finished
	spriteSizeTween.kill()
	spriteMotionTween = create_tween().bind_node(enemySprite)
	spriteMotionTween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	spriteMotionTween.set_loops()
	spriteMotionTween.tween_property(enemySprite,"scale:y", 1.10 , 0.2)
	spriteMotionTween.tween_property(enemySprite,"scale:y", 0.9 , 0.2)
	return true

func DeathTween() ->bool:
	if spriteMotionTween:
		spriteMotionTween.kill()
	var deathTween : Tween = create_tween().bind_node(enemySprite).parallel()
	deathTween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	deathTween.tween_property(enemySprite , "scale" , Vector2(1.10,1.10) , 0.15)
	deathTween.chain().tween_property(enemySprite , "scale" , Vector2.ZERO , 0.15)
	deathTween.tween_property(enemySprite , "self_modulate:a" , 0 , 0.25)
	await  deathTween.finished
	return true

func SetFlash(flashColor : Color , flashValue : float , flashTime: float , temporary : bool)-> void:
	var material : ShaderMaterial = enemySprite.material as ShaderMaterial
	material.set_shader_parameter("flashValue", 0.0)
	material.set_shader_parameter("flashColor" , flashColor)
	var materialTween : Tween = create_tween().bind_node(enemySprite)
	if temporary:
		material.set_shader_parameter("flashValue", flashValue)
		materialTween.tween_property(material,"shader_parameter/flashValue" , 0.0 , flashTime).set_delay(0.10)
	else:
		materialTween.tween_property(material,"shader_parameter/flashValue" , flashValue , flashTime)

func ResetFlash() -> void:
	SetFlash(bossChargeFlashColor , 0.0 , 0.5 , true)

func ExplodeFlash() -> void:
	SetFlash(explodeFlashColor , 1.0 , 0.35 , false)

func HitFlash() -> void:
	SetFlash(hitFlashColor , 1.0 , 0.15 , true)

func FireBulletFlash() -> void:
	SetFlash(fireBulletFlashColor , 1.0 , 0.15 , true)

func HealFlash() -> void:
	SetFlash(healFlashColor , 1.0  , 0.20 , true)

func NecromanceFlash() -> void:
	SetFlash(necromanceFlashColor , 1.0 , 0.15 , true)

func BossBulletFlash() -> void:
	SetFlash(bossBulletFlashColor , 0.6 , 0.05, true)

func BossChargeFlash() -> void:
	SetFlash(bossChargeFlashColor , 0.6 , 0.5 , false)
