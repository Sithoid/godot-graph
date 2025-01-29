@tool
extends Control

## This scene demonstrates graph generation from a skill tree that was built in-editor.

## In order for it to work, every [SkillTreeNode] should contain [SkillData],
## and all skills should have their prerequisites listed.

## Feel free to add, remove and move nodes however you like; as long as the data is correct,
## the graph will generate and provide pathfinding when launched.

## Press to generate the graph in-editor
@export var generate : bool = false:
	set(value):
		if value == true:
			generate_graph()
			generate = false

@export_category("Customization")
## Background color of the graph nodes (vertices)
@export var node_color : Color = Color("de8e11", 1.0):
	set(new_color):
		node_color = new_color
		if nodes_array.is_empty():
			collect_tree()
		for node : SkillTreeNode in nodes_array:
			node.self_modulate = node_color
## Color of labels on the graph nodes
@export var text_color : Color = Color("5a412c", 1.0):
	set(new_color):
		if nodes_array.is_empty():
			collect_tree()
		for node : SkillTreeNode in nodes_array:
			node.font_color = text_color
## Color of lines (edges) between the nodes
@export var edge_color : Color = Color("94775e", 1.0):
	set(new_color):
		edge_color = new_color
		queue_redraw()
## Color of the highlighted path
@export var edge_highlight_color : Color = Color("eb5223", 1.0):
	set(new_color):
		edge_highlight_color = new_color
		queue_redraw()
## Overall background of the scene
@export var background_color : Color = Color("decdbd", 1.0):
	set(new_color):
		background_color = new_color
		background.color = background_color

var nodes_array : Array[SkillTreeNode] = [] ## Holds references to the nodes in graph vertex order
var skills_array : Array[SkillData] = [] ## Holds references to the data within nodes in graph vertex order
var graph : GraphAdjacencyList = null ## Graph built from the scene. Can be operated upon
var highlighted_edges : Array[GraphAdjacencyList.GraphEdge] = [] ## Temp storage for highlighted edges

@onready var background = $Background

func _ready() -> void:
	if not Engine.is_editor_hint():
		generate_graph()
	# Trigger the setters
	node_color = node_color
	text_color = text_color

## Triggers pathfinding when a node in the tree is clicked (in-game only)
func _on_tree_node_input(event : InputEvent, index : int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			accept_event()
			# Highlights the path from the tree root to the clicked node
			highlighted_edges = graph.get_shortest_path(0, index)
			queue_redraw()

## Finds and stores all nodes that qualify as vertices of the tree
func collect_tree() -> void:
	for node : Node in find_children("*", "SkillTreeNode"):
		nodes_array.append(node as SkillTreeNode)
	skills_array.resize(nodes_array.size())

## Generates a GraphAdjacencyList from the relevant nodes present in the scene
func generate_graph() -> GraphAdjacencyList:
	clear_graph()
	collect_tree()
	graph = GraphAdjacencyList.new(nodes_array.size())
	# First pass: assign indices to all nodes
	for index : int in range(nodes_array.size()):
		var node : SkillTreeNode = nodes_array[index]
		if not node.graph_data:
			print("Tree node %s doesn't contain data!" % node.get_instance_id())
			return null
		skills_array[index] = node.graph_data
		# Listen to clicks if this is in-game
		if not Engine.is_editor_hint():
			node.gui_input.connect(_on_tree_node_input.bind(index))
	# Second pass: add edges
	for index : int in range(skills_array.size()):
		for prev_skill : SkillData in skills_array[index].prerequisites:
			var prev_index : int = skills_array.find(prev_skill)
			if prev_index < 0:
				print("Prerequisite %s not found in the tree!" % prev_skill.skill_name)
				return null
			graph.add_edge(prev_index, index, skills_array[index].cost)
	graph.print_list()
	queue_redraw()
	return graph

## Draws a visual representation of all edges when prompted by queue_redraw()
func _draw() -> void:
	if graph != null and nodes_array != []:
		var edges : Array[GraphAdjacencyList.GraphEdge] = graph.get_all_edges()
		for edge : GraphAdjacencyList.GraphEdge in edges:
			var draw_color : Color
			if highlighted_edges != [] and edge in highlighted_edges:
				draw_color = edge_highlight_color
			else:
				draw_color = edge_color
			draw_line(
				nodes_array[edge.head].position + nodes_array[edge.head].pivot_offset,
				nodes_array[edge.tail].position + nodes_array[edge.head].pivot_offset,
				draw_color,
				7.0)
	highlighted_edges.clear()

## Clears all persistent data
func clear_graph() -> void:
	nodes_array.clear()
	skills_array.clear()
	graph = null
