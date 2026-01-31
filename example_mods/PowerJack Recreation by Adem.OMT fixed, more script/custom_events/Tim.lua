local planoPago = false;

function onEvent(nome, valor1)
    if nome == 'Tim' then
        if valor1 == 'pago' then
            planoPago = true
        elseif valor1 == 'teu cu' then
            planoPago = false
        end
    end
end

function onUpdate()
    if planoPago then
        setProperty('tomate_Lagado_pa_carai.alpha', 1)
    elseif not planoPago then
        setProperty('tomate_Lagado_pa_carai.alpha', 0)
    end
end