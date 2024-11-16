ESX = exports['es_extended']:getSharedObject()

-- Enregistrer la commande /vipmenu
RegisterCommand('vipmenu', function(source, args, rawCommand)
    -- Récupérer l'objet du joueur
    local xPlayer = ESX.GetPlayerFromId(source)
end)

RegisterCommand('annonce', function(source, args, rawCommand)
    -- Récupérer l'objet du joueur
    local xPlayer = ESX.GetPlayerFromId(source)
end)
