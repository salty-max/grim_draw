# meta-name: Enemy Action
# meta-description: An action which will be performed by an enemy.
extends EnemyAction


func perform_action() -> void:
	if not enemy or not target:
		return
