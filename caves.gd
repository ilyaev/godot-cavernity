extends Node3D

@export var offset = -.1;
@export var global_offset := 0.;
@export var direction := 1.

var speed = .7;
var block = -1.;

var block_size := 10.

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.offset += global_offset
	pass # Replace with function body.


func get_last_block():
	var result
	var x = -100000.
	for child in get_children():
		if child.position.x > x:
			x = child.position.x
			result = child
	return result

func get_first_block():
	var result
	var x = 100000.
	for child in get_children():
		if child.position.x < x:
			x = child.position.x
			result = child
	return result

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var step = delta * speed * direction
	offset -= step

	for child in get_children():
		child.position.x -= step

	var next_block = floor(offset / block_size)

	if next_block < block:
		block = next_block
		var first_block = get_first_block()
		first_block.position.x += 3. * block_size - .05
		first_block.offset += 3. * block_size;
	elif next_block > block:
		block = next_block
		var last_block = get_last_block()
		last_block.position.x -= 3. * block_size - 0.03;
		last_block.offset -= 3. * block_size;

	pass
