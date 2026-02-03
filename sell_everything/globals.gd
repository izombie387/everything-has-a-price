extends Node

signal gold_changed(total_gold)
var sounds = {
	"swipe": {
		"stream": load("res://sfx/swipe-sfx.ogg"),
	},
	"click": {
		"stream": load("res://sfx/key-click.ogg"),
	}
}
var sfx: = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(sfx)
	sfx.bus = AudioServer.get_bus_name(1)

func play_sfx(sfx_name: String):
	sfx.stream = sounds[sfx_name]["stream"]
	sfx.play()

var gold = 0:
	set(g):
		gold = g
		gold_changed.emit(gold)

func get_gold():
	return gold

func add_gold(amount):
	gold+=amount
