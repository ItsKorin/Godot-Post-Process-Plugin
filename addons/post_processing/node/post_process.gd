@tool
extends CanvasLayer
class_name PostProcess

enum EffectType {
	ANALOG_MONITOR,
	ASCII,
	BLUR,
	CHROMATIC_ABERRATION,
	CIRCULAR_WAVES,
	COLOR_CORRECTION,
	CRT,
	DIRECTIONAL_DRIFT,
	FISHEYE,
	GLITCH,
	GRAIN,
	OUTLINE,
	PALETTE,
	PARTICLE_STORM,
	PIXELATE,
	SCREEN_SHAKE,
	SPEED_LINES,
	VIGNETTE,
}

## Stores the instantiated color rect of an effect keyed to its EffectType
var effects: Dictionary = {}

@export_category("Post Process")
@export var configuration : PostProcessingConfiguration
@export var dynamically_update : bool = true


func update_shaders() -> void:
	if not configuration:
		return
	for e in effects:
		var effect_canvas = effects[e]
		if effect_canvas:
			var effect_rect: ColorRect = effect_canvas.get_child(0)
			if effect_rect:
				_update_shader_parameters(e, effect_rect.material)
				effect_canvas.visible = _check_shader_visibility(e)


func _update_shader_parameters( _type : EffectType, _material : Material) -> void:
	match _type:
		EffectType.PALETTE:
			_material.set_shader_parameter("palette", configuration.PalettePalette)
		EffectType.PIXELATE:
			_material.set_shader_parameter("pixelSize", configuration.PixelatePixelSize)
		EffectType.COLOR_CORRECTION:
			_material.set_shader_parameter("tint", configuration.ColorCorrectionTint)
			_material.set_shader_parameter("brightness", configuration.ColorCorrectionBrightness)
			_material.set_shader_parameter("saturation", configuration.ColorCorrectionSaturation)
		EffectType.CHROMATIC_ABERRATION:
			_material.set_shader_parameter("offset", configuration.StrenghtCA)
		EffectType.BLUR:
			_material.set_shader_parameter("lod", configuration.L_O_D)
		EffectType.FISHEYE:
			_material.set_shader_parameter("aspect", configuration.FishEyeAspect)
			_material.set_shader_parameter("distortion", configuration.FishEyeDistortion)
			_material.set_shader_parameter("radius", configuration.FishEyeRadius)
			_material.set_shader_parameter("alpha", configuration.FishEyeAlpha)
			_material.set_shader_parameter("crop", configuration.FishEyeCrop)
			_material.set_shader_parameter("crop_color", configuration.FishEyeCropColor)
		EffectType.VIGNETTE:
			_material.set_shader_parameter("vignette_intensity", configuration.VignetteIntensity)
			_material.set_shader_parameter("vignette_opacity", configuration.VignetteOpacity)
			_material.set_shader_parameter("vignette_rgb", configuration.VignetteR_G_B)
		EffectType.GLITCH:
			_material.set_shader_parameter("range", configuration.GlitchRange)
			_material.set_shader_parameter("noiseQuality", configuration.GlitchNoiseQuality)
			_material.set_shader_parameter("noiseIntensity", configuration.GlitchIntenity)
			_material.set_shader_parameter("offsetIntensity", configuration.GlitchOffset)
			_material.set_shader_parameter("colorOffsetIntensity", configuration.GlitchColorOffset)
		EffectType.OUTLINE:
			_material.set_shader_parameter("edge_color", configuration.OutlineColor)
			_material.set_shader_parameter("threshold", configuration.OutlineThreshold)
			_material.set_shader_parameter("blend", configuration.OutlineBlend)
		EffectType.SCREEN_SHAKE:
			_material.set_shader_parameter("ShakeStrength", configuration.ScreenShakePower)
		EffectType.ANALOG_MONITOR:
			_material.set_shader_parameter("res", configuration.AnalogMonitorResolution)
		EffectType.GRAIN:
			_material.set_shader_parameter("strength", configuration.GrainPower)
		EffectType.CIRCULAR_WAVES:
			_material.set_shader_parameter("amplitude", configuration.CircularWavesAmplitude)
			_material.set_shader_parameter("frequency", configuration.CircularWavesFrequency)
			_material.set_shader_parameter("rippleRate", configuration.CircularWavesRippleRate)
		EffectType.SPEED_LINES:
			_material.set_shader_parameter("line_color", configuration.SpeedLinesColor)
			_material.set_shader_parameter("line_count", configuration.SpeedLinesCount)
			_material.set_shader_parameter("line_density", configuration.SpeedLineDensity)
			_material.set_shader_parameter("animation_speed", configuration.SpeedLineSpeed)
		EffectType.ASCII:
			_material.set_shader_parameter("ascii_size", configuration.ASCIISize)
		EffectType.CRT:
			_material.set_shader_parameter("overlay", configuration.overlay)
			_material.set_shader_parameter("scanlines_opacity", configuration.scanlines_opacity)
			_material.set_shader_parameter("scanlines_width", configuration.scanlines_width)
			_material.set_shader_parameter("grille_opacity", configuration.grille_opacity)
			_material.set_shader_parameter("pixelate", configuration.pixelate)
			_material.set_shader_parameter("roll_speed", configuration.roll_speed)
			_material.set_shader_parameter("roll_size", configuration.roll_size)
			_material.set_shader_parameter("roll_variation", configuration.roll_variation)
			_material.set_shader_parameter("distort_intensity", configuration.distort_intensity)
			_material.set_shader_parameter("noise_opacity", configuration.noise_opacity)
			_material.set_shader_parameter("noise_speed", configuration.noise_speed)
			_material.set_shader_parameter("static_noise_intensity", configuration.static_noise_intensity)
			_material.set_shader_parameter("aberration", configuration.aberration)
			_material.set_shader_parameter("brightness", configuration.brightness)
			_material.set_shader_parameter("discolor", configuration.discolor)
			_material.set_shader_parameter("warp_amount", configuration.warp_amount)
			_material.set_shader_parameter("clip_warp", configuration.clip_warp)
			_material.set_shader_parameter("vignette_intensity", configuration.vignette_intensity)
			_material.set_shader_parameter("vignette_opacity", configuration.vignette_opacity)
		EffectType.PARTICLE_STORM:  # Add new case
			_material.set_shader_parameter("particle_color", configuration.particle_storm_color)
			_material.set_shader_parameter("wind_direction", configuration.particle_storm_wind_direction)
			_material.set_shader_parameter("wind_speed", configuration.particle_storm_wind_speed)
			_material.set_shader_parameter("intensity", configuration.particle_storm_intensity)
			_material.set_shader_parameter("chaos", configuration.particle_storm_chaos)
			_material.set_shader_parameter("scale", configuration.particle_storm_scale)
			_material.set_shader_parameter("density", configuration.particle_storm_density)
		EffectType.DIRECTIONAL_DRIFT:
			_material.set_shader_parameter("particle_color", configuration.directional_drift_color)
			_material.set_shader_parameter("particle_density", configuration.directional_drift_density)
			_material.set_shader_parameter("flow_speed", configuration.directional_drift_speed)
			_material.set_shader_parameter("pattern_scale", configuration.directional_drift_scale)
			_material.set_shader_parameter("flow_direction", configuration.directional_drift_direction)
			_material.set_shader_parameter("layer_velocity_ratio", configuration.directional_drift_layer_ratio)
		_:
			push_error("Unhandled/Invalid EffectType: " + str(_type))


