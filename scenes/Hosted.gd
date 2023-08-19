extends Panel

var _lobby
signal selected(lobby)
func set_lobby(lobby):
	_lobby = lobby
	$Panel/Name.text = lobby.name

func _on_Panel_mouse_entered():
	modulate = Color.white * 1.05 


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			modulate = Color.white * 1.3
		else:
			_on_Panel_mouse_entered()
			emit_signal("selected", _lobby)
