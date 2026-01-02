@tool
extends Node

@export var set_external_material: bool = false:
	set(value):
		if value == true:
			SetExternalMaterial.run()
		set_external_material = false

@export var create_static_body: bool = false:
	set(value):
		if value == true:
			CreateStaticBody.run()
		create_static_body = false
