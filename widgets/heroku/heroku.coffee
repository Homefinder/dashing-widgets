class Dashing.Heroku extends Dashing.Widget

	onData: (data) ->
		if data.status
			if data.status == "green"
					$(@node).css( "background-image", "url('/assets/traffic_light_green.png')");
					$(@node).css( "background-color", "#8DD15A");
			if data.status == "yellow"
					$(@node).css( "background-image", "url('/assets/traffic_light_yellow.png')");
					$(@node).css( "background-color", "#D1CD5A");
			if data.status == "red"
					$(@node).css( "background-image", "url('/assets/traffic_light_red.png')");				
					$(@node).css( "background-color", "#D15A5A");
