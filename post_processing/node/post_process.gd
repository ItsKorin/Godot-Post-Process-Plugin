@tool
extends CanvasLayer

@export_category("Post Process")
@export_category("Chromatic Aberration")
@export var ChromaticAberration: bool
@export var StrenghtCA: float = 1
@export_category("Blur")
@export var Blur: bool
@export_range(0.0, 5) var L_O_D = 1.0
@export_category("Fish Eye")
@export var FishEye: bool
@export_range(-2.5, 2.5) var FishEyeAmount: float
@export_category("Vignette")
@export var Vignette: bool
@export var VignetteIntensity = 0.4
@export_range(0.0, 1.0) var VignetteOpacity = 0.5
@export var VignetteR_G_B: Color = Color(0.0, 0.0, 0.0, 1.0);
@export_category("Glitch")
@export var Glitch: bool
@export_range(0.0, 0.1, 0.005) var GlitchRange = 0.05
@export_range(0.0, 300, 0.1) var GlitchNoiseQuality = 250.0
@export_range(-0.6, 0.6, 0.0010) var GlitchIntenity = 0.0088
@export_range(-0.1, 0.1, 0.001) var GlitchOffset = 0.03
@export_range(0.0, 5.0, 0.001) var GlitchColorOffset = 1.3
@export_category("Outline")
@export var Outline: bool
@export var OutlineColor: Color = Color(0.0, 0.0, 0.0, 1.0)
@export_range(0.0, 1.0) var OutlineThreshold = 0.0
@export_range(0.0, 1.0) var OutlineBlend = 0.01


#@export_category("Bloom")
var Bloom: bool = false
var BloomDirection = Vector2(0,0)
var BloomRadius = 0.0
var BloomIntensity = 0.0

func _update_shaders():
	for child in get_children():
		if child.name == "ChromaticAberration":
			var data = child.get_child(0)
			data.material.set_shader_parameter("offset", StrenghtCA)
		elif child.name == "Blur":
			var data = child.get_child(0)
			data.material.set_shader_parameter("lod", L_O_D)
		elif child.name == "FishEye":
			var data = child.get_child(0)
			data.material.set_shader_parameter("effect_amount", FishEyeAmount)
		elif child.name == "Vignette":
			var data = child.get_child(0)
			data.material.set_shader_parameter("vignette_intensity", VignetteIntensity)
			data.material.set_shader_parameter("vignette_opacity", VignetteOpacity)
			data.material.set_shader_parameter("vignette_rgb", VignetteR_G_B)
		elif child.name == "Glitch":
			var data = child.get_child(0)
			data.material.set_shader_parameter("range", GlitchRange)
			data.material.set_shader_parameter("noiseQuality", GlitchNoiseQuality)
			data.material.set_shader_parameter("noiseIntensity", GlitchIntenity)
			data.material.set_shader_parameter("offsetIntensity", GlitchOffset)
			data.material.set_shader_parameter("colorOffsetIntensity", GlitchColorOffset)
		elif child.name == "Outline":
			var data = child.get_child(0)
			data.material.set_shader_parameter("edge_color", OutlineColor)
			data.material.set_shader_parameter("threshold", OutlineThreshold)
			data.material.set_shader_parameter("blend", OutlineBlend)
			
	if ChromaticAberration == true:
		for child in get_children():
			if child.name.begins_with("ChromaticAberration"):
				child.visible = true
	else:
		for child in get_children():
			if child.name.begins_with("ChromaticAberration"):
					child.visible = false
		if Blur == true:
			for child in get_children():
				if child.name.begins_with("Blur"):
					child.visible = true
		else:
			for child in get_children():
				if child.name.begins_with("Blur"):
					child.visible = false
		if FishEye == true:
			for child in get_children():
				if child.name.begins_with("FishEye"):
					child.visible = true
		else:
			for child in get_children():
				if child.name.begins_with("FishEye"):
					child.visible = false
		if Vignette == true:
			for child in get_children():
				if child.name.begins_with("Vignette"):
					child.visible = true
		else:
			for child in get_children():
				if child.name.begins_with("Vignette"):
					child.visible = false
		if Glitch == true:
			for child in get_children():
				if child.name.begins_with("Glitch"):
					child.visible = true
		else:
			for child in get_children():
				if child.name.begins_with("Glitch"):
					child.visible = false
		if Outline == true:
			for child in get_children():
				if child.name.begins_with("Outline"):
					child.visible = true
		else:
			for child in get_children():
				if child.name.begins_with("Outline"):
					child.visible = false
					
					
					
func _enter_tree():
	var ca = load("res://addons/post_processing/node/children/ChromaticAberration.tscn")
	add_child(ca.instantiate())
	print("created CA")
	var bl = load("res://addons/post_processing/node/children/blur.tscn")
	add_child(bl.instantiate())
	print("created BL")
	var feye = load("res://addons/post_processing/node/children/fish_eye.tscn")
	add_child(feye.instantiate())
	print("created FEYE")
	var vin = load("res://addons/post_processing/node/children/vignette.tscn")
	add_child(vin.instantiate())
	print("created VIN")
	var gli = load("res://addons/post_processing/node/children/glitch.tscn")
	add_child(gli.instantiate())
	print("created GLI")
	var out = load("res://addons/post_processing/node/children/outline.tscn")
	add_child(out.instantiate())
	print("created OUT")
	
	
	_update_shaders()




func _process(delta):
	if Engine.is_editor_hint() or !Engine.is_editor_hint():
		_update_shaders()
