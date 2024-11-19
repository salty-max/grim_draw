extends Card


func apply_effects(_targets: Array[Node]) -> void:
	var draw_effect := DrawEffect.new()
	draw_effect.amount = 1
	draw_effect.execute(_targets)
