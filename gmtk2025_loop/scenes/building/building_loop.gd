extends Node2D

@export var building_gap : float = 50
@export var building_scenes : Array[PackedScene]

var current_building : Building

func _ready():
	for index in range(len(building_scenes)):
		spawn_building(index)

	var middle_index = floor(len(building_scenes) / 2)

	# set position right-wards
	for index in range (middle_index + 1, len(get_children())):
		var last_building = get_child(index - 1)
		var next_building = get_child(index)
		next_building.global_position = calculate_position(last_building, next_building, 1)

	# set position left-wards
	for index in range (middle_index - 1, -1, -1):
		var last_building = get_child(index + 1)
		var next_building = get_child(index)
		next_building.global_position = calculate_position(last_building, next_building, -1)

func spawn_building(index: int):
	var building = building_scenes[index].instantiate()
	var middle_index = floor(len(building_scenes) / 2) 
	add_child(building)
	building.player_entered.connect(_on_player_entered)
	
func calculate_position(origin: Building, target: Building, direction: int):
	var dist = origin.get_half_width() + target.get_half_width() + building_gap
	return origin.global_position + (direction * Vector2(dist, 0))
	
func _on_player_entered(building: Building):
	var last_building = current_building
	current_building = building
	
	if last_building == null:
		return
	
	# entered left building
	if last_building.global_position.x > current_building.global_position.x:
		move_to_first()
	# entered right building
	elif last_building.global_position.x < current_building.global_position.x:
		move_to_last()

func move_to_last():
	var building = get_child(0)
	var position = calculate_position(get_child(-1), building, 1)
	building.global_position = position
	move_child(building, -1)
	
func move_to_first():
	var building = get_child(-1)
	var position = calculate_position(get_child(0), building, -1)
	building.global_position = position
	move_child(building, 0)
