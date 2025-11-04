// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title TrustShift
 * @notice A decentralized reputation protocol designed to record, verify, and transfer trust scores among users.
 *         Each user can receive trust ratings from peers, verified entities, or DAOs — creating a transparent trust economy.
 *
 * @dev Useful for decentralized identity (DID), DAO governance, freelance platforms, and social reputation systems.
 */
contract TrustShift {
    address public admin;
    uint256 public userCount;

    struct User {
        uint256 id;
        address wallet;
        uint256 totalRatings;
        uint256 ratingSum;
        bool verified;
    }

    mapping(address => User) public users;
    mapping(address => mapping(address => bool)) public hasRated;

    event UserRegistered(uint256 indexed id, address indexed user);
    event UserRated(address indexed rater, address indexed ratedUser, uint8 score);
    event UserVerified(address indexed user, address indexed verifier);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    /**
     * @notice Register as a new user in the TrustShift network.
     */
    function registerUser() external {
        require(users[msg.sender].wallet == address(0), "User already registered");

        userCount++;
        users[msg.sender] = User({
            id: userCount,
            wallet: msg.sender,
            totalRatings: 0,
            ratingSum: 0,
            verified: false
        });

        emit UserRegistered(userCount, msg.sender);
    }

    /**
     * @notice Rate another registered user with a trust score (1–5).
     * @param _user Address of the user being rated.
     * @param _score Rating score (1–5).
     */
    function rateUser(address _user, uint8 _score) external {
        require(users[_user].wallet != address(0), "User not registered");
        require(users[msg.sender].wallet != address(0), "You must be registered");
        require(!hasRated[msg.sender][_user], "You have already rated this user");
        require(_score >= 1 && _score <= 5, "Score must be between 1 and 5");
        require(_user != msg.sender, "You cannot rate yourself");

        hasRated[msg.sender][_user] = true;
        users[_user].totalRatings++;
        users[_user].ratingSum += _score;

        emit UserRated(msg.sender, _user, _score);
    }

    /**
     * @notice Verify a user (only admin can perform).
     * @param _user Address of the user to verify.
     */
    function verifyUser(address _user) external onlyAdmin {
        require(users[_user].wallet != address(0), "User not registered");
        require(!users[_user].verified, "Already verified");

        users[_user].verified = true;

        emit UserVerified(_user, msg.sender);
    }

    /**
     * @notice Get the average trust score of a user.
     * @param _user Address of the user.
     * @return The calculated trust score (scaled to 2 decimal precision).
     */
    function getTrustScore(address _user) public view returns (uint256) {
        User memory u = users[_user];
        if (u.totalRatings == 0) return 0;
        return (u.ratingSum * 100) / u.totalRatings; // example: returns 450 for avg 4.5
    }

    /**
     * @notice Retrieve full user information.
     * @param _user Address of the user.
     * @return id, wallet, average score, verified status.
     */
    function getUserDetails(address _user)
        external
        view
        returns (uint256, address, uint256, bool)
    {
        User memory u = users[_user];
        uint256 avgScore = getTrustScore(_user);
        return (u.id, u.wallet, avgScore, u.verified);
    }

    /**
     * @notice Transfer admin rights to a new address.
     * @param _newAdmin The address of the new admin.
     */
    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid new admin address");
        admin = _newAdmin;
    }
}
