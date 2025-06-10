// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract UserRegistry {
    enum Role { None, Patient, Doctor }

    mapping(address => Role) public roles;

    function registerAsPatient() public {
        require(roles[msg.sender] == Role.None, "Already registered");
        roles[msg.sender] = Role.Patient;
    }

    function registerAsDoctor() public {
        require(roles[msg.sender] == Role.None, "Already registered");
        roles[msg.sender] = Role.Doctor;
    }

    function isPatient(address user) public view returns (bool) {
        return roles[user] == Role.Patient;
    }

    function isDoctor(address user) public view returns (bool) {
        return roles[user] == Role.Doctor;
    }
}
