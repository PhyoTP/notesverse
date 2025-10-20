extends Control

var map = {
	"Structure": {
		"examples": ["Giant Ionic", "Covalent", "Giant Metallic"],
		"properties": {"thing":true}
	},
	"Forces": {
		"types": {
			"Electrostatic": {
				"relations": {
					"between ...": "Ions"
				}
			},
			"Covalent": {
				"relations": {
					"between ...": "Atoms"
				},
				"types": {
					"Giant": {
						"examples": ["Diamond", "Graphite"]
					},
					"Simple": {
						"examples": ["Water", "Carbon Dioxide", "Methane"]
					}
				}
			},
			"Intermolecular": {
				"relations": {
					"between ...": "Molecules"
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
		for prop in map[topic]:
			if prop == "examples":
				var index = newNode.get_child_count()
				print(index)
				var exampleLabel = Label.new()
				exampleLabel.text = "Examples:"
				newNode.add_child(exampleLabel)
				print(index)
				newNode.set_slot(index, false, 1, Color.LIME_GREEN, true, 1, Color.LIME_GREEN)
				for example in map[topic][prop]:
					var exampleNode = ensure_node(example)
					var exampleIndex = exampleNode.get_child_count()
					var exampleOfLabel = Label.new()
					exampleOfLabel.text = "example of:"
					exampleNode.add_child(exampleOfLabel)
					exampleNode.set_slot(exampleIndex, true, 1, Color.LIME_GREEN, false, 1, Color.LIME_GREEN)
					graph_edit.connect_node(topic, index, example, exampleIndex)
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
