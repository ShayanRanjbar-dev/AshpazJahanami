extends MarginContainer

@export var uiHandler : Node
@export var settingUi : Control
@export var masterVolumeText : Label
@export var musicVolumeText : Label
@export var JoystickSizeText : Label
@export var masterVolumeSlider : Slider
@export var musicVolumeSlider : Slider
@export var joystickSlider : Slider
@export var cameraShakeButton : CheckButton
@export var saveSettingBackground : ColorRect

const masterBus : int = 0
const MusicBus : int = 1
var settingConfig : ConfigFile = ConfigFile.new()
var configPath : String = "user://settings.cfg"

func GetSettingConfigValues()->void:
	masterVolumeSlider.value = settingConfig.get_value("Audio","MasterVolume",100)
	musicVolumeSlider.value = settingConfig.get_value("Audio","MusicVolume",100)
	joystickSlider.value = settingConfig.get_value("Input","JoystickSize",100)
	cameraShakeButton.button_pressed = settingConfig.get_value("Video","CameraShake",true)

func SetDefaultSettingConfigValue()->void:
	settingConfig.set_value("Audio","MasterVolume",100)
	settingConfig.set_value("Audio","MusicVolume",100)
	settingConfig.set_value("Input","JoystickSize",100)
	settingConfig.set_value("Video","CameraShake",true)
	settingConfig.save(configPath)

func SaveSettingConfigValue() ->void:
	settingConfig.set_value("Audio","MasterVolume",masterVolumeSlider.value)
	settingConfig.set_value("Audio","MusicVolume",musicVolumeSlider.value)
	settingConfig.set_value("Input","JoystickSize",joystickSlider.value)
	settingConfig.set_value("Video","CameraShake",cameraShakeButton.button_pressed)
	settingConfig.save(configPath)

func SetSliderText(value,text : Label ) -> void:
	text.text = str(int(value)) + "%"

func SetBusVolume(value : float , bus : int) -> void:
	var linear_value : float  = clamp( value / 100.0 , 0.0001 , 1.0) 
	var dbValue : float = linear_to_db(linear_value)
	AudioServer.set_bus_volume_db(bus,dbValue)

func _ready() -> void:
	var getSettingConfig  : int = settingConfig.load(configPath)
	if getSettingConfig == 0:
		GetSettingConfigValues()
		return
	SetDefaultSettingConfigValue()

func SettingButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiOpenSFX)
	Engine.time_scale = 0.0
	settingUi.show()
	uiHandler.EnterSetting.emit()

func MasterVolumeValueChanged(value: float) -> void:
	SetSliderText(value,masterVolumeText)
	SetBusVolume(value,masterBus)

func MusicVolumeValueChanged(value: float) -> void:
	SetSliderText(value,musicVolumeText)
	SetBusVolume(value,MusicBus)

func JoyStickSizeValueChanged(value: float) -> void:
	SetSliderText(value,JoystickSizeText)

func CameraShakeButtonToggled(toggled_on: bool) -> void:
	if toggled_on: UiSoundManager.PlayUiSound(UiSoundManager.uiClickOnSFX)
	else : UiSoundManager.PlayUiSound(UiSoundManager.uiClickOffSFX)

func SaveSettingButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiSaveSFX)
	saveSettingBackground.show()
	SaveSettingConfigValue()
	await get_tree().create_timer(0.25,true,false,true).timeout
	saveSettingBackground.hide()

func ReturnSettingButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	Engine.time_scale = 1.0
	GetSettingConfigValues()
	settingUi.hide()
	uiHandler.SettingUpdated.emit()

func ExitGameButtonPressed() -> void:
	Engine.time_scale = 1.0
	Loading.load_scene(HelperScript.SceneList.MainMenu , true)
