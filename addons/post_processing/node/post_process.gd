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
@export_category("Screen Shake")
@export var ScreenShake: bool
@export var ScreenShakePower = 0.1;
@export_category("Analog Monitor")
@export var AnalogMonitor: bool
@export var AnalogMonitorResolution = Vector2(256, 256)
@export_category("Grain")
@export var Grain: bool
@export_range(0, 150, 0.1) var GrainPower = 75
@export_category("Circular Waves")
@export var CircularWaves: bool
@export_range(0,2, 0.01) var CircularWavesAmplitude = 2.0
@export_range(0, 15, 0.01) var CircularWavesFrequency = 12.69
@export_range(0.5, 150.0, 0.1) var CircularWavesRippleRate = 9.2
@export_category("Speed Lines")
@export var SpeedLines: bool
@export var SpeedLinesColor: Color = Color.WHITE
@export_range(0,2, 0.05) var SpeedLinesCount = 2
@export_range(0.0, 1.0) var SpeedLineDensity = 0.072
@export_range(1.0, 40.0, 1.0) var SpeedLineSpeed = 20;


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
		elif child.name == "ScreenShake":
			var data = child.get_child(0)
			data.material.set_shader_parameter("ShakeStrength", ScreenShakePower)
		elif child.name == "AnalogMonitor":
			var data = child.get_child(0)
			data.material.set_shader_parameter("res", AnalogMonitorResolution)
		elif child.name == "Grain":
			var data = child.get_child(0)
			data.material.set_shader_parameter("strength", GrainPower)
		elif child.name == "CircularWaves":
			var data = child.get_child(0)
			data.material.set_shader_parameter("amplitude", CircularWavesAmplitude)
			data.material.set_shader_parameter("frequency", CircularWavesFrequency)
			data.material.set_shader_parameter("rippleRate", CircularWavesRippleRate)
		elif child.name == "SpeedLines":
			var data = child.get_child(0)
			data.material.set_shader_parameter("line_color", SpeedLinesColor)
			data.material.set_shader_parameter("line_count", SpeedLinesCount)
			data.material.set_shader_parameter("line_density", SpeedLineDensity)
			data.material.set_shader_parameter("animation_speed", SpeedLineSpeed)


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
	if ScreenShake == true:
		for child in get_children():
			if child.name.begins_with("ScreenShake"):
				child.visible = true
	else:
		for child in get_children():
			if child.name.begins_with("ScreenShake"):
				child.visible = false
	if AnalogMonitor == true:
		for child in get_children():
			if child.name.begins_with("AnalogMonitor"):
				child.visible = true
	else:
		for child in get_children():
			if child.name.begins_with("AnalogMonitor"):
				child.visible = false
	if Grain == true:
		for child in get_children():
			if child.name.begins_with("Grain"):
				child.visible = true
	else:
		for child in get_children():
			if child.name.begins_with("Grain"):
				child.visible = false
	if CircularWaves == true:
		for child in get_children():
			if child.name.begins_with("CircularWaves"):
				child.visible = true
	else:
		for child in get_children():
			if child.name.begins_with("CircularWaves"):
				child.visible = false
	if SpeedLines == true:
		for child in get_children():
			if child.name.begins_with("SpeedLines"):
				child.visible = true
	else:
		for child in get_children():
			if child.name.begins_with("SpeedLines"):
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
	var scr_shk = load("res://addons/post_processing/node/children/screen_shake.tscn")
	add_child(scr_shk.instantiate())
	print("created SCR_SHK")
	var anl_mon = load("res://addons/post_processing/node/children/analog_monitor.tscn")
	add_child(anl_mon.instantiate())
	print("created ANL_MON")
	var grn = load("res://addons/post_processing/node/children/grain.tscn")
	add_child(grn.instantiate())
	print("created GRN")
	var cir_wav = load("res://addons/post_processing/node/children/circular_waves.tscn")
	add_child(cir_wav.instantiate())
	print("created CIR_WAV")
	var spd_lin = load("res://addons/post_processing/node/children/speed_lines.tscn")
	add_child(spd_lin.instantiate())
	print("created SDP_LIN")
	
	
	_update_shaders()




func _process(delta):
	if Engine.is_editor_hint() or !Engine.is_editor_hint():
		_update_shaders()
