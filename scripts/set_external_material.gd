extends Node
class_name SetExternalMaterial

static func run():
	print("starts: execute_my_task")
	var assets_folder_path = "res://models/dungeon_assets/building"
	var material_path = "res://models/dungeon_assets/building/dungeon_mat.tres"
	var uid_path = "uid://dqvk6wl0edkgu"
	var glbs = get_glbs(assets_folder_path)
	for glb_path in glbs:
		update_glb(glb_path, material_path, uid_path)
	print("completed: execute_my_task")

static func get_glbs(path: String):
	var glbs = []
	if DirAccess.dir_exists_absolute(path):
		var files = DirAccess.get_files_at(path)
		for file_name in files:
			if file_name.ends_with(".glb"):
				var full_path = path.path_join(file_name)
				glbs.append(full_path)
	else:
		print("The directory does not exist!")
		
	return glbs

static func update_glb(model_path: String, material_path: String, uid_path: String):
	var config = ConfigFile.new()
	var import_file_path = model_path + ".import"
	
	if config.load(import_file_path) != OK:
		print("Could not load .import file")
		return
	
	var subresources = config.get_value("params", "_subresources", {})
	
	if subresources.has("materials"):
		print("materials already exists: ", model_path)
		return
	
	print("Setting external material for: ", model_path)
	var materials = {}
	subresources["materials"] = materials

	var dungeon_mat = {}
	materials["DungeonMat"] = dungeon_mat
	
	dungeon_mat["use_external/enabled"] = true
	dungeon_mat["use_external/fallback_path"] = material_path
	dungeon_mat["use_external/path"] = uid_path

	config.set_value("params", "_subresources", subresources)
	
	var err = config.save(import_file_path)
	if err == OK:
		EditorInterface.get_resource_filesystem().reimport_files([model_path])
		print("Successfully updated: ", model_path)
