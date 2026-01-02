extends Node
class_name SetExternalMaterial

const MODELS_FOLDER_PATH = "res://models/dungeon_assets/building"
const MATERIAL_PATH = "res://models/dungeon_assets/building/dungeon_mat.tres"
const UID_PATH = "uid://dqvk6wl0edkgu"

static func run():
	var glbs = Common.get_glbs(MODELS_FOLDER_PATH)
	for glb_path in glbs:
		var config = ConfigFile.new()
		var import_file_path = glb_path + ".import"

		if config.load(import_file_path) != OK:
			print("Could not load .import file")
			continue

		var subresources = config.get_value("params", "_subresources", {})

		if subresources.has("materials"):
			print("materials already exists: ", glb_path)
			continue
		
		print("Setting external material for: ", glb_path)
		var materials = {}
		subresources["materials"] = materials

		var dungeon_mat = {}
		materials["DungeonMat"] = dungeon_mat
		
		dungeon_mat["use_external/enabled"] = true
		dungeon_mat["use_external/fallback_path"] = MATERIAL_PATH
		dungeon_mat["use_external/path"] = UID_PATH

		config.set_value("params", "_subresources", subresources)

		var err = config.save(import_file_path)
		if err == OK:
			EditorInterface.get_resource_filesystem().reimport_files([glb_path])
			print("Successfully updated: ", glb_path)
