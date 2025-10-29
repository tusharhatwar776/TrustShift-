? Function 1: Register a new user
    function registerUser() public {
        require(users[msg.sender].userAddress == address(0), "User already registered");

        userCount++;
        users[msg.sender] = User(userCount, msg.sender, 0);
        userIds[userCount] = msg.sender;

        emit UserRegistered(userCount, msg.sender);
    }

    ? Function 3: View user trust points
    function getTrustPoints(address _user) public view returns (uint256) {
        require(users[_user].userAddress != address(0), "User not registered");
        return users[_user].trustPoints;
    }

    // ? Function 4: Get user by ID
    function getUserById(uint256 _id) public view returns (User memory) {
        address userAddr = userIds[_id];
        require(userAddr != address(0), "Invalid user ID");
        return users[userAddr];
    }
}
// 
update
// 
