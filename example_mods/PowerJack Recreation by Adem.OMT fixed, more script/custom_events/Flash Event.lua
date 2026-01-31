-- Event notes hooks
function onEvent(event, v1, v2)
	if event == 'Flash Event' then
		cameraFlash('camGame', v2, v1, false)
	end
end