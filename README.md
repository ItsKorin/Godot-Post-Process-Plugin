# Post Processing Plugin
#### An add-on for Godot 4.2, available in the Godot Asset Library.
After moving from Unity to Godot in late 2019, I've felt like there was a lack of post-processing tooling. In February 2024 I decided to make and publish this simple add-on.

## Features:
- Custom CanvasLayer node, "PostProcess".
- 2D/3D support.
- Custom resource type to save preset configurations, "PostProcessPreset".
- Ability to dynamically modify effects through code.
- Effects:

## Effects:
- ASCII (Monochromatic / Render everything as ASCII text) (for now uses only: `.:-+*=%@#`).
- Chromatic Aberration
- Blur
- Vignette
- Glitch (Animated)
- Outline (Not the best implementation, still being worked on).
- Screen Shake
- Analog Monitor
- Grain (Animated)
- Circular Waves / Speed Lines (Low Quality, still being worked on).
- Fish eye effect.

## Planned Features:
- [x] Effect Presets
- [ ] More Effects like: `Color Grading`, `Dithering`, `Motion Blur`, `VHS`, etc.
- [ ] Smooth transitions between previous and future effect states (ex: 0 blur slowly rising to 100)


## Basic Use:
Simply add the custom PostProcess node to the scene tree directly or through code. Set the "Configuration" property of the PostProcess to a PostProcessPreset (either pre-made or instantiated on-the-spot) and run the game. The add-on uses some simple "Screen Space" shaders to apply the desired effects.

![image](https://github.com/Loufe/Godot-Post-Process-Plugin/assets/5817861/7144aa73-a095-4a72-8c19-27c0c2b5e4b8) <br>
![image](https://github.com/Loufe/Godot-Post-Process-Plugin/assets/5817861/3c6c2192-615e-4834-9417-6f1e6b337d04) <br>
![image](https://github.com/Loufe/Godot-Post-Process-Plugin/assets/5817861/beb9e334-3852-4221-b78b-d5bd67893e0e) <br>

### Loading a preset:
![image](https://github.com/Loufe/Godot-Post-Process-Plugin/assets/5817861/6db89cad-3718-4e60-9e3b-1952a43ed8ac)

### Creating an in-place preset:
![image](https://github.com/Loufe/Godot-Post-Process-Plugin/assets/5817861/c480db22-6192-4afd-9ec2-bdb5de3e8ab4)


### Adding changes only through code:


All values can be modified during runtime and the changes will be applied immediately. This applies to on/off states as well as numbered parameters. All effects can be applied in parallel and work together well.

(NOTE: Effects are applied on rendering layers: 99-120, so i suggest putting UI above 120 and anything else like player, world etc. under 99!)



## Changing Effects Through Code.
In this example, we enable/disable ScreenShake!
```gdscript
extends Node3D

func _process(_delta):
    # Change the Screen Shake Power by 0.1 each frame
    $PostProcess.ScreenShakePower += 0.1

    # if Screen Shake Power is bigger than 2, change it back to 0!
    if $PostProcess.ScreenShakePower >= 2:
        $PostProcess.ScreenShakePower = 0


    # if key T is pressed, Enable Screen Shake
    if Input.is_key_pressed(KEY_T):
        $PostProcess.ScreenShake = true
    else:
        $PostProcess.ScreenShake = false
```

This also works with other effects like:
`ASCII`, `Blur`, `ChromaticAberration`, `FishEye`, etc...
### Contributors:
- **[Korin](https://github.com/ItsKorin)** _`Owner`_:crown:
- **[Loufe](https://github.com/Loufe)** _`Contributor`_:pen:

### Some Screenshots:
Normal:
![Godot_v4 2 1-stable_win64_4nCuRDZEv7](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/b2d2a33a-aa9d-4217-92d2-4b6827eb9298)
ASCII:
![Godot_v4 2 1-stable_win64_7GbIuOJMaA](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/ac89c01b-7f51-4208-8d45-2d0128d00fcf)
Chromatic Aberration:
![Godot_v4 2 1-stable_win64_jjyidzYH5b](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/4d394d1f-b934-4881-a5dc-a59f959b855b)
Vignette:
![Godot_v4 2 1-stable_win64_sHuRFKLWgJ](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/699c5b90-4246-476b-acb6-bade557c0e9b)
Glitch:
![Godot_v4 2 1-stable_win64_nf9MvEGLIF](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/3b781deb-e438-4733-9ee8-a607da814767)
Outline:
![Godot_v4 2 1-stable_win64_zEyjScQtmE](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/29983546-3eac-43b9-8960-5f38c8402a0e)
Grain:
![Godot_v4 2 1-stable_win64_mgGj2yIxPM](https://github.com/ItsKorin/Godot-Post-Process-Plugin/assets/92170697/b17a416e-b0bc-4ce2-b6b1-479185197507)


