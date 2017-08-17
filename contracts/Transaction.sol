pragma solidity ^0.4.11;

import "./SupplyChainManager.sol";
import "./SupplyChainManagerEnabled.sol";
import "./Token.sol";
import "./Certificate.sol";


contract Transaction is SupplyChainManagerEnabled {
  
  struct ContractTransaction{
    bytes32 contractHash; // TODO: Proof-saved for hashes bigger than 32 bytes.
    uint hashFunc;
    uint length;
  }
  
  mapping(address => ContractTransaction[]) private transactions;

  function hasTokens(address actor, bytes32 species, uint value) returns (bool) {
      // Only the SupplyManager contract can check if the address has tokens
      address token = ContractProvider(MANAGER).contracts("token");
      require(token != 0x0);
      // Use the interface to call on the transaction contract
      return Token(token).hasTokens(actor, species, value);
  }

  function trade(address _buyer, uint value, bytes32 species) returns (bool) {
      // Only the SupplyManager contract can check if the address has tokens
      /*address supplychainmanager = ContractProvider(MANAGER).contracts("supplychainmanager");
      require(supplychainmanager != 0x0);*/
      address token = ContractProvider(MANAGER).contracts("token");
      require(token != 0x0);
      address certificate = ContractProvider(MANAGER).contracts("certificate");
      require(certificate != 0x0);
      bool sellerCertified = Certificate(certificate).isCertified(msg.sender);
      bool buyerCertified = Certificate(certificate).isCertified(_buyer);
      require(sellerCertified && buyerCertified );
      if (Token(token).hasTokens(msg.sender, species, value)) {
          // Trade logic
          uint remain = value;
          while(remain > 0){
            var (origin, decreased) = Token(token).decreaseTokens(msg.sender, species, remain);
            Token(token).increaseTokens(_buyer, species, origin, decreased);
            remain = remain - decreased;
          }
          return true;
      } else {
        return false;
      }
  }
  
  

}
