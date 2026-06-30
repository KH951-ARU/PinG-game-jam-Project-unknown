extends Node


@export var animation_tree : AnimationTree
@export var player : CharacterBody3D

var tween : Tween



func _on_set_movement_state(_movement_state: Movementstate):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(animation_tree, "parameters/Movement_blend/blend_position", _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree, "parameters/Movement_animation_speed/scale" , _movement_state.animationspeed, 0.7)
	pass # Replace with function body.
