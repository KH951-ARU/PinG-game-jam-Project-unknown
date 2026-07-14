extends CharacterBody3D


signal pressed_jump(jump_state : JumpState)
signal changed_movement_state(_movement_state: Movementstate)
signal changed_movement_direction(_movement_direction: Vector3)

@export var movement_states : Dictionary
@export var jump_states : Dictionary
@export var max_air_jump : int = 1
@export var stances : Dictionary
var movement_direction : Vector3 
var air_jump_counter : int = 0 

func _input(event):
	if event.is_action_pressed("movement") or event.is_action_released("movement"):
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("back")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("sprint"):
				set_movement_state("sprint")
				if current_stance_name == "stealth":
					set_stance("upright")
			else:
				if Input.is_action_pressed("walk"):
					set_movement_state("walk")
				else:
					set_movement_state("run")
		else:
			set_movement_state("stand")
			
	if event.is_action_just_pressed("jump"):
		if air_jump_counter <= max_air_jump:
			if current_stance_name != "upright" and current_stance_name != "stealth":
				set_stance("upright"):
					return
			
			var jump_name = "ground_jump"
			
			if air_jump_counter > 0:
				jump_name = "air_jump"
			
			pressed_jump.emit(jump_states[jump_name])
			air_jump_counter += 1

func _ready():
	set_movement_state("stand")
	
func _physics_process(delta):
	if is_movement_ongoing():
		changed_movement_direction.emit(movement_direction)
	
	if is_on_floor():
		air_jump_counter = 0
	elif air_jump_counter == 0:
		air_jump_counter = 1
	

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0

func set_movement_state( state : String):
	var stance = get_node(stances[current_stance_name])
	current_movement_stance_name = state
	changed_movement_state.emit(stance.get_movement_state(state))
