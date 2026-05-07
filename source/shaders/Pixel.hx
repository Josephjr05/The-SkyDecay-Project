package shaders;

import flixel.system.FlxAssets.FlxShader;

class Pixel extends FlxShader
{
    //@:glFragmentSource("assets/shaders/pixel.frag")
    @:glFragmentSource('
    #pragma header
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 iResolution = openfl_TextureSize;
    uniform float intensity = 1.0;
    
    void main()
    {
        vec2 res = iResolution.xy/intensity;
        uv.x -= mod(uv.x, 1./res.x);
        uv.y -= mod(uv.y, 1./res.y);

        gl_FragColor = flixel_texture2D(bitmap, uv);
    }
    ')
    public function new()
    {
        super();
    }
}