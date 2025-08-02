extends Area2D

@export var speechBubble: SpeechBuble
@export var npcGreetingText: String;
@export var npcSwapText: String;
@export var npcEndedText: String;

@export var ItemWant: String = "NO ITEM WANT DEFINED";
@export var ItemHave: String = "NO ITEM WANT DEFINED";

var swapped: bool = false;

var player_in_range:bool = false

func _ready():
	print("wassup bitches i'm mario")
	speechBubble.set_text(npcGreetingText)
	ItemWant.to_upper()
	ItemHave.to_upper()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		#if (swapped)
			#UpdatedTextFields(npcEndedText)
		speechBubble.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		speechBubble.visible = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("mama mia you interacted with a me!")
		#AttemptItemSwap();

func AttemptItemSwap():
	var csharp_node = get_node("../Player")
	var csharp_script = csharp_node.get_script()
	var csharp_variable_value: String = csharp_script.GetItem()
	#var csharp_variable_value = csharp_script.Item;
	print(csharp_script.GetItem())
	#var csharp_node.my_csharp_variable = ItemHave;
	csharp_script.Item = ItemHave
	print(csharp_node.Item)
	swapped = true;
	UpdatedTextFields(npcEndedText)
	
	
func UpdatedTextFields(newText: String):
	speechBubble.set_text(npcGreetingText)
