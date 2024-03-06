# Post Processing Plugin
#### For Godot 4.2
Since i moved from Unity in late 2019 i felt like Godot was lacking something, so last month i decided to make this simple plugin.
It uses some simple Screen Space shaders to apply the effects.
(Effects are applied on layers: 99-120, so i suggest putting UI above 120 and anything else like player, world etc. under 99!)

### Features:
- Custom PostProcess node.
- 2D/3D support.
- Ability to modify effects thru code.
- ASCII (Monochromatic / Render everything as ASCII text) (for now uses only: `.:-+*=%@#`).
- Chromatic Aberration
- Blur
- Vignette
- Glitch (Animate)
- Outline (Not the best implementation, still being worked on).
- Screen Shake
- Analog Monitor
- Grain (Animated)
- Circular Waves / Speed Lines (Low Quality, still being worked on).

### Planned Features:
- More Effects like: `FishEye`, `Color Grading`, `Dithering`, etc.

### Changing Effects Thru Code.
In this example i will enable/disable ScreenShake!
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

### Some Screenshots:
(Sorry for mouse in screenshots.)
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


