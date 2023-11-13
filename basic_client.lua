local lastPlayerPos = {}

AddEventHandler('onClientMapStart', function()
  	exports.spawnmanager:setAutoSpawn(true)
  	exports.spawnmanager:forceRespawn(true)
end)

if Config.ManualRespawn then
	AddEventHandler('playerSpawned', function()
		exports.spawnmanager:setAutoSpawn(false)
		exports.spawnmanager:forceRespawn(false)
		Citizen.Wait(2000)
		TriggerServerEvent("GetPlayerSpawnPosition")
	end)
end

RegisterNetEvent("spawnmanga:placement")
AddEventHandler("spawnmanga:placement",function (position)
	if position ~= nil then
		NetworkResurrectLocalPlayer(position.x,position.y,position.z, true, true, false)
		SetPlayerInvincible(GetPlayerPed(-1), false)
		ClearPedBloodDamage(GetPlayerPed(-1))
	end
end)

RegisterNetEvent('respawnPlayer')
AddEventHandler('respawnPlayer', function()
	NetworkResurrectLocalPlayer(lastPlayerPos.x,lastPlayerPos.y,lastPlayerPos.z, true, true, false)
	SetPlayerInvincible(GetPlayerPed(-1), false)
	ClearPedBloodDamage(GetPlayerPed(-1))
	TriggerServerEvent("saveposition",lastPlayerPos)
end)

Citizen.CreateThread(function()
	while true do
   		lastPlayerPos = GetEntityCoords(GetPlayerPed(-1))
		TriggerServerEvent("saveposition",lastPlayerPos)
		Citizen.Wait(5000)
	end
end)