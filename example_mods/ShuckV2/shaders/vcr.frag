#pragma header

uniform float rOffset;
uniform float gOffset;
uniform float bOffset;

void main()
{
	vec4 col = vec4(1.0);
			
	col.r = texture2D(bitmap, openfl_TextureCoordv - vec2(rOffset, 0.0)).r;
	col.ga = texture2D(bitmap, openfl_TextureCoordv - vec2(gOffset, 0.0)).ga;
	col.b = texture2D(bitmap, openfl_TextureCoordv - vec2(bOffset, 0.0)).b;

	gl_FragColor = col;
}