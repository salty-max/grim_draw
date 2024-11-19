class_name DiscardEffect extends Effect

var amount := 0

func execute(_targets: Array[Node]) -> void:
	Events.player_card_discard_requested.emit(amount)
