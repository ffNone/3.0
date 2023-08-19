extends Panel
const PORT = 8070
var _mouse_start: Vector2
var _last_color: int = -1
var _color: int
var peer = WebSocketMultiplayerPeer.new()
#sync func _player_connected(id):
#	rpc("recieve_message", id)
 
func peer_disconnected(peer_id):
	print(peer_id, " left the party")
func host():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT)
	get_tree().set_network_peer(peer)
	get_tree().connect("network_peer_connected", self, "_player_connected")
	
	_last_color = (_last_color + 1) % 8
	_set_color(_last_color)
remotesync func _set_color(color):
	_color = color

func send_message():
	var message = $messages/LineEdit.text
	var id = get_tree().get_network_unique_id()
	rpc("recieve_message", id, message)
	
sync func recieve_message(id,message) :
	$messages/TextEdit.text += str(id) + ":" + str(message) + "\n"
func _input(event):
	if event is InputEventKey :
		if event.pressed and event.scancode == KEY_ENTER:
			send_message()
func join():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(Gotm.lobby.host.address, PORT)
	get_tree().set_network_peer(peer)
	
	$"Please Wait".show()
	yield(get_tree(), "connected_to_server")
	$"Please Wait".hide()
	
 
