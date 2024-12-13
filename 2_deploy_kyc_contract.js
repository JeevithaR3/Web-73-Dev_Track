const KYCVerification = artifacts.require("KYCVerification");

module.exports = function (deployer) {
  const authorityAddress = "0xBf521Dbb0AA470F8E0a34dE1F063De21f07D4CA0"; // Authority address

  // Deploy the KYCVerification contract with the authority address
  deployer.deploy(KYCVerification, authorityAddress);
};
