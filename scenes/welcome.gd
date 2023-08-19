extends Control
var data
class_name welcome
var path = "user://save.save"  
func load_game():
	var file = File.new()
	file.open("user://save.save" ,file.READ ) #, "%%%<ِسي يس%%% asd_ _($$*$ .). ."
	var data_str = file.get_as_text()
	data = parse_json(data_str)
var scene 
func save_scene():
	scene = get_tree().current_scene.name
	var file = File.new()
	file.open("user://scene.save",file.WRITE)
	var scenee = {
		"scene" : scene
	}
	file.store_line(to_json(scenee))
	file.close()
func _enter_tree(): 
	$ColorRect2/OK.visible = false 
	$MainPanel/HostedSector.hide()
	$ColorRect2/username.editable = false
	load_game()
	$MainPanel.visible = false
	$MainPanel/Hosted.hide()
	$MainPanel/Host/PanelHostName.hide()
var names: Array = []
var color 
var saved_login

func get_data(): 
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("userdata")
	var documents: Array = yield(Firebase.Firestore.list("userdata"), "listed_documents")
	var color = "" 
	for doc in documents:
		names.append(doc.doc_fields.name)
	print(names)
func get_colorr():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("userdata")
	firestore_collection.get(data["email"])
	var document : FirestoreDocument = yield(firestore_collection, "get_document")
	var color_str = document.doc_fields.color_rect
	var selected = document.doc_fields.button_option
	$ColorRect2/OptionButton.select(int(selected))
	var color = Color(color_str)
	$ColorRect2.color = color
	print(color)
func update():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(email, {'name':$ColorRect2/username.text})
	var document : FirestoreDocument = yield(up_task, "task_finished")

func update_color():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(email, {'color_rect' : $ColorRect2.color.to_html(), "button_option": $ColorRect2/OptionButton.selected})
	var document : FirestoreDocument = yield(up_task, "task_finished")
	
 
func _on_OK_button_up():
	if $ColorRect2/username.text in names :
		var x = Label.new()
		x.text = "Username Already Exists!"
		add_child(x)
		yield(get_tree().create_timer(1.1),"timeout")
		remove_child(x)
	else :
		update() 
		update_data()
		$ColorRect2/username.editable = false
		$ColorRect2/OK.disabled = true
 
	
func delete_saved():
	var file = File.new()
	file.open("user://save.save",file.WRITE)
	data = {
		"name" : "",
		"email": "",
		"password": ""
	}
	file.store_line(to_json(data))
	file.close()
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(data["email"], {'save_login' : false})
	var document : FirestoreDocument = yield(up_task, "task_finished")
func deleted_scene():
	var file = File.new()
	file.open("user://scene.save",file.WRITE)
	data = {
		"scene" : "Control"
	}
	file.store_line(to_json(data))
	file.close()
#func session():
#	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
#	var up_task : FirestoreTask = firestore_collection.update(email, {'session': '0', 'save_login': false})
#	var document : FirestoreDocument = yield(up_task, "task_finished")
	
func _on_quit_button_up(): 
	delete_saved()
#	session()
	data["scene"] = str('Control')
	yield(get_tree().create_timer(3),"timeout")
	get_tree().change_scene("res://Control.tscn")

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST  : 
#		var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
#		var up_task : FirestoreTask = firestore_collection.update(email, {'session': '0', 'save_login': false})
#		yield(get_tree().create_timer(3),"timeout")
#		get_tree().quit()
#		update_data()
		pass
	
 
var session
func get_dataa(): 
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("userdata")
	firestore_collection.get(data["email"])
	var document : FirestoreDocument = yield(firestore_collection, "get_document")
	username = document.doc_fields.name
	saved_login = document.doc_fields.save_login
#	session = document.doc_fields.session
	return saved_login
var username
var email
var password
func _ready():
	self.hide()
	Gotm.connect("lobby_changed", self, "_on_Gotm_lobby_changed")
	$MainPanel/Hosted/Refresh.show()
	load_game()
	email = data["email"]
	password = data["password"]
	Firebase.Auth.login_with_email_and_password(email,password)
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	yield(get_tree().create_timer(2),"timeout")
	get_dataa()
	yield(get_tree().create_timer(2),"timeout")
	get_colorr()
	if data["save_login"] == true :
		save_scene()
	yield(get_tree().create_timer(2),"timeout")
	$ColorRect2/username.text = str(username)
	print(data)
	if $ColorRect2/username.text == "" or $ColorRect2/username.text == "Null" :
		$ColorRect2/username.editable = true
		$ColorRect2/OK.visible = true
	else :
		$ColorRect2/OK.visible = false 
		$ColorRect2/username.editable = false
 
	var config = GotmConfig.new()
	config.project_key = "authenticators/X0cORsp7rSBkPTRe7Tdt"
	Gotm.initialize(config)
	yield(get_tree().create_timer(2),"timeout")
	print(str(saved_login))
	if saved_login == true :
		save_scene()
	if saved_login == false and session == "1":
		get_tree().set_auto_accept_quit(false)
	self.show()
#	get_tree().set_auto_accept_quit(false) 
 
