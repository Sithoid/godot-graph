extends Control

func _ready() -> void:
	# This is an example graph, as shown on the picture.
	# The GAL class is intended for internal use;
	# you'd probably want to parse a scene into it and/or populate a scene with its data.
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
	for i in range(graph.list.size()):
		graph.get_distances(i)
