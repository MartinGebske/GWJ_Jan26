extends Node

const SAVE_PATH := "user://best_times.json"

var best_times := {
	"track_1": INF,
	"track_2": INF,
	"track_3": INF,
	"track_4": INF
}

func _ready():
	load_times()

func check_time(track_id: String, new_time: float) -> bool:
	var old_time = best_times.get(track_id, INF)

	if new_time < old_time:
		best_times[track_id] = new_time
		save_times()
		print(
			"🏁 Neue Bestzeit auf ",
			track_id,
			": ",
			"%.2f" % new_time,
			" s (alt: ",
			"--" if old_time == INF else "%.2f" % old_time,
			" s)"
		)
		return true

	return false

func save_times():
	var save_dict := {}

	for key in best_times.keys():
		save_dict[key] = (
			-1 if best_times[key] == INF else best_times[key]
		)

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_dict))
	file.close()

func load_times():
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data: Variant = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) != TYPE_DICTIONARY:
		push_warning("BestTimes: Ungültige Save-Datei, benutze Defaults")
		return

	for key in best_times.keys():
		if data.has(key):
			best_times[key] = (
				INF if data[key] == -1 else float(data[key])
			)

func get_best_time(track_id: String) -> float:
	return best_times.get(track_id, INF)