func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	Firebase.Auth.save_auth(auth_info)


func _on_OptionButton_item_selected(index):
	
	if index == 0 :
		$ColorRect2.color = Color.white
			 
	elif index == 1 :
		$ColorRect2.color = Color.green
	elif index == 2 :
		$ColorRect2.color = Color.red
	update_color()

 
func _on_mutilplayer_pressed():
	$MainPanel.visible = true
	$ColorRect2.visible = false
	$quit.disabled = true
	$Menu/singleplayer.disabled = true
	$Menu/mutilplayer.disabled = true
func _on_Qpanel_pressed():
	$MainPanel/Hosted.visible = false
	$ColorRect2.visible = true
	$quit.disabled = false
	$Menu/singleplayer.disabled = false
	$Menu/mutilplayer.disabled = false
	$MainPanel.hide()
 

 
 
 

onready var _fetch = GotmLobbyFetch.new()
#func _on_D_pressed():
#
#	var peer = NetworkedMultiplayerENet.new()
#	peer.create_server(8070)
#	get_tree().set_network_peer(peer)
#	get_tree().connect("network_peer_connected", self, "_player_connected")
#	yield(get_tree().create_timer(3), "timeout")
#	$SectorD.visible = true
#	Gotm.host_lobby(false)
#	Gotm.lobby.hidden = false
#	Gotm.lobby.name = $MainPanel/LineEdit.text
#	yield(get_tree().create_timer(3),"timeout")
#	var name = Label.new()
#	name.text = str(username)
#	add_child(name)
	
#func _on_LobbyEntry_selected(lobby):
#	var success = yield(lobby.join(), "completed")
#	if success:
#		$MainPanel/D.join()
#		print("Success")
#	else:
#		push_error("Failed to connect to lobby '" + lobby.name + "'!")
#		print("ERROR!")
#func _on_Button_pressed():
#
#	var peer = NetworkedMultiplayerENet.new()
#	peer.create_client(Gotm.lobby.host.address, 8070)
#	get_tree().set_network_peer(peer)
#	yield(get_tree(), "connected_to_server")
#	$SectorD.visible = true
##		var name = Label.new()
##		name.text = str(username)
##		add_child(name)
 
func _player_connected(id):
	var x = Label.new()
	x.text = str(id)
	add_child(x)



 


func _on_Rooms_pressed():
	$MainPanel/Hosted.show()
	$MainPanel/Hosted/Panel.hide()

func _on_Exit_pressed():
	$MainPanel/Hosted.hide()


func _on_Host_pressed():
	$MainPanel/Host/PanelHostName.show()


func _on_LineEdit_focus_entered():
	$MainPanel/Host/PanelHostName/LineEdit.text = ""

 
func _on_close_pressed():
	 $MainPanel/Host/PanelHostName.hide()


 
	


func _on_Panel_selected(lobby):
	$MainPanel/HostedSector.show()
	var success = yield(lobby.join(), "completed")
	if success :
		$MainPanel/HostedSector.join()
	else : 
		$MainPanel/HostedSector.hide()
		var x = Label.new()
		x.text = "Error joining!"
		add_child(x)
		yield(get_tree().create_timer(1.1),"timeout")




func _on_Create_clicked(instance):
	$MainPanel/HostedSector.show()


	Gotm.host_lobby(false)
	Gotm.lobby.hidden = false
	Gotm.lobby.name = $MainPanel/Host/PanelHostName/Name.get_text()
	$MainPanel/HostedSector.host()


 
 


func _on_Refresh_clicked(instance):
	
	for child in $MainPanel/Hosted/Entries.get_children():
		child.queue_free()
	var lobbies = yield(_fetch.first(5), "completed")
	for i in range(lobbies.size()):
		var lobby = lobbies[i]
		var node = $MainPanel/Hosted/Panel.duplicate()
		node.show()
		$MainPanel/Hosted/Entries.add_child(node)
		node.set_lobby(lobby)
		node.rect_position.y += i * 80
	


func _on_LineEdit_text_entered(new_text):
	$MainPanel/HostedSector/messages/TextEdit.text += str(new_text)
var database_reference = FirebaseDatabaseReference
func _test_database():
	database_reference = Firebase.Database.get_database_reference("FirebaseTester/data", { })
	database_reference.connect("new_data_update", self, "_on_new_data_update") # for new data
	database_reference.connect("patch_data_update", self, "_on_patch_data_update")
	
	database_reference.push({'user_name':'username', 'message':'Hello worldzzz!'}) 
#func _exit_tree():
#	update_data()

var added_data_key
func _on_new_data_update(new_data : FirebaseResource):
	added_data_key = new_data.key
func update_data():
	Firebase.Auth.login_with_email_and_password(email,password)
 
	database_reference.connect("new_data_update", self, "_on_new_data_update") # for new data
	database_reference.connect("patch_data_update", self, "_on_patch_data_update") 
	yield(get_tree().create_timer(5), "timeout")
	database_reference.update(added_data_key, {'name': str($ColorRect2/username.text)})
 
func _on_patch_data_update(patch_data : FirebaseResource):

	added_data_key = patch_data.key
