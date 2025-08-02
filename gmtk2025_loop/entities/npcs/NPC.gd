extends Area2D

var speechBubble: SpeechBuble
@export var Name: String;
@export var npcGreetingText: String;
@export var npcItemCompletedText: String;
#@export var npcEndedText: String;

var ItemWant: String = "NO ITEM WANT DEFINED";
var ItemHave: String = "NO ITEM WANT DEFINED";

var swapped: bool = false;

var player: CharacterBody2D

func _ready():
	ItemWant.to_upper()
	ItemHave.to_upper()
	speechBubble = get_node("/root/Main/CanvasLayer/StoryTimeText")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		#if (swapped)
			#UpdatedTextFields(npcEndedText)
		speechBubble.visible = true
		speechBubble.set_text(Name + ": " + npcGreetingText)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		speechBubble.set_text("")
		speechBubble.visible = false

#func _process(delta):
	#if player != null and Input.is_action_just_pressed("interact"):
		#AttemptItemSwap(player)

func AttemptItemSwap(player: CharacterBody2D) -> bool:
	print("Attempting to swap " + player.Item + " for " + ItemHave)

	if player.Item == "NONE":
		print("Result: FAILED")
		return false
	
	var itemName = player.Item
	player.Item = ItemHave
	swapped = true;
	
	#UpdatedTextFields(npcEndedText)
	print("Result: SUCCESS")
	return true
	
func UpdatedTextFields(newText: String):
	speechBubble.set_text(Name + ": " + newText)
