extends Node

@onready var virtualJoystick: Node2D = $"Joystick CanvasLayer/VirtualJoystick"

func _ready() -> void:
	await get_tree().process_frame
	SetJoystickSize()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed :
			virtualJoystick.position = event.position
			virtualJoystick.show()
		else:
			virtualJoystick.hide()
			virtualJoystick.position = event.position

func GetInputVector()->Vector2:
	return virtualJoystick.get_value()

func SetJoystickSize()->void:
	virtualJoystick.scale = Vector2.ONE
	var size = HelperScript.GetJoyStickSize() / 100
	virtualJoystick.scale *= size
