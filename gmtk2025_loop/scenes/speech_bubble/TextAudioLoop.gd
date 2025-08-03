extends AudioStreamPlayer2D

@export var label: RichTextLabel
@export var moduloRange = Vector2(2, 3)

var shortCharCount: int = 0
var longCharCount: int = 0

var shortLabel: RichTextLabel
var longLabel: RichTextLabel


func _ready() -> void:
	shortLabel = get_node("/root/Main/ShortSpeech/StoryTimeText/RichTextLabel")
	longLabel = get_node("/root/Main/LongSpeech/StoryTimeText/RichTextLabel")

func _process(deltaTime: float):
	_processSound_Short(shortLabel)
	_processSound_Long(longLabel)

func _processSound_Short(label: RichTextLabel):
	if shortCharCount != label.visible_characters:
		shortCharCount = label.visible_characters
		var modulo = randi_range(moduloRange.x, moduloRange.y)
		if shortCharCount > 1 && shortCharCount < label.get_total_character_count() && shortCharCount % modulo == 0:
			play()
	
func _processSound_Long(label: RichTextLabel):
	if longCharCount != label.visible_characters:
		longCharCount = label.visible_characters
		var modulo = randi_range(moduloRange.x, moduloRange.y)
		if longCharCount > 1 && longCharCount < label.get_total_character_count() && longCharCount % modulo == 0:
			play()
