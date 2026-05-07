package shaders;

import flixel.system.FlxAssets.FlxShader;

class Grayscale extends FlxShader{
	@:glFragmentSource('
	#pragma header
    uniform float saturation;

    void main() {
        vec4 color = texture2D(bitmap, openfl_TextureCoordv);
        float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
        
        vec3 finalColor = mix(vec3(gray), color.rgb, saturation);
        
        gl_FragColor = vec4(finalColor, color.a);
    }')
    public function new() 
    {
        super();    
    }
}