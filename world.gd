extends Node3D

const speed = 1.;
#var index := 0.;
var direction = -1.;
var ship_speed = 1.;
var speed_decay = .4;

@export var gravity_magnitude = .5;

func fract(value: float) -> float:
	return value - floor(value)

func _ready():
	%Ship.on_collide.connect(on_ship_collide)
	pass # Replace with function body.
	
func _process(delta):
	var index = ceil(abs(%CaveMeshBottom.index) - 1)
	var h = %CaveMeshBottom.get_bar_height(index)
	var oh = %CaveMeshBottom.get_bar_height_opposite(index)
	%Beacon.position.y = h + %CaveMeshBottom.position.y
	%Beacon2.position.y = %CaveMeshTop.position.y - oh

func on_ship_collide(pos: Vector3, is_bullet: bool, obj):
	var x = pos.x - %CaveMeshBottom.index - 1.;
	var ship_offset = %Ship.position.x
	var bar = ceil(x - ship_offset)
	var bar_height = %CaveMeshBottom.get_bar_height(bar)
	#%Beacon.position.y = bar_height + %CaveMeshBottom.position.y

	if is_bullet:
		obj.queue_free()
		return
		
	stop_motion()

func _input(event):
	if event is InputEventKey:
		if event.is_action("ui_accept") && event.is_pressed():
			%Ship.gravity_scale = -1 * gravity_magnitude
			start_motion()
			%Ship.thrust(true)
		else:
			%Ship.gravity_scale = 1 * gravity_magnitude
			%Ship.thrust(false)


#func _process(delta):
	#index += delta * speed;

func start_motion():
	%CaveMeshBottom.speed = 3.
	%CaveMeshTop.speed = 3.
	%BGCavesBottom.speed = %CaveMeshBottom.speed / 3.
	%BGCavesTop.speed = %CaveMeshTop.speed / 3.
	
	
func stop_motion():
	%CaveMeshBottom.speed = 0.
	%CaveMeshTop.speed = 0.
	%BGCavesBottom.speed = 0.
	%BGCavesTop.speed = 0.
	


func _on_ship_body_entered(body):
	print("Collide: ", body)
	if body.get_meta("is_goodie", false) == true:
		print("Goodie!")
		body.queue_free()
	pass # Replace with function body.
