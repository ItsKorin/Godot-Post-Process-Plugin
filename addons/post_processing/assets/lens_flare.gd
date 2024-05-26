extends CanvasLayer

# In your main scene script

var camera = null
var light_source = null
var light_pos_world = null
var screen_pos = null
var light_pos_screen = null
var material = null

func _ready():
  # Get camera node automatically based on type
	camera = get_tree().get_root().find_child("Camera3D", true, true)  # Searches entire scene tree
	if not camera:
		print("Warning: No Camera node found in scene!")
		return

  # Get first light node (adjust if you need a specific light)
	light_source = get_tree().get_root().find_child("Light3D", true, true)  # Searches entire scene tree
	if not light_source:
		print("Warning: No Light node found in scene!")
		return

func _physics_process(delta):
	if not camera or not light_source:
		return  # Skip if camera or light not found

  # Calculate and set light position as before
	light_pos_world = light_source.global_transform.origin
	screen_pos = camera.project_world_ray(light_pos_world)
	light_pos_screen = screen_pos / screen_pos.w

	material = $data.material
	material.set_uniform("LightPositionWorldSpace", light_pos_screen)
