/* eslint-disable prettier/prettier */
// config.ts

interface Banks {
  name: string
  coords: { x: number; y: number; z: number }
  blipEnabled: boolean
}
interface BankTarget {
  coords: { x: number; y: number; z: number }
}

interface ServerConfig {
  Banks: Banks[]
  target: boolean
  BankTarget: BankTarget
}

const config: ServerConfig = {
  Banks: [
    {
      name: 'Bank',
      coords: { x: 149.78, y: -1040.95, z: 29.37 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: 150.0386, y: -1040.7106, z: 29.3741 }, // Legion Square Bank
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: 149.91, y: -1040.74, z: 29.374 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: -1212.63, y: -330.78, z: 37.59 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: -2962.47, y: 482.93, z: 15.5 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: -350.99, y: -49.99, z: 48.84 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: 1175.02, y: 2706.87, z: 37.89 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: -113.01, y: 6470.24, z: 31.43 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: 246.63, y: 223.62, z: 106.0 },
      blipEnabled: true,
    },
    {
      name: 'Bank',
      coords: { x: 314.3904, y: -279.1545, z: 54.1708 },
      blipEnabled: true,
    },
  ],
  target: false, // Below only works if this is true
  BankTarget: {
    coords: { x: 149.78, y: -1040.95, z: 29.37 }, // Example location. Change to your location
  },
}

export default config
