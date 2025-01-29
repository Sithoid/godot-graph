extends Control

## This scene shows a barebones example of using the internal GAL class
## with a pre-determined skill tree as displayed in the picture.

func _ready() -> void:
	var graph := GraphAdjacencyList.new(9)
	graph.add_edge(0, 1, 1.0)
	graph.add_edge(0, 2, 1.0)
	graph.add_edge(0, 3, 1.0)
	graph.add_edge(2, 4, 2.0)
	graph.add_edge(2, 5, 2.0)
	graph.add_edge(3, 6, 2.0)
	graph.add_edge(3, 7, 2.0)
	graph.add_edge(7, 8, 3.0)

	graph.print_list()
	graph.get_shortest_path_points(0, 8)
