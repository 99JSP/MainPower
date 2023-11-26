import React, { createContext, useContext, useEffect, useState } from 'react'
import { appPages } from './pages'

interface PageState {
  name: string
  component: (props: any) => JSX.Element
}

interface PageContext {
  openPage: (page: string, playerCash?: number, playerBank?: number, fullName?: string) => void
  closePage: (page: string) => void
}

const PageContext = createContext({} as PageContext)
export const usePageContext = () => useContext(PageContext)

function App() {
  const [pages, setPages] = useState<PageState[]>([])

  function openPage(pageName: string, playerCash: number, playerBank: number, fullName: string) {
    type ObjectKey = keyof typeof appPages
    const key = pageName as ObjectKey

    if (!pageName || !appPages[key]) return
    if (pages.find((page) => page.name === pageName)) return

    const newPage = {
      name: pageName,
      component: () => appPages[key]({ playerCash, playerBank, fullName }), // Pass playerCash as a prop
    }
    const newPages = [...pages, newPage]
    setPages(newPages)
  }

  function closePage(pageName: string) {
    const newPages = pages.filter((page) => page.name !== pageName)
    setPages(newPages)
  }

  function handleMessage(event: { data: any }) {
    const data = event.data

    if (data.action === 'openPage') {
      openPage(data.data.pageName, data.data.playerCash, data.data.playerBank, data.data.fullName)
    } else if (data.action === 'closePage') {
      closePage(data.data.pageName)
    }
  }

  useEffect(() => {
    window.addEventListener('message', handleMessage)
    return () => {
      window.removeEventListener('message', handleMessage)
    }
  }, [])

  const pagesMapped = pages.map((page, index) => {
    const Page = page.component
    return <Page key={index} />
  })

  return <PageContext.Provider value={{ openPage, closePage }}>{pagesMapped}</PageContext.Provider>
}

export default App
