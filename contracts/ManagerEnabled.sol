pragma solidity ^0.4.11;

contract ManagerEnabled {

  address public MANAGER;

  function setManagerAddress(address managerAddr) returns (bool result){
    // Once the manager address is set, don't allow it to be set again, except by the
    // manager contract itself.
    if(MANAGER != 0x0 && msg.sender != MANAGER){
        return false;
    }
    MANAGER = managerAddr;
    return true;
  }

  // Makes it so that Manager is the only contract that may kill it.
  function remove(){
    if(msg.sender == MANAGER){
        selfdestruct(MANAGER);
    }
  }

  function getManagerAddress() returns (address addr) {
    return MANAGER;
  }
}
