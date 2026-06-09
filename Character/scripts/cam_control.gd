extends Node
## variables for camera system

@onready var h_node =$"h(yaw)"
@onready var w_node =$"h(yaw)/w(pitch)"
@onready var cam = $"h(yaw)/w(pitch)/Camera3D"

var h : float = 0
var w : float = 0
var h_sensitivity : float = 0.07
var w_sensitivity : float = 0.07
var h_acceleration : float = 10
var w_acceleration : float = 10

## functions and operations
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		h += -event.relative.x * h_sensitivity
		w += event.relative.y * w_sensitivity
		

func _physics_process(delta):
	h_node.rotation_degrees.y = lerp(h_node.rotation_degrees.y, h, h_acceleration * delta)
	w_node.rotation_degrees.y = lerp(w_node.rotation_degrees.x, w, w_acceleration * delta)

##https://www.youtube.com/watch?v=C-1AerTEjFU
