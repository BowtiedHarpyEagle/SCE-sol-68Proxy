// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// Transparent upgradeable proxy pattern 
// Topics
// -Intro (wrong way) 
// -Return Data From Fallback
// -Storage for implementation and admin 
// -Separate user-admin interfaces 
// -Proxy admin
// -Demo

contract CounterV1 {
    address public implementation;
    address public admin;
    uint public count;
    
    function inc() external {
        count += 1;

    }

}

contract CounterV2 {
    address public implementation;
    address public admin;
    uint public count;
    
    function inc() external {
        count += 1;

    }

    function dec() external {
        count -= 1;
        
    }
}

contract BuggyProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
        (bool ok, bytes memory res ) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "not authorised");
        implementation = _implementation;
    }
}