#pragma header

//uniform float iTime;
uniform float amount;

vec2 PincushionDistortion(in vec2 uv, float strength) {
	vec2 st = uv - 0.5;
    float uvA = atan(st.x, st.y);
    float uvD = dot(st, st);
    return 0.5 + vec2(sin(uvA), cos(uvA)) * sqrt(uvD) * (1.0 - strength * uvD);
}

vec4 ChromaticAbberationHUD(sampler2D tex, in vec2 uv) 
{
	float bChannel = texture2D(tex, PincushionDistortion(uv, 0.3 * amount)).b;
	float gChannel = texture2D(tex, PincushionDistortion(uv, 0.15 * amount)).g;
	float rChannel = texture2D(tex, PincushionDistortion(uv, -0.09 * amount)).r;
	float aChannel = texture2D(tex, PincushionDistortion(uv,  0.1 * amount)).a;
	
	vec4 retColor = vec4(rChannel, gChannel, bChannel, aChannel);
	return retColor;
}

void main(){
	vec2 uv = openfl_TextureCoordv;
	vec4 col = ChromaticAbberationHUD(bitmap, uv);
	
	gl_FragColor = col;
}