class_name InnerStrengthStatus
extends Status

const MUSCLE_STATUS = preload("res://statuses/muscle.tres")
const MUSCLE_PER_TURN := 2
	
	
func apply_status(target: Node) -> void:
	print("Apply inner strength to %s" % target)
	
	var status_effect := StatusEffect.new()
	var muscle := MUSCLE_STATUS.duplicate()
	muscle.stacks = MUSCLE_PER_TURN
	status_effect.status = muscle
	status_effect.execute([target])
	
	status_applied.emit(self)
