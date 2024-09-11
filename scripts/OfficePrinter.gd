extends Interactable
class_name OfficePrinter

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GameManager.decrease_stress(Consts.print_good)
	exit()
	
func interact(body):
	super(body)
	animation_player.play("printing")
