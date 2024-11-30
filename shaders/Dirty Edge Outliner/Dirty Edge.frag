#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
uniform vec4 iMouse;

/*
Calculates a 'dirty' edge image by subtracting the original image
from a 'blurred' copy of itself, except the blurred copy is coming
from a simple 'monto carlo' blur. The result is combined back into
the original image. A bit like unsharp masking:
https://en.wikipedia.org/wiki/Unsharp_masking

credit
https://www.shadertoy.com/view/DdlSDr

I really like the term 'monte carlo blur', it comes from Justaway:
https://www.shadertoy.com/view/MdXXWr
*/


//#define EDGES_ONLY
#define TWO_PI 6.283185307
#define ANIMATED_NOISE 0.25


// Settings applied when mouse isn't active
float default_offset = 0.015;
float default_darken = 0.92;


// From Dave_Hoskins: https://www.shadertoy.com/view/4djSRW
vec2 hash22(vec2 p)
{
	vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx+33.33);
    return fract((p3.xx+p3.yz)*p3.zy);

}


vec2 get_random_sampling_offset(vec2 xy) {

    vec2 random_2d = hash22(xy);
    float random_radius = random_2d.x;
    float random_angle = random_2d.y * TWO_PI;
    
    #ifdef ANIMATED_NOISE
        random_angle += (iTime * ANIMATED_NOISE);
    #endif
    
    return random_radius * vec2(cos(random_angle), sin(random_angle));
}


void mainImage()
{
    // For convenience
    vec2 xy_norm = fragCoord/iResolution.xy;
    vec2 mouse_xy_norm = iMouse.xy / iResolution.xy;
    float is_mouse_down = clamp(iMouse.z, 0., 1.);
    
    // Get offset sampling scale (can be altered by mouse Y)
    float mouse_scale = mix(0.001, 0.5, mouse_xy_norm.y);
    float offset_scale = mix(default_offset, mouse_scale, is_mouse_down);
    vec2 sampling_offset = offset_scale * get_random_sampling_offset(fragCoord);

    // Get edges by subtracting a 'blurry' copy of the image from itself
    vec4 orig_img = texture(iChannel0, xy_norm);
    vec4 offset_img = texture(iChannel0, xy_norm + sampling_offset);
    vec4 diff_img = orig_img - offset_img;
    float gray = 1.0 - length(diff_img.xyz);
    
    // Contrast bump before output (can be altered by mouse X)
    float mouse_darken = mix(0.0, 1.0, mouse_xy_norm.x);
    float darken = mix(default_darken, mouse_darken, is_mouse_down);
    gray = smoothstep(darken, 1.0, gray) * 0.8 + 0.2;
    vec3 gray_3d = vec3(gray);
    
    // Choose coloring style
    vec3 col;
    #ifdef EDGES_ONLY
        col = gray_3d;
    #else
        vec3 dulled_offset = offset_img.rgb * 0.6 + 0.2;
        col = mix(gray_3d, dulled_offset, gray);
    #endif
    
    fragColor = vec4(col, 1.0);
gl_FragColor.a = flixel_texture2D(bitmap, openfl_TextureCoordv).a;
}

