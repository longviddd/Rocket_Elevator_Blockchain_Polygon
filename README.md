# Rocket Elevators - Week 12 - Blockchain
## Folder Organization Info

Smart Contract: `src/contracts/RE_SmartContract.sol`

Test: `test/`

App:https://shielded-savannah-02259.herokuapp.com/

Marketplace Collection on TestNet: https://testnets.opensea.io/collection/rea-v3

### Bonus 

Alternate Blockchain Details Doc: https://docs.google.com/document/d/1qvXIayeNGzuSGV1Vt1pL_croTbym0f7YQWTRwtri3OA/edit?usp=sharing

## Installation 🛠️

If you are cloning the project then run this first, otherwise you can download the source code on the release page and skip this step.

```sh
git clone https://github.com/HashLips/hashlips_nft_minting_dapp.git
```

Make sure you have node.js installed so you can use npm, then run:

```sh
npm install
```

## Usage ℹ️

In order to make use of this dapp, all you need to do is change the configurations to point to your smart contract as well as update the images and theme file.

For the most part all the changes will be in the `public` folder.

To link up your existing smart contract, go to the `public/config/config.json` file and update the following fields to fit your smart contract, network and marketplace details. The cost field should be in wei.

Note: this dapp is designed to work with the intended NFT smart contract, that only takes one parameter in the mint function "mintAmount". But you can change that in the App.js file if you need to use a smart contract that takes 2 params.

```json
{
  “CONTRACT_ADDRESS”: “0x63337Aa7a6Db08e1B37fAFe565614ed708bA2a70",
  “CONTRACT_ADDRESS_ROCKET”: “0x3b8F02Aa259f1c55fC2afaFF9cC3695074Ff80EB”,
  “SCAN_LINK”: “https://polygonscan.com/token/0x1F2215EB06Ae0d3B0615F64a7f8416Ef3fE66673”,
  “NETWORK”: {
    “NAME”: “Rinkeby”,
    “SYMBOL”: “Ether”,
    “ID”: 4
  },
  “NFT_NAME”: “Rocket Elevator Artwork”,
  “SYMBOL”: “REA”,
  “MAX_SUPPLY”: 1000,
  “WEI_COST”: 10000000000000000,
  “WEI_COST_PRESALE”: 5000000000000000,
  “DISPLAY_COST”: 0.01,
  “GAS_LIMIT”: 3000000,
  “MARKETPLACE”: “Opeansea”,
  “MARKETPLACE_LINK”: “https://opensea.io/collection/”,
  “SHOW_BACKGROUND”: true
}

```

Make sure you copy the contract ABI from remix and paste it in the `public/config/abi.json` file.
(follow the youtube video if you struggle with this part).

Now you will need to create and change 2 images and a gif in the `public/config/images` folder, `bg.png`, `example.gif` and `logo.png`.

Next change the theme colors to your liking in the `public/config/theme.css` file.

```css
:root {
  --primary: #0b64a06b;
  --primary-text: #ffffff;
  --secondary: #0B64A0;
  --secondary-text: #ffffff;
  --accent: #505050c9;
  --accent-text: #ffffff;
}
```

Now you will need to create and change the `public/favicon.ico`, `public/logo192.png`, and
`public/logo512.png` to your brand images.

Remember to update the title and description the `public/index.html` file

```html
<title>Rocket Elevators</title>
<meta name="description" content="Mint your Rocket Elevators NFT" />
```

Also remember to update the short_name and name fields in the `public/manifest.json` file

```json
{
  "short_name": "RE",
  "name": "Rocket Elevators"
}
```

After all the changes you can run.

```sh
npm run start
```

Or create the build if you are ready to deploy.

```sh
npm run build
```

Now you can host the contents of the build folder on a server.

That's it! you're done.
