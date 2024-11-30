#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/MsX3DN

const float speed = 2.0;
const float wobblyness = 7.0;
const float shiftStrength = 0.1;

void mainImage()
{
    vec2 uv = fragCoord / iResolution.xy;
    
    uv.x -= sin((iTime * speed) + (uv.y * wobblyness)) * shiftStrength;
    uv.x = mod(uv.x, 1.);

    fragColor = vec4(texture(iChannel0, uv).rgb, 1.);
gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}