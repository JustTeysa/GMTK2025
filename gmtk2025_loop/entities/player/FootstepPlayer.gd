extends AudioStreamPlayer2D

@export var Player: CharacterBody2D
@export var AnimatedSprite: AnimatedSprite2D
var current_frame = -1;

func _process(deltaTime: float):
	if !Player.is_on_floor():
		return
	
	if AnimatedSprite.animation.begins_with("walk") && AnimatedSprite.frame % 2 == 1 && current_frame != AnimatedSprite.frame:
		current_frame = AnimatedSprite.frame
		play()
