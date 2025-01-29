@tool
class_name SkillTreeNode
extends Control

## A UI node for displaying a node in a tree/graph. Contains a [SkillData] resource within.

## Resource containing data that this node will display
@export var graph_data : SkillData:
	set(new_skill):
		graph_data = new_skill
		if is_node_ready():
			update_visuals()

## Set by the SkillTree for all nodes at once
var font_color : Color:
	set(new_color):
		font_color = new_color
		if is_node_ready():
			update_visuals()

@onready var label : Label = $Label

func _ready() -> void:
	update_visuals()

## Updates the visuals whenever the data changes
func update_visuals() -> void:
	pivot_offset = size / 2
	if graph_data:
		tooltip_text = "%s \nCost: %s" % [graph_data.skill_name, graph_data.cost]
		label.text = graph_data.skill_name
		label.add_theme_color_override("font_color", font_color)
