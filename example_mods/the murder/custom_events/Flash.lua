-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Flash' then
		cameraFlash('camGame', value1, value2, true)
	end
end