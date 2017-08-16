pragma solidity ^0.4.11;

import "./SupplyChainManagerEnabled.sol";
import "./TimberTokenDb.sol";
import "./Manager.sol";
import "./ContractProvider.sol";

// The Token Controller
contract Token is SupplyChainManagerEnabled {

function issueTokens(address _actor, bytes32 species, bytes32 origin, uint value) returns (bool) {
    // Only the manager can issue Tokens
    require(isSupplyChainManager());
    address timberTokenDb = ContractProvider(MANAGER).contracts("timberTokenDb");
    require(timberTokenDb != 0x0);
    // Use the interface to call on the timberTokenDb contract.
    bool success = TimberTokenDb(timberTokenDb).issueTokens(_actor, species, origin, value);
    return success;
}

  function hasTokens(address actor, bytes32 species, uint value) returns (bool) {
      // Only the Tx contract can check if the address has tokens
    require(isSupplyChainManager());
    if(MANAGER != 0x0) {
        /*address transaction = ContractProvider(MANAGER).contracts("transaction");*/
        if (msg.sender == MANAGER) { // TODO: change later to Transaction contract
            address timberTokenDb = ContractProvider(MANAGER).contracts("timberTokenDb");
            require(timberTokenDb != 0x0);
            // Use the interface to call on the timberTokenDb contract.
            bool success = TimberTokenDb(timberTokenDb).hasTokens(actor, species, value);
            return success;
        }
    }
    return false;
  }

}
