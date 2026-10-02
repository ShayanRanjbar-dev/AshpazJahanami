extends CanvasLayer

@onready var fps_text: Label = $"FPS Text"

func _process(_delta: float) -> void:
	fps_text.text = "FPS: %d" % [Engine.get_frames_per_second()]
