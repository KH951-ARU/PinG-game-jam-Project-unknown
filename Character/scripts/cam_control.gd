extends Node
## variables for camera system

@onready var h_node =$"h(yaw)"
@onready var w_node =$"h(yaw)/w(pitch)"
@onready var cam = $"h(yaw)/w(pitch)/Camera3D"

var h : float = 0
var w : float = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
