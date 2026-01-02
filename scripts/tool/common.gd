extends Node
class_name Common

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
