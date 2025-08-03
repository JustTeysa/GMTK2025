extends AudioStreamPlayer2D

var shortLabel: RichTextLabel
var longLabel: RichTextLabel

var has_played_audio = false

func _ready() -> void:
	shortLabel = get_node("/root/Main/ShortSpeech/StoryTimeText/RichTextLabel")
	longLabel = get_node("/root/Main/LongSpeech/StoryTimeText/RichTextLabel")

func _process(deltaTime: float):
	_processSound(shortLabel)
	#_processSound(longLabel)

func _processSound(label: RichTextLabel):
	if label.visible_characters == 0:
		has_played_audio = false
		return
		
	if label.visible_characters == label.get_total_character_count() && !has_played_audio:
		has_played_audio = true
		play()
