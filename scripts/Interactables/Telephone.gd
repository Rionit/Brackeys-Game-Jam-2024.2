extends Interactable
class_name Telephone

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer3D = $Audio

const PHONE_CALL = preload("res://audio/sfx/phone_call.mp3")
const PHONE_RINGING = preload("res://audio/sfx/phone_ringing.wav")

func interact(body):
	super(body)
	audio.stop()
	animation_player.play("pick_up")
	
func init(task):
	super(task)
	audio.stream = PHONE_RINGING
	audio.play()

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	GameManager.decrease_stress(Consts.tel_good)
	GameManager.task_finished.emit("telephone")
	interactable = false
	exit()
