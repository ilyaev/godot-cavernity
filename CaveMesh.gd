@tool
extends Node3D

@export var density := 10
@export var offset := 0
@export var is_primary := false
var step := 1.
var index := 0.0
@export var base_height := .3



var block := -1
@export var direction := 1

var speed = 4.
var depth = 1.

var T:=0.

@export var noise_multiplier := 1.
@export var noise2_multiplier := 1.

@export var noise: FastNoiseLite:
	set(new_noise):
		noise = new_noise


@export var noise2: FastNoiseLite:
	set(new_noise):
		noise2 = new_noise

var shader_code : Shader = preload("res://cave.gdshader")



func get_bar_height(i):
	var nv = noise.get_noise_2d(1., i)
	var nv2 = noise2.get_noise_2d(1., i)
	var h = base_height + abs(nv)*noise_multiplier + abs(nv2)*noise2_multiplier
	return h

func get_bar_height_opposite(i):
	var _offset = 345
	var _x = 5
	var opposite_i = _offset + 20 - i - _x
	return get_parent().get_node("CaveMeshTop").get_bar_height(opposite_i)

func build_mesh(mesh_offset):
	var surface = SurfaceTool.new()
	var _mesh = ArrayMesh.new()

	surface.clear()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_smooth_group(-1)

	var verts = []

	for i in range(density):
		var h = get_bar_height(i + mesh_offset)

		var v1 = Vector3(i*step, 0, 0)
		var v2 = Vector3(i*step, h, 0)

		var v3 = v1 - Vector3(0., 0., depth)
		var v4 = v2 - Vector3(0., -0.0, depth)

		verts.append(v1)
		verts.append(v2)
		verts.append(v3)
		verts.append(v4)

	for i in range(density - 1):
		var offset = i * 4.;

		var v1 = verts[offset]
		var v2 = verts[offset+1]
		var v11 = verts[offset+2]
		var v22 = verts[offset+3]
		var v3 = verts[offset+4]
		var v4 = verts[offset+5]
		var v33 = verts[offset+6]
		var v44 = verts[offset+7]

		# Front

		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v1)
		surface.set_uv(Vector2(0,1))
		surface.add_vertex(v2)
		surface.set_uv(Vector2(1,0))
		surface.add_vertex(v3)

		surface.set_uv(Vector2(1,0))
		surface.add_vertex(v3)
		surface.set_uv(Vector2(0,1))
		surface.add_vertex(v2)
		surface.set_uv(Vector2(1,1))
		surface.add_vertex(v4)

		# Back

		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v33)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v22)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v11)

		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v44)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v22)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v33)

		# Top

		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v2)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v22)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v44)

		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v4)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v2)
		surface.set_uv(Vector2(0,0))
		surface.add_vertex(v44)



	surface.index()
	surface.generate_normals()
	surface.generate_tangents()

	surface.commit(_mesh)

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.set_mesh(_mesh)
	mesh_instance.position = Vector3(0, 0, 0)

	# var material = StandardMaterial3D.new()
	# material.albedo_color = Color(.9, .3, .1) # Red color

	var material = ShaderMaterial.new()
	material.set_shader(shader_code)

	mesh_instance.material_override = material
	mesh_instance.create_trimesh_collision()
	mesh_instance.set_meta("offset", mesh_offset)

	populate(mesh_instance)

	return mesh_instance

func rebuild_shape():
	for child in get_children():
		child.queue_free()

	var center = build_mesh(offset)
	var left = build_mesh(offset - (density - 1))
	var right = build_mesh(offset + (density - 1))

	center.position.x = 0 - (density/2.)*step
	left.position.x = center.position.x - (density)*step + step
	right.position.x = center.position.x + (density)*step - step

	#left.hide()
	#right.hide()

	add_child(left)
	add_child(center)
	add_child(right)

