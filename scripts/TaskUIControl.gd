extends VBoxContainer

@onready var title: Label = $Title
@onready var description: Label = $Description

var task: Task

func _ready() -> void:
	title.text = task.title
	description.text = task.description

func setup(_task: Task):
	task = _task
	
func remove():
	queue_free()
