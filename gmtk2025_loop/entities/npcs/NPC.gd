extends Area2D

var speechBubble: SpeechBuble
var longSpeechBubble: SpeechBuble

@export var Name: String;
@export var npcGreetingText: String;
@export var npcItemCompletedText: String;
#@export var npcEndedText: String;
@export var isMom: bool = false;
@export var momStarterText: String;
@export var ShouldAnimate = true

var ItemWant: String = "NO ITEM WANT DEFINED";
var ItemHave: String = "NO ITEM WANT DEFINED";

var swapped: bool = false

var player: CharacterBody2D
var contactMade:bool = false

var sprite2d: Sprite2D
var timeLimit: float
var currentTime: float
var minFlipTime: float = 1
var maxFlipTime: float = 5

var squishTalkTimer: float
var squishTalkTimerLimit: float
var squishTalkDown: bool
@export var squishDownMax = 0.9
@export var squishTalkTimeRange = Vector2(0.8, 1.2)
var squishTalkSpeed = 1
@export var squishTalkSpeedRange = Vector2(2.5, 4.0)

func _ready():
	ItemWant.to_upper()
	ItemHave.to_upper()
	Name.to_upper()
	speechBubble = get_node("/root/Main/ShortSpeech/StoryTimeText")
	longSpeechBubble = get_node("/root/Main/LongSpeech/StoryTimeText")
	sprite2d = get_node("Sprite2D");
	currentTime = 0
	timeLimit = 3
	
func _process(delta: float) -> void:
	if !ShouldAnimate:
		return
	
	currentTime += delta
	
	
	if (player != null):
		AimAtPlayer()
		SquishTalk(delta)
	else:
		sprite2d.scale.y = 1
		if (currentTime >= timeLimit):
			UpdateFlipTimer()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		
		## is mom, no contacts, no item
		if (isMom):
			#momBase Text
			if (!CheckPlayerDialogueFlag(player)):
				UpdatedTextFields(momStarterText)
			elif (CheckPlayerDialogueFlag(player) && !player.itemCompleted):
				#all contacts made but no item
				UpdatedTextFields(npcGreetingText)
			elif (CheckPlayerDialogueFlag(player) && player.itemCompleted):
				#all contacts made + item
				var menu = get_node("/root/Main/Menu")
				menu.shouldFadeToBlack = true
				menu.fadeStep = 0.0001
				
				var player = get_node("/root/Main/Player")
				player.Speed = 0
				player.JumpVelocity = 0

				UpdatedLongTextFields(npcItemCompletedText)
		else:
			if (CheckPlayerDialogueFlag(player)):
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
		
	if (isMom && player.allContacts):
		#player.Item = "FOUND"
		player.UpdateItem();
		
	if (player.Item == "NONE"):
		print("Item Result: FAILED")
	
	if (player.Item == "FOUND"):
		print("Item Result: SUCCESS")
		itemFound = true;
	
	return itemFound;

func UpdatedTextFields(newText: String):
	speechBubble.set_text(Name + ":[p]" + newText)
	
func UpdatedLongTextFields(newText: String):
	longSpeechBubble.set_text(Name + ":[p]" + newText)
	
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

func UpdateFlipTimer():
	currentTime = 0
	if sprite2d.flip_h:
		sprite2d.flip_h = false
	else:
		sprite2d.flip_h = true
	
	var rand = RandomNumberGenerator.new()
	timeLimit = randf_range(minFlipTime, maxFlipTime)

func AimAtPlayer():
	if player.global_position < global_position:
		sprite2d.flip_h = false
	if player.global_position > global_position:
		sprite2d.flip_h = true
		
func SquishTalk(deltaTime: float):
	squishTalkTimer += (deltaTime * squishTalkSpeed)

	if (squishTalkTimer > squishTalkTimerLimit):
		squishTalkDown = !squishTalkDown
		squishTalkTimer = 0
		squishTalkTimerLimit = randf_range(squishTalkTimeRange.x, squishTalkTimeRange.y)
		squishTalkSpeed = randf_range(squishTalkSpeedRange.x, squishTalkSpeedRange.y)
	elif (squishTalkDown):
		sprite2d.scale.y = remap(squishTalkTimer, 0, squishTalkTimerLimit, 1, squishDownMax)
	else:
		sprite2d.scale.y = remap(squishTalkTimer, 0, squishTalkTimerLimit, squishDownMax, 1)
