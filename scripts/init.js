var Manager = artifacts.require("Manager.sol");
var ManagerEnabled = artifacts.require("ManagerEnabled.sol");
var SupplyChainManager = artifacts.require("SupplyChainManager.sol");
var SupplyChainManagerEnabled = artifacts.require("SupplyChainManagerEnabled.sol");
var Token = artifacts.require("Token.sol");
var TimberTokenDb = artifacts.require("TimberTokenDb.sol");

// Contracts are created through the manager contract.
module.exports = function (callback) {
  var manager = Manager.at(Manager.address);

  var contracts = [
    [Token.address, "token"],
    [TimberTokenDb.address, "timberTokenDb"],
    [SupplyChainManager.address, "supplychainmanager"],
    [SupplyChainManagerEnabled.address, "registrymanagerenabled"],
    [ManagerEnabled.address, "managerenabled"]
  ];

  for (var i = 0; i < contracts.length; i++) {
    manager.addContract(contracts[i][1], contracts[i][0]);
  }
  return callback();
}
//
// var manager = Manager.at(Manager.address); manager.issueTokens(web3.eth.accounts[0], 'gh', 'fg', 34)
// var tkb = TimberTokenDb.at(TimberTokenDb.address)
//
