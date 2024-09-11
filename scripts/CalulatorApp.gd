extends NinePatchRect

@onready var equation_label: Label = %Equation
@onready var user_input: LineEdit = %UserInput

var equation = ""
var answer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	reset()

func evaluate_equation(_equation: String) -> float:
	# Use the built-in 'eval()' function to evaluate the string equation
	var expression = Expression.new()
	expression.parse(_equation)
	var result = expression.execute()
	return result

func generate_equation(difficulty: int) -> String:
	var operators = ["+", "-", "*"]
	var _equation = str(randi_range(1, 10 * difficulty))  # Start with a random number, range based on difficulty
	
	# Add random operations and numbers based on the difficulty level
	for i in range(difficulty):
		var operator = operators[randi() % operators.size()]  # Randomly select an operator
		var number = randi_range(1, 10 * difficulty)  # Random number
		_equation += " " + operator + " " + str(number)
		
	return _equation

func reset():
	user_input.text = ""
	equation = generate_equation(1)
	answer = str(evaluate_equation(equation))
	equation_label.text = equation

func check_user():
	var user_answer = user_input.text
	if str(answer) == user_answer:
		print("yippeee")
		GameManager.decrease_stress(Consts.cal_good)
	else:
		print("hahahah dumbass")
		GameManager.increase_stress(Consts.cal_bad)
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	visible = false

func _on_launcher_pressed() -> void:
	visible = true

func _on_user_input_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		check_user()
