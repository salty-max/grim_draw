# meta-name: Status Logic
# meta-description: A status that will be applied to targets
class_name MyStatus
extends Status

var member_var := 0


func initialize_status(target: Node) -> void:
	print("Initialize status for target %s" % target)
	
	
func apply_status(target: Node) -> void:
	print("Status target %s" % target)
	print("Do something")
	
	status_applied.emit(self)
