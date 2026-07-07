extends Node
class_name Stance

@export_category("movement stances")
@export var idle_state : Movementstate
@export var walk_state : Movementstate
@export var run_state : Movementstate
@export var sprint_state : Movementstate

@export_category("camera data")
@export var camera_height : float = 1.3

@export_category("collisioon data")
@export var col_raycast : RayCast3D
@export var collider : CollisionObject3D
@export var higher_stances :Array[Stance]
