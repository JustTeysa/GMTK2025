extends Area2D

@export var speechBubble: SpeechBuble
@export var Name: String;
@export var npcGreetingText: String;
@export var npcItemCompletedText: String;
#@export var npcEndedText: String;
@export var isMom: bool = false;
@export var momStarterText: String;

var ItemWant: String = "NO ITEM WANT DEFINED";
var ItemHave: String = "NO ITEM WANT DEFINED";

var swapped: bool = false;

var player: CharacterBody2D
var contactMade:bool = false;

func _ready():
	ItemWant.to_upper()
	ItemHave.to_upper()
	Name.to_upper()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		
		if (isMom && !contactMade):
			UpdatedTextFields(momStarterText)
		elif (CheckPlayerDialogueFlag(player)):
			UpdatedTextFields(npcItemCompletedText)
		else:
			UpdatedTextFields(npcGreetingText)
		
		enableTextBox()
		ContactPlayer(player)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		disableTextBox()

func enableTextBox():
	speechBubble.visible = true
	#speechBubble.set_text(Name + ": " + npcGreetingText)
	
func disableTextBox():
	speechBubble.set_text("")
	speechBubble.visible = false

func ContactPlayer(player: CharacterBody2D):
	print("Sending NPC info to Player")
	
	if (player == null):
		return;
	
	player.AddContact(Name)
	contactMade = true;

func CheckPlayerDialogueFlag(player: CharacterBody2D) -> bool:
	var itemFound = false;
	print("CheckingPlayerFlag")
	if (player == null):
		return false;
		
	if (player.Item == "NONE"):
		print("Item Result: FAILED")
	
	if (player.Item == "FOUND"):
		print("Item Result: SUCCESS")
		itemFound = true;
	
	return itemFound;

func UpdatedTextFields(newText: String):
	speechBubble.set_text(Name + ": " + newText)
	
#func _process(delta):
#	if player != null and Input.is_action_just_pressed("interact"):
#		player.Item = "MOWER";
		#AttemptItemSwap(player)

func AttemptItemSwap(player: CharacterBody2D) -> bool:
	print("Attempting to swap " + player.Item + " for " + ItemHave)
	if player.Item == "NONE":
		print("Result: FAILED")
		#return false
	
	var itemName = player.Item
	player.Item = ItemHave
	swapped = true;
	
	#UpdatedTextFields(npcEndedText)
	print("Result: SUCCESS")
	print(itemName)
	return true
