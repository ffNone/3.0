extends Control
var data
class_name first_scene
func save_game():
	var file = File.new()
	file.open("user://save.save",file.WRITE)
	data = {
		"name" : username,
		"email": $Login/email.text,
		"password": $Login/password.text,
		'save_login': save_login
	}
	file.store_line(to_json(data))
	file.close()
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
var userinfo = null
onready var x = JavaScript.eval("window.addEventListener('beforeunload',function(e){e.preventDefault(); e.returnValue ='';})")
var database_reference  : FirebaseDatabaseReference
func _ready():
	self.hide()
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")
	Firebase.Auth.connect("login_failed", self, "_on_FirebaseAuth_login_failed")	
	Firebase.Auth.connect("signup_succeeded", self, "_on_FirebaseAuth_signup_succeeded")
	Firebase.Auth.connect("signup_failed", self, "_on_FirebaseAuth_signup_failed")
	save_scene()
	JavaScript.eval("window.addEventListener('beforeunload',function(e){e.preventDefault();var name = '0' var value=name.value var dpUpdate= firebase.database().ref.update({session : value}) e.returnValue ='';})")
		 
	self.show()
	
 
 
func quitt():
	JavaScript.eval("window.addEventListener('beforeunload',function(e){e.preventDefault(); e.returnValue ='';})")
func _my_callback(args):
	var js_event = args[0]
	# Call preventDefault and set the `returnValue` property of the DOM event.
	js_event.preventDefault()
	js_event.returnValue = ''
 
func _on_login_button_up():
	var email  = $Login/email.text
	var password = $Login/password.text
	Firebase.Auth.login_with_email_and_password(email,password)
	print(session)
 
var username
var email 
func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
 
	Firebase.Auth.save_auth(auth_info)
	yield(get_tree().create_timer(1.1),"timeout")
	get_data()
	print(str(email) + "That's the email!")
	yield(get_tree().create_timer(5),"timeout")
#	session()
	if session == '1' :
		var x = Label.new()
		x.text = "This email already logged in from another Device!"
		add_child(x)
	else :
		yield(get_tree().create_timer(5),"timeout")
		get_tree().change_scene("res://scenes/welcome.tscn")
		save_game()
	if $Login/rememberME/CheckBox.pressed :
			save_login()
			save_game()
 
	print(userinfo.email)
	database_reference = Firebase.Database.get_database_reference(str(name) , { })
	database_reference.push({"email" : $Login/email.text, "name" : ""})
func _on_FirebaseAuth_login_failed(code,message) :
	var label = Label.new()
	label.text = str(code) + str(message)
	add_child(label)
	yield (get_tree().create_timer(3), "timeout")
	remove_child(label)	


func _on_FirebaseAuth_signup_succeeded(auth_info):
	print("signup successful " + str(auth_info))
	userinfo = auth_info
	yield (get_tree().create_timer(1.1), "timeout")
	 
	Firebase.Auth.send_account_verification_email()
	var x = Label.new()
	x.text = "Signup Succeded!"
	add_child(x)
	yield (get_tree().create_timer(1.1), "timeout")
	add()
	$Login/signup.disabled = true
	remove_child(x)
	$Login/signup.disabled = false
	 
func _on_FirebaseAuth_signup_failed(auth_info,message) :
	var label = Label.new()
	label.text = message
	add_child(label)
	yield (get_tree().create_timer(3), "timeout")
	remove_child(label)	
func _on_signup_button_up():
	var email = $Login/email.text
	var password = $Login/password.text
	Firebase.Auth.signup_with_email_and_password(email,password)
func _on_reset_button_up():
	var email = $Login/email.text
	Firebase.Auth.send_password_reset_email(email)
	
 
func _process(delta):
	if $Login/password.text.length() <= 4 :
		$Login/login.disabled = true
	else : $Login/login.disabled = false

#	JavaScript.eval("window.addEventListener('beforeunload',function(e){e.preventDefault(); e.returnValue ='';})")

	 
func add():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var add_task: FirestoreTask = firestore_collection.add(userinfo.email, 
	{'save_login':false, 'scene':'', 'active': 'true', 'name': '' , 'coins': '', 'color_rect': "", "button_option" : "" , "score" : ""})
	var document = yield(add_task, "add_document")
	print(userinfo.email)
var session
var save_login : bool


func save_login():
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
	var up_task : FirestoreTask = firestore_collection.update($Login/email.text, {'save_login': true})
	var document : FirestoreDocument = yield(up_task, "task_finished")
#func session():
#	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection('userdata')
#	var up_task : FirestoreTask = firestore_collection.update($Login/email.text, {'session': '1'})
#	var document : FirestoreDocument = yield(up_task, "task_finished")
func get_data(): 
	var firestore_collection : FirestoreCollection = Firebase.Firestore.collection("userdata")
	firestore_collection.get($Login/email.text)
	var document : FirestoreDocument = yield(firestore_collection, "get_document")
	username = document.doc_fields.name
	email = document.doc_name
#	session = document.doc_fields.session
	save_login = document.doc_fields.save_login
var control1_scene = load("res://scenes/welcome.tscn")
#func load_game():
#	var file = File.new()
#	file.open("user://scene.save",file.READ ) #, "%%%<ِسي يس%%% asd_ _($$*$ .). ."
#	var data_str = file.get_as_text()
#	data = parse_json(data_str)
#	return data
#	file.close()

	
 
#func _notification(what):
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and data["scene"] == 'Control':
#		get_tree().quit()
 
