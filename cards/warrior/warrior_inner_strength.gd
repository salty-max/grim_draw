extends Card

const INNER_STRENGTH_STATUS = preload("res://statuses/inner_strength.tres")

func apply_effects(targets: Array[Node]) -> void:
	var status_effect := StatusEffect.new()
	var inner_strength = INNER_STRENGTH_STATUS.duplicate()
	status_effect.status = inner_strength
	status_effect.execute(targets)
