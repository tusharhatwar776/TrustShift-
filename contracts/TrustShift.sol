// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title TrustShift
 * @notice A decentralized reputation and trust management system that enables users
 *         to build and transfer reputation scores across platforms in a transparent way.
 */
contract Project {
    address public admin;
    uint256 public profileCount;

    struct Profile {
        uint256 id;
        address user;
        string name;
        uint256 trustScore;
        uint256 lastUpdated;
        bool verified;
    }

    mapping(address => Profile) public profiles;

    event ProfileCreated(uint256 indexed id, address indexed user, string name);
    event TrustScoreUpdated(address indexed user, uint256 newScore);
    event ProfileVerified(address indexed user, bool verified);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Create a new user trust profile
     * @param _name Name or identifier for the user
     */
    function createProfile(string memory _name) external {
        require(bytes(_name).length > 0, "Name required");
        require(profiles[msg.sender].user == address(0), "Profile already exists");

        profileCount++;
        profiles[msg.sender] = Profile({
            id: profileCount,
            user: msg.sender,
            name: _name,
            trustScore: 50, // default neutral trust score
            lastUpdated: block.timestamp,
            ve
