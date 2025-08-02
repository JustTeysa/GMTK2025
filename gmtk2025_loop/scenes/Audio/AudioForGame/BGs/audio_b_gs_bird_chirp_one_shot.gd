extends Node2D

@export
var timer: Timer
@export
var playOnce: bool = false
@export
var minimumTimerInterval: float = 5.0
@export
var maximumTimerInterval: float = 8.0
@export
var audioPlayer: AudioStreamPlayer2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartTimer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (timer.time_left < 0.05):
		PlayOneshot()

func StartTimer():
	var randomizer = RandomNumberGenerator.new()
	var randTime: float = randomizer.randf_range(minimumTimerInterval, maximumTimerInterval)
	timer.start(randTime)
	
func PlayOneshot():
	audioPlayer.play(0)
	if (!playOnce):
		StartTimer()
	
