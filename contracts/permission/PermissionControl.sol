// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "contracts/user/UserRegistry.sol";

contract PermissionControl is UserRegistry {
    mapping(address => mapping(address => bool)) internal permissions;

    modifier onlyDoctor() {
        require(roles[msg.sender] == Role.Doctor, "Only doctor allowed");
        _;
    }

    modifier onlyPatient() {
        require(roles[msg.sender] == Role.Patient, "Only patient allowed");
        _;
    }

    function checkPermission(address _patient, address _doctor)
        public
        view
        returns (bool)
    {
        return permissions[_patient][_doctor];
    }
}
