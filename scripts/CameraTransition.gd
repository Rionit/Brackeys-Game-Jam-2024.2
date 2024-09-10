extends Node

@onready var camera3D: Camera3D = $Camera3D

var transitioning := false

func transition_camera3D(from: Camera3D, to: Camera3D, duration: float = 1.0) -> void:
	if transitioning: return
	
	camera3D.fov = from.fov
	camera3D.cull_mask = from.cull_mask
	
	camera3D.global_transform = from.global_transform
	
	camera3D.current = true
	
	transitioning = true
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera3D, "global_transform", to.global_transform, duration).from(camera3D.global_transform)
	tween.tween_property(camera3D, "fov", to.fov, duration).from(camera3D.fov)

	# Wait for the tween to complete
	await tween.finished
	
	transitioning = false
	to.current = true
