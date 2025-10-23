extends Control

var maps = {
	"Chemical Bonding": {
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
	},
	"Cells": {
		"Microscope": {
			"relations": {
				"visualises ...": ["Cells"]
			},
			"types": {
				"Visualisation":{
					"Light": {
						"relations": {
							"magnify by ...": ["Refraction"]
						}
					},
					"Electron": {
						"types": {
							"": {
								"Scanning": {
									"properties": {
										"studies": "surface",
										"dimensions": 3
									}
								},
								"Transmission": {
									"properties": {
										"studies": "internal structure",
										"dimensions": 2
									}
								}
							}
						}
					}
				}
			}
		},
		"Cells": {
			"types": {
				"": {
					"Eukaryotic": {
						"relations": {
							"has": ["Nucleus"]
						}
					},
					"Prokaryotic": {
						"relations": {
							"has": ["Nucleoid Region"]
						}
					}
				}
			},
			"relations": {
				"made of ...": [["DNA","Ribosomes","Cytoplasm","Cell Membrane"]]
			}
		},
		"Organelles": {
			"examples": ["Ribosomes", "ER", "Golgi Apparatus", "Lysosomes", "Mitochondria","Chloroplasts","Vacuoles","Centrioles"]
		},
		"Ribosomes": {
			"types": {
				"Location": {
					"Free": {
						
					},
					"Bound": {
						
					}
				}
			}
		},
		"Nucleus": {
			"relations": {
				"made of ...": [["Nuclear Envelope", "Nucleolus", "Nucleoplasm", "Chromatin"]]
			},
			"properties": {
				"function": "control cell activities"
			}
		}
	}
}
@onready var navigation = preload("res://navigation_button.tscn")
@onready var map_view = preload("res://map_view.tscn")
func _ready() -> void:
	for map in maps:
		var button: Button = navigation.instantiate()
		button.text = map
		button.pressed.connect(_navigate.bind(maps[map]))
		$VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer.add_child(button)
func _navigate(map: Dictionary):
	var view = map_view.instantiate()
	view.map = map
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(view)
