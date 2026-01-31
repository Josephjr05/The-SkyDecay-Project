#pragma header
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;

uniform float pxSize = 0.0;
void main() {
	vec2 uv = fragCoord.xy / openfl_TextureSize.xy;
	
	float plx = openfl_TextureSize.x * pxSize / 500.0;
	float ply = openfl_TextureSize.y * pxSize / 275.0;
	
	float dx = plx * (1.0 / openfl_TextureSize.x);
	float dy = ply * (1.0 / openfl_TextureSize.y);
	
	uv.x = dx * floor(uv.x / dx);
	uv.y = dy * floor(uv.y / dy);
	
	gl_FragColor = flixel_texture2D(bitmap, uv);
}