extends LineEdit

var early_lambda = (func(l):
	print(max_length)
	var x = int(max_length)
	print(l)
	print(x)).bind(max_length)


func _on_text_submitted(_new_text: String) -> void:
	print(position)
	max_length += 5
	early_lambda.call()
	
	
