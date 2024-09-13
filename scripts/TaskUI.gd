extends VBoxContainer

const TASK_UI_CONTROL = preload("res://scenes/task_ui_control.tscn")

var tasks : Array[Dictionary] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.task_started.connect(create_new)
	GameManager.task_finished.connect(delete)

func create_new(_object, task: Task):
	var new_task_ui = TASK_UI_CONTROL.instantiate()
	new_task_ui.setup(task)
	add_child(new_task_ui)
	tasks.push_back({task.title.to_lower(): new_task_ui})

func delete(title: String):
	title = title.to_lower()
	for task in tasks:
		# Get the first key (task name) from the dictionary
		var task_title = task.keys()[0]
		if task_title == title:
			var task_ui_control = task[task_title]
			task_ui_control.remove() 
			tasks.erase(task) 
			return 
