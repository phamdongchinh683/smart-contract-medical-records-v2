// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "contracts/permission/PermissionControl.sol";
import "contracts/user/UserRegistry.sol";
import "contracts/interface/DoctorInterface.sol";
import "contracts/interface/PatientInterface.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MedicalRecord is
    UserRegistry,
    PermissionControl,
    DoctorInterface,
    PatientInterface,
    ERC721
{
    uint256 private _tokenIdCounter;

    constructor() ERC721("MedicalRecord", "MEDNFT") {
        _tokenIdCounter = 0;
    }

    mapping(address => address[]) private authorizedPatientList;
    mapping(address => uint256[]) private patientTokens;

    event MedicalRecordCreated(uint256 indexed _tokenIdCounter);

    // Doctor method
    function addRecord(address patient) external override onlyDoctor {
        unchecked {
            _tokenIdCounter++;
        }
        _mint(patient, _tokenIdCounter);
        patientTokens[patient].push(_tokenIdCounter);

        emit MedicalRecordCreated(_tokenIdCounter);
    }

    function getAuthorizedPatients()
        external
        view
        override
        onlyDoctor
        returns (address[] memory)
    {
        return authorizedPatientList[msg.sender];
    }

    function getMedicalRecords(address _patient)
        external
        view
        override
        onlyDoctor
        returns (uint256[] memory)
    {
        require(
            checkPermission(_patient, msg.sender),
            "You are not authorized to access this patient's records"
        );
        return patientTokens[_patient];
    }

    // Patient methods
    function grantPermission(address _doctor) external override onlyPatient {
        require(
            !checkPermission(msg.sender, _doctor),
            "This doctor has been authorized"
        );
        permissions[msg.sender][_doctor] = true;

        bool alreadyAdded = false;
        for (uint256 i = 0; i < authorizedPatientList[_doctor].length; i++) {
            if (authorizedPatientList[_doctor][i] == msg.sender) {
                alreadyAdded = true;
                break;
            }
        }
        if (!alreadyAdded) {
            authorizedPatientList[_doctor].push(msg.sender);
        }
    }
    

    function revokePermission(address _doctor) external override onlyPatient {
        require(
            checkPermission(msg.sender, _doctor),
            "This doctor is not authorized."
        );
        permissions[msg.sender][_doctor] = false;

        address[] storage list = authorizedPatientList[_doctor];
        for (uint256 i = 0; i < list.length; i++) {
            if (list[i] == msg.sender) {
                list[i] = list[list.length - 1];
                list.pop();
                break;
            }
        }
    }

    function patientMedicalRecords()
        external
        view
        override
        onlyPatient
        returns (uint256[] memory)
    {
        return patientTokens[msg.sender];
    }
}
