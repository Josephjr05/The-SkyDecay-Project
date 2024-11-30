#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/lsXSWl

float rng2(vec2 seed)
{
    return fract(sin(dot(seed * floor(iTime * 12.), vec2(127.1,311.7))) * 43758.5453123);
}

float rng(float seed)
{
    return rng2(vec2(seed, 1.0));
}

void mainImage()
{
	vec2 uv = fragCoord.xy / iResolution.xy;
    vec2 blockS = floor(uv * vec2(24., 9.));
    vec2 blockL = floor(uv * vec2(8., 4.));
    
    float r = rng2(uv);
    vec3 noise = (vec3(r, 1. - r, r / 2. + 0.5) * 1.0 - 2.0) * 0.08;
    
    float lineNoise = pow(rng2(blockS), 8.0) * pow(rng2(blockL), 3.0) - pow(rng(7.2341), 17.0) * 2.;
    
    vec4 col1 = texture(iChannel0, uv);
    vec4 col2 = texture(iChannel0, uv + vec2(lineNoise * 0.05 * rng(5.0), 0));
    vec4 col3 = texture(iChannel0, uv - vec2(lineNoise * 0.05 * rng(31.0), 0));
    
	fragColor = vec4(vec3(col1.x, col2.y, col3.z) + noise, 1.0);
gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}