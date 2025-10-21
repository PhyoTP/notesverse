extends GraphNode

func init(info: Dictionary) -> void:
	for i in info:
		if i == "properties":
			var index = get_input_port_count()
			for prop in info[i]:
				var newLabel = Label.new()
				newLabel.text = prop + ": " + str(info[i][prop])
				add_child(newLabel)
				set_slot(index, false, 0, Color.WHITE, false, 0, Color.WHITE)
				index+=1
