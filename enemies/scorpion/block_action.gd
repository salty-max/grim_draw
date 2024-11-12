extends EnemyAction

@export var block := 5


func perform_action() -> void:
	if not enemy or not target:
		return
		
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC)
	var block_effect := BlockEffect.new()
	var target_array: Array[Node] = [enemy]
	
	block_effect.amount = block
	block_effect.sound = sound
	
	tween.tween_property(enemy.sprite_2d, "scale", Vector2(1.2, 1.2), 0.4)
	tween.tween_callback(block_effect.execute.bind(target_array))
	tween.tween_interval(0.25)
	tween.tween_property(enemy.sprite_2d, "scale", Vector2.ONE, 0.4)
	
	tween.finished.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
