#pragma header

// da floats
uniform float distort; // no touchie this i think
uniform float amount;
uniform float pixel;

vec2 PincushionDistortion(in vec2 uv, float strength) 
{
	vec2 st = uv - 0.5;
	float uvA = atan(st.x, st.y);
	float uvD = dot(st, st);
	return 0.5 + vec2(sin(uvA), cos(uvA)) * sqrt(uvD) * (1.0 - strength * uvD);
}

void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    uv -= vec2(0.5);
    float l = length(uv);
    uv *= (1.0 + distort * l * l);
    uv /= (1.0 + distort * l * l);
    uv += vec2(0.5);
    uv = PincushionDistortion(uv, amount);
    if(pixel <= 0){
        floor(uv * openfl_TextureSize.x + pixel) / (openfl_TextureSize.x + pixel);
    }else{
        uv = floor(uv * openfl_TextureSize.x / pixel) / (openfl_TextureSize.x / pixel);
    }
    if(uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0)
    gl_FragColor = texture2D(bitmap, uv);
}