package shaders;

import flixel.system.FlxAssets.FlxShader;

class FNFRain extends FlxShader{
    @glFragmentSource('
    
#pragma header

//from https://www.shadertoy.com/view/DlcfR7

vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define fragColor gl_FragColor
#define texture flixel_texture2D
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;


// Parameters for Rain and Wind
float baseRainSpeed = -2.0; // Base speed of falling rain
int rainCount = 250; // Number of raindrops
float windStrength = 0.1; // Strength of the wind effect

int amount = 25;


void main()
{
    // Normalized pixel coordinates
    //vec2 uv = fragCoord / iResolution.xy;

    // Webcam input
    vec4 webcamColor = texture(iChannel0, uv);

    // Initialize rain effect
    float rainEffect = 0.0;

    // Calculate uniform wind effect
    float windOffset = windStrength * sin(iTime * 0.5);
    
    float opacityAdjustment = 1.0;
    float sizeAdjustment = 1.0;
    
    opacityAdjustment = 1.0 + (float(amount) - 20.) / 150.;
    sizeAdjustment = 1.0 + (float(amount) - 20.) / 70.;

    rainCount += (amount * 8 - 200);

    // Create individual raindrops, extending the spawn area
    for (int i = 0; i < rainCount; ++i) {
        // Randomize the horizontal position of each raindrop, extending 25% on each side
        float extendedArea = 1.5; // 25% extended on each side
        float randX = fract(sin(float(i) * 43758.5453123) * 12345.6789) * extendedArea - 0.25; // Adjusted for extended area

        // Generate a constant seed for varying the raindrops speed and opacity
        float speedVariation = mix(1.0, 2.0, fract(sin(float(i) * 12345.6789) * 54321.1234));

        // Calculate the vertical position of the raindrop, including speed variation
        float adjustedSpeed = baseRainSpeed * speedVariation ;
        float rainDropY = fract(iTime * adjustedSpeed + float(i) / float(rainCount));

        // Calculate opacity based on speed
        float dropOpacity = 0.2 * speedVariation * opacityAdjustment; // Inverse relation to speed

        // Create a raindrop as a vertical streak with uniform wind effect
        float dropWidth = 0.02 * (dropOpacity/4.0) * sizeAdjustment; // Width of the raindrop
        float dropHeight = 0.05 * (speedVariation) * (sizeAdjustment / 2.); // Height of the raindrop
        vec2 rainDropPos = vec2(randX + windOffset, rainDropY);

        // Calculate the alpha value of the raindrop based on distance to its center
        float dropAlpha = smoothstep(dropWidth, 0.0, abs(uv.x - rainDropPos.x)) * smoothstep(dropHeight, 0.0, abs(rainDropY - uv.y)) * dropOpacity;
        rainEffect = max(rainEffect, dropAlpha);
    }

    // Apply rain effect over webcam image
    vec3 finalColor = mix(webcamColor.rgb, vec3(0.9, 0.95, 1.0), rainEffect);

    fragColor = vec4(finalColor, 1.0);
}
    ')
    public function new(){
        super();
    }
}