func _check_shader_visibility(_type: EffectType) -> bool:
	match _type:
		EffectType.ASCII:
			return configuration.ASCII
		EffectType.ANALOG_MONITOR:
			return configuration.AnalogMonitor
		EffectType.BLUR:
			return configuration.Blur
		EffectType.CHROMATIC_ABERRATION:
			return configuration.ChromaticAberration
		EffectType.CIRCULAR_WAVES:
			return configuration.CircularWaves
		EffectType.COLOR_CORRECTION:
			return configuration.ColorCorrection
		EffectType.CRT:
			return configuration.CRT
		EffectType.GLITCH:
			return configuration.Glitch
		EffectType.GRAIN:
			return configuration.Grain
		EffectType.FISHEYE:
			return configuration.FishEye
		EffectType.OUTLINE:
			return configuration.Outline
		EffectType.PALETTE:
			return configuration.Palette
		EffectType.PIXELATE:
			return configuration.Pixelate
		EffectType.SCREEN_SHAKE:
			return configuration.ScreenShake
		EffectType.SPEED_LINES:
			return configuration.SpeedLines
		EffectType.VIGNETTE:
			return configuration.Vignette
		EffectType.PARTICLE_STORM:
			return configuration.particle_storm
		EffectType.DIRECTIONAL_DRIFT:
			return configuration.directional_drift
		_:
			push_error("Unhandled/Invalid EffectType: " + str(_type))
			return false


