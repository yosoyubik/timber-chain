var Manager = artifacts.require("Manager.sol");
var ManagerEnabled = artifacts.require("ManagerEnabled.sol");
var SupplyChainManager = artifacts.require("SupplyChainManager.sol");
var SupplyChainManagerEnabled = artifacts.require("SupplyChainManagerEnabled.sol");
var Token = artifacts.require("Token.sol");
var TimberTokenDb = artifacts.require("TimberTokenDb.sol");
var Transaction = artifacts.require("Transaction.sol");
var Certificate = artifacts.require("Certificate.sol");
var CertificateDb = artifacts.require("CertificateDb.sol");

// Contracts are created through the manager contract.
module.exports = function (callback) {
  var manager = Manager.at(Manager.address);

  var contracts = [
    [Token.address, "token"],
    [TimberTokenDb.address, "timbertokendb"],
    [SupplyChainManager.address, "supplychainmanager"],
    [SupplyChainManagerEnabled.address, "registrymanagerenabled"],
    [ManagerEnabled.address, "managerenabled"],
    [Transaction.address, "transaction"],
    [Certificate.address, "certificate"],
    [CertificateDb.address, "certificatedb"]
  ];
  // Contract creation
  for (var i = 0; i < contracts.length; i++) {
    manager.addContract(contracts[i][1], contracts[i][0]);
  }
  // Token creation
  manager.issueTokens(web3.eth.accounts[0], 'oak', 'DK', 34);

  // Certificate creation
  manager.issueCertificate(web3.eth.accounts[0], 90000, 'TIMBERTEAM');
  manager.issueCertificate(web3.eth.accounts[1], 90000, 'NepConDK');
  manager.issueCertificate(web3.eth.accounts[2], 90000, 'NepConES');
  manager.issueCertificate(web3.eth.accounts[3], 90000, 'NepConTH');

// Trading
  var tx = Transaction.at(Transaction.address);

  // tx.trade(web3.eth.accounts[2], 4, 'oak');

  return callback();
}
//
// var manager = Manager.at(Manager.address); manager.issueTokens(web3.eth.accounts[0], 'oak', 'DK', 34);
// var token = TimberTokenDb.at(TimberTokenDb.address)
// var manager = Manager.at(Manager.address); tx.hasTokens.call(web3.eth.accounts[0], 'oak', 34)
// token.getValue.call(web3.eth.accounts[0])
    // tx = Transaction.at(Transaction.address) ; tx.hasTokens.call(web3.eth.accounts[4], 'oak', 34)
//
//
// TRADE
// tx = Transaction.at(Transaction.address) ; tx.trade(web3.eth.accounts[2], 4, 'oak')
//
