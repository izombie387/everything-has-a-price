shader_type canvas_item;

uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float frequency : hint_range(0.0, 30.0) = 5.0;
uniform float amplitude : hint_range(0.0, 0.2) = 0.05; // UV 是 0-1，所以振幅要小

void fragment() {
    vec2 uv = UV;
    float wave = sin(TIME * speed + uv.x * frequency) * amplitude * uv.x;
    uv.y += wave;

    COLOR = texture(TEXTURE, uv);

    float light = cos(TIME * speed + uv.x * frequency) * 0.2;
    COLOR.rgb += light * uv.x;

}