class_name PostProcessingConfiguration extends Resource

@export_category("Post Process")
@export var reload: bool
@export_category("ASCII (No Color)")
@export var ASCII: bool
@export var ASCIISize: Vector2 = Vector2(4,9)
@export_category("Chromatic Aberration")
@export var ChromaticAberration: bool
@export var StrenghtCA: float = 1
@export_category("Blur")
@export var Blur: bool
@export_range(0.0, 5) var L_O_D = 1.0
@export_category("Fish Eye")
@export var FishEye: bool
@export var FishEyeAspect = 1.0
@export var FishEyeDistortion = 1.0
@export var FishEyeRadius = 1.0
@export var FishEyeAlpha = 1.0
@export var FishEyeCrop = 1.0
@export var FishEyeCropColor = Color.BLACK
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
