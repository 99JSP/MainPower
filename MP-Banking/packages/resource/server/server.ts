const MP = global.exports['MP-Base'].GetObject()

onNet('MP-Banking:Open', async (source: number) => {
  const src = global.source
  const Player = MP.Functions.GetPlayer(src)
  const data = Player.Data
  const cash = data.cash
  const bank = data.bank
  const name = `${data.firstname} ${data.lastname}`
  emitNet('MP-Banking:OpenClient', src, cash, bank, name)
})

onNet('MP-Banking:withdraw', function (amount: number) {
  const src = source
  const Player = MP.Functions.GetPlayer(src)
  const cash = Player.Data.cash
  const bank = Player.Data.bank
  const swap = Player.Functions.swapMoney('cash', amount)

  setTimeout(() => {
    const Player = MP.Functions.GetPlayer(src)
    const cash = Player.Data.cash
    const bank = Player.Data.bank
    emitNet('MP-Banking:UpdateClient', Player.Data.PlayerId, cash, bank)
  }, 1000) // 1000 milliseconds (2 seconds)
})

onNet('MP-Banking:deposit', function (amount: number) {
  const src = source
  const Player = MP.Functions.GetPlayer(src)
  // newPlayer function to make banking a lot easier. swapMoney[swapping2, amount]
  const cash = Player.Data.cash
  const bank = Player.Data.bank
  const swap = Player.Functions.swapMoney('bank', amount)

  setTimeout(() => {
    const Player = MP.Functions.GetPlayer(src)
    const cash = Player.Data.cash
    const bank = Player.Data.bank
    emitNet('MP-Banking:UpdateClient', Player.Data.PlayerId, cash, bank)
  }, 1000) // 1000 milliseconds (2 seconds)
})

onNet('MP-Banking:transfer', function (amount: number, id: number) {
  const src = source
  const Player = MP.Functions.GetPlayer(src)
  // newPlayer function to make banking a lot easier. swapMoney[swapping2, amount]
  const cash = Player.Data.cash
  const bank = Player.Data.bank

  emitNet(
    'chat:addMessage',
    Player.Data.PlayerId,
    `Banking: Transfer payment of ${amount} was denied as banking is currently under maintenance`,
  )
})
