// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract KYCVerification {
    
    // Enum for KYC status
    enum KYCStatus { Pending, Accepted, Rejected }
    
    // Struct to hold user KYC details
    struct AadhaarDetails {
        string name;
        string aadhaarNumber;
        KYCStatus status;
        uint256 submissionTime;
        uint256 verificationTime;
    }
    
    // Mapping to store user KYC details by their address
    mapping(address => AadhaarDetails) private aadhaarRecords;

    // List to store addresses of users who have submitted their Aadhaar details
    address[] public users;

    // Event for when a user submits a KYC application
    event AadhaarRegistered(address indexed user, string aadhaarNumber);

    // Event for when an authority verifies a user's KYC application (accepted or rejected)
    event AadhaarVerified(address indexed user, KYCStatus status);

    // Address of the authority who can approve/reject KYC
    address public authority;

    // Modifier to restrict actions to only the authority
    modifier onlyAuthority() {
        require(msg.sender == authority, "Only the authority can perform this action.");
        _;
    }

    // Constructor to set the authority address
    constructor(address _authority) {
        require(_authority != address(0), "Invalid authority address"); // Ensure authority is a valid address
        authority = _authority;
    }

    // Function to allow users to register their Aadhaar details
    function registerAadhaar(string memory _name, string memory _aadhaarNumber) public {
        require(bytes(aadhaarRecords[msg.sender].aadhaarNumber).length == 0, "Aadhaar already registered.");
        
        aadhaarRecords[msg.sender] = AadhaarDetails({
            name: _name,
            aadhaarNumber: _aadhaarNumber,
            status: KYCStatus.Pending,
            submissionTime: block.timestamp, // Record submission time
            verificationTime: 0 // Verification time is initially 0
        });

        users.push(msg.sender);  // Add user address to the list of users

        emit AadhaarRegistered(msg.sender, _aadhaarNumber);
    }

    // Function for the authority to verify the Aadhaar details (Accept or Reject)
    function verifyAadhaar(address _user, KYCStatus _status) public onlyAuthority {
        require(bytes(aadhaarRecords[_user].aadhaarNumber).length > 0, "Aadhaar not found.");
        
        // Update the KYC status and verification time
        aadhaarRecords[_user].status = _status;
        aadhaarRecords[_user].verificationTime = block.timestamp;

        emit AadhaarVerified(_user, _status);
    }

    // Function to get the KYC details of a user
    function getUserKYCDetails(address _user) public view returns (string memory name, string memory aadhaarNumber, KYCStatus status, uint256 submissionTime, uint256 verificationTime) {
        AadhaarDetails memory details = aadhaarRecords[_user];
        return (details.name, details.aadhaarNumber, details.status, details.submissionTime, details.verificationTime);
    }

    // Function to get the verification status of a user's Aadhaar
    function getVerificationStatus(address _user) public view returns (KYCStatus status) {
        return aadhaarRecords[_user].status;
    }

    // Function to get all user addresses who have registered their Aadhaar
    function getAllUserApplications() public view onlyAuthority returns (address[] memory) {
        return users;
    }
}
