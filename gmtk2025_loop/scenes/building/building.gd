class_name Building extends Area2D 

@export var collider: CollisionShape2D

signal player_entered(building)

func get_width():
	return collider.shape.get_rect().size.x

func get_half_width():
	return get_width() / 2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_entered.emit(self)
