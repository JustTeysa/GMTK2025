extends Area2D

@export var target : Node 	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.global_position = target.global_position
