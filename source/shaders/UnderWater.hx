package shaders;

import flixel.system.FlxAssets.FlxShader;

class UnderWater extends FlxShader
{
    @:glFragmentSource('
    #pragma header
    vec2 uv = openfl_TextureCoordv.xy;
    vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
    vec2 iResolution = openfl_TextureSize;
    uniform float iTime;
    #define iChannel0 bitmap
    #define texture flixel_texture2D
    #define fragColor gl_FragColor
    #define mainImage main
    void main()
{
    vec2 uv = fragCoord/iResolution.xy;
    
    const float waveStrength = 0.01;
    const float waveFrequency = 64.0;
    const float waveSpeed = 0.2;
    
    vec3 col = texture(iChannel0, uv + vec2(sin((iTime + waveFrequency * uv.y) * waveSpeed + uv.y)* waveStrength, 0.0)).rgb;
    //col.b += 0.2;
    //col.rg -= 0.05;
    
    gl_FragColor = vec4(col,1.0);
}
    ')
    public function new()
        {
            super();
        }
}