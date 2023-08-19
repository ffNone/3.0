tool
extends Button
signal clicked(instance)
export(bool) var filled = false setget set_filled
func set_filled(new_filled):
	filled = new_filled

	
	if filled:
		self.modulate = Color.white
		self.modulate = Color.white
	else:
		self.modulate = Color.black
		self.modulate = Color.black
func _on_Refresh_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if filled:
				modulate = Color.white * 1.3
			else:
				modulate = Color.white * 0.7
		else:
			_on_Refresh_mouse_entered()
			emit_signal("clicked", self)


func _on_Refresh_mouse_entered():
	if filled:
		modulate = Color.white * 1.05
	else:
		modulate = Color.white * 0.95
