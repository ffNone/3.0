extends Node
var data
var scene 

var control_scene = load("res://Control.tscn")
var control1_scene = load("res://scenes/welcome.tscn")
func load_game():
	var file = File.new()
	if !file.file_exists("user://scene.save") :
		return
	file.open("user://scene.save",file.READ)
	var data_str = file.get_as_text()
	var data = parse_json(data_str)
	if file.get_len() == 0:
		return
	if data["scene"] == str("Control1")  :
		load("res://scenes/welcome.tscn")
		get_tree().change_scene_to(control1_scene)
	if data["scene"] == str("Control") :
		load("res://Control.tscn")
		get_tree().change_scene_to(control_scene)
	file.close()
func _ready():
	load_game()
