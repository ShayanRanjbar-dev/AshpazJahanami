extends Control


@export var httpRequest : HTTPRequest
@export var loadingText : Label
@export var networkRetry : PanelContainer

var isOnline: bool = false

func _ready() -> void:
	BackGroundMusic.PlayNextTrack()

func CheckInternetConnection():
	var url = "https://myket.ir/"
	var error = httpRequest.request(url)
	if error != OK:
		isOnline = false

func ChangeScene()->void:
	if isOnline:
		Loading.load_scene(HelperScript.SceneList.MainMenu , false)
	else:
		UiSoundManager.PlayUiSound(UiSoundManager.uiErrorSFX)
		loadingText.hide()
		networkRetry.scale *= 0.75
		networkRetry.show()
		var net_tween : Tween=create_tween().bind_node(networkRetry).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
		net_tween.tween_property(networkRetry,"scale",Vector2(1.10,1.10),0.15)
		net_tween.tween_property(networkRetry,"scale",Vector2(1,1),0.05)
		await net_tween.finished
		net_tween.kill()

func HTTPRequestCompleted(result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if result == HTTPRequest.RESULT_SUCCESS and response_code == 200:
		isOnline = true
	else:
		isOnline = false
	ChangeScene()

func ExitButtonPressed() -> void:
	get_tree().quit()

func RetryButtonPressed() -> void:
	CheckInternetConnection()
	networkRetry.hide()
	loadingText.show()
