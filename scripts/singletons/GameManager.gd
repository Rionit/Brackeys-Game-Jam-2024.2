extends Node

var stress_level := 0.0
var interacting := false

signal task_finished(object, title: String)
signal task_started(object, task: Task)
signal task_updated(task_name: String)

signal storm

signal equation_calculated
signal text_rewritten

var stress_timer: Timer = Timer.new()

func _ready() -> void:
	stress_timer.timeout.connect(increase_stress.bind(Consts.incremental_stress))
	storm.connect(game_over)
	add_child(stress_timer)
	stress_timer.start()

func game_over():
	stress_level = 0.0
	interacting = false
	get_tree().reload_current_scene()

func increase_stress(amount: float) -> void:
	stress_level += amount
	if stress_level >= 100:
		pass # TODO: Game Over

func decrease_stress(amount: float) -> void:
	stress_level -= amount
	if stress_level <= 0:
		stress_level = 0

func get_stress_percentage():
	return stress_level / 100
