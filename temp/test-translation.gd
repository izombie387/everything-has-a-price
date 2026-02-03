@tool
extends Sprite2D

@export var pos: = Vector2.ZERO
@export_range(0,355) var rot: = 10.0

@export_tool_button("redraw") var red_actions = queue_redraw
func _draw():
	draw_set_transform(pos, deg_to_rad(rot))
	draw_texture(texture, Vector2.ZERO, Color(1.0, 0.544, 0.479, 1.0))
