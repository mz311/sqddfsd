ESX = nil

-- Récupération de l'objet ESX
Citizen.CreateThread(function()
    ESX = exports['es_extended']:getSharedObject()

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX = xPlayer
    end)
end)

-- Menus contextuels
local contextMenus = {
    menuf5 = {
        { title = 'Faire une animation', arrow = true, icon = 'user', event = 'rp:RecieveMenu' },
        { title = 'Menu Facture', arrow = true, icon = 'fa-credit-card', event = 'skFactureV2:OpenMenu' },
        { title = 'Menu Annonce', arrow = true, icon = 'fa-bell', event = 'openAnnonce' },
        { title = 'Menu Props', arrow = true, icon = 'usert', event = 'openpropsmenu' },
        { title = 'Boutique', arrow = true, icon = 'shopping-cart', event = 'openVIPMenu' }
    },
    limite_vitesse = {
        { title = 'Limiter à 50 km/h', event = 'setSpeedLimit', args = 50 },
        { title = 'Limiter à 100 km/h', event = 'setSpeedLimit', args = 100 },
        { title = 'Limiter à 150 km/h', event = 'setSpeedLimit', args = 150 },
        { title = 'Personnaliser la limite', event = 'setCustomSpeedLimit' },
        { title = 'Désactiver le limiteur', event = 'removeSpeedLimit' }
    }
}

-- Enregistrement des menus contextuels
Citizen.CreateThread(function()
    lib.registerContext({
        id = 'menuf5',
        title = 'Menu principal',
        options = contextMenus.menuf5
    })

    lib.registerContext({
        id = 'limite_vitesse',
        title = 'Limite de vitesse',
        options = contextMenus.limite_vitesse
    })
end)

-- Mise à jour du menu F5
function UpdateVehicleMenu()
    local playerPed = PlayerPedId()
    local inVehicle = IsPedInAnyVehicle(playerPed, false)

    -- Sauvegarde des options de base
    local baseOptions = {
        { title = 'Faire une animation', arrow = true, icon = 'user', event = 'rp:RecieveMenu' },
        { title = 'Menu Facture', arrow = true, icon = 'fa-credit-card', event = 'skFactureV2:OpenMenu' },
        { title = 'Menu Annonce', arrow = true, icon = 'fa-bell', event = 'openAnnonce' },
        { title = 'Menu Props', arrow = true, icon = 'user', event = 'openpropsmenu' },
        { title = 'Boutique', arrow = true, icon = 'shopping-cart', event = 'openVIPMenu' }
    }

    -- Ajout des options liées au véhicule
    if inVehicle then
        table.insert(baseOptions, { title = 'Véhicule', arrow = true, icon = 'fa-car', event = 'bit-vehControl:open' })
        table.insert(baseOptions, { title = 'Limiter la vitesse', arrow = true, icon = 'fa-tachometer-alt', menu = 'limite_vitesse' })
    end

    -- Mise à jour du menu
    contextMenus.menuf5 = baseOptions
end

-- Vérification de la pression de la touche F5
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 166) then -- Touche F5
            ShowContextMenu('menuf5', GetPlayerName(PlayerId()))
        end
    end
end)

-- Fonction pour afficher le menu contextuel
function ShowContextMenu(contextId, playerName)
    UpdateVehicleMenu() -- Met à jour les options du menu

    local menu = contextMenus[contextId]
    if menu then
        lib.registerContext({ id = contextId, title = playerName, options = menu })
        lib.showContext(contextId)
    else
        print("Erreur: Le menu avec l'ID '" .. contextId .. "' n'existe pas.")
    end
end

-- Notifications via ox_lib
function ShowNotification(message, type)
    lib.notify({
        title = 'Notification',
        description = message,
        type = type or 'inform'
    })
end

-- Ouvrir le menu Annonce
RegisterNetEvent('openAnnonce')
AddEventHandler('openAnnonce', function()
    TriggerEvent('chat:addMessage', {
        args = { "/annonce exécuté!" }
    })
    ExecuteCommand('annonce')
end)

-- Ouvrir le menu VIP (Boutique)
RegisterNetEvent('openVIPMenu')
AddEventHandler('openVIPMenu', function()
    TriggerEvent('chat:addMessage', {
        args = { "/vipmenu exécuté!" }
    })
    ExecuteCommand('vipmenu')
end)

-- Ouvrir le menu props
RegisterNetEvent('openpropsmenu')
AddEventHandler('openpropsmenu', function()
    TriggerEvent('chat:addMessage', {
        args = { "/sprops exécuté!" }
    })
    ExecuteCommand('sprops')
end)

-- Commande de test pour afficher le menu F5
RegisterCommand('testMenu', function()
    ShowContextMenu('menuf5', GetPlayerName(PlayerId()))
end, false)

-- Débogage : Afficher les options du menu dans la console
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        print("Options actuelles du menu F5:")
        print(json.encode(contextMenus.menuf5)) -- Vérifie les options affichées
    end
end)
