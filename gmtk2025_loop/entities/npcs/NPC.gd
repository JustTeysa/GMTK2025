extends Area2D



var player_in_range:bool = false

func _ready():
	print("wassup bitches i'm mario")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		print("Player entered NPC range.")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		print("Player left NPC range.")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		print("mama mia you interacted with a me!")
