#pragma header
vec2 uv = openfl_TextureCoordv.xy;
uniform float force;

void main() {
    float f = force / 70.0; // scale factor
    vec3 col;
    col.r = texture2D(bitmap, vec2(uv.x + f, uv.y)).r;
    col.g = texture2D(bitmap, uv).g;
    col.b = texture2D(bitmap, vec2(uv.x - f, uv.y)).b;
    gl_FragColor = vec4(col, texture2D(bitmap, uv).w);
}

//Shader and lua script for it is By Ferzy