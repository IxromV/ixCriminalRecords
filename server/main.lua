  
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function GetActualTime() 
	date = os.date('*t')
	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
	if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

	date = "" .. date.day .. "/" .. date.month .. "/" .. date.year .. " - " .. math.floor(date.hour + 2) .. ":" .. date.min .. ":" .. date.sec 
	return date
end

RegisterNetEvent("ixCriminalRecords:create")
AddEventHandler("ixCriminalRecords:create", function(nameSuspect, ageSuspect, heightSuspect, nationalitySuspect, sexSuspect)
	local __src = source 
	local casierData = {}
	MySQL.Async.fetchAll("SELECT * FROM criminal_records WHERE name = @name", {
		["name"] = nameSuspect
	}, function(casierData)
		if casierData[1] == nil then
			TriggerClientEvent('esx:showAdvancedNotification', __src, "Casier Judiciaire", "~g~Succès", "Le Casier Judiciaire a bien été crée au nom de : ~g~"..nameSuspect, 'CHAR_ARIAM', 0)
	MySQL.Async.execute("INSERT INTO criminal_records (depositary, name, age, height, nationality, sex, date) VALUES (@a, @b, @c, @d, @e, @f, @g)", {
		["a"] = GetPlayerName(__src),
		["b"] = nameSuspect,
		["c"] = ageSuspect,
		["d"] = heightSuspect,
		["e"] = nationalitySuspect,
		["f"] = sexSuspect,
		["g"] = GetActualTime()
	})
	local logs = {{ ["author"] = { ["name"] = "🌌 RFS Store", ["icon_url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["thumbnail"] = { ["url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["color"] = "7419530", ["title"] = Title, ["description"] = "Casier Crée : "..nameSuspect.."\nAuteur de la Création : "..GetPlayerName(__src).."["..__src.."]", ["footer"] = { ["text"] = GetActualTime(), ["icon_url"] = nil }, } }
            PerformHttpRequest(configuration.webhook.createCasier, function(err, text, headers) end, 'POST', json.encode({username = "LogsBot", embeds = logs, avatar_url = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }), { ['Content-Type'] = 'application/json' })
else
	TriggerClientEvent('esx:showAdvancedNotification', __src, "Casier Judiciaire", "~r~Echec", "Cet individu (~g~"..nameSuspect.."~s~) possède déjà un casier !", 'CHAR_ARIAM', 0)
end
end)
end)


ESX.RegisterServerCallback("ixCriminalRecords:getList", function(source, cb)
	totalCasierData = {}
	MySQL.Async.fetchAll("SELECT * FROM criminal_records", {}, function(data)
		for _, v in pairs(data) do
		table.insert(totalCasierData, {name = v.name, age = v.age, depositary = v.depositary, height = v.height, nationality = v.nationality, sex = v.sex, date = v.date})
		end 
	cb(totalCasierData)
	end)
end)

RegisterNetEvent("ixCriminalRecords:deletecasier")
AddEventHandler("ixCriminalRecords:deletecasier", function(name)
	local __src = source
	MySQL.Async.execute("DELETE FROM criminal_records WHERE name = @a", {
		["a"] = name
	})
	local logs = {{ ["author"] = { ["name"] = "🌌 RFS Store", ["icon_url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["thumbnail"] = { ["url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["color"] = "7419530", ["title"] = Title, ["description"] = "Casier Supprimé : "..name.."\nAuteur de la Suppression : "..GetPlayerName(__src).."["..__src.."]", ["footer"] = { ["text"] = GetActualTime(), ["icon_url"] = nil }, } }
            PerformHttpRequest(configuration.webhook.supprCasier, function(err, text, headers) end, 'POST', json.encode({username = "LogsBot", embeds = logs, avatar_url = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }), { ['Content-Type'] = 'application/json' })
end)


RegisterNetEvent("ixCriminalRecords:addmotif")
AddEventHandler("ixCriminalRecords:addmotif", function(name, motif)
	local __src = source
	MySQL.Async.execute("INSERT INTO criminal_records_content (depositary,name,motif,date) VALUES (@a,@b,@c,@d)", {
		["a"] = GetPlayerName(__src),
		["b"] = name,
		["c"] = motif,
		["d"] = GetActualTime()
	})
	local logs = {{ ["author"] = { ["name"] = "🌌 RFS Store", ["icon_url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["thumbnail"] = { ["url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["color"] = "7419530", ["title"] = Title, ["description"] = "Casier : "..name.."\nMotif Ajouté : "..motif.."\nAuteur de l'Ajout : "..GetPlayerName(__src), ["footer"] = { ["text"] = GetActualTime(), ["icon_url"] = nil }, } }
            PerformHttpRequest(configuration.webhook.addMotif, function(err, text, headers) end, 'POST', json.encode({username = "LogsBot", embeds = logs, avatar_url = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }), { ['Content-Type'] = 'application/json' })
end)

ESX.RegisterServerCallback("ixCriminalRecords:getList", function(source, cb)
	totalCasierData = {}
	MySQL.Async.fetchAll("SELECT * FROM criminal_records", {}, function(data)
		for _, v in pairs(data) do
		table.insert(totalCasierData, {name = v.name, age = v.age, depositary = v.depositary, height = v.height, nationality = v.nationality, sex = v.sex, date = v.date})
		end 
	cb(totalCasierData)
	end)
end)

casiera = nil
RegisterNetEvent("actualCasier:selected")
AddEventHandler("actualCasier:selected", function(name)
	casiera = name
end)

ESX.RegisterServerCallback("ixCriminalRecords:getCasier", function(source, cb)
	motifData = {}
	MySQL.Async.fetchAll("SELECT * FROM criminal_records_content WHERE name = @a", {["@a"] = casiera}, function(data)
		for _, v in pairs(data) do
		table.insert(motifData, {depositary = v.depositary, name = v.name, motif = v.motif, date = v.date})
		end 
	cb(motifData)
	end)
end)

RegisterNetEvent("edit:motif")
AddEventHandler("edit:motif", function(name, lastMotif ,newMotif)
	local __src = source
	MySQL.Async.execute("UPDATE criminal_records_content SET motif = @a WHERE name = @b and motif = @c", {
		["a"] = newMotif,
		["b"] = name,
		["c"] = lastMotif
	})
	local logs = {{ ["author"] = { ["name"] = "🌌 RFS Store", ["icon_url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["thumbnail"] = { ["url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["color"] = "7419530", ["title"] = Title, ["description"] = "Casier : "..name.."\nAvant Modification : "..lastMotif.."\nAprès Modification : "..newMotif.."\nAuteur de la Modification : "..GetPlayerName(__src), ["footer"] = { ["text"] = GetActualTime(), ["icon_url"] = nil }, } }
            PerformHttpRequest(configuration.webhook.editMotif, function(err, text, headers) end, 'POST', json.encode({username = "LogsBot", embeds = logs, avatar_url = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("delete:motif")
AddEventHandler("delete:motif", function(name, motif)
	local __src = source
	MySQL.Async.execute("DELETE FROM criminal_records_content WHERE name = @name and motif = @motif", {
		["name"] = name, 
		["motif"] = motif
	})
	local logs = {{ ["author"] = { ["name"] = "🌌 RFS Store", ["icon_url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["thumbnail"] = { ["url"] = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }, ["color"] = "7419530", ["title"] = Title, ["description"] = "Casier : "..name.."\nMotif Supprimé : "..motif.."\nAuteur de la Suppression : "..GetPlayerName(__src), ["footer"] = { ["text"] = GetActualTime(), ["icon_url"] = nil }, } }
            PerformHttpRequest(configuration.webhook.supprMotif, function(err, text, headers) end, 'POST', json.encode({username = "LogsBot", embeds = logs, avatar_url = "https://media.discordapp.net/attachments/976967293793886258/976968665360654356/rfs_plus_groe.png" }), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent("delete:allmotif")
AddEventHandler("delete:allmotif", function(name)
	MySQL.Async.execute("DELETE FROM criminal_records_content WHERE name = @name", {
		["name"] = name
	})
end)