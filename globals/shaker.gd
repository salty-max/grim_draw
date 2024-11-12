
extends Node

const shake_count := 10

@export var noise_seed: int = int(randf() * 1000)

func shake(thing: Node2D, strength: float, duration: float = 0.2) -> void:
	if not thing:
		return

	var noise := FastNoiseLite.new()
	noise.seed = noise_seed
	noise.frequency = 10.0
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

	var orig_pos := thing.position
	var tween := create_tween()
	var shake_time := 0.0
	var shake_interval := duration / shake_count
	
	while shake_time < duration:
		shake_time += shake_interval
		
		var noise_offset_x := noise.get_noise_2d(shake_time, 0) * strength
		var noise_offset_y := noise.get_noise_2d(0, shake_time) * strength
		var target := orig_pos + Vector2(noise_offset_x, noise_offset_y)

		tween.tween_property(thing, "position", target, shake_interval)

		strength *= 0.75
	
	tween.finished.connect(func(): thing.position = orig_pos)
