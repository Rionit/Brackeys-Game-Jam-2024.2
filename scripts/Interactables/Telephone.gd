extends Interactable
class_name Telephone

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func interact(body):
	super(body)
	animation_player.play("pick_up")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	GameManager.decrease_stress(Consts.tel_good)
	GameManager.task_finished.emit("telephone")
	interactable = false
	exit()
