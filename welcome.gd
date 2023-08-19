extends Control
var data
class_name welcome
var path = "user://save.save"
var path2 = "user://scene.save"  
var x = control.new()
func load_game():
	var file = File.new()
	file.open(path,file.READ)
	var data_str = file.get_as_text()
	data = parse_json(data_str)
var scene = null
func _enter_tree():
	
	load_game()
	$username.text = str(data["name"])
#	$ColorRect2.color = data["color"]
	if $username.text == "" :
		$username.editable = true
		$username.text = "Enter a username!"
	else :
		$OK.visible = false 
		$username.editable = false
		
	var scene = get_tree().current_scene.name
	var file = File.new()
	file.open("user://scene.save",file.WRITE)
	data = {
		"scene" : scene
	}
	file.store_string(to_json(data))
	file.close()
var names: Array = []
var color 
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
	var color_str = document.doc_fields.color
	var selected = document.doc_fields.optionbutton
	$OptionButton.select(int(selected))
	var color = Color(color_str)
	$ColorRect2.color = color
	print(color)
func update():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(data["email"], {'name':$username.text})
	var document : FirestoreDocument = yield(up_task, "task_finished")

func update_color():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update(data["email"], {'color' : $ColorRect2.color.to_html(), "optionbutton": $OptionButton.selected})
	var document : FirestoreDocument = yield(up_task, "task_finished")
	
func _on_OK_button_up():
	if $username.text in names :
		var x = Label.new()
		x.text = "Username Already Exists!"
		add_child(x)
		yield(get_tree().create_timer(1.1),"timeout")
		remove_child(x)
	else :
		update() 
		$username.editable = false
		$OK.disabled = true
 
	


func _on_quit_button_up():
	get_tree().change_scene("res://Control.tscn")


func _ready():
#	load_game()
#	var email = data["email"]
#	var password = data["password"]
#	yield(get_tree().create_timer(0.2),"timeout")
#	Firebase.Auth.login_with_email_and_password(email,password)
#	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
#	get_data()
#	get_colorr()
	$username.text = x.username
	
	Gotm.initialize()
	var config = GotmConfig.new()
	config.project_key = "authenticators/X0cORsp7rSBkPTRe7Tdt"
	Gotm.initialize(config)
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
