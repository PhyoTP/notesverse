extends GraphNode

func init(info: Dictionary) -> void:
	for i in info:
		if i == "properties":
			var index = 0
			for prop in info[i]:
				var newLabel = Label.new()
				newLabel.text = prop + ": " + str(info[i][prop])
				add_child(newLabel)
				set_slot(index, true, 0, Color.TRANSPARENT, true, 0, Color.TRANSPARENT)
