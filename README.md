# MedicalRecord Smart Contract

## Overview

The `MedicalRecord` smart contract is an **NFT-based electronic health record (EHR) system** built on Ethereum. It allows **doctors to create immutable medical records** for patients, represented as ERC-721 tokens, while ensuring **strict access control** based on user roles and permissions.

The contract integrates:
- ERC-721 token functionality (`ERC721`)
- User role management (`Doctor`, `Patient`)
- Permission-based access for privacy and security

---

## Features

- **Role-Based Access Control**  
  - Users can register as `Doctor` or `Patient`
  - Role verification is enforced using modifiers

- **Medical Record Minting**  
  - Only doctors can mint records (`addRecord()`)
  - Each record is an ERC-721 NFT assigned to the patient

- **Permission Control**  
  - Patients grant or revoke access to doctors
  - Doctors can view records only if permission is granted

- **Record Management**  
  - Doctors view patient records with `getMedicalRecords()`
  - Patients view their own records with `patientMedicalRecords()`

---

## Contract Architecture

### Inheritance Structure

- `UserRegistry`: Manages user registration and roles
- `PermissionControl`: Handles permission mapping between patients and doctors
- `ERC721`: Provides tokenization of medical records
- `DoctorInterface` / `PatientInterface`: Defines doctor and patient functions