func populate(mesh : MeshInstance3D):
	var goodie = preload("res://goodie.tscn")
	var turret = preload("res://turret.tscn")
	var rock = preload("res://rock.tscn")
	var _offset = mesh.get_meta("offset", 0)
	var last_rock = -1
	var last_turret = -1
	for i in range(density):
		var _index = _offset + i
		var h = get_bar_height(_index)
		var next_h = get_bar_height(_index + 1)
		var a = atan(next_h - h)
		
		if is_primary:
			var rock_pos = is_rock_fit_to(_index)
			if rock_pos > 0 && (i - last_rock) > 5.:
				last_rock = i
				var rockmesh = rock.instantiate()
				rockmesh.position = Vector3(i, rock_pos, 0.)
				rockmesh.multiplier = .5
				if !Engine.is_editor_hint():
					rockmesh.multiplier += GlobalNoise.r21(32.22, _index * 10) - .2
				mesh.add_child(rockmesh)

		if Engine.is_editor_hint() || GlobalNoise.r21(_index*10., 123.22) > .2:
			if i < density - 2 && (i - last_rock) > 2. && (i - last_turret) > 2.:
				var t = turret.instantiate()
				last_turret = i
				t.position.y = h + (next_h - h)/2.
				t.position.x = i*step + step/2.
				t.position.z = -depth/2.
				t.angle = a
				t.index = _index
				t.delay = 3. + abs(noise.get_noise_2d(323.33, _index) * 2.)
				t.speed = 1. + abs(noise.get_noise_2d(2323.33, _index/2) * 2.)
				mesh.add_child(t)

		if Engine.is_editor_hint() || GlobalNoise.r21(_index, 23.22) > .2:
			if i < density - 2 && (i - last_rock) > 2.:
				var g = goodie.instantiate()
				g.shift = noise.get_noise_2d(2., _index)
				g.position.y = h + (next_h - h)/2. + abs(noise.get_noise_2d(2., _index*3.) * 5.) + 1.
				g.position.x = i*step + step/2.
				g.position.z = -depth/2.
				g.angle = a
				g.index = _index
				g.multiplier += 1. + noise.get_noise_2d(3., _index) * 2. - .5
				mesh.add_child(g)
	pass

func is_rock_fit_to(_index):
	var indexes = [_index - 1, _index, _index + 1]
	var dists = []
	for i in indexes:
		var h = get_bar_height(i)
		var oh = get_bar_height_opposite(i)
		dists.append(5 - h + 5 - oh)
		
	var all = 0
	for i in dists:
		all += i
	
	var m = all/dists.size()
	
	if m > 6.7:
		if Engine.is_editor_hint():
			return 5.
		var r = abs(GlobalNoise.r21(33.22, _index*100.)*2.)
		if r > .4:
			return get_bar_height(_index) + 2.
		elif r > .3:
			return 5.
		elif r > .2:
			return 5 + (5. - get_bar_height_opposite(_index)) - 2.
	return -1
	pass

func _ready():
	rebuild_shape()

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

func _process(delta):
	if Engine.is_editor_hint():
		if !T:
			T = 0
		T  = T + delta
		if T > 1.:
			T = 0.
			rebuild_shape()
		return

	var move_step = delta * speed * direction
	var block_size = ((density-1)*step)

	index -= move_step

	for child in get_children():
		child.position.x -= move_step

	var next_block = floor(index / block_size)
	# print([index, block, next_block])

	if next_block < block:
		# print([block, next_block])
		block = next_block
		var first_block = get_first_block()
		var last_block = get_last_block()
		var next = build_mesh(offset - (block+1)*(density-1) + (density-1))
		next.position.x = last_block.position.x + (density-1)*step
		first_block.queue_free()
		add_child(next)
	elif next_block > block:
		block = next_block
		var last_block = get_last_block()
		var first_block = get_first_block()
		var next = build_mesh(offset - (block+1)*(density-1) - (density-1))
		next.position.x = first_block.position.x - (density-1)*step
		last_block.queue_free()
		add_child(next)


	pass
