extends Node

func increase_stress(amount: float) -> void:
	Consts.stress_level += amount
	if Consts.stress_level >= 100:
		pass # TODO: Game Over

func decrease_stress(amount: float) -> void:
	Consts.stress_level -= amount
	if Consts.stress_level <= 0:
		Consts.stress_level = 0
