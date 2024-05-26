@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("PostProcess", "CanvasLayer", load("res://addons/post_processing/node/post_process.gd"), load("res://addons/post_processing/node/post_process.svg"))


func _exit_tree():
	remove_custom_type("PostProcess")
