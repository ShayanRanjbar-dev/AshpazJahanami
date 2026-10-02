extends Node

@export var firstMusicPlayer : AudioStreamPlayer
@export var secondMusicPlayer : AudioStreamPlayer
@export var musicTracks : Array[AudioStream]
@export var fadeInVolume : float = -10
@export_range(0.0, 3, 0.01) var fadeInTime : float = 1.5

@onready var fadeOutTime : float = fadeInTime * 3

const FadeOutVolume : float = -80
var activePlayer : AudioStreamPlayer
var inactivePlayer : AudioStreamPlayer
var fadePoint : float = -1.0
var isFading : bool = false

func _ready() -> void:
	activePlayer = firstMusicPlayer
	inactivePlayer = secondMusicPlayer

func _process(_delta: float) -> void:
	if activePlayer.playing and not isFading and fadePoint > 0.0:
		if abs(activePlayer.get_playback_position() - fadePoint) < 0.01:
			PlayNextTrack()

func PlayNextTrack(shuffle: bool = false) -> void:
	isFading = true
	var nextTrack : AudioStream
	if shuffle:
		nextTrack = musicTracks.pick_random()
	else:
		nextTrack = musicTracks.pop_front()
		musicTracks.push_back(nextTrack)
	inactivePlayer.stream = nextTrack
	inactivePlayer.volume_db = -80
	inactivePlayer.play()
	fadePoint = nextTrack.get_length() - fadeOutTime
	var fadeOut : Tween = create_tween()
	var fadeIn : Tween = create_tween()
	fadeOut.tween_property(activePlayer, "volume_db", FadeOutVolume , fadeOutTime)
	fadeIn.tween_property(inactivePlayer, "volume_db", fadeInVolume , fadeInTime)
	await fadeOut.finished
	activePlayer.stop()
	var temp = activePlayer
	activePlayer = inactivePlayer
	inactivePlayer = temp
	isFading = false
