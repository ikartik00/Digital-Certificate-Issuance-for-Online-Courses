// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DigitalCertificate is Ownable {
    struct Certificate {
        string courseName;
        string studentName;
        string certificateHash; // IPFS or hash of certificate document
        uint256 issuedAt;
        bool exists;
    }

    mapping(bytes32 => Certificate) private certificates;

    event CertificateIssued(bytes32 indexed certId, string courseName, string studentName, string certificateHash, uint256 issuedAt);
    event CertificateRevoked(bytes32 indexed certId);

    constructor() Ownable(msg.sender) {}

    function issueCertificate(
        string calldata courseName,
        string calldata studentName,
        string calldata certificateHash
    ) external onlyOwner returns (bytes32) {
        bytes32 certId = keccak256(abi.encodePacked(courseName, studentName, certificateHash, block.timestamp));
        require(!certificates[certId].exists, "Certificate already issued");

        certificates[certId] = Certificate({
            courseName: courseName,
            studentName: studentName,
            certificateHash: certificateHash,
            issuedAt: block.timestamp,
            exists: true
        });

        emit CertificateIssued(certId, courseName, studentName, certificateHash, block.timestamp);
        return certId;
    }

    function verifyCertificate(bytes32 certId) external view returns (
        string memory courseName,
        string memory studentName,
        string memory certificateHash,
        uint256 issuedAt,
        bool valid
    ) {
        Certificate memory cert = certificates[certId];
        require(cert.exists, "Certificate does not exist");
        return (cert.courseName, cert.studentName, cert.certificateHash, cert.issuedAt, true);
    }

    function revokeCertificate(bytes32 certId) external onlyOwner {
        require(certificates[certId].exists, "Certificate does not exist");
        delete certificates[certId];
        emit CertificateRevoked(certId);
    }
}