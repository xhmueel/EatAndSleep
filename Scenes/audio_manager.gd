extends AudioStreamPlayer2D

func play_fx(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer2D.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()
