const { build } = require('esbuild')
const { filelocPlugin } = require('esbuild-plugin-fileloc')

build({
  bundle: true,
  sourcemap: 'inline',
  entryPoints: ['./server/server.ts'],
  outfile: './dist/server.js',
  platform: 'node',
  target: 'node16',
  plugins: [filelocPlugin()],
})
  .then(() => console.log('Built server files'))
  .catch(() => process.exit(1))

build({
  bundle: true,
  minify: true,
  sourcemap: 'inline',
  outfile: './dist/client.js',
  entryPoints: ['./client/client.ts'],
  platform: 'browser',
})
  .then(() => console.log('Built client files'))
  .catch(() => process.exit(1))
