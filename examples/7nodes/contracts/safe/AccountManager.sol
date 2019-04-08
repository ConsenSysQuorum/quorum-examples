pragma solidity ^0.5.3;

contract AccountManager {
    enum AccountStatus {NotInList, PendingApproval, Active, Inactive}
    struct AccountAccessDetails {
        address acctId;
        string orgId;
        string role;
        AccountStatus status;
        bool orgAdmin;
    }

    AccountAccessDetails[] private acctAccessList;
    mapping(address => uint) private accountIndex;
    uint private numberOfAccts;

    mapping(bytes32 => bool) private orgAdminIndex;

    // account permission events
    event AccountAccessModified(address _address, string _roleId);
    event AccountAccessRevoked(address _address, string _roleId);

    // Get account details given index

    function orgAdminExists(string memory _orgId) public view returns (bool)
    {
        return orgAdminIndex[keccak256(abi.encodePacked(_orgId))];

    }

    function getAccountStatus(address _acct) internal view returns (AccountStatus)
    {
        if (accountIndex[_acct] == 0) {
            return AccountStatus.NotInList;
        }
        uint aIndex = getAcctIndex(_acct);
        return (acctAccessList[aIndex].status);
    }

    function getAccountDetails(address _acct) external view returns (address, string memory, string memory, AccountStatus, bool)
    {
        if (accountIndex[_acct] == 0) {
            return (_acct, "NONE", "", AccountStatus.NotInList, false);
        }
        uint aIndex = getAcctIndex(_acct);
        return (acctAccessList[aIndex].acctId, acctAccessList[aIndex].orgId, acctAccessList[aIndex].role, acctAccessList[aIndex].status, acctAccessList[aIndex].orgAdmin);
    }

    // Get number of accounts
    function getNumberOfAccounts() external view returns (uint)
    {
        return acctAccessList.length;
    }

    function assignAccountRole(address _address, string calldata _orgId, string calldata _roleId) external
    {
        bool orgAdminRole = false;
        AccountStatus status = AccountStatus.Active;
        // if the role id is ORGADMIN then check if already an orgadmin exists
        if ((keccak256(abi.encodePacked(_roleId)) == keccak256(abi.encodePacked("ORGADMIN"))) ||
            (keccak256(abi.encodePacked(_roleId)) == keccak256(abi.encodePacked("NETWORKADMIN")))) {
            if (orgAdminIndex[keccak256(abi.encodePacked(_orgId))]) {
                return;
            }
            else {
                orgAdminRole = true;
                status = AccountStatus.PendingApproval;
            }
        }
        // Check if account already exists
        uint aIndex = getAcctIndex(_address);
        if (accountIndex[_address] != 0) {
            acctAccessList[aIndex].role = _roleId;
            acctAccessList[aIndex].status = status;
            acctAccessList[aIndex].orgAdmin = orgAdminRole;
        }
        else {
            numberOfAccts ++;
            accountIndex[_address] = numberOfAccts;
            acctAccessList.push(AccountAccessDetails(_address, _orgId, _roleId, status, orgAdminRole));
        }
        if (orgAdminRole) {
            orgAdminIndex[keccak256(abi.encodePacked(_orgId))] = true;
        }
        emit AccountAccessModified(_address, _roleId);
    }

    function approveOrgAdminAccount(address _address) external
    {
        // check of the account role is ORGADMIN and status is pending approval
        // if yes update the status to approved
        string memory role = getAccountRole(_address);
        AccountStatus status = getAccountStatus(_address);

        if ((keccak256(abi.encodePacked(role)) == keccak256(abi.encodePacked("ORGADMIN"))) &&
            (status == AccountStatus.PendingApproval)) {
            uint aIndex = getAcctIndex(_address);
            acctAccessList[aIndex].status = AccountStatus.Active;
            emit AccountAccessModified(_address, acctAccessList[aIndex].role);
        }

    }

    function revokeAccountRole(address _address) external
    {
        // Check if account already exists
        uint aIndex = getAcctIndex(_address);
        if (accountIndex[_address] != 0) {
            acctAccessList[aIndex].status = AccountStatus.Inactive;
            emit AccountAccessRevoked(_address, acctAccessList[aIndex].role);
        }
    }

    function getAccountRole(address _acct) public view returns (string memory)
    {
        if (accountIndex[_acct] == 0) {
            return "NONE";
        }
        uint acctIndex = getAcctIndex(_acct);
        if (acctAccessList[acctIndex].status != AccountStatus.NotInList) {
            return acctAccessList[acctIndex].role;
        }
        else {
            return "NONE";
        }
    }

    function checkOrgAdmin(address _acct, string calldata _orgId) external view returns (bool)
    {
        if (accountIndex[_acct] == 0) {
            return false;
        }
        uint acctIndex = getAcctIndex(_acct);
        return ((acctAccessList[acctIndex].orgAdmin) &&
                (keccak256(abi.encodePacked(acctAccessList[acctIndex].orgId)) == keccak256(abi.encodePacked(_orgId))));
    }

    // this function checks if account access can be modified. Account access can be modified for a new account
    // or if the call is from the orgadmin of the same org.
    function valAcctAccessChange(address _acct, string calldata _orgId) external view returns (bool)
    {
        if (accountIndex[_acct] == 0) {
            return true;
        }
        uint acctIndex = getAcctIndex(_acct);
        return ((keccak256(abi.encodePacked(acctAccessList[acctIndex].orgId)) == keccak256(abi.encodePacked(_orgId))));
    }
    // Returns the account index based on account id
    function getAcctIndex(address _acct) internal view returns (uint)
    {
        return accountIndex[_acct] - 1;
    }

}
