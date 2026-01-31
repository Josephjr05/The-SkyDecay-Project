function onEvent(tag, arg1, arg2)
    if tag ~= "CinimaticNotes" then return end

    if arg2 == '' then
        tweenCinimon = "quadOut"
    else
        tweenCinimon = arg2
    end
    if stringTrim(arg1:lower()) == "true" then
        for i,v in ipairs({412, 524, 636, 748}) do
            if not middlescroll then
                noteTweenX("bfCinNote" .. i, i + 3, v, 0.5, tweenCinimon)
            end
            noteTweenAlpha("dadByeNotes" .. i, i - 1, 0, 0.5, tweenCinimon)
        end
    else
        for i,v in ipairs({732, 844, 956, 1068}) do
            if not middlescroll then
                noteTweenX("bfCinNote" .. i, i + 3, v, 0.5, tweenCinimon)
            end
            noteTweenAlpha("dadByeNotes" .. i, i - 1, (middlescroll and 0.35 or 1), 0.5, tweenCinimon)
        end
    end
end