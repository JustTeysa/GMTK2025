class_name SpeechBuble extends Control

@export var label : RichTextLabel

# --- SIGNALS ---
# Emitted when the text animation finishes.
signal typing_finished()

# --- VARIABLES ---
# This will hold our Tween instance for animating the text.
var tween: Tween

# You can adjust this value in the Godot Editor's Inspector to change
# how fast the text appears.
@export var characters_per_second = 20.0

# --- GODOT FUNCTIONS ---

# Called when the node enters the scene tree for the first time.
func _ready():
	# This is a safety check. If the script can't find the "Label" node,
	# or if it's not a RichTextLabel, it will print an error instead of crashing.
	if not label:
		push_error("SpeechBubble script could not find the Label node. Make sure a RichTextLabel node is a direct child of the SpeechBubble scene's root and is named 'Label'.")
		return

	# We start with the label being empty, input processing off, and the bubble hidden.
	label.text = ""
	hide()
	set_process_input(false)

# Called every frame. `delta` is the elapsed time since the previous frame.
# We use this to handle input for skipping the text animation.
func _input(event):
	# Check if the "ui_accept" action is pressed (configured in Project Settings -> Input Map).
	# This is typically the Enter, Space, or Z key.
	if event.is_action_pressed("interact"):
		# If the text is still typing out, we skip the animation.
		if label.visible_characters < label.get_total_character_count():
			skip_typing()
		else:
			# If typing is done, you can add logic here to advance to the next
			# line of dialogue or close the bubble. For example:
			# hide_bubble()
			pass

# --- CUSTOM FUNCTIONS ---

# This is the main function to call to display new text.
# It now works with BBCode for rich text formatting.
func set_text(text_to_display: String):
	# If the label node wasn't found, do nothing.
	if not label:
		return
	
	# Make the bubble visible and enable input processing.
	show()
	set_process_input(true)
		
	# Set the label's text, but make none of it visible initially.
	label.text = text_to_display
	label.visible_characters = 0

	# If a tween animation is already running, we should stop it.
	if tween and tween.is_valid():
		tween.kill()

	# Create a new Tween. A Tween is a powerful Godot node for animating properties.
	tween = create_tween()
	
	# We want to animate the "visible_characters" property.
	# get_total_character_count() correctly gets the length of the text without the BBCode tags.
	var total_chars = label.get_total_character_count()
	var duration = total_chars / characters_per_second
	
	# Animate from 0 to the total number of visible characters.
	tween.tween_property(label, "visible_characters", total_chars, duration)
	
	# When the tween finishes, emit our custom signal.
	tween.finished.connect(func(): emit_signal("typing_finished"))


# This function skips the typing animation and reveals the full text instantly.
func skip_typing():
	# If the label node wasn't found, do nothing.
	if not label:
		return
		
	# If there's an active tween, stop it.
	if tween and tween.is_valid():
		tween.kill()
	# Set the visible_characters to the max to show all the text immediately.
	label.visible_characters = label.get_total_character_count()
	# Since we skipped, we should also emit the finished signal.
	emit_signal("typing_finished")

# Call this function from your NPC or dialogue manager to hide the bubble.
func hide_bubble():
	hide()
	set_process_input(false)
