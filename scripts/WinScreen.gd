extends Node

@onready var button: Button = $VBoxContainer/Button

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	button.pressed.connect(GameManager.game_over)
