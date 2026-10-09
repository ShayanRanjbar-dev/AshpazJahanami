extends MarginContainer

@export var gameOverWave : Label 
@export var continueText : Label
@export var continueButton : Button

func GetGameWaveFinish(wave : String) -> void:
	HelperScript.PlayUiSlideAnimation(get_parent() , HelperScript.TweenUp)
	gameOverWave.text = "شما %s موج از آنها را شکست دادید." % [wave]

func ContinueGame(isRewarded : bool) -> void:
	if isRewarded:
		Engine.time_scale = 1.0
		get_parent().hide()
		continueButton.hide()
		continueText.text = "شما از قابلیت ادامه دادن خود استفاده کردید"
		owner.ContinueGame.emit()
	else:
		continueButton.button_pressed = not continueButton.button_pressed
		continueText.text = "تبلیغ ناموفق بود دوباره تلاش کنید"
		continueText.label_settings.font_color = Color.RED
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)

func ExitButtonPressed() -> void:
	Engine.time_scale = 1.0
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	Loading.load_scene(HelperScript.SceneList.MainMenu , true)

func ContinueButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	ContinueGame(true)
