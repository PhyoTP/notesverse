extends Control

var map = {
	"node1": {
		"examples": ["node1a","node1b"],
		"relations": {
			"words ... more words ...": [
				"node2",
				["node3","node4"]
			]
		},
		"properties": {
			"property": "value"
		},
		"types":{
			"subtype": { 
				"subtype1": {
					"properties": {
						"property": true
					}
				},
				"subtype2": {
					"properties": {
						"property": false
					}
				}
			}
		}
	},
	"node2": { 
		"relations": {
			"words ...": ["node1_subtype2"]
		}
	}
}
@onready var node_scene = preload("res://topic_node.tscn")
@onready var graph_edit = $GraphEdit
func _ready() -> void:
	for topic in map:
		var newNode: GraphNode
		if graph_edit.get_node_or_null(topic):
			newNode = graph_edit.get_node(topic)
		else:
			newNode = node_scene.instantiate()
			newNode.name = topic
			newNode.title = topic
		newNode.init(map[topic])
		if not graph_edit.get_node_or_null(topic):
			graph_edit.add_child(newNode)
		add_node(map[topic], newNode)
	graph_edit.arrange_nodes()
func ensure_node(topic: String) -> GraphNode:
	var node = graph_edit.get_node_or_null(topic)
	if node:
		return node
	var new_node = node_scene.instantiate()
	new_node.name = topic
	new_node.title = topic
	graph_edit.add_child(new_node)
	return new_node
func add_node(props: Dictionary, newNode: GraphNode):
	for prop in props:
		if prop == "examples":
			var index = newNode.get_child_count()
			var exampleLabel = Label.new()
			exampleLabel.text = "Examples:"
			newNode.add_child(exampleLabel)
			newNode.set_slot(index, false, 1, Color.WHITE, true, 1, Color.LIME_GREEN)
			for example in props[prop]:
				var exampleNode = ensure_node(example)
				var exampleIndex = exampleNode.get_child_count()
				var exampleOfLabel = Label.new()
				exampleOfLabel.text = "example of:"
				exampleNode.add_child(exampleOfLabel)
				exampleNode.set_slot(exampleIndex, true, 1, Color.LIME_GREEN, false, 1, Color.WHITE)
				graph_edit.connect_node(newNode.name, newNode.get_output_port_count() - 1, example, exampleNode.get_input_port_count() - 1)
		elif prop == "types":
			for type in props[prop]:
				var index = newNode.get_child_count()
				var typeLabel = Label.new()
				typeLabel.text = type + " types:"
				newNode.add_child(typeLabel)
				newNode.set_slot(index, false, 2, Color.WHITE, true, 2, Color.YELLOW)
				for subtype in props[prop][type]:
					var typeNode = node_scene.instantiate()
					typeNode.name = newNode.name + "." + subtype
					typeNode.title = subtype
					typeNode.init(props[prop][type][subtype])
					graph_edit.add_child(typeNode)
					add_node(props[prop][type][subtype], typeNode)
					var typeIndex = typeNode.get_child_count()
					var subtypeLabel = Label.new()
					subtypeLabel.text = type + " type of:"
					typeNode.add_child(subtypeLabel)
					typeNode.set_slot(typeIndex, true, 2, Color.YELLOW, false, 2, Color.WHITE)
					graph_edit.connect_node(newNode.name, newNode.get_output_port_count() - 1, typeNode.name, typeNode.get_input_port_count()-1)
		elif prop == "relations":
			for relation in props[prop]:
				var relations = relation.split("...")
				var relators = [newNode.name] + props[prop][relation]
				for index in range(len(relators)):
					var relator = relators[index]
					if relator is not Array:
						relator = [relator]
					for i in relator:
						var relatorNode = ensure_node(i)
						var relationIndex = relatorNode.get_child_count()
						var relationLabel = Label.new()
						relationLabel.text = (relations[index] if index < len(relations) else "").strip_edges() + ":"
						relatorNode.add_child(relationLabel)
						relatorNode.set_slot(relationIndex, index != 0, 3, Color.DODGER_BLUE, index + 1 < len(relators), 3, Color.DODGER_BLUE)
						if index > 0:
							var lastRelator = relators[index-1]
							if lastRelator is not Array:
								lastRelator = [lastRelator]
							for j in lastRelator:
								var last := ensure_node(j)
								graph_edit.connect_node(last.name, last.get_output_port_count() - 1, i, relatorNode.get_input_port_count() - 1)
					
				
