const {ethers} = require("hardhat");
const Link = "https://ipfs.io/ipfs/QmWVCu2MQJB5q2zZSDiVGXRSEQsiBySLSZWoYRjp1ockkh"
async function main() {
  const Slayder = await ethers.getContractFactory("NFT");
  const slayder = Slayder.deploy("Slayder","QIT");
  
  await slayder.deployed(); 
  console.log("Succesfully deployed smart contract to: ", slayder.getAddress().toString());
  await slayder.mint(Link);
  console.log("NFT successfully minted");
}
main() 
  .then(() =>process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1)
  })