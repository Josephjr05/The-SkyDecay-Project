package shaders;

import flixel.system.FlxAssets.FlxShader;

class Outline extends FlxShader
{
    @glFragmentSource('
    // Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

    #pragma header

    #define iResolution openfl_TextureSize
    uniform float iTime;
    #define iChannel0 bitmap
    
    
    const vec3 color1 = vec3(1., 1., 1.); // white
    const vec3 color2 = vec3(0., 0., 0.); // black
    const float radius = 2.; // do 0. if you want to disable the outline
    
    #define MODE 2
    // 1 - other colors to color1
    // 2 - color1 to color2 => other colors to color1
    
    mat2 rot(float a) {
        float c = cos(a);
        float s = sin(a);
        return mat2(c, s, -s, c);
    }
    
    #define Pi 3.1415926535
    
    vec4 drawOutline(vec2 uv) {
        vec4 tex = flixel_texture2D(iChannel0, uv);
    
        if (MODE == 2 && tex.a >= .5 && tex.rgb == color2) {
            tex.rgb = color1;
        }
        if (MODE == 1 && tex.a >= .5) {
            tex.rgb = color2;
        }
    
        vec3 color = vec3(0.);
        float dist = radius / iResolution.x;
    
        if (tex.a < .5 && radius != 0.) {
            int N = 8;
            vec4 outline = vec4(color1, 0.);
            for (int i = 0; i < N; ++i) {
                vec2 dir = rot(float(i) * 2. * Pi / float(N)) * vec2(dist, 0);
                vec4 t = flixel_texture2D(iChannel0, uv + dir);
                outline.rgb += color * t.a;
                outline.a += t.a;
            }
            tex = outline;
        }
        if (MODE == 2 && tex.a >= .5 && tex.rgb != color1) {
            tex.rgb = color2;
        }
    
        return tex;
    }
    
    void main() {
        vec2 uv = gl_FragCoord.xy / iResolution.xy;
        vec4 col = vec4(0.);
        col = drawOutline(uv);
        gl_FragColor = col;
    }')
    public function new()
	{
		super();
	}
}