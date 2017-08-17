pragma solidity ^0.4.11;

import "./ManagerEnabled.sol";
import "./Manager.sol";
import "./ContractProvider.sol";

// The bank database
contract TimberTokenDb is ManagerEnabled {

    struct BigNumber {
        uint[2] coeficient;
        uint exponent;
        uint sign;
    }

    /*struct Token {
      bytes32 origin;
      // e.g: 'DK' => 256
      mapping (bytes32 => uint) speciesCount;
      //mapping (bytes32 => BigNumber) speciesCount;
    }*/

    struct Token {
      bytes32 origin;
      bytes32 species;
      uint value;
      /*BigNumber value;*/
      // e.g: 'DK' => 256
      /*mapping (bytes32 => uint) speciesCount;*/
      /*mapping (bytes32 => BigNumber) speciesCount;*/
    }

    mapping (address => Token[]) public balances;
    /*mapping (address => Token) public balances;*/
    uint public nAddress;

    function getValue(address _actor) returns (uint) {
        Token[] myTokens = balances[_actor];
        return myTokens[0].value;
    }

    function issueTokens(address _actor, bytes32 species, bytes32 origin, uint value) returns (bool){
        require(MANAGER != 0x0);
        address token = ContractProvider(MANAGER).contracts("token");
        require(msg.sender == token); // Only token controller can issue Tokens
        Token memory timberToken;
        timberToken.species = species;
        timberToken.origin = origin;
        timberToken.value = value;
        balances[_actor].push(timberToken);
        nAddress++;
        return true;
    }

    function hasTokens(address actor, bytes32 species, uint value) returns ( bool){
        address token = ContractProvider(MANAGER).contracts("token");
        if (msg.sender == token) {
            Token[] tokens = balances[actor];
            uint sumValue=0;
            for (uint i = 0; i < tokens.length; i++) {
                if (tokens[i].species == species) {
                    sumValue += tokens[i].value;
                    if(sumValue >= value) {
                        return true;
                    }
                }
            }
            return false;
        }
        return false;
    }

    function getTokens(address actor, bytes32 species, bytes32 origin) returns ( uint){
        address token = ContractProvider(MANAGER).contracts("token");
        if (msg.sender == token) {
            Token[] tokens = balances[actor];
            for (uint i = 0; i < tokens.length; i++) {
                if (tokens[i].species == species && tokens[i].origin == origin) {
                    return tokens[i].value;
                }
            }
            return 0;
        }
        return 0;
    }


    function increaseTokens(address actor, bytes32 species, bytes32 origin, uint value) returns (bool) {
        // Only the Tx contract can check if the address has tokens
      if(MANAGER != 0x0) {
        address transaction = ContractProvider(MANAGER).contracts("token");
        if (msg.sender == transaction) {
            Token[] tokens = balances[actor];
                for (uint i = 0; i < tokens.length; i++) {
                    if (tokens[i].species == species && tokens[i].origin == origin) {
                        tokens[i].value += value;
                        return true;
                    }
                }
                Token memory timberToken;
                timberToken.species = species;
                timberToken.origin = origin;
                timberToken.value = value;
                balances[actor].push(timberToken);
            }
        }
      return false;
    }

    // returns decreased value
    function decreaseTokens(address actor, bytes32 species, uint value) returns (bytes32, uint, uint) {
        // Only the Tx contract can check if the address has tokens
      if(MANAGER != 0x0) {
        address token = ContractProvider(MANAGER).contracts("token");
        if (msg.sender == token) {
            Token[] tokens = balances[actor];
                for(uint i=0; i < tokens.length; i++) {
                    if(tokens[i].species == species && tokens[i].value > 0){
                        uint v = 0;
                        if(tokens[i].value <= value) {
                            v = tokens[i].value;
                        }
                        else if(tokens[i].value >= value){
                            v = value;
                        }
                        tokens[i].value -= v;
                        return (tokens[i].origin, v, tokens[i].value);
                    }
                }
            }
     }
     return ("", 0, 0);
  }




/*

  // TODO: What if size is bigger than 32
  // Inspired by: https://www.reddit.com/r/ethdev/comments/6lbmhy/a_practical_guide_to_cheap_ipfs_hash_storage_in/
  struct MultiHashIPFS {
    bytes32 ipfsHash; // TODO: Proof-saved for hashes bigger than 32 bytes.
    uint hashFunc;
    uint length;
  }
  mapping (address => MultiHashIPFS[]) private userSamples;
  mapping (address => MultiHashIPFS[]) private samples;

  uint public nSamples;

  event NewSample(
    address _from,
    bytes32 _ipfshash,
    uint _hashFunc,
    uint _length
  );

  event NewAccess(
    address _from,
    uint _offset
  );

  // Register a new sample
  function register(bytes32 ipfshash, uint hashFunc, uint length, address addr) returns (bool res) {
    if(MANAGER != 0x0) {
      address sample = ContractProvider(MANAGER).contracts("sample");
      if (msg.sender == sample) {
        MultiHashIPFS memory multiHashIPFS;
        multiHashIPFS.ipfsHash = ipfshash;
        multiHashIPFS.hashFunc = hashFunc;
        multiHashIPFS.length = length;
        userSamples[addr].push(multiHashIPFS);
        nSamples++;
        NewSample(addr, ipfshash, hashFunc, length);
        return true;
      }
    }
    return false;
  }

  function numberOfSamples(address addr) constant returns (uint) {
    require(MANAGER != 0x0);
    address sample = ContractProvider(MANAGER).contracts("sample");
    require(msg.sender == sample);
    return userSamples[addr].length;
  }

  // Requesting access to sample
  function access(address addr, uint sampleOff) constant returns (bytes32, uint, uint) {
    if(MANAGER != 0x0) {
      address sample = ContractProvider(MANAGER).contracts("sample");
      if (msg.sender == sample) {
        NewAccess(addr, sampleOff);
        return (samples[addr][sampleOff - 1].ipfsHash, samples[addr][sampleOff - 1].hashFunc, samples[addr][sampleOff - 1].length);
      }
    }
    return ('', 0, 0);
  }*/

}
