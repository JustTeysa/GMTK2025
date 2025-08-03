extends AudioStreamPlayer2D

@export var AnimatedSprite: AnimatedSprite2D
var has_played_this_land = false

func _process(deltaTime: float):
	if has_played_this_land && AnimatedSprite.frame == 1:
		has_played_this_land = false
	elif AnimatedSprite.animation.begins_with("land") && AnimatedSprite.frame == 0:
		has_played_this_land = true
		play()
