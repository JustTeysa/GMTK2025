extends AudioStreamPlayer2D

@export var AnimatedSprite: AnimatedSprite2D

var has_played_this_jump = false

func _process(deltaTime: float):
	if has_played_this_jump && AnimatedSprite.frame == 1:
		has_played_this_jump = false
	elif AnimatedSprite.animation.begins_with("jump") && AnimatedSprite.frame == 0 && !has_played_this_jump:
		has_played_this_jump = true
		play()
	
