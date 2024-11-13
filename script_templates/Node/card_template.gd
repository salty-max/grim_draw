# meta-name: Enemy Action
# meta-description: An action which can be performed by an enemy during its turn.
extends EnemyAction


func perform_action() -> void:
	if not enemy or not target:
		return
