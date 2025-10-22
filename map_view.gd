extends Control

var map = {
	"Structure": {
		"examples": ["Giant Ionic", "Covalent", "Giant Metallic"]
	},
	"Forces": {
		"types": {
			"Strength": {
				"Electrostatic": {
					"relations": {
						"between ...": ["Ions"]
					}
				},
				"Covalent": {
					"relations": {
						"between ...": ["Atoms"]
					},
					"types": {
						"Size": {
							"Giant": {
								"examples": ["Diamond", "Graphite"]
							},
							"Simple": {
								"examples": ["Water", "Carbon Dioxide", "Methane"]
							}
						}
					}
				},
				"Intermolecular": {
					"relations": {
						"between ...": ["Molecules"]
					}
				}
			}
		}
	},
	"Diamond": {
		"properties": {
			"can conduct": false,
			"has mobile electrons": false,
			"bonds": 4
		}
	},
	"Graphite": {
		"properties": {
			"can conduct": true,
			"has mobile electrons": true,
			"bonds": 3
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
					var relatorNode = ensure_node(relator)
					var relationIndex = relatorNode.get_child_count()
					var relationLabel = Label.new()
					relationLabel.text = (relations[index] if index < len(relations) else "").strip_edges() + ":"
					relatorNode.add_child(relationLabel)
					relatorNode.set_slot(relationIndex, index != 0, 3, Color.DODGER_BLUE, index + 1 < len(relators), 3, Color.DODGER_BLUE)
					if index > 0:
						var lastRelator := ensure_node(relators[index-1])
						graph_edit.connect_node(lastRelator.name, lastRelator.get_output_port_count() - 1, relator, relatorNode.get_input_port_count() - 1)
					
				
