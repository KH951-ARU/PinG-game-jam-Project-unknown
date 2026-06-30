extends Node
## variables for camera system

@onready var h_node =$"h(yaw)"
@onready var w_node =$"h(yaw)/w(pitch)"
@onready var cam = $"h(yaw)/w(pitch)/SpringArm3D/Camera3D"

var hyaw : float = 0
var wpitch : float = 0
var h_sensitivity : float = 0.07
var w_sensitivity : float = 0.07
var h_acceleration : float = 15
var w_acceleration : float = 15

var pitch_max : float = 75 
var pitch_min : float = -55

var tween : Tween

signal set_cam_rotation(_cam_rotation : float)


## functions and operations
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		hyaw += -event.relative.x * h_sensitivity
		wpitch += event.relative.y * w_sensitivity
		

func _physics_process(delta):
	wpitch = clamp( wpitch , pitch_min , pitch_max)
	
	h_node.rotation_degrees.y = lerp(h_node.rotation_degrees.y, hyaw, h_acceleration * delta)
	w_node.rotation_degrees.x = lerp(w_node.rotation_degrees.x, wpitch, w_acceleration * delta)
	
	set_cam_rotation.emit(h_node.rotation.y)
 
func _on_set_movement_state(_movement_state : Movementstate):
	if tween:
		tween.kill()
		
	tween = create_tween()
	tween.tween_property(cam, "fov",_movement_state.camera_fov,0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
