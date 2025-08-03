extends AudioStreamPlayer2D

@export var AnimatedSprite: AnimatedSprite2D
var current_frame = -1;

func _process(deltaTime: float):
	if AnimatedSprite.animation.begins_with("land") && AnimatedSprite.frame % 2 == 1 && current_frame != AnimatedSprite.frame:
		current_frame = AnimatedSprite.frame
		play()
