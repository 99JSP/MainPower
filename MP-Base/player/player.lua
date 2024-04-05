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
		self.Data.job_grade = result[1].job_grade
		self.Data.bankingId = result[1].bankingId
		self.Data.phone = result[1].phone
		self.Data.metadata = result[1].metadata
        self.Data.citizenid = '' ..  self.Data.cid .. '-' .. self.Data.identifier .. ''


		self.Functions.switchJob = function(newJob, grade)
			if newJob ~= nil then
				self.Data.job = newJob
				self.Data.job_grade = grade
				-- MP.Functions.UpdateJob(self)
				-- self.Functions.UpdatePlayerData()
			end
			MP.Player.Save(source)
		end


		self.Functions.swapMoney = function(bankingType, amount)
			-- banking ids will be added here later
			if bankingType == "cash" then
				if (amount > self.Data.bank) then
					TriggerClientEvent('chat:addMessage', self.Data.PlayerId, "Banking: Not enough in bank.");
				else
					self.Data.cash = self.Data.cash + amount
					print(self.Data.cash)
					self.Data.bank = self.Data.bank - amount
					print(self.Data.bank)
					MP.Functions.UpdateMoney(self)
				end
			elseif bankingType == "bank" then
				-- swap to bank
				if (amount > self.Data.cash) then
					TriggerClientEvent('chat:addMessage', self.Data.PlayerId, "Banking: Not enough cash.");
				else
					self.Data.cash = self.Data.cash - amount
					print(self.Data.cash)
					self.Data.bank = self.Data.bank + amount
					print(self.Data.bank)
					MP.Functions.UpdateMoney(self)
				end
			end
			TriggerClientEvent("MP-Elements:Client:UpdateMoney", self.Data.PlayerId)
		end

		self.Functions.UpdateMoney = function(bankingType, amount, change)
			if bankingType == "cash" then
				if tostring(change) == "add" then
					TriggerClientEvent("MP-Elements:Client:UpdateCash", self.Data.PlayerId, amount, tostring(change))
					self.Data.cash = self.Data.cash + amount
				elseif tostring(change) == "del" then
					if amount > self.Data.cash then
						TriggerClientEvent('chat:addMessage', self.Data.PlayerId, "System: Not Enough Cash.")
					else
						TriggerClientEvent("MP-Elements:Client:UpdateCash", self.Data.PlayerId, amount, tostring(change) )
						self.Data.cash = self.Data.cash - amount
					end
				end
			elseif bankingType == "bank" then
				if tostring(change) == "add" then
					self.Data.bank = self.Data.bank + amount
					MP.Functions.UpdateMoney(self)
				elseif tostring(change) == "del" then
					self.Data.bank = self.Data.bank - amount
					MP.Functions.UpdateMoney(self)
				end
			end
			MP.Player.Save(source)

		end

		function self.Functions.Save()
			if self.Offline then
				MP.Player.SaveOffline(self.Data)
			else
				MP.Player.Save(self.Data)
			end
		end

		function self.Functions.UpdatePlayerData()
			if self.Offline then return end -- Unsupported for Offline Players
			TriggerEvent('MP:Player:SetPlayerData', self.Data)
			TriggerClientEvent('MP-SetCharData', self.Data.PlayerId, self.Data)
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
    end)

end

function MP.Functions.UpdateMoney(player)
    local PlayerData = player.Data
	if PlayerData then -- making sure data is grabbed
		-- saves cash/bank on update
		MySQL.query("UPDATE players SET bank = :bank, cash = :cash WHERE citizenid = :citizenid", {
			['bank'] = PlayerData.bank,
			['cash'] = PlayerData.cash,
			['citizenid'] = PlayerData.citizenid,
		})

	end
end

function MP.Functions.UpdateJob(player)
    local PlayerData = player.Data
	if PlayerData then
		MySQL.query("UPDATE players SET job = :job, job_grade = :job_grade WHERE citizenid = :citizenid", {
			['job'] = PlayerData.job,
			['job_grade'] = PlayerData.job_grade,
		})
	end
end

function MP.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = MP.Players[source].Data
    if PlayerData then
        MySQL.query("UPDATE players SET cid = :cid, license = :license, name = :name, sex = :sex, cash = :cash, bank = :bank, job = :job, job_grade = :job_grade, phone = :phone, metadata = :metadata WHERE citizenid = :citizenid", {
			['citizenid'] = PlayerData.citizenid,
			['cid'] = tonumber(PlayerData.cid),
			['license'] = PlayerData.license,
			['name'] = PlayerData.name,
			['sex'] = PlayerData.sex,
			['cash'] = PlayerData.cash,
			['bank'] = PlayerData.bank,
			['job'] = PlayerData.job,
			['job_grade'] = PlayerData.job_grade,
			['phone'] = PlayerData.phone,
			['metadata'] = PlayerData.metadata,
		})
        print("Player Saved")

		TriggerClientEvent('MP:Player:UpdatePlayerData', ped)
    else
        print("err playerdata = nil")
    end
end

function MP.Player.SaveOffline(PlayerData)
    if PlayerData then
        MySQL.Async.query("UPDATE players SET cid = :cid, license = :license, name = :name, sex = :sex, cash = :cash, bank = :bank, job = :job, job_grade = :job_grade, phone = :phone, metadata = :metadata WHERE citizenid = :citizenid", {
			['citizenid'] = PlayerData.citizenid,
			['cid'] = tonumber(PlayerData.cid),
			['license'] = PlayerData.license,
			['name'] = PlayerData.name,
			['sex'] = PlayerData.sex,
			['cash'] = PlayerData.cash,
			['bank'] = PlayerData.bank,
			['job'] = PlayerData.job,
			['phone'] = PlayerData.phone,
			['metadata'] = PlayerData.metadata,
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
