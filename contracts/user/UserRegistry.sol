// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract UserRegistry {
    enum Role {
        None,
        Patient,
        Doctor
    }

    mapping(address => Role) public roles;
    event Registered(address indexed user, Role role);

    function registerAsPatient() public {
        require(roles[msg.sender] == Role.None, "Already registered");
        roles[msg.sender] = Role.Patient;
        emit Registered(msg.sender, Role.Patient);
    }

    function registerAsDoctor() public {
        require(roles[msg.sender] == Role.None, "Already registered");
        roles[msg.sender] = Role.Doctor;
        emit Registered(msg.sender, Role.Doctor);
    }

    function isPatient(address user) internal view returns (bool) {
        return roles[user] == Role.Patient;
    }

    function isDoctor(address user) internal view returns (bool) {
        return roles[user] == Role.Doctor;
    }
}
