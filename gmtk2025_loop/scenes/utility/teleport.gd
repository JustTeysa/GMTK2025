extends Node2D

@export var target : Node 	

func _on_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.position = target.position
