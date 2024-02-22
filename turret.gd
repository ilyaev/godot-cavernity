extends Node3D

@export var angle := 0.
var normal := Vector3.UP
@export var index := 0
@export var delay := 1.1
@export var speed := 3.

var T := 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	rotate_z(angle)
	normal = Vector3.UP.rotated(Vector3.BACK, angle)
	position -= normal*.3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta
	if T > delay:
		$Animation.play("show")
		#await get_tree().create_timer(.5).timeout
		var bullet = preload("res://bullet.tscn")		
		var b = bullet.instantiate()
		b.position = position - normal *.5
		b.normal = normal
		b.speed = speed
		get_parent().add_child(b)
		T = 0.
		await get_tree().create_timer(1.).timeout
		$Animation.play("hide")
	pass
