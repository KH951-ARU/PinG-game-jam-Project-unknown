extends CharacterBody3D


signal pressed_jump(jump_state : JumpState)
signal changed_stance(stance : Stance)
signal changed_movement_state(_movement_state: Movementstate)
signal changed_movement_direction(_movement_direction: Vector3)

@export var movement_states : Dictionary
@export var jump_states : Dictionary
@export var max_air_jump : int = 1
@export var stances : Dictionary

@export_group("collisons")
@onready var uprightcollision = $"Upright collision"
@onready var crouchedcollision = $"Upright collision"

var movement_direction : Vector3 
var air_jump_counter : int = 0 
var current_stance_name : String = "upright"
var current_movement_state_name : String
var stance_antispam_timer : SceneTreeTimer

func _input(Input):
	if Input.is_action_pressed("movement") or Input.is_action_released("movement"):
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
			
	if Input.is_action_pressed("jump"):
		if air_jump_counter <= max_air_jump:
			if is_stance_blocked("upright"):
				return
			
			if current_stance_name != "upright" and current_stance_name != "stealth":
				set_stance("upright")
				return
			
			var jump_name = "ground_jump"
			
			if air_jump_counter > 0:
				jump_name = "air_jump"
			
			pressed_jump.emit(jump_states[jump_name])
			air_jump_counter += 1
	if is_on_floor():
		for stance in stances.keys():
			if Input.is_action_pressed(stance):
				set_stance(stance)

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
	current_movement_state_name = state
	changed_movement_state.emit(stance.get_movement_state(state))

func set_stance(_stance_name : String):
	# If you want to use the timer, uncomment these lines safely:
	# if stance_antispam_timer and stance_antispam_timer.time_left > 0:
	#     return
	stance_antispam_timer = get_tree().create_timer(0.25)
	
	var next_stance_name : String
	
	if _stance_name == current_stance_name:
		next_stance_name = "upright"
	else:
		next_stance_name = _stance_name
	
	if is_stance_blocked(next_stance_name):
		return
	
	# 1. Fetch and safely disable the old stance collider
	var old_stance = get_node(stances[current_stance_name])
	if old_stance and old_stance.collider:
		old_stance.collider.set_deferred("disabled", true)
	
	# 2. Update to the new stance name pointer
	current_stance_name = next_stance_name
	
	# 3. Fetch and safely enable the new stance collider
	var new_stance = get_node(stances[current_stance_name])
	if new_stance and new_stance.collider:
		new_stance.collider.set_deferred("disabled", false)
	
	# 4. Emit the updated active node out to your camera script
	changed_stance.emit(new_stance)
	set_movement_state(current_movement_state_name)

func is_stance_blocked(_stance_name : String) -> bool:
	var stance = get_node(stances[_stance_name])
	return stance.is_blocked()
