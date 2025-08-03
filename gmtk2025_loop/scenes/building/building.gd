class_name Building extends Area2D 

@export var collider: CollisionShape2D
@export var npc_scenes : Array[PackedScene]
@export var npc_roots : Array[Marker2D]
signal player_entered(building)

func _ready():
	for index in range(len(npc_scenes)):
		var npc_instance = npc_scenes[index].instantiate()
		var root_index = index % len(npc_roots)
		npc_roots[root_index].add_child(npc_instance)
		npc_instance.position = Vector2(0,0)

func get_width():
	return collider.shape.get_rect().size.x

func get_half_width():
	return get_width() / 2

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_entered.emit(self)
