extends Node

signal task_finished(task_name: String)
signal task_started(object, task: Task)
signal task_updated(task_name: String)

signal equation_calculated
signal text_rewritten

func increase_stress(amount: float) -> void:
	Consts.stress_level += amount
	if Consts.stress_level >= 100:
		pass # TODO: Game Over

func decrease_stress(amount: float) -> void:
	Consts.stress_level -= amount
	if Consts.stress_level <= 0:
		Consts.stress_level = 0

func get_stress_percentage():
	return Consts.stress_level / 100
