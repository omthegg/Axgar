@tool
extends StaticBody3D

## Only put static level geometry gltf scene as children of this.
class_name LevelBody

@export_tool_button("Refresh", "RotateRight") var refresh_action = refresh

@export var level_node:Node3D
@export var lightmap_texel_size:float = 0.1


func refresh() -> void:
	var mesh_instances:Array[MeshInstance3D] = []
	mesh_instances = get_mesh_instances()
	refresh_collision_shapes(mesh_instances)
	refresh_uv2_unwrapped_mesh_instances(mesh_instances)


func get_mesh_instances() -> Array[MeshInstance3D]:
	var children = level_node.get_children()
	var mesh_instances:Array[MeshInstance3D]
	for child in children:
		if child is MeshInstance3D:
			mesh_instances.append(child)
	
	return mesh_instances


func refresh_collision_shapes(mesh_instances:Array[MeshInstance3D]) -> void:
	for child in get_children():
		if child is CollisionShape3D:
			remove_child(child)
			child.queue_free()
	
	for mesh_instance in mesh_instances:
		var shape:Shape3D = mesh_instance.mesh.create_trimesh_shape()
		var col_shape:CollisionShape3D = CollisionShape3D.new()
		add_child(col_shape)
		col_shape.owner = get_tree().edited_scene_root
		col_shape.shape = shape
		col_shape.global_transform = mesh_instance.global_transform


func refresh_uv2_unwrapped_mesh_instances(mesh_instances:Array[MeshInstance3D]) -> void:
	for child in get_children():
		if child is MeshInstance3D:
			remove_child(child)
			child.queue_free()
	
	for mesh_instance in mesh_instances:
		var new_mesh_instance:MeshInstance3D = MeshInstance3D.new()
		add_child(new_mesh_instance)
		new_mesh_instance.owner = get_tree().edited_scene_root
		
		var old_mesh:Mesh = mesh_instance.mesh
		new_mesh_instance.mesh = ArrayMesh.new()
		for surface_id in range(old_mesh.get_surface_count()):
			new_mesh_instance.mesh.add_surface_from_arrays(
				Mesh.PRIMITIVE_TRIANGLES, 
				old_mesh.surface_get_arrays(surface_id)
			)
			var old_mat = old_mesh.surface_get_material(surface_id)
			new_mesh_instance.mesh.surface_set_material(surface_id, old_mat)
		
		new_mesh_instance.global_transform = mesh_instance.global_transform
		new_mesh_instance.mesh.lightmap_unwrap(new_mesh_instance.global_transform, lightmap_texel_size)
		new_mesh_instance.use_in_baked_light = true
