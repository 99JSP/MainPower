import { useEffect, useRef } from 'react'

const LISTENED_KEYS = ['Escape']

export const useExitListener = (callback: any) => {
  const setterRef = useRef(() => null)

  useEffect(() => {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    setterRef.current = callback
  }, [callback])

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (LISTENED_KEYS.includes(e.code)) {
        setterRef.current()
      }
    }

    window.addEventListener('keydown', keyHandler)

    return () => window.removeEventListener('keydown', keyHandler)
  }, [])
}
