extends TextureRect

func _process(_delta: float) -> void:
	modulate.a = min(pow(GameManager.get_stress_percentage() + 0.2, 2), 1.0)
