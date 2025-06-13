// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface DoctorInterface {
    function addRecord(address patient) external;

    function getAuthorizedPatients()
        external
        view
        returns (address[] memory);

    function getMedicalRecords(address patient)
        external
        view
        returns (uint256[] memory);
}
