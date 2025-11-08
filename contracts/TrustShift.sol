example: returns 450 for avg 4.5
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
// 
End
// 
