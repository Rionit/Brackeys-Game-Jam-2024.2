extends VBoxContainer

@onready var title: Label = $Title
@onready var description: Label = $Description

var task: Task

func _ready() -> void:
	title.text = task.title
	update_description()
	
	GameManager.task_updated.connect(_on_task_updated)

func update_description():
	var count_text = ""
	if task.count != 0:
		count_text = " [" + str(task.count) + "]"
	description.text = task.description + count_text

func _on_task_updated(task_name: String):
	if task_name == task.title.to_lower():
		update_description()

func setup(_task: Task):
	task = _task
	
func remove():
	queue_free()
