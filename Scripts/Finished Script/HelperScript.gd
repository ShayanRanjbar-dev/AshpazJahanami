class_name HelperScript 

const SceneList : Dictionary[String,String] = {
	"Intro" : "res://Scenes/Finished Scenes/Intro.tscn" ,
	"MainMenu" : "res://Scenes/Finished Scenes/MainMenu.tscn" ,
	"GameScene" : "res://Scenes/Finished Scenes/GameScene.tscn"
}
const TweenLeft : Vector2 = Vector2.LEFT
const TweenRight : Vector2 = Vector2.RIGHT
const TweenUp : Vector2 = Vector2.UP
const TweenDown : Vector2 = Vector2.DOWN

static var uiAnimation : Dictionary[Control , bool] = {}

static func PlayUiErrorAnimation( ui : Control , distance : float = 25 , time : float = 0.025  , loops : int  = 3,  easeing : Tween.EaseType = Tween.EASE_IN_OUT , trans : Tween.TransitionType = Tween.TRANS_SINE) -> void :
	if uiAnimation.has(ui) and uiAnimation[ui]:
		return
	uiAnimation[ui] = true
	var uiTween : Tween = ui.create_tween().set_ease(easeing).set_trans(trans).set_loops(loops)
	var enterTweenPosition : Vector2 = ui.position
	uiTween.tween_property(ui , "position" , enterTweenPosition+ (TweenLeft *  distance ) , time)
	uiTween.tween_property(ui , "position" , enterTweenPosition+ (TweenRight *  distance) , time)
	await  uiTween.finished
	uiTween.set_loops(false)
	uiTween.stop()
	uiTween.tween_property(ui , "position" , enterTweenPosition , time)
	ui.position = enterTweenPosition
	uiAnimation[ui] = false

static func PlayUiSlideAnimation(ui : Control , direction : Vector2 , exiting : bool = false  , time : float = 0.25 , easeing : Tween.EaseType = Tween.EASE_IN_OUT , trans : Tween.TransitionType = Tween.TRANS_SINE) -> void:
	if uiAnimation.has(ui) and uiAnimation[ui]:
		return
	uiAnimation[ui] = true
	var screenSize : Vector2 =  DisplayServer.screen_get_size()
	var uiTween : Tween = ui.create_tween().set_ease(easeing).set_trans(trans)
	var position : Vector2 =  direction * screenSize
	var enterTweenPosition : Vector2 = ui.position
	if exiting:
		uiTween.tween_property(ui , "position" , position , time)
		await uiTween.finished
		ui.hide()
		ui.position = enterTweenPosition
	else:
		ui.show()
		uiTween.tween_property(ui , "position" , position , 0.000000001)
		uiTween.tween_property(ui , "position" , enterTweenPosition , time)
		await uiTween.finished
	uiAnimation[ui] = false

static func PlayUiPopUpAnimation(ui : Control , exiting : bool = false , time : float = 0.25  , easeing : Tween.EaseType = Tween.EASE_IN_OUT , trans : Tween.TransitionType = Tween.TRANS_SINE) -> void:
	var pivotOffset : Vector2 = ui.size / 2
	var scale : Vector2 = ui.scale
	var uiTween : Tween = ui.create_tween().set_ease(easeing).set_trans(trans)
	ui.pivot_offset = pivotOffset
	if exiting:
		uiTween.tween_property(ui , "scale" , scale * 1.15 , time / 4)
		uiTween.tween_property(ui , "scale" , Vector2.ZERO , time / 2)
		await  uiTween.finished
		ui.visible = not exiting
		ui.scale = scale
	else:
		ui.show()
		await ui.get_tree().process_frame
		ui.call_deferred("set", "scale", Vector2(0.1, 0.1))
		uiTween.tween_property(ui , "scale" , scale * 1.15 , time / 4)
		uiTween.tween_property(ui , "scale" , scale, time / 2)
	await  uiTween.finished
	uiTween.kill()

static func PlayAds(calleble : Callable) -> void :
	AdiveryManager.calleble = calleble
	AdiveryManager.show_rewarded_ad()

static func GetCameraShake() -> bool:
	const  SettingConfigPath : String = "user://settings.cfg"
	var settingConfig : ConfigFile = ConfigFile.new()
	settingConfig.load(SettingConfigPath)
	var cameraShake : bool =settingConfig.get_value("Video","CameraShake",true)
	return cameraShake

static func GetJoyStickSize() -> float:
	const  SettingConfigPath : String = "user://settings.cfg"
	var settingConfig : ConfigFile = ConfigFile.new()
	settingConfig.load(SettingConfigPath)
	var joyStickSize : float = settingConfig.get_value("Input","JoystickSize",100)
	return joyStickSize

static func PlayRandomPitchAudio(audio : AudioStream , player : AudioStreamPlayer2D , _min : float = 0.9 , _max : float = 1.25) -> void:
	var randomPitch : float = randf_range(_min , _max)
	player.pitch_scale = randomPitch
	player.stream = audio
	player.play()
