@tool
extends CanvasLayer

@export_category("Post Process")
@export_category("Chromatic Aberration")
@export var ChromaticAberration: bool
@export var StrenghtCA: float = 1
@export_category("Blur")
@export var Blur: bool
@export_range(0.0, 5) var L_O_D = 1.0
#@export_category("Bloom")
var Bloom: bool = false
var BloomDirection = Vector2(0,0)
var BloomRadius = 0.0
var BloomIntensity = 0.0

func _enter_tree():
	var ca = load("res://addons/post_processing/node/children/ChromaticAberration.tscn")
	add_child(ca.instantiate())
	print("created CA")
	var bl = load("res://addons/post_processing/node/children/blur.tscn")
	add_child(bl.instantiate())
	print("created BL")
	var blr = load("res://addons/post_processing/node/children/Bloom.tscn")
	add_child(blr.instantiate())
	print("created BLR")

func _process(delta):
	if Engine.is_editor_hint() or !Engine.is_editor_hint():
		for child in get_children():
			if child.name == "ChromaticAberration":
				var data = child.get_child(0)
				data.material.set_shader_parameter("offset", StrenghtCA)
			elif child.name == "Blur":
				var data = child.get_child(0)
				data.material.set_shader_parameter("lod", L_O_D)
			elif child.name == "Bloom":
				var data = child.get_child(0)
				data.material.set_shader_parameter("blur_direction", BloomDirection)
				data.material.set_shader_parameter("blur_radius", BloomRadius)
				data.material.set_shader_parameter("blur_amount", BloomIntensity)
			
			
		if ChromaticAberration == true:
			for child in get_children():
				if child.name == "ChromaticAberration":
					child.visible = true
		else:
			for child in get_children():
				if child.name == "ChromaticAberration":
					child.visible = false
		if Blur == true:
			for child in get_children():
				if child.name == "Blur":
					child.visible = true
		else:
			for child in get_children():
				if child.name == "Blur":
					child.visible = false
		if Bloom == true:
			for child in get_children():
				if child.name == "Bloom":
					child.visible = true
		else:
			for child in get_children():
				if child.name == "Bloom":
					child.visible = false


