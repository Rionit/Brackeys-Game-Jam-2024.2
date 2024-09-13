extends Node

const WIN_SCREEN = preload("res://scenes/win_screen.tscn")
const MAIN_LEVEL = preload("res://scenes/main_level.tscn")

var stress_level := 0.0
var interacting := false
var active_tasks := 2

signal task_finished(object, title: String)
signal task_started(object, task: Task)
signal task_updated(task_name: String)

signal storm
signal calm

signal equation_calculated
signal text_rewritten

var stress_timer: Timer = Timer.new()

func _ready() -> void:
	stress_timer.timeout.connect(increase_stress_incremental)
	storm.connect(game_over)
	calm.connect(win)
	add_child(stress_timer)
	stress_timer.start()

func win():
	get_tree().change_scene_to_packed(WIN_SCREEN)

func game_over():
	stress_level = 0.0
	interacting = false
	active_tasks = 2
	get_tree().change_scene_to_packed(MAIN_LEVEL)

func increase_stress_incremental():
	increase_stress(Consts.incremental_stress * active_tasks)

func increase_stress(amount: float) -> void:
	print("Increasing: " + str(amount))
	stress_level += amount
	if stress_level >= 100:
		pass # TODO: Game Over

func decrease_stress(amount: float) -> void:
	stress_level -= amount
	if stress_level <= 0:
		stress_level = 0

func get_stress_percentage():
	return stress_level / 100
