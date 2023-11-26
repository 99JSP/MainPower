import React, { useState, useEffect } from 'react'
import { usePageContext } from '../../App'
import { fetchNui, useNuiQuery } from '../../utils/nui'
import { useExitListener } from '../../utils/exitListener'
import MP from '../../../public/mp.png'

interface MPBANKINGProps {
  playerCash: number
  playerBank: number
  fullName: string
}

const MPBANKING: React.FC<MPBANKINGProps> = ({ playerCash, playerBank, fullName }) => {
  const { closePage } = usePageContext()
  const [showInput, setShowInput] = useState<boolean>(false)
  const [inputValue, setInputValue] = useState<string>('')
  const [secondInputValue, setSecondInputValue] = useState<string>('')
  const [LastButton, setLastButton] = useState<string>('')
  const [refresh, setRefresh] = useState(false)
  const [cash, setCash] = useState(playerCash)
  const [bank, setBank] = useState(playerBank)

  useEffect(() => {
    const handleMessage = (event) => {
      const data = event.data

      if (data.action === 'updateDataMoney') {
        const newCashAmount = data.data.newCashAmount
        const newBankAmount = data.data.newBankAmount
        updateDataMoney(newCashAmount, newBankAmount)
      }
    }

    window.addEventListener('message', handleMessage)

    return () => {
      window.removeEventListener('message', handleMessage)
    }
  }, [])

  const formattedBankAmount = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 2, // Number of decimal places
  }).format(bank)

  const updateDataMoney = (newCashAmount: number, newBankAmount: number) => {
    setCash(newCashAmount)
    setBank(newBankAmount)
  }

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setInputValue(e.target.value)
  }

  const handleSecondInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSecondInputValue(e.target.value)
  }

  const handleBack = () => {
    setShowInput(false)
    setInputValue('')
    setSecondInputValue('')
  }

  const handleButtonClick = (buttonType: any) => {
    setLastButton(buttonType)
    if (buttonType === 'transfer') {
      setShowInput(true)
      setSecondInputValue('')
    } else if (buttonType === 'withdraw' || buttonType === 'deposit') {
      setShowInput(buttonType)
    }
  }

  const sendDataToFiveM = (buttonType: any, amount: any, id: any) => {
    const data = { buttonType, amount, id }
    fetchNui('BankingDetails', data)
    setRefresh(!refresh)
  }

  const handleConfirm = () => {
    sendDataToFiveM(LastButton, inputValue, secondInputValue)
    setInputValue('')
    setSecondInputValue('')
    setShowInput(false)
  }

  async function close() {
    closePage('MPBANKING')
    await fetchNui('closeMenu')
  }

  useExitListener(async () => {
    await close()
  })

  return (
    <div className='banking'>
      <div className='banking__container'>
        <div className='banking__container--header'>
          <div className='header__content'>
            <div className='banking__container--header-left'>
              <img src={MP} alt='main power' /> | Banking
            </div>
            <div className='banking__container--header-right'>
              <h3>Welcome, {fullName}</h3>
            </div>
          </div>
        </div>
        <div className='banking__container--account'>
          <div className='account__info'>
            <div className='banking__container--account-name'>
              <h3>Checking</h3>
            </div>
            <div className='banking__container--account-amount'>
              <p>Current Balance:</p>
              <h3>{formattedBankAmount}</h3>
            </div>
          </div>
        </div>
        <div className='width100'>
          {!showInput && (
            <>
              <button className='banking-Button' onClick={() => handleButtonClick('withdraw')}>
                Withdraw
              </button>
              <button className='banking-Button' onClick={() => handleButtonClick('deposit')}>
                Deposit
              </button>
              <button className='banking-Button' onClick={() => handleButtonClick('transfer')}>
                Transfer
              </button>
            </>
          )}

          {showInput === true && (
            <div className='width100 gap2'>
              <input
                type='text'
                placeholder='1000'
                value={inputValue}
                onChange={handleInputChange}
              />
              <input
                type='text'
                placeholder='id'
                value={secondInputValue}
                onChange={handleSecondInputChange}
              />
              <button className='confrim-Button' onClick={handleConfirm}>
                Confirm
              </button>
              <button className='return-Button' onClick={handleBack}>
                Back
              </button>
            </div>
          )}

          {showInput === 'withdraw' && (
            <div className='width50 gap2'>
              <input
                type='text'
                placeholder='1000'
                value={inputValue}
                onChange={handleInputChange}
              />
              <button className='confrim-Button' onClick={handleConfirm}>
                Confirm
              </button>
              <button className='return-Button' onClick={handleBack}>
                Back
              </button>
            </div>
          )}

          {showInput === 'deposit' && (
            <div className='width50 gap2'>
              <input
                type='text'
                placeholder='1000'
                value={inputValue}
                onChange={handleInputChange}
              />
              <button className='confrim-Button' onClick={handleConfirm}>
                Confirm
              </button>
              <button className='return-Button' onClick={handleBack}>
                Back
              </button>
            </div>
          )}
        </div>
      </div>
      <div className='end-flex'>
        <button className='exit' onClick={close}>
          Close
        </button>
        <p>You have ${cash} on hand!</p>
      </div>
    </div>
  )
}

export default MPBANKING
