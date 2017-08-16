pragma solidity ^0.4.11;

import "./SupplyChainManager.sol";
import "./SupplyChainManagerEnabled.sol";
import "./Token.sol";
/*import "./Certificate.sol";*/


contract Transaction is SupplyChainManagerEnabled {

  function hasTokens(address actor, bytes32 species, uint value) returns (bool) {
      // Only the SupplyManager contract can check if the address has tokens
      address token = ContractProvider(MANAGER).contracts("Token");
      require(token != 0x0);
      // Use the interface to call on the transaction contract
      bool success = Token(token).hasTokens(actor, species, value);
      return success;
  }

  function trade(address _buyer, address _seller, uint value) returns (bool) {
      // Only the SupplyManager contract can check if the address has tokens
      address transaction = ContractProvider(MANAGER).contracts("transaction");
      require(transaction != 0x0);
      return true;
  }

}
