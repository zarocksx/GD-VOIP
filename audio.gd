extends Node

var idx : int
var effect : AudioEffectCapture
var playback : AudioStreamGeneratorPlayback

var has_authority_audio := false

@onready var input : AudioStreamPlayer = $Input
@onready var output : AudioStreamPlayer = $Output


func _ready() -> void:
	# we only want to initalize the mic for the peer using it
	input.stream = AudioStreamMicrophone.new()
	input.play()
	idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	# replace 0 with whatever index the capture effect is

	# playback variable will be needed for playback on other peers	
	playback = output.get_stream_playback()

func _process(_delta: float) -> void:
	var buffer_size = effect.get_frames_available()
	if (effect.can_get_buffer(buffer_size) && playback.can_push_buffer(buffer_size)):
		send_data(effect.get_buffer(buffer_size))
	effect.clear_buffer()

func send_data(data : PackedVector2Array):
	for i in range(0,data.size()):
		playback.push_frame(data[i])
