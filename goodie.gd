extends Node3D


@export var angle := 0.
var normal := Vector3.UP
@export var index := 0
@export var shift := 0

@export var multiplier = 1.

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_z(angle)
	normal = Vector3.UP.rotated(Vector3.BACK, angle)


func _physics_process(delta):
	rotate_x(delta * PI/4 * multiplier)
	rotate_y(delta * PI/2 * multiplier)
	rotate_z(delta * PI/8 * multiplier)



func _on_area_3d_body_entered(body):
	if body is Ship:
		queue_free()
