@tool
extends Node

# This creates a checkbox in the Inspector
@export var trigger_automation: bool = false:
	set(value):
		if value == true:
			execute_my_task()
		# We don't actually need to store the 'true' value
		trigger_automation = false 

func execute_my_task():
	print("Automating properties...")
	print(get_glbs())

func get_glbs():
	var path = "res://models/dungeon_assets/building"
	var glbs = []
	if DirAccess.dir_exists_absolute(path):
		var files = DirAccess.get_files_at(path)
		for file_name in files:
			if file_name.ends_with(".glb"):
				print("Found model: ", file_name)
				glbs.append(file_name)
	else:
		print("The directory does not exist!")
		
	return glbs
	
