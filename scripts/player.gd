extends CharacterBody3D

@export var SENSITIVITY = 0.25
@export var SPRINT_SPEED = 8.0

@onready var head = $Head

var speed = 0.0
var gravity = 9.8

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	handle_mouse_input(event)

func _physics_process(delta):
	head.update(velocity, delta)
	
	move_and_slide()

func handle_mouse_input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
