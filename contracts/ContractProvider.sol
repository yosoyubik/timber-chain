pragma solidity ^0.4.11;

// Interface for getting contracts from Manager
contract ContractProvider {
    function contracts(bytes32 name) returns (address addr);
}
