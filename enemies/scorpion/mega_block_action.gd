extends EnemyAction

@export var block := 15
@export var hp_threshold := 5

var already_used := false


func is_performable() -> bool:
	if already_used or not enemy or not target:
		return false
		
	var is_low := enemy.stats.health <= hp_threshold
	already_used = is_low
	
	return is_low
	
	
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
