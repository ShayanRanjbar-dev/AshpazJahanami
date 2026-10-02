class_name BaseCollectible extends Area2D

@export_enum("Chef Hat","Money") var collectibleType : String : set = SetCollectibleType
@export var collectibleSprite : Sprite2D
@export var collectibleShadow : Sprite2D
@export var collectibleSpawnParticle : GPUParticles2D
@export var collectibleAudioPlayer : AudioStreamPlayer2D
@export var collectibleValue : float = 0 : set = SetCollectibleValue
@export var collectibleSpawnSFX : AudioStream
@export var collectiblePickUpSFX : Array[AudioStream]

@onready var collectibeHandler : Node = get_parent().get_parent()

var tween : Tween

func SetCollectibleType(type : String) -> void:
	collectibleType = type

func SetCollectibleValue(value : float) -> void:
	var rawValue : float = collectibleValue
	collectibleValue = rawValue * (1 + value )

func SetCollectibleUpgrades(data : CollectibleData) -> void:
	collectibleValue = data.ChefHatValue if collectibleType == "Chef Hat" else data.MoneyValue

func SetCollectibleSpawn() -> void:
	collectibleSpawnParticle.emitting = true
	collectibleSprite.scale = Vector2(0.25,0.25)
	var spawnTween : Tween = create_tween().bind_node(collectibleSprite)
	spawnTween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	spawnTween.tween_property(collectibleSprite , "scale" , Vector2(1.25,1.25), 0.35)
	spawnTween.tween_property(collectibleSprite , "scale" , Vector2.ONE , 0.15)
	await  spawnTween.finished
	collectibleSpawnParticle.queue_free()
	monitoring = true
	var motionTween : Tween = create_tween().bind_node(collectibleSprite)
	motionTween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	motionTween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	motionTween.tween_property(collectibleSprite,"position:y",-8,0.5)
	motionTween.tween_property(collectibleSprite,"position:y",0,0.5)
	tween = motionTween

func SetCollectAnimation() -> void:
	if tween:
		tween.kill()
	var collectSpriteTween : Tween = create_tween().bind_node(collectibleSprite)
	var collectShadowTween : Tween = create_tween().bind_node(collectibleShadow)
	collectSpriteTween.tween_property(collectibleSprite,"scale", Vector2(1.35 , 1.35) ,0.1)
	collectShadowTween.tween_property(collectibleShadow,"scale", Vector2(1.35 , 1.35) ,0.1)
	collectSpriteTween.tween_property(collectibleSprite,"scale",Vector2(0.1 , 0.1),0.35)
	collectShadowTween.tween_property(collectibleShadow,"scale",Vector2(0.1 , 0.1),0.35)
	await collectSpriteTween.finished
	call_deferred("queue_free")

func PlayerCollected(area: Area2D) ->void:
	if area.get_parent() is not PlayerCharacter : 
		return
	if collectibleType == "Chef Hat" :
		collectibeHandler.PlayerPickUpChefHat.emit(collectibleValue)
	else:
		collectibeHandler.PlayerPickUpMoney.emit(collectibleValue)
	set_deferred("monitoring", false)
	HelperScript.PlayRandomPitchAudio(collectiblePickUpSFX.pick_random() , collectibleAudioPlayer , 0.95 , 1.15)
	SetCollectAnimation() 

func _ready() -> void:
	HelperScript.PlayRandomPitchAudio(collectibleSpawnSFX , collectibleAudioPlayer , 0.95 , 1.15)
	area_entered.connect(PlayerCollected)
	SetCollectibleSpawn()
