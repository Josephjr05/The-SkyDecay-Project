#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

float iOffset = 0.004;
float iMin = 0.01;

vec4 pix(vec2 pos) 
{
    return flixel_texture2D(bitmap, vec2(0.5) + pos);
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 pos = (uv - 0.5);
    
    float angle = atan(pos.y, pos.x);
    vec2 offset = iOffset * vec2(cos(angle), sin(angle)); 
    
    float dist = length(pos * vec2(0.5, 1.0));
    vec2 scale = dist > iMin ? offset * min(2.0, (dist - iMin) * 6.0) : vec2(0.0);
    vec4 og = pix(pos);
    gl_FragColor = vec4(pix(pos - scale).x, og.y, pix(pos + scale).z, og.a);
}