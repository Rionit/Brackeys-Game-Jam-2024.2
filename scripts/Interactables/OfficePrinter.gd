extends Interactable
class_name OfficePrinter

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	GameManager.decrease_stress(Consts.print_good)
	exit()
	
func interact(body):
	super(body)
	animation_player.play("printing")
