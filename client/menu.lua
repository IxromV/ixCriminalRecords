ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local ItemsList = {"Aucun" ,"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}
local filterIndex = 1
local itemIndex = 1

open = false 
local mainMenu = RageUI.CreateMenu("Casier Judicaire", "Interaction")
local listSub = RageUI.CreateSubMenu(mainMenu, "Liste Individu", "Interaction")
local createCas = RageUI.CreateSubMenu(mainMenu, "Creation", "Interaction")
local infoSub = RageUI.CreateSubMenu(listSub, "Info", "Interaction")
local viewCasier = RageUI.CreateSubMenu(infoSub, "Casier", "Interaction")
mainMenu.Closed = function()
    open = false 
end

function OpenMenu()
    if open then 
        open = false 
        RageUI.Visible(mainMenu, false)
        return 
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu, function()

                    RageUI.Button("Créer un Casier Vierge", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                        end
                    }, createCas)

                    RageUI.Button("Consulter les Casiers (~g~"..#listeData.."~s~)", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            LoadListe()
                        end
                    }, listSub)
                end)

                RageUI.IsVisible(createCas, function()

                    RageUI.Button("Nom & Prénom :", nil, {RightLabel = nameOfSuspect}, true, {
                        onSelected = function()
                            nameSuspect = KeyboardInput("Nom et Prénom de l'individu", nameSuspect, 30)
                            if nameSuspect == nil then
                                ESX.ShowNotification("Champ Invalide")
                            else
                                nameOfSuspect = "~g~"..nameSuspect..""
                            end
                        end
                    })

                    RageUI.Button("Âge :", nil, {RightLabel = ageOfSuspect}, true, {
                        onSelected = function()
                            ageSuspect = KeyboardInput("Âge de l'individu", ageSuspect, 3)
                            if ageSuspect == nil then
                                ESX.ShowNotification("Champ Invalide")
                            else
                                ageSuspect = tonumber(ageSuspect)
                                ageOfSuspect = "~g~"..ageSuspect
                            end
                        end
                    })

                    RageUI.Button("Taille (cm) :", nil, {RightLabel = heightOfSuspect}, true, {
                        onSelected = function()
                            heightSuspect = KeyboardInput("Taille de l'individu", heightSuspect, 3)
                            if heightSuspect == nil then
                                ESX.ShowNotification("Champ Invalide")
                            else
                                heightSuspect = tonumber(heightSuspect)
                                heightOfSuspect = "~g~"..heightSuspect
                            end
                        end
                    })

                    RageUI.Button("Nationalité :", nil, {RightLabel = nationalityOfSuspect}, true, {
                        onSelected = function()
                            nationalitySuspect = KeyboardInput("Nationalité de l'individu", nationalitySuspect, 20)
                            if nationalitySuspect == nil then
                                ESX.ShowNotification("Champ Invalide")
                            else
                                nationalityOfSuspect = "~g~"..nationalitySuspect..""
                            end
                        end
                    })

                    RageUI.Button("Sexe :", nil, {RightLabel = sexOfSuspect}, true, {
                        onSelected = function()
                            sexSuspect = KeyboardInput("Sexe de l'individu (H/F)", sexSuspect, 1)
                            if sexSuspect == nil then
                                ESX.ShowNotification("Champ Invalide")
                            else
                                sexOfSuspect = "~g~"..sexSuspect..""
                            end
                        end
                    })
                    
                    if (nameOfSuspect and ageOfSuspect and heightOfSuspect and nationalityOfSuspect and sexOfSuspect ~= nil) then
                    RageUI.Button('Valider', false, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            TriggerServerEvent("ixCriminalRecords:create", nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect)
                            LoadListe()
                            nameOfSuspect, ageOfSuspect, heightOfSuspect, nationalityOfSuspect, sexOfSuspect, nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect = nil
                            RageUI.CloseAll()
                            open = false
                        end
                    })
                else
                    RageUI.Button("~m~Valider", "Tout les champs ne sont pas remplis", {RightBadge = RageUI.BadgeStyle.Lock}, false, {})
                end
                end)

                RageUI.IsVisible(listSub, function()

   

                    RageUI.List("Filtre :", ItemsList, filterIndex, nil, {}, true, {
                        onListChange = function(Index, Items)
                            filterIndex = Index
                        end,
                            onSelected = function()
                        end,
                })
                
                RageUI.Line()
                if filterIndex == 1 then 
                
                    for i = 1, #listeData,1 do
                       
                        RageUI.Button(listeData[i].name, nil, {RightLabel = "→→"}, true, {
                            onSelected = function()
                                nameSelected = listeData[i].name
                                ageSelected = listeData[i].age
                                heightSelected = listeData[i].height
                                nationalitySelected = listeData[i].nationality
                                sexSelected = listeData[i].sex
                                depositarySelected = listeData[i].depositary
                                dateSelected = listeData[i].date
                                
                            end
                        }, infoSub)
                        
                    end
                else
                
                
                                    for i = 1, #listeData,1 do
                                        if starts(listeData[i].name:lower(), ItemsList[filterIndex]:lower()) then
                                        RageUI.Button(listeData[i].name, nil, {RightLabel = "→→"}, true, {
                                            onSelected = function()
                                                nameSelected = listeData[i].name
                                                ageSelected = listeData[i].age
                                                heightSelected = listeData[i].height
                                                nationalitySelected = listeData[i].nationality
                                                sexSelected = listeData[i].sex
                                                depositarySelected = listeData[i].depositary
                                                dateSelected = listeData[i].date
                                                
                                            end
                                        }, infoSub)
                                    end
                                        
                                    end
                                end
                                end)


                RageUI.IsVisible(infoSub, function()
                    RageUI.Button("Identité : ", nil, {RightLabel = nameSelected}, true, {})
                    RageUI.Button("Âge: ", nil, {RightLabel = ageSelected}, true, {})
                    RageUI.Button("Taille : ", nil, {RightLabel = heightSelected}, true, {})
                    RageUI.Button("Nationalité : ", nil, {RightLabel = nationalitySelected}, true, {})
                    RageUI.Button("Sexe : ", nil, {RightLabel = sexSelected}, true, {})
                    RageUI.Button("Auteur du Casier : ", nil, {RightLabel = depositarySelected}, true, {})
                    RageUI.Button("Date : ", nil, {RightLabel = dateSelected}, true, {})
                    RageUI.Line()
                    RageUI.Button("Voir le Contenu du Casier", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent("actualCasier:selected", nameSelected)
                            LoadCasier()
                        end
                    }, viewCasier)
                    if ESX.PlayerData.job.grade_name == 'boss' then
                    RageUI.Button("Détruire le Casier", "Cette action est irréversible", {RightBadge = RageUI.BadgeStyle.Alert}, true, {
                        onSelected = function()
                            TriggerServerEvent("ixCriminalRecords:deletecasier", nameSelected)
                            TriggerServerEvent("delete:allmotif", nameSelected)
                            Wait(50)
                            LoadListe()
                            Wait(50)
                            RageUI.GoBack()
                        end
                    })
                else
                    RageUI.Button("~m~Détruire le Casier", "Option réservée au Commandant", {RightBadge = RageUI.BadgeStyle.Lock}, true, {})
                end
                end)

                RageUI.IsVisible(viewCasier, function()

                    RageUI.Button("Individu : ", nil, {RightLabel = nameSelected}, true, {})

                    RageUI.Checkbox("Modification", nil, IsInEditMode, {}, {
                        onChecked = function(index, items)
                            IsInEditMode = true
                        end,
                        onUnChecked = function(index, items)
                            IsInEditMode = false
                        end
                    
                    })
                    
                    if IsInEditMode then 
                        RageUI.Button("Ajouter un Motif", nil, {RightLabel = "→→→"}, true, {
                            onSelected = function()
                                motifOfSuspect = KeyboardInput("Motif", "", 200)
                                TriggerServerEvent("ixCriminalRecords:addmotif", nameSelected, motifOfSuspect)
                                Wait(50)
                                LoadCasier()
                            end
                        })
                    end
                    RageUI.Line()

                    if not IsInEditMode then 
                    for i = 1, #casierData,1 do
                        
                        RageUI.Button(casierData[i].motif, "Rédigé par ~g~"..casierData[i].depositary.."~s~ le ~g~"..casierData[i].date, {}, true, {
                            onSelected = function()   
                            end
                        })
                    end
                else
                    for i = 1, #casierData,1 do
                        
                        RageUI.List(casierData[i].motif, {"Modifier", "Supprimer"}, itemIndex, nil, {}, true, {
                            onListChange = function(Index, Items)
                                itemIndex = Index
                            end,
                                onSelected = function()
                                    motifOfCasier = casierData[i].motif
                                    if itemIndex == 1 then 
                                        newMotif = KeyboardInput("Nouveau Motif :", motifOfCasier, 200)
                                        TriggerServerEvent("edit:motif", nameSelected,motifOfCasier,newMotif)
                                        Wait(50)
                                        LoadCasier()
                                    else
                                        TriggerServerEvent("delete:motif", nameSelected,motifOfCasier)
                                        Wait(50)
                                        LoadCasier()
                                    end
                            end,
                    })
                    end
                end


                end)

                Wait(0)
            end
        end)
    end
end



CreateThread(function()
    while true do
        local coordsOfPlayer = GetEntityCoords(PlayerPedId())
        local spam = false
        for _,v in pairs(configuration.casier) do
            if #(coordsOfPlayer - v.pos) < 2 then
                spam = true
                if ESX.PlayerData.job.name == "police" then
                Visual.Subtitle("Appuyez sur ~p~E~s~ pour ~b~intéragir avec l'ordinateur")
                if IsControlJustReleased(0, 38) then
                    OpenMenu()
                    LoadListe()
                end  
            end               
            elseif #(coordsOfPlayer - v.pos) < 1.3 then
                spam = false 
                RageUI.CloseAll()
            end
        end
        if spam then
            Wait(1)
        else
            Wait(500)
        end
    end
end)