pragma solidity ^0.4.11;

import "./ManagerEnabled.sol";
import "./Manager.sol";
import "./ContractProvider.sol";
import "./CertificateDb.sol";

// The bank database
contract Certificate is ManagerEnabled {


    function isCertified(address _actor) returns (bool){
        require(MANAGER != 0x0);
        address transaction = ContractProvider(MANAGER).contracts("transaction");
         // Only transaction controller can issue Tokens (i.e. only when transacting)
        require(msg.sender == transaction);
        address certificatedb = ContractProvider(MANAGER).contracts("certificatedb");
        require(certificatedb != 0x0);
        return CertificateDb(certificatedb).isCertified(_actor);
    }

    function issueCertificate(address _actor, uint time, bytes32 certifier) returns ( bool){
        require(MANAGER != 0x0);
        /*address manager = ContractProvider(MANAGER).contracts("certificate");*/
        if (msg.sender == MANAGER) {
            address certificatedb = ContractProvider(MANAGER).contracts("certificatedb");
            require(certificatedb != 0x0);
            return CertificateDb(certificatedb).issueCertificate(_actor, time, certifier);
        }
        return false;
    }

    function renewCertificate(address _actor, uint newTime, bytes32 certifier) returns ( bool){
        require(MANAGER != 0x0);
        /*address manager = ContractProvider(MANAGER).contracts("certificate");*/
        if (msg.sender == MANAGER) {
            address certificatedb = ContractProvider(MANAGER).contracts("certificatedb");
            require(certificatedb != 0x0);
            return CertificateDb(certificatedb).renewCertificate(_actor, newTime, certifier);
        }
        return false;
    }

    function cancelCertificate(address _actor) returns ( bool){
        require(MANAGER != 0x0);
        address manager = ContractProvider(MANAGER).contracts("certificate");
        if (msg.sender == manager) {
            address certificatedb = ContractProvider(MANAGER).contracts("certificatedb");
            require(certificatedb != 0x0);
            return CertificateDb(certificatedb).cancelCertificate(_actor);
        }
        return false;
    }
}
