extends Interactable
class_name Computer

# Used for checking if the mouse is inside the Area3D.
var is_mouse_inside = false
# The last processed input touch/mouse event. To calculate relative movement.
var last_event_pos2D = null
# The time of the last event in seconds since engine start.
var last_event_time: float = -1.0
var active_tasks : Array[Task]

@onready var node_viewport = $Display/SubViewport
@onready var node_quad = $Display
@onready var node_area = $Area
@onready var key_click: Node3D = $KeyClick

func _ready():
	super()
	node_area.mouse_entered.connect(_mouse_entered_area)
	node_area.mouse_exited.connect(_mouse_exited_area)
	node_area.input_event.connect(_mouse_input_event)
	GameManager.equation_calculated.connect(_on_equation_calculated)
	GameManager.text_rewritten.connect(_on_text_rewritten)

func init(task):
	interactable = true
	active_tasks.push_back(task)

func _mouse_entered_area():
	is_mouse_inside = true
	
func _mouse_exited_area():
	is_mouse_inside = false
	
func _unhandled_input(event):
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			# If the event is a mouse/touch event, then we can ignore it here, because it will be
			# handled via Physics Picking.
			return
	node_viewport.push_input(event)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and interacting:
		exit()
	
	if event is InputEventKey and event.pressed and interacting:
		key_click.key_pressed()
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() and interacting:
		key_click.mouse_clicked()

func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	# Get mesh size to detect edges and make conversions. This code only support PlaneMesh and QuadMesh.
	var quad_mesh_size = node_quad.mesh.size

	# Event position in Area3D in world coordinate space.
	var event_pos3D = event_position

	# Current time in seconds since engine start.
	var now: float = Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: affine_inverse accounts for the Area3D node's scale, rotation, and position in the scene!
	event_pos3D = node_quad.global_transform.affine_inverse() * event_pos3D

	var event_pos2D: Vector2 = Vector2()

	if is_mouse_inside:
		# Convert the relative event position from 3D to 2D.
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= node_viewport.size.x
		event_pos2D.y *= node_viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.

	elif last_event_pos2D != null:
		# Fall back to the last known event position.
		event_pos2D = last_event_pos2D

	# Set the event's position and global position.
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)

	# Update last_event_pos2D with the position we just calculated.
	last_event_pos2D = event_pos2D

	# Update last_event_time to current time.
	last_event_time = now

	# Finally, send the processed input event to the viewport.
	node_viewport.push_input(event)

func get_task_remainder(task_name):
	for task in active_tasks:
		if task.title.to_lower() == task_name:
			task.count -= 1
			return task.count
	return null

func remove_task(task_name):
	for i in range(active_tasks.size()):
		if active_tasks[i].title.to_lower() == task_name:
			active_tasks.remove_at(i)
			return

func update_task(task_name):
	var rem = get_task_remainder(task_name)
	if rem == null: return
	
	if rem <= 0:
		remove_task(task_name)
		GameManager.task_finished.emit(self, task_name)
		return
		
	GameManager.task_updated.emit(task_name)
	
func _on_equation_calculated():
	update_task("calculator")
	
func _on_text_rewritten():
	update_task("textune")
