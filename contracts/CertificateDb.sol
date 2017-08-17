pragma solidity ^0.4.11;

import "./ManagerEnabled.sol";
import "./Manager.sol";
import "./ContractProvider.sol";

// The bank database
contract CertificateDb is ManagerEnabled {

    struct Certificate {
        mapping (bytes32 => uint) convertionRate; // Converstion rate
        uint expirationDate; // Unix Timestamp
        bytes32 issuer;
        bytes32 id;
        bool isItCertified; // Automatically turned off after expiration date ? Do we need Oracle?
    }

    mapping (address => Certificate) private certifications;

    function isCertified(address _actor) public returns (bool){
        require(MANAGER != 0x0);
        address transaction = ContractProvider(MANAGER).contracts("certificate");
         // Only transaction controller can issue Tokens (i.e. only when transacting)
        require(msg.sender == transaction);
        return certifications[_actor].isItCertified;
    }

    function issueCertificate(address _actor, uint time, bytes32 certifier) returns ( bool){
        require(MANAGER != 0x0);
        address manager = ContractProvider(MANAGER).contracts("certificate");
        if (msg.sender == manager) {
            address certificatedb = ContractProvider(MANAGER).contracts("certificatedb");
            require(certificatedb != 0x0);
            certifications[_actor].expirationDate = time;
            certifications[_actor].isItCertified = true;
            certifications[_actor].issuer = certifier;
            return true;
        }
        return false;
    }

    function renewCertificate(address _actor, uint newTime, bytes32 certifier) returns ( bool){
        require(MANAGER != 0x0);
        address manager = ContractProvider(MANAGER).contracts("certificate");
        if (msg.sender == manager) {
            certifications[_actor].expirationDate = newTime;
            certifications[_actor].isItCertified = true;
            certifications[_actor].issuer = certifier;
            return true;
        }
        return false;
    }

    function cancelCertificate(address _actor) returns ( bool){
        require(MANAGER != 0x0);
        address manager = ContractProvider(MANAGER).contracts("certificate");
        if (msg.sender == manager) {
            certifications[_actor].isItCertified = false;
            return true;
        }
        return false;
    }
}
