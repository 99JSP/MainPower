
MP.Player = {}

MP.Player.LoadData = function(source, identifier, cid)

    MySQL.query('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
        local self = {}
        self.Data = {}
        self.Functions = {}

		self.Data.id = result[1].id
        self.Data.PlayerId = source
        self.Data.identifier = result[1].identifier
        self.Data.license = result[1].license
        self.Data.name = result[1].name
		self.Data.sex = result[1].sex
        self.Data.cid = cid
        self.Data.firstname = result[1].firstname
        self.Data.lastname = result[1].lastname
        self.Data.cash = result[1].cash
        self.Data.bank = result[1].bank
		self.Data.job = result[1].job
		self.Data.phone = result[1].phone
		self.Data.metadata = result[1].metadata
        self.Data.citizenid = '' ..  self.Data.cid .. '-' .. self.Data.identifier .. ''

        self.Functions.addCash = function(amount)
            MP.Functions.addCash(self, amount)
            self.Data.cash = self.Data.cash + amount
        end

        self.Functions.GiveCash = function(amount)
            MP.Functions.GiveCash(self, amount)
            self.Data.cash = self.Data.cash + amount
        end

        self.Functions.removeCash = function(amount)
            MP.Functions.removeCash(self, amount)
            self.Data.cash = self.Data.cash - amount
        end

		self.Functions.AddBank = function(amount)
            MP.Functions.AddBank(self, amount)
            self.Data.bank = self.Data.bank + amount
        end

        self.Functions.GiveBank = function(amount)
            MP.Functions.GiveBank(self, amount)
            self.Data.bank = self.Data.bank + amount
        end

        self.Functions.removeBank = function(amount)
            MP.Functions.removeBank(self, amount)
            self.Data.bank = self.Data.bank + amount
        end

        self.Functions.setCash = function(amount)
            self.Data.cash =  amount
            MP.Functions.setCash(self, amount)
        end

        self.Functions.setBank = function(amount)
            self.Data.bank =  amount
            MP.Functions.setBank(self, amount)
        end

		function self.Functions.Save()
			if self.Offline then
				MP.Player.SaveOffline(self.Data)
			else
				MP.Player.Save(self.Data.PlayerId)
			end
		end

		function self.Functions.UpdatePlayerData()
			if self.Offline then return end -- Unsupported for Offline Players
			TriggerEvent('MP:Player:SetPlayerData', self.Data)
			TriggerClientEvent('MP:Player:SetPlayerData', self.Data.PlayerId, self.Data)
		end

		function self.Functions.SetMetaData(meta, val)
			if not meta or type(meta) ~= 'string' then return end
			if meta == 'hunger' or meta == 'thirst' then
				val = val > 100 and 100 or val
			end
			self.PlayerData.metadata[meta] = val
			self.Functions.UpdatePlayerData()
		end

		function self.Functions.GetMetaData(meta)
			if not meta or type(meta) ~= 'string' then return end
			return self.PlayerData.metadata[meta]
		end

		function self.Functions.SetPlayerData(key, val)
			if not key or type(key) ~= 'string' then return end
			self.Data[key] = val
			self.Functions.UpdatePlayerData()
		end

		function self.Functions.Logout()
			if self.Offline then return end -- Unsupported for Offline Players
			MP.Player.Logout(self.Data.PlayerId)
		end

        MP.Players[source] = self
		print("DATA LOADED")
    end)

end

-- RegisterCommand('testing', function(source)
-- 	local ped = GetPlayerPed(source)
--     local pcoords = GetEntityCoords(ped)
--     local PlayerData = MP.Players[source].Data
-- 	print(PlayerData)
-- end)

function MP.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = MP.Players[source].Data
    if PlayerData then
        MySQL.query("UPDATE players SET cid = :cid, license = :license, name = :name, sex = :sex, cash = :cash, bank = :bank, job = :job, phone = :phone, metadata = :metadata WHERE citizenid = :citizenid", {
			['citizenid'] = PlayerData.citizenid,
			['cid'] = tonumber(PlayerData.cid),
			['license'] = PlayerData.license,
			['name'] = PlayerData.name,
			['sex'] = PlayerData.sex,
			['cash'] = PlayerData.cash,
			['bank'] = PlayerData.bank,
			['job'] = PlayerData.job,
			['phone'] = PlayerData.phone,
			['metadata'] = json.encode(PlayerData.metadata),
		})
        print("Player Saved")
    else
        print("err playerdata = nil")
    end
end

function MP.Player.SaveOffline(PlayerData)
    if PlayerData then
        MySQL.Async.query("UPDATE players SET cid = :cid, license = :license, name = :name, sex = :sex, cash = :cash, bank = :bank, job = :job, phone = :phone, metadata = :metadata WHERE citizenid = :citizenid", {
			['citizenid'] = PlayerData.citizenid,
			['cid'] = tonumber(PlayerData.cid),
			['license'] = PlayerData.license,
			['name'] = PlayerData.name,
			['sex'] = PlayerData.sex,
			['cash'] = PlayerData.cash,
			['bank'] = PlayerData.bank,
			['job'] = PlayerData.job,
			['phone'] = PlayerData.phone,
			['metadata'] = json.encode(PlayerData.metadata),
		})
        print("Offline Player Saved")
    else
        print("err offline playerdata = nil")
    end
end

function MP.Player.Logout(source)
    TriggerClientEvent('MP:Client:OnPlayerUnload', source)
    TriggerEvent('MP:Server:OnPlayerUnload', source)
    TriggerClientEvent('MP:Player:UpdatePlayerData', source)
    Wait(200)
    MP.Players[source] = nil
end
