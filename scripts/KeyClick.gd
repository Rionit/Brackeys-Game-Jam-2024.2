extends Node3D

@export var key_sounds: Array[Resource]
@export var mouse_click: Resource

func create_player(sound):
	var audio_player := AudioStreamPlayer3D.new()
	#audio_player.finished.connect(destroy.bind(audio_player))
	audio_player.finished.connect(func(): audio_player.queue_free())
	audio_player.stream = sound
	audio_player.bus = "SFX"
	audio_player.volume_db = -15.0
	add_child(audio_player)
	audio_player.play()

func key_pressed():
	create_player(key_sounds.pick_random())

func mouse_clicked():
	create_player(mouse_click)

#func destroy(audio_player: AudioStreamPlayer3D):
	#audio_player.queue_free()
