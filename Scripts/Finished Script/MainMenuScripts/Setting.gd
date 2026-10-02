extends MarginContainer

@export var menuContainer : MarginContainer
@export var masterVolumeText : Label
@export var musicVolumeText : Label
@export var JoystickSizeText : Label
@export var masterVolumeSlider : Slider
@export var musicVolumeSlider : Slider
@export var joystickSlider : Slider
@export var cameraShakeButton : CheckButton
@export var saveSettingBackground : ColorRect

const MasterBus : int = 0
const MusicBus : int = 1
const SfxBus : int = 2
const  SettingConfigPath : String = "user://settings.cfg"
var settingConfig : ConfigFile = ConfigFile.new()


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
	settingConfig.save(SettingConfigPath)

func SaveSettingConfigValue() ->void:
	settingConfig.set_value("Audio","MasterVolume",masterVolumeSlider.value)
	settingConfig.set_value("Audio","MusicVolume",musicVolumeSlider.value)
	settingConfig.set_value("Input","JoystickSize",joystickSlider.value)
	settingConfig.set_value("Video","CameraShake",cameraShakeButton.button_pressed)
	settingConfig.save(SettingConfigPath)

func SetSliderText(value,text : Label ) -> void:
	text.text = str(int(value)) + "%"

func SetBusVolume(value : float , bus : int) -> void:
	var linear_value : float  = clamp( value / 100.0 , 0.0001 , 1.0) 
	var dbValue : float = linear_to_db(linear_value)
	AudioServer.set_bus_volume_db(bus,dbValue)

func _ready() -> void:
	var getSettingConfig  : int = settingConfig.load(SettingConfigPath)
	if getSettingConfig == 0:
		GetSettingConfigValues()
		return
	SetDefaultSettingConfigValue()

func MasterVolumeValueChanged(value: float) -> void:
	SetSliderText(value, masterVolumeText)
	SetBusVolume(value, SfxBus)

func MusicVolumeValueChanged(value: float) -> void:
	SetSliderText(value,musicVolumeText)
	SetBusVolume(value,MusicBus)

func JoyStickSizeValueChanged(value: float) -> void:
	SetSliderText(value,JoystickSizeText)

func CameraShakeButtonToggled(toggled_on: bool) -> void:
	if toggled_on: UiSoundManager.PlayUiSound(UiSoundManager.uiClickOnSFX)
	else : UiSoundManager.PlayUiSound(UiSoundManager.uiClickOffSFX)

func ResetSettingButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiResetProgressSFX)
	saveSettingBackground.show()
	SetDefaultSettingConfigValue()
	GetSettingConfigValues()
	await get_tree().create_timer(0.25).timeout
	saveSettingBackground.hide()

func BackSettingButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiCloseSFX)
	GetSettingConfigValues()
	menuContainer.show()
	hide()

func SaveSettingButtonPressed() -> void:
	UiSoundManager.PlayUiSound(UiSoundManager.uiSaveSFX)
	saveSettingBackground.show()
	SaveSettingConfigValue()
	await get_tree().create_timer(0.25).timeout
	saveSettingBackground.hide()
