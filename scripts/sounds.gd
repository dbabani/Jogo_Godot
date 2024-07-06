extends Node2D


func play_cristal():
	$cristal.play()

func play_impact():
	$impact.play()

func play_queda():
	$queda.play()
	
func play_fury():
	$fury.play()
	
func play_jump():
	$jump.play()
	
func play_running():
	if !$running.playing:
		$running.play()

func stop_running():
	$running.stop()
	
func play_background():
	$background.play()
