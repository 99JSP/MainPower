
MP.Player = {}

MP.Player.LoadData = function(source, identifier, cid)

    MySQL.query.await('SELECT * FROM players WHERE identifier = @identifier AND cid = @cid', {['@identifier'] = identifier, ['@cid'] = cid}, function(result)
        local self = {}
        self.Data = {}
        self.Functions = {}

        self.Data.PlayerId = source
        self.Data.identifier = result[1].identifier
        self.Data.license = result[1].license
        self.Data.name = result[1].name
        self.Data.cid = cid
        self.Data.job = result[1].job
        self.Data.firstname = result[1].firstname
        self.Data.lastname = result[1].lastname
        self.Data.cash = result[1].cash
        self.Data.bank = result[1].bank
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

        MP.Players[source] = self
    end)

end
