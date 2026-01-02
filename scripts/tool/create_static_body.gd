@tool
extends Node
class_name CreateStaticBody

# --- SETTINGS ---
const MODELS_FOLDER_PATH = "res://models/dungeon_assets/building"
const SAVE_PATH = "res://scenes"
# Options: "trimesh" (precise), "convex" (performant), or "multiple_convex"
const COLLISION_TYPE = "trimesh" 

static func run():
	var glbs = Common.get_glbs(MODELS_FOLDER_PATH)
	for glb_path in glbs:
		var glb_name = glb_path.split("/")[-1].split(".")[0]
		# 1. Load the GLB model
		var model_scene = load(glb_path)
		if not model_scene:
			printerr("Error: Could not load model.")
			continue
			
		var model_instance = model_scene.instantiate()
		
		# 2. Create the StaticBody3D Root
		var static_body = StaticBody3D.new()
		static_body.name = glb_name
		
		# 3. Find the MeshInstance3D inside the GLB
		var mesh_node: MeshInstance3D = null
		if model_instance is MeshInstance3D:
			mesh_node = model_instance
		else:
			# Search children if the GLB root is just a Node3D
			for child in model_instance.get_children():
				if child is MeshInstance3D:
					mesh_node = child
					break
		
		if not mesh_node:
			printerr("Error: No MeshInstance3D found in the GLB.")
			return

		# 4. Clean up parenting and move mesh to the new root
		var mesh_parent = mesh_node.get_parent()
		mesh_parent.owner = null
		static_body.add_child(mesh_parent)
		mesh_parent.owner = static_body # Important for saving scenes
		
		## 5. Generate Collision Shape
		## create_trimesh_collision() is a built-in helper for MeshInstance3D
		match COLLISION_TYPE:
			"trimesh":
				mesh_node.create_trimesh_collision()
			"convex":
				mesh_node.create_convex_collision()
			"multiple_convex":
				mesh_node.create_multiple_convex_collisions()
#
		## Set owners for the newly created collision children so they save
		var collision_parent = mesh_node.find_child(mesh_node.name + "_col")
		for child in collision_parent.get_children():
			collision_parent.remove_child(child)
			child.owner = null
			static_body.add_child(child)
			child.owner = static_body
		collision_parent.free()

		# 6. Save the Scene
		var packed_scene = PackedScene.new()
		var result = packed_scene.pack(static_body)
		
		if result == OK:
			var save_path = SAVE_PATH.path_join(glb_name + ".tscn")
			var save_error = ResourceSaver.save(packed_scene, save_path)
			if save_error == OK:
				print("Success! Scene saved to: ", save_path)
			else:
				printerr("Error saving scene: ", save_error)
		else:
			printerr("Error packing scene: ", result)

		# Clean up memory
		static_body.queue_free()