func _ready():
	_add_canvas_layer_children("res://addons/post_processing/node/children/ChromaticAberration.tscn", EffectType.CHROMATIC_ABERRATION)
	_add_canvas_layer_children("res://addons/post_processing/node/children/blur.tscn", EffectType.BLUR)
	_add_canvas_layer_children("res://addons/post_processing/node/children/fish_eye.tscn", EffectType.FISHEYE)
	_add_canvas_layer_children("res://addons/post_processing/node/children/vignette.tscn", EffectType.VIGNETTE)
	_add_canvas_layer_children("res://addons/post_processing/node/children/glitch.tscn", EffectType.GLITCH)
	_add_canvas_layer_children("res://addons/post_processing/node/children/outline.tscn", EffectType.OUTLINE)
	_add_canvas_layer_children("res://addons/post_processing/node/children/screen_shake.tscn", EffectType.SCREEN_SHAKE)
	_add_canvas_layer_children("res://addons/post_processing/node/children/analog_monitor.tscn", EffectType.ANALOG_MONITOR)
	_add_canvas_layer_children("res://addons/post_processing/node/children/grain.tscn", EffectType.GRAIN)
	_add_canvas_layer_children("res://addons/post_processing/node/children/circular_waves.tscn", EffectType.CIRCULAR_WAVES)
	_add_canvas_layer_children("res://addons/post_processing/node/children/speed_lines.tscn", EffectType.SPEED_LINES)
	_add_canvas_layer_children("res://addons/post_processing/node/children/ascii.tscn", EffectType.ASCII)
	_add_canvas_layer_children("res://addons/post_processing/node/children/CRT.tscn", EffectType.CRT)
	_add_canvas_layer_children("res://addons/post_processing/node/children/color_correction.tscn", EffectType.COLOR_CORRECTION)
	_add_canvas_layer_children("res://addons/post_processing/node/children/pixelate.tscn", EffectType.PIXELATE)
	_add_canvas_layer_children("res://addons/post_processing/node/children/palette.tscn", EffectType.PALETTE)
	_add_canvas_layer_children("res://addons/post_processing/node/children/particle_storm.tscn", EffectType.PARTICLE_STORM)
	_add_canvas_layer_children("res://addons/post_processing/node/children/directional_drift.tscn", EffectType.DIRECTIONAL_DRIFT)

	var null_effects: PackedStringArray = []
	for e in effects:
		if (not effects.has(e)) or effects[e] == null:
			null_effects.append(EffectType.keys()[e])
	if not null_effects.is_empty(): # Not all effects were added
		var null_warning = ""
		for e in null_effects:
			null_warning += e + " "
		push_warning("Post process effects missing: " + null_warning)

	update_shaders()


func _enter_tree():
	update_shaders()


func _add_canvas_layer_children(_path : String, _type: EffectType) -> void:
	var child_instance = load(_path).instantiate()
	add_child(child_instance)
	var data = child_instance.get_child(0)
	var material_instance = data.material.duplicate()
	data.material = material_instance
	effects[_type] = child_instance


func _process(delta):
	if not configuration:
		return
	if configuration.reload and (dynamically_update or Engine.is_editor_hint()):
		configuration.reload = false
		update_shaders()
