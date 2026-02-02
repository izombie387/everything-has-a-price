#@tool
extends Node2D

#@export_tool_button("test") var test_action = test
func test():
	var l = Label.new()
	add_child(l)
	l.owner=self
	var t: = Timer.new()
	t.start(t.time_left)
