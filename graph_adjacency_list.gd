class_name GraphAdjacencyList
extends Resource

## This class stores graph data in an adjacency list.
## It's supposed to be used for directional acyclic graphs and can sort them and calculate shortest paths.

## GDScript implementation by Sithoid; based on:
## https://www.geeksforgeeks.org/adjacency-list-meaning-definition-in-dsa/
## https://www.scaler.in/shortest-path-in-directed-acyclic-graph/

## Main storage
var list : Array[Array] = [] ## Adjacency list this class operates on
var stack : Array[int] = [] ## Result of topological sorting

#region Wrappers/external calls
## Call for initializing with .new(). Provide the number of vertices
func _init(vertices : int = 1) -> void:
	list = create_list(vertices)

## Prints the adjacency list. Not needed in actual implementations (presumably a GUI will be in place)
func print_list() -> void:
	print("Adjacency list representation:")
	for vertex_index : int in range(list.size()):
		var line := "Vertex %s:" % vertex_index
		for edge : Array in list[vertex_index]:
			line += " target %s, weight %s;" % [edge[0], edge[1]] 
		print(line)
#endregion

#region Adding and removing elements
## Initializes an adjacency list with a given number of vertices
func create_list(vertices : int) -> Array[Array]:
	clear_list()
	var adj : Array[Array] = []
	adj.resize(vertices)
	return adj

## Adds a new vertex at the end of the list
## A vertex is addressed by its index and is represented with an array holding its outgoing edges.
func add_vertex() -> Array[Array]:
	clear_stack()
	list.append([])
	return list

## Removes a vertex at a given index. Also removes all edges that connect to it
func remove_vertex(vertex_index_to_remove : int) -> Array[Array]:
	clear_stack()
	if vertex_index_to_remove > list.size():
		print("Can't remove a nonexistent vertex")
		return list
	for vertex_index : int in range(list.size()):
		remove_edge(vertex_index, vertex_index_to_remove)
	list.remove_at(vertex_index_to_remove)
	return list

## Adds an edge between two given vertices
## An edge is an array holding the index of the target vertex and the weight (cost) of transition
func add_edge(source_vertex : int, target_vertex : int, weight : float = 1.0) -> Array[Array]:
	clear_stack()
	if source_vertex >= list.size() or target_vertex >= list.size():
		print("Can't connect nonexistent vertices")
		return list
	if source_vertex == target_vertex:
		print("Can't connect a vertex to itself")
		return list
	for edge : Array in list[source_vertex]:
		if edge[0] == target_vertex:
			print("This edge already exists")
			return list
	# The vertex stores outgoing edges
	list[source_vertex].append([target_vertex, weight])
	return list

## Removes an edge connecting two given vertices
func remove_edge(source_vertex : int, target_vertex : int) -> Array[Array]:
	clear_stack()
	if source_vertex >= list.size() or target_vertex >= list.size():
		print("Can't remove an edge from nonexistent vertices")
		return list
	for edge : Array in list[source_vertex]:
		if edge[0] == target_vertex:
			list[source_vertex].erase(edge)
	return list

## Resets the list and the stack
func clear_list() -> void:
	clear_stack()
	list.clear()
#endregion

#region Sorting and pathfinding
## Topological sorting of the array. Returns the order in which the vertices can be reached
func top_sort() -> Array[int]:
	clear_stack()
	var visited : Array[bool]
	visited.resize(list.size())
	visited.fill(false)
	for vertex_index : int in range(list.size()):
		_recursive_top_sort(visited, vertex_index)
	# GDScript doesn't have true LIFO stacks, so we're just reversing the array
	stack.reverse()
	print("Topological sorting of the adjacency list:")
	print(stack)
	return stack

## Helper function for topological sorting
func _recursive_top_sort(visited : Array[bool], vertex_index : int) -> void:
	if visited[vertex_index]:
		return
	visited[vertex_index] = true
	for edge : Array in list[vertex_index]:
		var adjacent_vertex = edge[0]
		if visited[adjacent_vertex] == false:
			_recursive_top_sort(visited, adjacent_vertex)
	stack.push_back(vertex_index)

## Clears the stack in order to sort anew
func clear_stack() -> void:
	stack.clear()

## Returns shortest paths from the source vertex to all other vertices. Will sort if no stack exists
## Call dist[i] to learn the cost of travel from source to i
## Distance from the vertex to itself is always 0; inf means this vertex can't be reached from there
func get_distances(source_vertex : int) -> Array[float]:
	if source_vertex >= list.size():
		print("Source vertex %s is not in this graph!" % source_vertex)
	# Sort if no pre-sorted stack is provided
	if stack.is_empty():
		top_sort()
	# Shortest path search
	var dist : Array[float]
	dist.resize(list.size())
	dist.fill(INF)
	dist[source_vertex] = 0.0
	for vertex : int in stack:
		for edge : Array in list[vertex]:
			var adjacent_vertex = edge[0]
			# edge[1] stores weight
			if dist[adjacent_vertex] > dist[vertex] + edge[1]:
				dist[adjacent_vertex] = dist[vertex] + edge[1]
	print("Distances from %s:" % source_vertex)
	print(dist)
	return dist
#endregion
