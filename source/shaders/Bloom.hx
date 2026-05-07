package shaders;

import flixel.system.FlxAssets.FlxShader;

class Bloom extends FlxShader
{
	@:glFragmentSource('
#pragma header

const float amount = 2.0;

// GAUSSIAN BLUR SETTINGS
float dim = 1.8;
float Directions = 26.0;
float Quality = 3.0; //this is fine since this shader is really expensive
uniform float size; //the sweet spot is 8.0
vec2 Radius = size/openfl_TextureSize.xy;
void main(void)
{
	vec2 uv = openfl_TextureCoordv.xy;

	vec2 pixel = uv*openfl_TextureSize.xy;

	float Pi = 6.28318530718; // Pi*2

	vec4 Color = texture2D(bitmap, uv);

	for( float d=0.0; d<Pi; d+=Pi/Directions){
		for(float i=1.0/Quality; i<=1.0; i+=1.0/Quality){
			Color += flixel_texture2D(bitmap, uv+vec2(cos(d),sin(d))*size*i/openfl_TextureSize.xy);
		}
	}

	Color /= (dim * Quality) * Directions - 15.0;
	vec4 bloom = (flixel_texture2D(bitmap, uv)/ dim)+Color;
	if (pixel.y < 1.0 || pixel.y > openfl_TextureSize.y-1.0){
		bloom = vec4(0.0,0.0,0.0,1.0);
	}
	gl_FragColor = bloom;
}
	')
	public function new()
		{
			super();
		}
}
