extends Node

@export var telephones: Array[Telephone]
@export var office_printer: OfficePrinter 
@export var computer: Computer
@export var player: Node3D

@export var calculator_task : Resource
@export var telephone_task : Resource
@export var printer_task : Resource
@export var textune_task : Resource

func _ready() -> void:
	GameManager.task_finished.connect(_on_task_finished)

func _on_task_finished(title: String):
	print("yup " + title)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		test()

func test():
	#GameManager.task_started.emit(telephones[0], telephone_task)
	#GameManager.task_started.emit(telephones[1], telephone_task)
	GameManager.task_started.emit(telephones[2], telephone_task)
	GameManager.task_started.emit(office_printer, printer_task)
	GameManager.task_started.emit(computer, calculator_task)
	GameManager.task_started.emit(computer, textune_task)
