tool
extends Node2D

var obj

func _ready():
	if Engine.editor_hint:
		obj = load("res://Scenes/Objects/Prototypes/laneGuide.tscn").instance()
		obj.visible = false
		add_child(obj)

func _process(_delta):
	if Engine.editor_hint:
		if Input.is_key_pressed(KEY_KP_0):
			obj.visible = true
		if Input.is_key_pressed(KEY_KP_PERIOD):
			obj.visible = false