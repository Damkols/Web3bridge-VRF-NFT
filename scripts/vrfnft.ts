import { ethers } from "hardhat";

//Subscription ID 14221
// Link Token: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
// VRF coordinator: 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
// Key Hash: 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15
// Metadata: ipfs://QmarWREKiu5CrgpwgRb8bbcq7zDbsMM4SQ1uhXH9XMbkDS/
// fee: 0.25

async function main() {
 //Subscription ID 14221
 const LinkToken = "0x326C977E6efc84E512bB9C30f76E30c160eD06FB";
 const VRFcoordinator = "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D";
 const KeyHash =
  "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15";
 const fee = await ethers.parseEther("0.25");
 //682529530727253409792

 // Metadata: ipfs://QmarWREKiu5CrgpwgRb8bbcq7zDbsMM4SQ1uhXH9XMbkDS/

 const vrfNftDeploy = await ethers.deployContract("VRFNFT", [
  VRFcoordinator,
  LinkToken,
  KeyHash,
  fee,
 ]);
 await vrfNftDeploy.waitForDeployment();
 console.log(vrfNftDeploy);
 console.log(`VRF NFt deployed to ${vrfNftDeploy.target}`);

 const vrfNft = "0x3cc4E76B82F76aA11393A40147136FF25B354Dd3";

 const VRFNFTContract = await ethers.getContractAt("VRFNFT", vrfNft);

 //  VRF NFt deployed on Goerli at 0x3cc4E76B82F76aA11393A40147136FF25B354Dd3

 const mint = await VRFNFTContract.mint();

 const receipt = await mint.wait();

 console.log(receipt);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
 console.error(error);
 process.exitCode = 1;
});
