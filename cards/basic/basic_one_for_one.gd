extends Card


func apply_effects(targets: Array[Node]) -> void:
	if not targets:
		return

	var tween := targets[0].create_tween().set_trans(Tween.TRANS_QUINT)
	var draw_effect := DrawEffect.new()
	var discard_effect := DiscardEffect.new()
	
	draw_effect.amount = 1
	discard_effect.amount = 1
	
	tween.tween_callback(draw_effect.execute.bind(targets))
	tween.tween_interval(0.35)
	tween.tween_callback(discard_effect.execute.bind(targets))
	tween.tween_interval(0.25)
