extends Control
@onready var bg = $BG
@export var cords = Array()
@export var file_path = "res://VectorText/coords.txt"
var result_string
var button_state
var file_write
var mouse_pos
var half_screen = Vector2i(160,160)
var looping = false


func _ready():
	#print(cords)
	file_write = false
	_on_file_dialog_file_selected(file_path)

	pass 

func save(result_string):
	var file = FileAccess.open(file_path,FileAccess.WRITE)
	file.store_string(result_string)
	
	pass

func _process(delta):
	var mouse_pos = DisplayServer.mouse_get_position()
	if button_state == true:
		cords.append(mouse_pos)
	
	if looping:
		while looping == true:
			DisplayServer.window_set_position(mouse_pos - half_screen)
			break
	print(Engine.max_fps)
	
func exclude_and_save():
	var chars_to_exclude = ["(", ")", "[", "]"]
	var result_string = "\n".join(cords)
	result_string = str(result_string)
	for char in chars_to_exclude:
		result_string = result_string.replace(char, "")
	save(result_string)
	pass

func _on_start_button_toggled(toggled_on):
	if toggled_on:
		button_state = true
		#print("true")
		if bg.frame != 30:
			bg.play("SmolSlider", 2.0)
		else:
			bg.stop()

	else:
		button_state = false
		#print("false")
		if bg.frame == 30:
			bg.play_backwards("SmolSlider")
		else:
			bg.stop()
		exclude_and_save()
		OS.shell_open(file_path)

func _on_close_button_pressed():
	get_tree().quit()
	
func _on_move_window_button_button_down():
	looping = true

func _on_move_window_button_button_up():
	looping = false


func _on_file_dialog_file_selected(path):
	file_path = path+(".txt")
	print("works")
	print(file_path)


func _on_30fps_button_2_pressed() -> void:
	Engine.set_max_fps(30)
	$"30FPS_Button2/30_Label".modulate = Color("red")
	$"60FPS_Button/60_Label".modulate = Color("black")
func _on_60fps_button_pressed() -> void:
	Engine.set_max_fps(60)
	$"30FPS_Button2/30_Label".modulate = Color("black")
	$"60FPS_Button/60_Label".modulate = Color("red")
