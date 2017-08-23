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

  event Trade(address _buyer, address _seller, bytes32 _species, bytes32 _origin, uint valueSeller, uint valueBuyer);

  function hasTokens(address actor, bytes32 species, uint value) returns (bool) {
      // Only the SupplyManager contract can check if the address has tokens
      address token = ContractProvider(MANAGER).contracts("token");
      require(token != 0x0);
      // Use the interface to call on the transaction contract
      return Token(token).hasTokens(actor, species, value);
  }

  function getTokens(address actor, bytes32 species, bytes32 origin) returns (uint) {
    address token = ContractProvider(MANAGER).contracts("token");
    require(token != 0x0);
    return Token(token).getTokens(actor, species, origin);
  }
  
  function fakeTrade() returns (bool) {
    address seller = 0x6d208dd04e78b97e6d4da7c0d05677dcb0338757;
    address _buyer = 0x66a7edda90a2e54e2df6218a5a51ffc3186f9361;
    uint value = 4;
    bytes32 species = 'oak'; 
    
    address token = ContractProvider(MANAGER).contracts("token");
    require(token != 0x0);
    address certificate = ContractProvider(MANAGER).contracts("certificate");
    require(certificate != 0x0);
    bool sellerCertified = Certificate(certificate).isCertified(seller);
    bool buyerCertified = Certificate(certificate).isCertified(_buyer);
    require(sellerCertified && buyerCertified );
    if (Token(token).hasTokens(msg.sender, species, value)) {
        // Trade logic
        uint remain = value;
        while(remain > 0){
          var (origin, decreased, updated) = Token(token).decreaseTokens(seller, species, remain);
          Token(token).increaseTokens(_buyer, species, origin, decreased);
          remain = remain - decreased;
          Trade(_buyer, seller, species, origin, updated, decreased);
        }
        return true;
    } else {
      return false;
    }
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
            var (origin, decreased, updated) = Token(token).decreaseTokens(msg.sender, species, remain);
            Token(token).increaseTokens(_buyer, species, origin, decreased);
            remain = remain - decreased;
            Trade(_buyer, msg.sender, species, origin, updated, decreased);
          }
          return true;
      } else {
        return false;
      }
  }
  
  

}
