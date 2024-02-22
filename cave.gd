@tool
extends MeshInstance3D

@export var offset := 0.:
	set(new_offset):
		# print("SET:", new_offset)
		set_instance_shader_parameter("offset", new_offset)
		offset = new_offset

# Called when the node enters the scene tree for the first time.
func _ready():
	set_instance_shader_parameter("offset", offset)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
