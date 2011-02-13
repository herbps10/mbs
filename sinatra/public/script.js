$(document).ready(function() {
	if($("body").attr('id') == "generate") {
		setTimeout("updateProgress()", 1000);
	}
});

var start = (new Date).getTime();
var count = 0
function updateProgress() {
	$.get("/mbs/status", { job: "generate" }, function(data) {
		$("div.progress").css('width', data + "%");

		var intdata = parseInt(data)

		$("h2.textprogress").text(Math.floor(intdata) + "%")
		if(intdata < 100) {
			// Start collecting data points after the first one, which is always 0%
			if(count > 0) {
				var diff = (new Date).getTime() - start;
				
				var total = ((100 / intdata) * diff) / 1000;
				
				var remaining = total - (diff / 1000);
				remaining = Math.floor(remaining);
				
				if(count == 1 || count % 5 == 0) {
					var message = "";
					if(remaining < 60) {
						message = remaining + " seconds remaining";
					}
					else {
						minutes = Math.floor(remaining / 60);
						
						if(minutes == 1) {
							message = "1 minute remaining";
						}
						else {
							message = minutes + " minutes remaining";
						}
					}

					$(".time").text(message);
				}
			}

			setTimeout("updateProgress()", 500);

			count += 1;
		}
		else {
			window.location.replace("/mbs/complete");
		}
	});
}
