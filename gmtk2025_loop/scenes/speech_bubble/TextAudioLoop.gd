extends AudioStreamPlayer2D

@export var label: RichTextLabel

func _process(deltaTime: float):
	if label.visible_characters > 1 && label.visible_characters < label.get_total_character_count():
		play()
