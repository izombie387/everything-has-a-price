shader_type spatial;
render_mode unshaded;
uniform float t1 = 1.0;
uniform float t2 = 0.05;
void fragment() {
	float silhouette = dot(NORMAL, VIEW);
	float color = smoothstep(t1, t2, silhouette);
	ALBEDO = vec3(color);
}
