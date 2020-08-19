extends Sprite

onready var current_menu: Node = get_parent()
var entries := []
var index := 0


func _ready():
	entries = []
	for entry in current_menu.get_children():
		if entry.visible and entry is Label:
			entries.append(entry)
	set_selection(0)
	
	
func set_selection(new_index):
	if 0 <= new_index and new_index < len(entries):
		index = new_index
		var select_node = entries[index] 
		position = Vector2(	select_node.rect_position.x - (get_rect().size.x*scale.x),select_node.rect_position.y + (get_rect().size.y*scale.y))
	else: 
		print("ERROR set_selection(): invalid index")
		print("Restart the scene")
	
func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		move_down()
	if Input.is_action_just_pressed("ui_down"):
		move_up()
	if Input.is_action_just_pressed("ui_accept"):
		var select_node = entries[index] 
		if select_node.modulate.a == 1:
			select_node.callback()
		else:
			get_tree().quit()
		
func move_down():
	if set_selection(index - 1):
		$Sounds/Confirm.play()

func move_up():
	if set_selection(index + 1):
		$Sounds/Confirm.play()