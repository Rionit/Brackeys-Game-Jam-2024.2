extends TextureProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	value = GameManager.stress_level
	if value >= 100:
		GameManager.storm.emit()
