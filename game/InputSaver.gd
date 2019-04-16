extends Node

var process_id = 0
var events_saved = []
var time = []
var start_time : float = 0.0

func reset():
	start_time = OS.get_ticks_msec()
	events_saved = []
	set_physics_process(false)

func play_saved():
	process_id = 0
	start_time = OS.get_ticks_msec()
	set_physics_process(true)

func _ready():
	reset()
	
func _physics_process(delta):
	if(OS.get_ticks_msec() - start_time >= time[process_id]):
		get_tree().input_event(events_saved[process_id])
		process_id += 1

func _input(event):
	time.append(OS.get_ticks_msec() - start_time)
	events_saved.append(event)