// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "contracts/permission/PermissionControl.sol";
import "contracts/user/UserRegistry.sol";
import "contracts/interface/DoctorInterface.sol";
import "contracts/interface/PatientInterface.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "contracts/struct/MedicalStruct.sol";

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
    mapping(address => MedicalStruct.MedicalRecord[]) private patientTokens;

    event MedicalRecordCreated(uint256 indexed tokenId, uint256 timestamp);

    // Doctor method
    function addRecord(address patient) external override onlyDoctor {
        unchecked {
            _tokenIdCounter++;
        }
        _mint(patient, _tokenIdCounter);
        MedicalStruct.MedicalRecord memory newRecord = MedicalStruct
            .MedicalRecord({
                tokenNft: _tokenIdCounter,
                timestamp: block.timestamp
            });

        patientTokens[patient].push(newRecord);

        emit MedicalRecordCreated(_tokenIdCounter, block.timestamp);
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
        returns (uint256[] memory tokenIds, uint256[] memory timestamps)
    {
        require(
            checkPermission(_patient, msg.sender),
            "You are not authorized to access this patient's records"
        );

        uint256 len = patientTokens[_patient].length;
        tokenIds = new uint256[](len);
        timestamps = new uint256[](len);

        for (uint256 i = 0; i < len; i++) {
            tokenIds[i] = patientTokens[_patient][i].tokenNft;
            timestamps[i] = patientTokens[_patient][i].timestamp;
        }

        return (tokenIds, timestamps);
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
        returns (uint256[] memory tokenIds, uint256[] memory timestamps)
    {
         uint256 len = patientTokens[msg.sender].length;
        tokenIds = new uint256[](len);
        timestamps = new uint256[](len);

        for (uint256 i = 0; i < len; i++) {
            tokenIds[i] = patientTokens[msg.sender][i].tokenNft;
            timestamps[i] = patientTokens[msg.sender][i].timestamp;
        }

        return (tokenIds, timestamps);
    }
}
