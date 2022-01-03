const { assert } = require("chai");

const SmartContract = artifacts.require("./SmartContract.sol");

require("chai").use(require("chai-as-promised")).should();

contract("SmartContract", (accounts) => {
  let smartContract;

  before(async () => {
    smartContract = await SmartContract.deployed();
  });

  describe("smartContract deployment", async () => {
    it("deploys successfully", async () => {
      const address = await smartContract.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address,null)
      assert.notEqual(address,undefined)
    });
  });
  describe("the contract has the all the information necessary", async() =>{
    it("has correct name", async () => {
      const name = await smartContract.name();
      assert.equal(name, "Rockett");
    });
    it("has a symbol",async() =>{
      const symbol = await smartContract.symbol()
      assert.equal(symbol ,"Symbol" )
    })
    it("has the correct base Uri", async () => {
      const baseUri = await smartContract.baseURI();
      console.log(smartContract.baseURI())
      assert.equal(typeof baseUri, "string");
  });
    it("has the correct whitelist array", async() => {
      const addresses = [
        "0x49C99dB83eA1cDa354b718A4Be90f4B1C3Dc94A4",
        "0xd1679bB3543e8aD195FF9f3Ac3436039bA389237",

        // Domin
        "0xde4F53f2735467330B8b884abdd0d131aA98ef82",
        // Long
        "0xb28C0431f0D4EAd93167c18bc25F7959fd56Dd2A",
        "0x60911dC5af0DF086cd685d9e2d35744e266184a7",
        "0x5e0ACa5Ca440a91dA8D51f893Da92E332A9A5fd5",
        // Jasmine
        "0x9eDBE91E988294ABe24e0282d21Cbf9Ee796cB20",
        // Carl
        "0x60911dC5af0DF086cd685d9e2d35744e266184a7"
      ]
      const Alladdress = await smartContract.whitelistedAddresses;

      for (var i = 0; i < Alladdress.length; i++){
        assert.include(Alladdress, addresses[i])
      }      
    })
  });
  describe("the mint process has the right amount", async() =>{
    it("has a maximum of 10", async() => {
      try {
        await smartContract.mint(11);
        assert.fail("max mint amount per session exceeded");
      }
      catch (err) {
          assert.include(err.message, "revert", "The error message should contain 'revert'");
      }
    })
    it("has a cost for each nft's", async()=>{
      const cost = await contract.cost
      assert.notEqual(cost, 0.01)
    })
  });
  
//   describe("the wallet of the owner is present",async() =>{
//     it("receive the number of token the owner has", async () => {
//       const Alladdress = await smartContract.whitelistedAddresses;
//       const tokenIds = await smartContract.walletOfOwner(smartContract.rocketTokenAddress);
//       assert.notEqual(tokenIds, null);
//     });
//     it("token URI returns hidden URI", async () => {
//         const tokenURI = await smartContract.tokenURI(0);
//         assert.notEqual(typeof tokenURI, "string");
//     });
//   });

});