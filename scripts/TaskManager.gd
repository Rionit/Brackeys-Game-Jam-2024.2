extends Node

@export var telephones: Array[Telephone]
@export var office_printer: OfficePrinter 
@export var computer: Computer
@export var player: Node3D

@export var calculator_task : Resource
@export var telephone_task : Resource
@export var printer_task : Resource
@export var textune_task : Resource

var active_tasks : Array

func _ready() -> void:
	GameManager.task_finished.connect(_on_task_finished)
	create_timer(0.5, init_tasks)
	start_task_timers()

func create_timer(wait_time, function):
	var timer = Timer.new()
	timer.timeout.connect(function.bind(timer))	
	timer.wait_time = wait_time
	add_child(timer)
	timer.start()

func init_tasks(init_tasks_timer):
	GameManager.task_started.emit(computer, calculator_task)
	GameManager.task_started.emit(computer, textune_task)
	active_tasks.push_back(computer)
	active_tasks.push_back(computer)
	init_tasks_timer.queue_free()
	
func start_task_timers():
	for telephone in telephones:
		create_timer(randi_range(20, 100), func(timer): _on_task_timer_timeout(telephone, telephone_task, timer))
	create_timer(randi_range(20, 50), func(timer): _on_task_timer_timeout(office_printer, printer_task, timer))

func _on_task_timer_timeout(object, task: Task, timer: Timer):
	if !active_tasks.has(object):
		active_tasks.push_back(object)
		timer.wait_time = randi_range(60, 120)
		GameManager.task_started.emit(object, task)
		GameManager.active_tasks = active_tasks.size()

func _on_task_finished(object, _title: String):
	active_tasks.erase(object)
	GameManager.active_tasks = active_tasks.size()
	if active_tasks.size() == 0:
		GameManager.calm.emit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		GameManager.calm.emit()
#
#func test():
	##GameManager.task_started.emit(telephones[0], telephone_task)
	##GameManager.task_started.emit(telephones[1], telephone_task)
	#GameManager.task_started.emit(telephones[2], telephone_task)
	#GameManager.task_started.emit(office_printer, printer_task)
