class_name PostProcessingConfiguration extends Resource

# post-processing-config based system by loufe
@export_group("Settings")
@export var reload: bool
@export_group("Visual Effects")
@export_subgroup("ASCII (No Color)")
@export var ASCII: bool
@export var ASCIISize: Vector2 = Vector2(4,9):
	set(value):
		ASCIISize = value
		reload = true
@export_subgroup("Chromatic Aberration")
@export var ChromaticAberration: bool
@export var StrenghtCA: float = 1:
	set(value):
		StrenghtCA = value
		reload = true
@export_subgroup("Blur")
@export var Blur: bool
@export_range(0.0, 5) var L_O_D = 1.0:
	set(value):
		L_O_D = value
		reload = true
@export_subgroup("Fish Eye")
@export var FishEye: bool
@export var FishEyeAspect = 1.0:
	set(value):
		FishEyeAspect = value
		reload = true
@export var FishEyeDistortion = 1.0:
	set(value):
		FishEyeDistortion = value
		reload = true
@export var FishEyeRadius = 1.0:
	set(value):
		FishEyeRadius = value
		reload = true
@export var FishEyeAlpha = 1.0:
	set(value):
		FishEyeAlpha = value
		reload = true
@export var FishEyeCrop = 1.0:
	set(value):
		FishEyeCrop = value
		reload = true
@export var FishEyeCropColor = Color.BLACK:
	set(value):
		FishEyeCropColor = value
		reload = true
@export_subgroup("Vignette")
@export var Vignette: bool
@export var VignetteIntensity = 0.4:
	set(value):
		VignetteIntensity = value
		reload = true
@export_range(0.0, 1.0) var VignetteOpacity = 0.5:
	set(value):
		VignetteOpacity = value
		reload = true
@export var VignetteR_G_B: Color = Color(0.0, 0.0, 0.0, 1.0):
	set(value):
		VignetteR_G_B = value
		reload = true
@export_subgroup("Glitch")
@export var Glitch: bool
@export_range(0.0, 0.1, 0.005) var GlitchRange = 0.05:
	set(value):
		GlitchRange = value
		reload = true
@export_range(0.0, 300, 0.1) var GlitchNoiseQuality = 250.0:
	set(value):
		GlitchNoiseQuality = value
		reload = true
@export_range(-0.6, 0.6, 0.0010) var GlitchIntenity = 0.0088:
	set(value):
		GlitchIntenity = value
		reload = true
@export_range(-0.1, 0.1, 0.001) var GlitchOffset = 0.03:
	set(value):
		GlitchOffset = value
		reload = true
@export_range(0.0, 5.0, 0.001) var GlitchColorOffset = 1.3:
	set(value):
		GlitchColorOffset = value
		reload = true
@export_subgroup("Outline")
@export var Outline: bool
@export var OutlineColor: Color = Color(0.0, 0.0, 0.0, 1.0):
	set(value):
		OutlineColor = value
		reload = true
@export_range(0.0, 1.0) var OutlineThreshold = 0.0:
	set(value):
		OutlineThreshold = value
		reload = true
@export_range(0.0, 1.0) var OutlineBlend = 0.01:
	set(value):
		OutlineBlend = value
		reload = true
@export_subgroup("Grain")
@export var Grain: bool
@export_range(0, 150, 0.1) var GrainPower = 75:
	set(value):
		GrainPower = value
		reload = true
@export_subgroup("Circular Waves")
@export var CircularWaves: bool
@export_range(0,2, 0.01) var CircularWavesAmplitude = 2.0:
	set(value):
		CircularWavesAmplitude = value
		reload = true
@export_range(0, 15, 0.01) var CircularWavesFrequency = 12.69:
	set(value):
		CircularWavesFrequency = value
		reload = true
@export_range(0.5, 150.0, 0.1) var CircularWavesRippleRate = 9.2:
	set(value):
		CircularWavesRippleRate = value
		reload = true
@export_subgroup("Speed Lines")
@export var SpeedLines: bool
@export var SpeedLinesColor: Color = Color.WHITE:
	set(value):
		SpeedLinesColor = value
		reload = true
@export_range(0,2, 0.05) var SpeedLinesCount = 2:
	set(value):
		SpeedLinesCount = value
		reload = true
@export_range(0.0, 1.0) var SpeedLineDensity = 0.072:
	set(value):
		SpeedLineDensity = value
		reload = true
@export_range(1.0, 40.0, 1.0) var SpeedLineSpeed = 20:
	set(value):
		SpeedLineSpeed = value
		reload = true

@export_group("Display")
@export_subgroup("Color Correction")
@export var ColorCorrection: bool
@export var ColorCorrectionTint : Color
@export_range(-1.0, 1.0) var ColorCorrectionBrightness : float = 0
@export_range(-1.0, 1.0) var ColorCorrectionSaturation : float = 0
@export_subgroup("Palette")
@export var Palette : bool
@export var PalettePalette : Texture2D
@export_subgroup("Pixelate")
@export var Pixelate : bool
@export_range(0, 64) var PixelatePixelSize = 8
@export_subgroup("CRT")
@export var CRT: bool
@export var overlay : bool = false:
	set(value):
		overlay = value
		reload = true
@export_range(0.0, 1.0) var scanlines_opacity : float = 0.4:
	set(value):
		scanlines_opacity = value
		reload = true
@export_range(0.0, 0.5) var scanlines_width : float = 0.25:
	set(value):
		scanlines_width = value
		reload = true
@export_range(0.0, 1.0) var grille_opacity : float = 0.3:
	set(value):
		grille_opacity = value
		reload = true
@export var pixelate : bool = true:
	set(value):
		pixelate = value
		reload = true
@export var roll_speed : float = 8.0:
	set(value):
		roll_speed = value
		reload = true
@export_range(0.0, 100.0) var roll_size : float = 15.0:
	set(value):
		roll_size = value
		reload = true
@export_range(0.1, 5.0) var roll_variation : float = 1.8:
	set(value):
		roll_variation = value
		reload = true
@export_range(0.0, 0.2) var distort_intensity : float = 0.05:
	set(value):
		distort_intensity = value
		reload = true
@export_range(0.0, 1.0) var noise_opacity : float = 0.4:
	set(value):
		noise_opacity = value
		reload = true
@export var noise_speed : float = 5.0:
	set(value):
		noise_speed = value
		reload = true
@export_range(0.0, 1.0) var static_noise_intensity : float = 0.06:
	set(value):
		static_noise_intensity = value
		reload = true
@export_range(-1.0, 1.0) var aberration : float = 0.03:
	set(value):
		aberration = value
		reload = true
@export var brightness : float = 1.4:
	set(value):
		brightness = value
		reload = true
@export var discolor : bool = true:
	set(value):
		discolor = value
		reload = true
@export_range(0.0, 5.0) var warp_amount : float = 1.0:
	set(value):
		warp_amount = value
		reload = true
@export var clip_warp : bool = false:
	set(value):
		clip_warp = value
		reload = true
@export var vignette_intensity : float = 0.4:
	set(value):
		vignette_intensity = value
		reload = true
@export_range(0.0, 1.0) var vignette_opacity : float = 0.5:
	set(value):
		vignette_opacity = value
		reload = true
@export_subgroup("Analog Monitor")
@export var AnalogMonitor: bool
@export var AnalogMonitorResolution = Vector2(256, 256):
	set(value):
		AnalogMonitorResolution = value
		reload = true
@export_group("Other")
@export_subgroup("Screen Shake")
@export var ScreenShake: bool
@export var ScreenShakePower = 0.1:
	set(value):
		ScreenShakePower = value
		reload = true
