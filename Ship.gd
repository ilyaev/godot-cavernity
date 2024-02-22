class_name Ship
extends RigidBody3D


signal on_collide

var rotation_speed = 5.

# Called when the node enters the scene tree for the first time.
func _ready():
	$Thruster.stop()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Thruster.is_active:
		$ufo.rotate_y(delta*rotation_speed)		
	pass

func thrust(is_thurst: bool):
	if is_thurst:
		$Thruster.start()
	else:
		$Thruster.stop()

func _integrate_forces(state: PhysicsDirectBodyState3D):
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var contact_pos = state.get_contact_collider_position(i)
		var is_bullet = state.get_contact_collider_object(i).get_meta('is_bullet', false)
		var obj = false
		if is_bullet:
			obj = state.get_contact_collider_object(i).get_parent().get_parent()
		on_collide.emit(contact_pos, is_bullet, obj)
