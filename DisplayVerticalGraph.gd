extends HBoxContainer
@onready var volume_mic_value = $RecordContainer/ProgressBar
@onready var volume_master_value = $MasterContainer/ProgressBar

var record_bus_index: int = 0
var record_master_index: int = 0

func _ready():
	record_bus_index = AudioServer.get_bus_index('Record')
	record_master_index = AudioServer.get_bus_index('Master')

func _process(_delta):
	var sample = AudioServer.get_bus_peak_volume_left_db(record_bus_index, 0)
	var sample_master = AudioServer.get_bus_peak_volume_left_db(record_master_index, 0)
	var linear_sample = db_to_linear(sample)
	var linear_sample_master = db_to_linear(sample_master)
	
	volume_mic_value.value = linear_sample
	volume_master_value.value = linear_sample_master

