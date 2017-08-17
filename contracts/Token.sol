pragma solidity ^0.4.11;

import "./SupplyChainManagerEnabled.sol";
import "./TimberTokenDb.sol";
import "./Manager.sol";
import "./ContractProvider.sol";

// The Token Controller
contract Token is ManagerEnabled {

function issueTokens(address _actor, bytes32 species, bytes32 origin, uint value) returns (bool) {
    // Only the manager can issue Tokens
    require(MANAGER != 0x0);
    if (msg.sender == MANAGER) {
      address timberTokenDb = ContractProvider(MANAGER).contracts("timbertokendb");
      require(timberTokenDb != 0x0);
      // Use the interface to call on the timberTokenDb contract.
      bool success = TimberTokenDb(timberTokenDb).issueTokens(_actor, species, origin, value);
      return success;
    }
    return false;
}

  function hasTokens(address actor, bytes32 species, uint value) returns (bool) {
      // Only the Tx contract can check if the address has tokens
    if(MANAGER != 0x0) {
        address transaction = ContractProvider(MANAGER).contracts("transaction");
        if (msg.sender == transaction) { // TODO: change later to Transaction contract
            address timberTokenDb = ContractProvider(MANAGER).contracts("timbertokendb");
            require(timberTokenDb != 0x0);
            // Use the interface to call on the timberTokenDb contract.
            return TimberTokenDb(timberTokenDb).hasTokens(actor, species, value);
        }
    }
    return false;
  }
  
  function getTokens(address _actor, bytes32 species, bytes32 origin) returns (uint) {
    if(MANAGER != 0x0) {
        address transaction = ContractProvider(MANAGER).contracts("transaction");
        if (msg.sender == transaction) { // TODO: change later to Transaction contract
            address timberTokenDb = ContractProvider(MANAGER).contracts("timbertokendb");
            require(timberTokenDb != 0x0);
            // Use the interface to call on the timberTokenDb contract.
            return TimberTokenDb(timberTokenDb).getTokens(_actor, species, origin);
        }
    }
    return 0;
   }
  
  function decreaseTokens(address actor, bytes32 species, uint value) returns (bytes32, uint, uint) {
      // Only the Tx contract can check if the address has tokens
    if(MANAGER != 0x0) {
        address transaction = ContractProvider(MANAGER).contracts("transaction");
        if (msg.sender == transaction) {
            /*return ("", 4);*/
            address timbertokendb = ContractProvider(MANAGER).contracts("timbertokendb");
            return TimberTokenDb(timbertokendb).decreaseTokens(actor, species, value);
        }
    }
    return ("", 0, 0);
  }
  
  function increaseTokens(address actor, bytes32 species, bytes32 origin, uint value) returns (bool) {
      // Only the Tx contract can check if the address has tokens
    if(MANAGER != 0x0) {
      address transaction = ContractProvider(MANAGER).contracts("transaction");
      if (msg.sender == transaction) { // TODO: change later to Transaction contract
          address timbertokendb = ContractProvider(MANAGER).contracts("timbertokendb");
          bool success = TimberTokenDb(timbertokendb).increaseTokens(actor, species, origin, value);
          return success;
      }
    }
    return false;
  }

}
