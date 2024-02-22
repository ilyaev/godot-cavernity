extends Node3D

@export var multiplier := .3;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(delta * PI/4 * multiplier)
	rotate_y(delta * PI/2 * multiplier)
	rotate_z(delta * PI/8 * multiplier)
