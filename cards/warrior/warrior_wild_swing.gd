extends Card

func apply_effects(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = 8
	damage_effect.sound = sound
	
	if targets.size() == 1:
		damage_effect.execute.bind(targets)
		damage_effect.execute.bind(targets)
		return
	
	var first_target_index := randi() % targets.size()
	var first_target := targets[first_target_index]
	var second_target_index := first_target_index
	while second_target_index == first_target_index:
		second_target_index = randi() % targets.size()
	var second_target := targets[second_target_index]
	
	damage_effect.execute.bind([first_target, second_target])
