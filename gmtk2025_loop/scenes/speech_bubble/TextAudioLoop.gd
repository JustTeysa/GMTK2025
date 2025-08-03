extends AudioStreamPlayer2D

@export var label: RichTextLabel

var charCount: int = 0

var shortLabel: RichTextLabel
var longLabel: RichTextLabel

func _ready() -> void:
	shortLabel = get_node("/root/Main/ShortSpeech/StoryTimeText/RichTextLabel")
	longLabel = get_node("/root/Main/LongSpeech/StoryTimeText/RichTextLabel")

func _process(deltaTime: float):
	_processSound(shortLabel)
	#_processSound(longLabel)

func _processSound(label: RichTextLabel):
	if charCount != label.visible_characters:
		charCount = label.visible_characters
		if charCount > 1 && charCount < label.get_total_character_count():
			play()
	
