function onEvent(name, value1, value2)
    if not middlescroll then
	    if value1 == 'On' then
            noteTweenAlpha('note movement1', 0, 0, value2, 'linear')
            noteTweenAlpha('note movement2', 1, 0, value2, 'linear')
            noteTweenAlpha('note movement3', 2, 0, value2, 'linear')
            noteTweenAlpha('note movement4', 3, 0, value2, 'linear')
            noteTweenX('note movement5', 4, 412, value2, 'linear')
            noteTweenX('note movement6', 5, 524, value2, 'linear')
            noteTweenX('note movement7', 6, 636, value2, 'linear')
            noteTweenX('note movement8', 7, 748, value2, 'linear')
            noteTweenX('note movement9', 0, 412, value2, 'linear')
            noteTweenX('note movement10', 1, 524, value2, 'linear')
            noteTweenX('note movement11', 2, 636, value2, 'linear')
            noteTweenX('note movement12', 3, 748, value2, 'linear')
        end
		if value1 == 'Off' then
            noteTweenAlpha('note movement1', 0, 1, value2, 'linear')
            noteTweenAlpha('note movement2', 1, 1, value2, 'linear')
            noteTweenAlpha('note movement3', 2, 1, value2, 'linear')
            noteTweenAlpha('note movement4', 3, 1, value2, 'linear')
            noteTweenX('note movement5', 4, 732, value2, 'linear')
            noteTweenX('note movement6', 5, 844, value2, 'linear')
            noteTweenX('note movement7', 6, 956, value2, 'linear')
            noteTweenX('note movement8', 7, 1068, value2, 'linear')
            noteTweenX('note movement9', 0, 92, value2, 'linear')
            noteTweenX('note movement10', 1, 204, value2, 'linear')
            noteTweenX('note movement11', 2, 316, value2, 'linear')
            noteTweenX('note movement12', 3, 428, value2, 'linear')
		end
    end
end
