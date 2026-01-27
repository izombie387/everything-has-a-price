extends Node

const UI_SLOTS: = 3
const CHARACTER_SLOTS: = 1
const ITEM_SLOTS: = 6
const ACTION_SLOTS: = 3

var slots = {
	"player": {
		"ui": new_array(UI_SLOTS),
		"character": new_array(CHARACTER_SLOTS),
		"items": new_array(ITEM_SLOTS),
		"actions": new_array(ACTION_SLOTS),
	},
	"enemy": {
		"ui": new_array(UI_SLOTS),
		"character": new_array(CHARACTER_SLOTS),
		"items": new_array(ITEM_SLOTS),
		"actions": new_array(ACTION_SLOTS),
	},
	"shop": {
		"ui": new_array(UI_SLOTS),
		"character": new_array(CHARACTER_SLOTS),
		"items": new_array(ITEM_SLOTS),
		"actions": new_array(ACTION_SLOTS),
	},
}

func new_array(size):
	var arr = []
	arr.resize(size)
	arr.fill(null)
	return arr
