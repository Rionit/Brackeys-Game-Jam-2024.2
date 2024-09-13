class_name Interactable
extends Node3D

@export var camera: Camera3D
@export var mesh: MeshInstance3D
@export var prompt_message = "Interact"
@export var prompt_action = "interact"
@export var interactable := false

var outline_width = 0.0
var highlighted := false
var interacting := false
var player = null

func _ready() -> void:
	mesh.get_active_material(0).next_pass.set_shader_parameter("outline_color", Consts.outline_color)
	GameManager.task_started.connect(_on_task_started)
	
func _physics_process(_delta: float) -> void:
	mesh.get_active_material(0).next_pass.set_shader_parameter("outline_width", outline_width)

func init(_task):
	interactable = true

func _on_task_started(object, task):
	if self == object:
		init(task)

func exit() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await CameraTransition.transition_camera3D(camera, player.camera, 0.8)
	Consts.interacting = false
	interacting = false

func set_highlighted(value: bool) -> void:
	highlighted = value
	if highlighted:
		# Add code to visually highlight the object
		outline_width = Consts.outline_width
	else:
		# Add code to remove the highlight
		outline_width = 0.0

func interact(body):
	player = body
	Consts.interacting = true
	interacting = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	CameraTransition.transition_camera3D(player.camera, camera, 0.7)

func get_prompt():
	var key_name = ""
	for action in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[" + key_name + "]"
