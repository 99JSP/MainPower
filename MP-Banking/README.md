# FiveM React Typescript Eslint Boilerplate

Opinionated boilerplate for [FiveM](https://fivem.net/) with [React](https://reactjs.org/) JSX Vite [Typescript](https://www.typescriptlang.org/) Webpack & esbuild [Eslint](https://eslint.org/) [Prettier](https://prettier.io/) using [Lerna](https://lerna.js.org/) and yarn workspaces.

Includes Eslint and prettier for client server and ui with typechecking.

## Requirements
* Brains
* Yarn
* Basic understanding of web development with react and some understanding of FiveM resources.

## How to use
1. Download this repo and extract
2. Rename folder to something great and innovative
3. Place folder to your Cfx server resources folder
4. Add `ensure your_resource_name_here` to your server.cfg
5. `yarn install` in root of the project
6. Start making content using commands listed below

## Development

``yarn watch:web`` Launches web browser with UI. You can also develop in game with this mode.

``yarn watch`` Starts watching for changes in client and server. Rebuilds on change. Works also in game.

## Building

``yarn build``


## Acknowledgements

Some utils used are from Project Error. You can read more about the utils at [Project Error react boilerplate](https://github.com/project-error/fivem-react-boilerplate-lua)
