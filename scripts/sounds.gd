extends Node2D


func play_cristal():
	$cristal.play()

func play_impact():
	$impact.play()
	
func play_impact_master():
	$impact_master.play()

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
	
func play_master():
	$background.stop()
	$background_master.play()

func play_mola():
	$mola.play()

func play_master_defeat():
	$background_master.stop()
	$master_defeat.play()

func play_player_defeat():
	$background.stop()
	$background_master.stop()
	$player_defeat.play()

func play_game_over():
	$game_over.play()

func stop_game_over():
	$game_over.stop()
