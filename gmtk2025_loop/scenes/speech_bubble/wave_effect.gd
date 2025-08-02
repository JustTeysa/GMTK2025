class_name WaveEffect
extends RichTextEffect

var bbcode = "wave"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# --- Customizable Parameters ---
	# You can change these values in the BBCode tag like this:
	# [wave amp=10.0 freq=5.0 speed=2.0]Wavy Text[/wave]
	
	# How high the wave goes.
	var amplitude = char_fx.env.get("amp", 5.0)
	# How close the letters are to each other in the wave.
	var frequency = char_fx.env.get("freq", 5.0)
	# How fast the wave moves.
	var speed = char_fx.env.get("speed", 1.0)

	# --- Wave Calculation ---
	# We use a sine wave to create the up-and-down motion.
	# `char_fx.elapsed_time` makes the wave move over time.
	# `char_fx.relative_index` gives each character a different position in the wave.
	var sine_wave = sin(char_fx.elapsed_time * speed + char_fx.relative_index * frequency)
	
	# We apply the wave to the character's vertical position (offset.y).
	char_fx.offset.y = sine_wave * amplitude

	# Return true to confirm that the effect has been applied.
	return true
