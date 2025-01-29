class_name SkillData
extends Resource

## This Resource holds data for a particular skill. It can be used to build a SkillTree

## Display name for this skill
@export var skill_name : String = "Generic Skill"
## Attach here all skills that are [i]immediate[/i] precursors of this one (no need to list the entire tree)
@export var prerequisites : Array[SkillData]
## Individual cost of this skill (aka travel cost to its node from the previous one).
@export var cost : float = 1.0
