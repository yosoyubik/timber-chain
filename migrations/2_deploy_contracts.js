var Manager = artifacts.require("./Manager.sol");
var ManagerEnabled = artifacts.require("./ManagerEnabled.sol");
var SupplyChainManagerEnabled = artifacts.require("./SupplyChainManagerEnabled.sol");
var SupplyChainManager = artifacts.require("./SupplyChainManager.sol");
var Token = artifacts.require("./Token.sol");
var TimberTokenDb = artifacts.require("./TimberTokenDb.sol");
var ContractProvider = artifacts.require("./ContractProvider.sol");

module.exports = function(deployer) {
    deployer.deploy(Manager);
    deployer.deploy(ManagerEnabled);
    deployer.link(Manager, ManagerEnabled);
    deployer.deploy(Token);
    deployer.deploy(SupplyChainManager);
    deployer.deploy(SupplyChainManagerEnabled);
    deployer.deploy(TimberTokenDb);
    deployer.link(Token, SupplyChainManagerEnabled);
};
