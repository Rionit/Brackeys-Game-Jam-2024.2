extends Node

@export var telephones: Array[Telephone]
@export var office_printer: OfficePrinter 
@export var computer: Computer
@export var player: Node3D

@export var calculator_task : Resource
@export var telephone_task : Resource

var active_tasks : Array[Task]

func _ready() -> void:
	GameManager.task_finished.connect(_on_task_finished)

func _on_task_finished(name: String):
	print("yup " + name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		test()

func test():
	GameManager.task_started.emit(telephones[2], telephone_task)
