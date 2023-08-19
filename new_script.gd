var file_path = ["res://Control.gd","res://welcome.gd","res://scenes/Game.gd","C:/Users/k/Documents/Game/.env"]
var output_file_path = "encrypted_file.bin"

var encryption_key = OS.get_environment("SCRIPT_AES256_ENCRYPTION_KEY")
var initialization_vector = OS.get_random_dir()

var openssl_command = "openssl enc -aes-256-cbc -salt -in " + file_path + " -out " + output_file_path + " -K " + encryption_key + " -iv " + initialization_vector
func ok () :
	return "hello"
var result = OS.execute(openssl_command,ok())

