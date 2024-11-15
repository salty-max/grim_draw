class_name EnemyHandler extends Node2D


func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)
	
	for enemy: Enemy in get_children():
		enemy.sprite_2d.play("default")
	
	
func reset_enemies_action() -> void:
	for enemy: Enemy in get_children():
		enemy.current_action = null
		enemy.update_action()
		
		
func start_turn() -> void:
	if get_child_count() == 0:
		return
		
	var first_enemy: Enemy = get_child(0) as Enemy
	first_enemy.do_turn()
	
	
func _on_enemy_action_completed(enemy: Enemy) -> void:
	if enemy.get_index() == get_child_count() - 1:
		Events.enemies_turn_ended.emit()
		return
		
	var next_enemy: Enemy = get_child(enemy.get_index() + 1) as Enemy
	next_enemy.do_turn()
