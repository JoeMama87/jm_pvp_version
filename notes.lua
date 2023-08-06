local messageToSend = "This is a message sent to the Discord webhook!"
TriggerEvent('sendWebhook', messageToSend)


-- server.lua

include('config.lua')

RegisterServerEvent('sendWebhook')
AddEventHandler('sendWebhook', function(message)
    if Config.webhook.url == 'CHANGE_ME' or Config.webhook.url == '' then
        if Config.webhook.debug then
            print('[YourServerName] Discord webhook URL not set. Skipping webhook sending.')
        end
        return
    end

    -- Perform any server-side actions here if needed before triggering the client event
    if Config.webhook.debug then
        print('[YourServerName] Triggering webhook event with message:', message)
    end

    TriggerClientEvent('sendWebhook', -1, message) -- Sending the event to all clients
end)


-- client.lua

include('config.lua')

RegisterNetEvent('sendWebhook')
AddEventHandler('sendWebhook', function(message)
    if Config.webhook.url == 'CHANGE_ME' or Config.webhook.url == '' then
        if Config.webhook.debug then
            print('[YourServerName] Discord webhook URL not set. Skipping webhook sending.')
        end
        return
    end

    local data = {
        content = message,
        username = Config.serverName
    }
    PerformHttpRequest(Config.webhook.url, function(statusCode, response, headers)
        if Config.webhook.debug then
            print('[YourServerName] Webhook Response:', statusCode, response)
        end
    end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
end)


-- config.lua

Config = {
    webhook = {
        url = 'CHANGE_ME', -- Set this to 'CHANGE_ME' initially
        debug = false, -- Set this to true to enable debug prints for webhook functionality
    },
    serverName = 'My FiveM Server',
    maxPlayers = 32,
    -- Add other configuration options here
}
