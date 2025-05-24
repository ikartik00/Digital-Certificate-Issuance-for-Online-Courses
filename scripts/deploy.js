const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying DigitalCertificate contract with account:", deployer.address);

  const DigitalCertificate = await hre.ethers.getContractFactory("DigitalCertificate");
  const digitalCertificate = await DigitalCertificate.deploy();

  await digitalCertificate.deployed();

  console.log("DigitalCertificate deployed to:", digitalCertificate.address);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
