import config from '../config/config'
const Delay = (time: number) => new Promise((resolve) => setTimeout(resolve, time))
let isNearBank = false
let sleep = 10000 // defaulted to 10 sec its not a bad wait if you were to get there right away. I think
import { RegisterNuiCB } from '@project-error/pe-utils'

onNet('MP-Banking:OpenClient', (cash: number, bank: number, name: string) => {
  SendNUIMessage({
    action: 'openPage',
    data: {
      pageName: 'MPBANKING',
      playerCash: cash,
      playerBank: bank,
      fullName: name,
    },
  })
  SetNuiFocus(true, true)
})

onNet('MP-Banking:UpdateClient', (cash: number, bank: number) => {
  SendNUIMessage({
    action: 'updateDataMoney',
    data: {
      newCashAmount: cash,
      newBankAmount: bank,
    },
  })
})

onNet('MP-Banking:Management', () => {
  const source = PlayerId()
})

RegisterNuiCB('BankingDetails', (data, cb) => {
  const bType = data.buttonType
  const amount = data.amount
  const id = data.id
  const source = GetPlayerPed(-1)

  if (bType === 'withdraw') {
    emitNet('MP-Banking:withdraw', parseInt(amount))
  } else if (bType === 'deposit') {
    emitNet('MP-Banking:deposit', parseInt(amount))
  } else if (bType === 'transfer') {
    // Assuming `amount` and `id` are variables representing the amount and ID values
    emitNet('MP-Banking:transfer', parseInt(amount), parseInt(id))
  }


  cb('Success')
})

RegisterNuiCB('closeMenu', (_, cb) => {
  SetNuiFocus(false, false)
  SendNUIMessage({
    action: 'closePage',
    data: {
      pageName: 'MPBANKING',
    },
  })

  cb(true)
})

async function Blips() {
  // for every bank coordinate in config.ts create a blip
  for (const bank of config.Banks) {
    if (bank.blipEnabled) {
      const blip = AddBlipForCoord(bank.coords.x, bank.coords.y, bank.coords.z)
      SetBlipSprite(blip, 108)
      SetBlipDisplay(blip, 4)
      SetBlipScale(blip, 0.8)
      SetBlipColour(blip, 2)
      SetBlipAsShortRange(blip, true)
      BeginTextCommandSetBlipName('STRING')
      AddTextComponentString(bank.name)
      EndTextCommandSetBlipName(blip)
    }
  }
}
Blips()

async function BankTarget() {
  const source = PlayerPedId()
  const playerPos = GetEntityCoords(PlayerPedId(), false)
  isNearBank = false

  for (const bank of config.Banks) {
    // added another check for distance then set sleep lower to check every 1.5sec [there should be a slight delay i found this pretty well]
    if (
      Vdist(playerPos[0], playerPos[1], playerPos[2], bank.coords.x, bank.coords.y, bank.coords.z) <
      20
    ) {
      sleep = 1500
    }
    if (
      Vdist(playerPos[0], playerPos[1], playerPos[2], bank.coords.x, bank.coords.y, bank.coords.z) <
      2.5
    ) {
      isNearBank = true
      sleep = 10
      if (isNearBank && IsControlPressed(0, 38)) {
        emitNet('MP-Banking:Open', source)
        break
      }
    }
  }
}

setTick(async () => {
  await Delay(sleep)
  BankTarget()
})
