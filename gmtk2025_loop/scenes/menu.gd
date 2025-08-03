extends CanvasLayer

@export var BlackScreen : ColorRect
@export var MenuScreen : Array[Node]

var shouldFadeToBlack = false
var keyPressCount = 0
var isFinishedFading = false
var fadeStep = 0.05

func _process(delta: float):
	if (shouldFadeToBlack):
		BlackScreen.set_modulate(lerp(BlackScreen.get_modulate(), Color(0,0,0,1), fadeStep))
	else:
		BlackScreen.set_modulate(lerp(BlackScreen.get_modulate(), Color(1,1,1,0), fadeStep))
		
	if(Input.is_anything_pressed()):
		keyPressCount += 1
		
	if keyPressCount == 1:
		shouldFadeToBlack = true
		
	if keyPressCount >= 1 && BlackScreen.get_modulate().a > 0.95 && !isFinishedFading:
		isFinishedFading = true
		shouldFadeToBlack = false
		var player = get_node("/root/Main/Player")
		player.set_collision_layer_value(1, true)
		for screen in MenuScreen:
			screen.visible = false
		
