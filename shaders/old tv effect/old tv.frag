#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

// https://www.shadertoy.com/view/sl3GDr

vec2 crt_coords(vec2 uv, float bend)
{
	uv -= 0.5;
    uv *= 2.;
    uv.x *= 1. + pow(abs(uv.y)/bend, 2.);
    uv.y *= 1. + pow(abs(uv.x)/bend, 2.);
    
    uv /= 2.5;
    return uv + .5;
}

float vignette(vec2 uv, float size, float smoothness, float edgeRounding)
{
 	uv -= .5;
    uv *= size;
    float amount = sqrt(pow(abs(uv.x), edgeRounding) + pow(abs(uv.y), edgeRounding));
    amount = 1. - amount;
    return smoothstep(0., smoothness, amount);
}

float scanline(vec2 uv, float lines, float speed)
{
    return sin(uv.y * lines + iTime * speed);
}

float random(vec2 uv)
{
 	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));   
}

float noise(vec2 uv)
{
 	vec2 i = floor(uv);
    vec2 f = fract(uv);
    
    float a = random(i);
    float b = random(i + vec2(1.,0.));
	float c = random(i + vec2(0., 1.));
    float d = random(i + vec2(1.));
    
    vec2 u = smoothstep(0., 1., f);
    
    return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y; 
                     
}


void mainImage()
{
    vec2 uv = fragCoord/iResolution.xy;
    
    vec2 crt_uv = crt_coords(uv, 4.);
    
    float s1 = scanline(uv, 200., -10.);
    float s2 = scanline(uv, 20., -3.);
    
    vec4 col;
    col.r = texture(iChannel0, crt_uv + vec2(0., 0.01)).r;
    col.g = texture(iChannel0, crt_uv).r;
    col.b = texture(iChannel0, crt_uv + vec2(0., -0.01)).b;
    col.a = texture(iChannel0, crt_uv).a;
    
    col = mix(col, vec4(s1 + s2), 0.05);
	fragColor = mix(col, vec4(noise(uv * 75.)), 0.05) * vignette(uv, 1.9, .6, 8.);;

}