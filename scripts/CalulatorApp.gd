extends NinePatchRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	visible = false

func _on_launcher_pressed() -> void:
	visible = true
