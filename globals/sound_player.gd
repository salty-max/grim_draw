extends Node

func play(source: AudioStream, single = false) -> void:
	if not source:
		return
		
	if single:
		stop()
	
	for player in get_children():
		player = player as AudioStreamPlayer
		
		if not player.playing:
			player.stream = source
			player.play()
			break
			
			
func stop() -> void:
	for player in get_children():
		player = player as AudioStreamPlayer
		player.stop()
	
