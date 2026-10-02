extends MarginContainer

@export var waveText : RichTextLabel
@export var timeText : Label
@export var mainFont : Font
@export var numberFont : Font

func _ready() -> void:
	GetGameWave(1)

func GetGameWave( wave : int ) -> void:
	waveText.clear()
	waveText.push_outline_color(Color.BLACK)
	waveText.push_outline_size(7)
	waveText.push_font_size(72)
	waveText.push_font(mainFont)
	waveText.add_text("موج ")
	waveText.pop()
	waveText.pop()
	waveText.push_font_size(64)
	waveText.push_font(numberFont)
	waveText.add_text("%02d" % wave)
	waveText.pop()
	waveText.pop()
	waveText.pop()
	waveText.pop()

func GetGameTime( time : float ) -> void:
	var intTime : int = ceil(time)
	timeText.text = "%02d" % intTime
