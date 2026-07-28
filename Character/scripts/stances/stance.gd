extends Node
class_name Stance

@export_category("movement stances")
@export var idle_state : Movementstate
@export var walk_state : Movementstate
@export var run_state : Movementstate
@export var sprint_state : Movementstate

@export_category("camera data")
@export var camera_height : float = 1.3

@export_category("collison data")
@export var col_raycast : RayCast3D
@export var collider : CollisionShape3D 
@export var higher_stances :Array[Stance]

func is_blocked() -> bool:
	return col_raycast and col_raycast.is_colliding()

func get_movement_state(state_name : String) -> Movementstate :
	match state_name:
		"idle":
			return idle_state
		"walk":
			return walk_state
		"run":
			return run_state
		"sprint":
			return sprint_state
		_:
			return idle_state
