// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface PatientInterface {
    function grantPermission(address _doctor) external;

    function revokePermission(address _doctor) external;

    function patientMedicalRecords() external view returns (uint256[] memory);
}
