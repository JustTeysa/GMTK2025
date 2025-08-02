extends CanvasLayer

@export var BlackScreen : ColorRect
@export var MenuScreen : Array[Node]

var shouldFadeToBlack = false
var keyPressCount = 0
var isFinishedFading = false

func _process(delta: float):
	if (shouldFadeToBlack):
		BlackScreen.set_modulate(lerp(BlackScreen.get_modulate(), Color(0,0,0,1), 0.05))
	else:
		BlackScreen.set_modulate(lerp(BlackScreen.get_modulate(), Color(1,1,1,0), 0.05))
		
	if(Input.is_anything_pressed()):
		keyPressCount += 1
		
	if keyPressCount == 1:
		shouldFadeToBlack = true
		
	if keyPressCount >= 1 && BlackScreen.get_modulate().a > 0.95 && !isFinishedFading:
		isFinishedFading = true
		shouldFadeToBlack = false
		for screen in MenuScreen:
			screen.visible = false
		
