extends Control

var nodes_dict = {}

func add_param(var node : Node, var param : String, var p_name : String = ""):
	var new_label = Label.new()
	if p_name == "":
		new_label.text = param
	else:
		new_label.text = p_name
	$Params/VBoxContainer/Grid.add_child(new_label)
	if(typeof(node.get(param)) == TYPE_BOOL):
		var new_box = CheckBox.new()
		new_box.pressed = node.get(param)
		new_box.connect("pressed", self, "_on_bool_param_set", [new_box])
		$Params/VBoxContainer/Grid.add_child(new_box)
		# Adding to dict :
		nodes_dict[new_box] = {"node":node, "param":param}
	else:
		var new_line = LineEdit.new()
		new_line.text = String(node.get(param))
		new_line.connect("text_changed", self, "_on_param_set", [new_line])
		$Params/VBoxContainer/Grid.add_child(new_line)
		# Adding to dict :
		nodes_dict[new_line] = {"node":node, "param":param}
	
	
func _on_param_set(var txt : String, var line : LineEdit):
	var node = nodes_dict[line]["node"]
	var param = nodes_dict[line]["param"]
	node.set(param, convert(txt, typeof(node.get(param))))
	
func _on_bool_param_set(var check : CheckBox):
	var node = nodes_dict[check]["node"]
	var param = nodes_dict[check]["param"]
	node.set(param, convert(check.pressed, typeof(node.get(param))))
