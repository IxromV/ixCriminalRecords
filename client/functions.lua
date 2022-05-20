function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Citizen.Wait(0) end 
    if UpdateOnscreenKeyboard() ~= 2 then local result = GetOnscreenKeyboardResult() Citizen.Wait(500) blockinput = false return result else Citizen.Wait(500) blockinput = false return nil end
end

function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

listeData = {}
function LoadListe()
    ESX.TriggerServerCallback("ixCriminalRecords:getList", function(data)
     listeData = data
    end)
end

casierData = {}
function LoadCasier()
    ESX.TriggerServerCallback("ixCriminalRecords:getCasier", function(data)
     casierData = data
    end)
end