@tool
extends CanvasLayer

@export_category("Post Process")
@export var configuration : PostProcessingConfiguration

func _update_shaders() -> void:
	if not configuration:
		return
	for child in get_children():
		var data : ColorRect = child.get_child(0)
		if data:
			_update_shader_parameters(data.name, data.material)
		child.visible = _check_shader_visibility(child.name)
	return

func _update_shader_parameters( _name : String, _material : Material) -> void:
	match _name:
		"ChromaticAberration":
			_material.set_shader_parameter("offset", configuration.StrenghtCA)
		"Blur":
			_material.set_shader_parameter("lod", configuration.L_O_D)
		"FishEye":
			_material.set_shader_parameter("aspect", configuration.FishEyeAspect)
			_material.set_shader_parameter("distortion", configuration.FishEyeDistortion)
			_material.set_shader_parameter("radius", configuration.FishEyeRadius)
			_material.set_shader_parameter("alpha", configuration.FishEyeAlpha)
			_material.set_shader_parameter("crop", configuration.FishEyeCrop)
			_material.set_shader_parameter("crop_color", configuration.FishEyeCropColor)
		"Vignette":
			_material.set_shader_parameter("vignette_intensity", configuration.VignetteIntensity)
			_material.set_shader_parameter("vignette_opacity", configuration.VignetteOpacity)
			_material.set_shader_parameter("vignette_rgb", configuration.VignetteR_G_B)
		"Glitch":
			_material.set_shader_parameter("range", configuration.GlitchRange)
			_material.set_shader_parameter("noiseQuality", configuration.GlitchNoiseQuality)
			_material.set_shader_parameter("noiseIntensity", configuration.GlitchIntenity)
			_material.set_shader_parameter("offsetIntensity", configuration.GlitchOffset)
			_material.set_shader_parameter("colorOffsetIntensity", configuration.GlitchColorOffset)
		"Outline":
			_material.set_shader_parameter("edge_color", configuration.OutlineColor)
			_material.set_shader_parameter("threshold", configuration.OutlineThreshold)
			_material.set_shader_parameter("blend", configuration.OutlineBlend)
		"ScreenShake":
			_material.set_shader_parameter("ShakeStrength", configuration.ScreenShakePower)
		"AnalogMonitor":
			_material.set_shader_parameter("res", configuration.AnalogMonitorResolution)
		"Grain":
			_material.set_shader_parameter("strength", configuration.GrainPower)
		"CircularWaves":
			_material.set_shader_parameter("amplitude", configuration.CircularWavesAmplitude)
			_material.set_shader_parameter("frequency", configuration.CircularWavesFrequency)
			_material.set_shader_parameter("rippleRate", configuration.CircularWavesRippleRate)
		"SpeedLines":
			_material.set_shader_parameter("line_color", configuration.SpeedLinesColor)
			_material.set_shader_parameter("line_count", configuration.SpeedLinesCount)
			_material.set_shader_parameter("line_density", configuration.SpeedLineDensity)
			_material.set_shader_parameter("animation_speed", configuration.SpeedLineSpeed)
		"Ascii":
			_material.set_shader_parameter("ascii_size", configuration.ASCIISize)

func _check_shader_visibility(_name: String) -> bool:
	
		if _name.begins_with("ChromaticAberration"):
			return true if configuration.ChromaticAberration else false
		
		if _name.begins_with("Blur"):
			return true if configuration.Blur else false
			
		if _name.begins_with("FishEye"):
			return true if configuration.FishEye else false
		
		if _name.begins_with("Vignette"):
			return true if configuration.Vignette else false
		
		if _name.begins_with("Glitch"):
			return true if configuration.Glitch else false
		
		if _name.begins_with("Outline"):
			return true if configuration.Outline else false
		
		if _name.begins_with("ScreenShake"):
			return true if configuration.ScreenShake else false
		
		if _name.begins_with("AnalogMonitor"):
			return true if configuration.AnalogMonitor else false

		if _name.begins_with("Grain"):
			return true if configuration.Grain else false
		
		if _name.begins_with("CircularWaves"):
			return true if configuration.CircularWaves else false
		
		if _name.begins_with("SpeedLines"):
			return true if configuration.SpeedLines else false

		if _name.begins_with("Ascii"):
			return true if configuration.ASCII else false
		
		push_error("#Undefined type Post Processing addon - verify it has been properly integrated.")
		return false # bad!

func _enter_tree():
	
	_add_canvas_layer_children("res://addons/post_processing/node/children/ChromaticAberration.tscn", "CA")
	_add_canvas_layer_children("res://addons/post_processing/node/children/blur.tscn", "BL")
	_add_canvas_layer_children("res://addons/post_processing/node/children/fish_eye.tscn", "FEYE")
	_add_canvas_layer_children("res://addons/post_processing/node/children/vignette.tscn", "VIN")
	_add_canvas_layer_children("res://addons/post_processing/node/children/glitch.tscn", "GLI")
	_add_canvas_layer_children("res://addons/post_processing/node/children/outline.tscn", "OUT")
	_add_canvas_layer_children("res://addons/post_processing/node/children/screen_shake.tscn", "SCR_SHK")
	_add_canvas_layer_children("res://addons/post_processing/node/children/analog_monitor.tscn", "ANL_MON")
	_add_canvas_layer_children("res://addons/post_processing/node/children/grain.tscn", "GRN")
	_add_canvas_layer_children("res://addons/post_processing/node/children/circular_waves.tscn", "CIR_WAV")
	_add_canvas_layer_children("res://addons/post_processing/node/children/speed_lines.tscn", "SDP_LIN")
	_add_canvas_layer_children("res://addons/post_processing/node/children/ascii.tscn", "ASCII")
	
	_update_shaders() 

func _add_canvas_layer_children(_path : String, _name: String) -> void:
	add_child(load(_path).instantiate())
	print_debug("Successfully added child canvas-layer: " + _name + " to PostProcess adddon node.")

func _process(delta):
	if not configuration:
		return
	if Engine.is_editor_hint() or !Engine.is_editor_hint():
		if configuration.reload == true:
			_update_shaders()
			configuration.reload = false
