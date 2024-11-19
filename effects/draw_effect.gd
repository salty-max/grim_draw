class_name DrawEffect extends Effect

var amount := 0

func execute(_targets: Array[Node]) -> void:
	Events.player_card_draw_requested.emit(amount)
