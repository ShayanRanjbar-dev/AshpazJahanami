class_name SoundHandler extends AudioStreamPlayer

@export var uiAcceptSFX : AudioStream
@export var uiClickOffSFX : AudioStream
@export var uiClickOnSFX : AudioStream
@export var uiCloseSFX : AudioStream
@export var uiErrorSFX : AudioStream
@export var uiOpenSFX : AudioStream
@export var uiProgressSFX : AudioStream
@export var uiResetProgressSFX : AudioStream
@export var uiSaveSFX : AudioStream
@export var uiSelectSFX : AudioStream



func PlayUiSound(audio : AudioStream) -> void:
	if !audio:
		return
	var randomPitch : float = randf_range(0.85 , 1.25)
	pitch_scale = randomPitch
	stream = audio
	play()
