extends RayCast3D

var previous_interactable: Interactable = null
@onready var prompt: Label = $UI/Prompt

func _physics_process(_delta: float) -> void:
	prompt.text = ""

	if is_colliding():
		var detected = get_collider()

		if detected is Interactable and !Consts.interacting:
			prompt.text = detected.get_prompt()
			
			# Set highlight on the currently detected interactable
			detected.set_highlighted(true)
			
			# If there's a previous interactable and it's different from the current one, un-highlight it
			if previous_interactable and previous_interactable != detected:
				previous_interactable.set_highlighted(false)
			
			# Update the previous_interactable to the current one
			previous_interactable = detected
			
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
			
		else:
			# If the detected object is not an Interactable, remove highlight from previous one
			if previous_interactable:
				previous_interactable.set_highlighted(false)
				previous_interactable = null
	else:
		# If nothing is being collided, remove highlight from previous interactable
		if previous_interactable:
			previous_interactable.set_highlighted(false)
			previous_interactable = null
