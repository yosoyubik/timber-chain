var Manager = artifacts.require("./Manager.sol");
var ManagerEnabled = artifacts.require("./ManagerEnabled.sol");
var SupplyChainManagerEnabled = artifacts.require("./SupplyChainManagerEnabled.sol");
var SupplyChainManager = artifacts.require("./SupplyChainManager.sol");
var Token = artifacts.require("./Token.sol");
var TimberTokenDb = artifacts.require("./TimberTokenDb.sol");
var Certificate = artifacts.require("./Certificate.sol");
var CertificateDb = artifacts.require("./CertificateDb.sol");
var Transaction = artifacts.require("./Transaction.sol");

module.exports = function(deployer) {
    deployer.deploy(Manager);
    deployer.deploy(ManagerEnabled);
    deployer.link(Manager, ManagerEnabled);
    deployer.deploy(Token);
    deployer.deploy(SupplyChainManager);
    deployer.deploy(SupplyChainManagerEnabled);
    deployer.deploy(TimberTokenDb);
    deployer.deploy(CertificateDb);
    deployer.deploy(Certificate);
    deployer.deploy(Transaction);
    deployer.link(Token, SupplyChainManagerEnabled);
};
