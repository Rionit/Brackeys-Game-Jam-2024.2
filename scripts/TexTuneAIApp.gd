extends NinePatchRect

@onready var user_text_colored: RichTextLabel = %UserTextColored
@onready var user_text_input: TextEdit = %UserTextInput
@onready var original_text: RichTextLabel = $VBoxContainer/MarginContainer/OriginalText

var bbcode_regex = RegEx.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	bbcode_regex.compile(r"\[/?[a-z]+[^\]]*\]")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_exit_pressed() -> void:
	visible = false

func _on_launcher_pressed() -> void:
	visible = true

func _on_user_text_input_text_changed() -> void:
	var unprocessed_text = user_text_input.text
	user_text_colored.text = process_text(unprocessed_text)

func remove_bbcode(text: String) -> String:
	return bbcode_regex.sub(text, "", true)

func process_text(unprocessed: String) -> String:
	var original = remove_bbcode(original_text.text)
	var processed := ""
	
	for i in range(unprocessed.length()):
		if i > original.length(): break
		var c1 = unprocessed[i]
		var c2 = original[i]
		
		
		if c1 != c2:
			processed += "[color=red]" + c1 + "[/color]"
		else:
			processed += c1
			
	return processed
