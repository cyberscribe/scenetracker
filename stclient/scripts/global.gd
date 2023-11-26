extends Node

var config_file: String = "res://config.ini"
var scenes_file: String = "res://scenes.txt"

var url_base: String = "https://localhost/scenetracker/write?key=%s&a=%s&s=%s&p=%s"
var url_sync: String = "https://localhost/scenetracker/json"
var shared_secret: String = "changeme"
var use_spacebar: bool = false

var labels: Array = []

func _init():
    var config = ConfigFile.new()
    var status = config.load(config_file)
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
    var file = FileAccess.open(scenes_file, FileAccess.READ)
    while !file.eof_reached():
        var csv = file.get_csv_line()
        if csv.size() > 0:
            labels.append(csv)
    file.close()
