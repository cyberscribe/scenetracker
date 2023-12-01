extends Node

var config = ConfigFile.new()

var config_file: String = "res://config.ini"
var scenes_file: String = "res://scenes.txt"

var user_config_file: String = "user://config.ini"
var user_scenes_file: String = "user://scenes.txt"

var url_base: String = "https://localhost/scenetracker/write?key=%s&a=%s&s=%s&p=%s"
var url_sync: String = "https://localhost/scenetracker/json"
var shared_secret: String = "changeme"
var use_spacebar: bool = false

var labels: Array = []

func _init():
    var config_file_to_load: String = config_file
    if FileAccess.file_exists(user_config_file):
        config_file_to_load = user_config_file
        print("Loading user config file " + ProjectSettings.globalize_path(user_config_file))
    var status: int = config.load(config_file_to_load)
    if status == OK:
        if config.has_section_key("main", "url_base"):
            url_base = config.get_value("main", "url_base", "https://localhost/scenetracker/write?key=%s&a=%s&s=%s&p=%s")
        if config.has_section_key("main", "url_sync"):
            url_sync = config.get_value("main", "url_sync", "https://localhost/scenetracker/json")
        if config.has_section_key("main", "shared_secret"):
            shared_secret = config.get_value("main", "shared_secret", "changeme")
        if config.has_section_key("main", "use_spacebar"):
            use_spacebar = config.get_value("main", "use_spacebar", false)
            #use_spacebar = ["true","yes","on"].has(use_spacebar_string.to_lower())

    else:
        printerr(Time.get_datetime_string_from_system() + ": Unable to read config file " + config_file)
    var scenes_file_to_load: String = scenes_file
    if FileAccess.file_exists(user_scenes_file):
        scenes_file_to_load = user_scenes_file
        print("Loading user scenes file " + ProjectSettings.globalize_path(user_scenes_file))
    var file = FileAccess.open(scenes_file_to_load, FileAccess.READ)
    if file != null:
        while !file.eof_reached():
            var csv = file.get_csv_line()
            if csv.size() == 3:
                labels.append(csv)
        file.close()
    
func _notification(what: int) -> void:
    if what == NOTIFICATION_WM_CLOSE_REQUEST:
        save()

func save() -> void:
    # save labels to csv file spcified in user_scenes_file
    var file = FileAccess.open(user_scenes_file, FileAccess.WRITE)
    if file != null:
        for label in labels:
            file.store_csv_line(label)
        file.close()
    # write config to file specified in user_config_file
    config.save(user_config_file)