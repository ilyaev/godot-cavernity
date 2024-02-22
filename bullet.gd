extends Node3D

var normal := Vector3.UP
@export var speed = 3.


var T := 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += normal * delta * speed
	T += delta
	if position.length() > 25:
		queue_free()
	pass
