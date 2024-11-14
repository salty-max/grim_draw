extends Card


func perform_action(targets: Array[Node]) -> void:
	var block_effect := BlockEffect.new()
	block_effect.amount = 20
	block_effect.sound = sound
	block_effect.execute(targets)
