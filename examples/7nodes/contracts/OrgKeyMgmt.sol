pragma solidity ^0.5.3;

contract AccountManager {
    function getAccountDetails(address _acct) external view returns (address acct, string memory orgId, string memory role, bool active);

    function getNumberOfAccounts() external view returns (uint);

    function assignAccountRole(address _address, string calldata _orgId, string calldata _roleId) external;

    function getAccountRole(address _acct) external view returns (string memory);
}

contract RoleManager {
    enum AccountAccess {ReadOnly, Transact, ContractDeploy, FullAccess}
    function getRoleDetails(string calldata _roleId, string calldata _orgId) external view returns (string memory roleId, string memory orgId, RoleManager.AccountAccess accessType, bool voter, bool active);

    function getNumberOfRole() external view returns (uint);

    function addRole(string memory _roleId, string memory _orgId, RoleManager.AccountAccess _baseAccess, bool _voter) public;

    function removeRole(string calldata _roleId, string calldata _orgId) external;

    function isFullAccessRole(string calldata _roleId, string calldata _orgId) external view returns (bool);

    function isVoterRole(string calldata _roleId, string calldata _orgId) external view returns (bool);
}

contract OrgVoterManager {
    enum PendingOpType {None, OrgAdd, OrgRemoval}
    function checkIfVoterExists(string memory _orgId, address _address) public view returns (bool);

    function getNumberOfVoters(string calldata _orgId) external view returns (uint);

    function getNumberOfValidVoters(string calldata _orgId) external view returns (uint);

    function getVoter(string calldata _orgId, uint i) external view returns (address _addr, bool _active);

    function checkVotingAccountExists(string calldata _orgId) external view returns (bool);

    function addVoter(string calldata _orgId, address _address) external;

    function deleteVoter(string calldata _orgId, address _address) external;

    function addVotingItem(string calldata _fromOrg, string calldata _orgId, PendingOpType _pendingOp) external;

    function processVote(string calldata _fromOrg, address _vAccount) external returns (bool);

    function getVoteCount(string calldata _orgId) external view returns (uint, uint);

    function getPendingOpDetails(string calldata _orgId) external view returns (string memory, string memory, PendingOpType);
}

contract OrgManager {
    AccountManager private accounts;
    RoleManager private roles;
    OrgVoterManager private orgVoters;
    //    NodeManager private nodes;

    string private adminOrgId;
    string private adminRole;

    // checks if first time network boot up has happened or not
    bool private networkBoot = false;

    enum OrgStatus {NotInList, Proposed, Approved, PendingRemoval, Removed, PendingReenabling}
    struct OrgDetails {
        string orgId;
        OrgStatus status;
    }

    OrgDetails [] private orgList;
    mapping(bytes32 => uint) private OrgIndex;
    uint private orgNum = 0;

    // events related to Master Org add
    event OrgApproved(string _orgId);
    event OrgPendingApproval(string _orgId, OrgStatus _type);
    event OrgRemoved(string _orgId);

    function init(address _rolesManager, address _acctManager, address _voterManager) external
    {
        // init will be called only once when the network starts
        // networkBoot will be updated to true post init
        require(networkBoot == false, "Invalid call: Network boot up completed");

        adminOrgId = "NETWORKADMIN";
        adminRole = "NETWORKADMIN";

        roles = RoleManager(_rolesManager);
        accounts = AccountManager(_acctManager);
        orgVoters = OrgVoterManager(_voterManager);
        //        nodes = new NodeManager();

        // Create the new "NETWORKADMIN" org
        addAdminOrg(adminOrgId);
        addAdminRole(adminRole, adminOrgId);

    }

    function addAdminOrg(string memory _orgId) internal
    {
        require(networkBoot == false, "Invalid call: Network boot up completed");
        orgNum++;
        OrgIndex[keccak256(abi.encodePacked(_orgId))] = orgNum;
        uint id = orgList.length++;
        orgList[id].orgId = _orgId;
        orgList[id].status = OrgStatus.Approved;
        emit OrgApproved(_orgId);
    }

    function addAdminRole(string memory _roleId, string memory _orgId) internal
    {
        require(networkBoot == false, "Invalid call: Network boot up completed");
        roles.addRole(_roleId, _orgId, RoleManager.AccountAccess.FullAccess, true);
    }


    function addAdminAccounts(address _acct) external
    {
        require(networkBoot == false, "Invalid call: Network boot up completed");
        assignAccountRole(_acct, adminOrgId, adminRole);
    }

    // update the network boot status as true
    function updateNetworkBootStatus() external returns (bool)
    {
        require(networkBoot == false, "Invalid call: Network boot up completed");
        networkBoot = true;
        return networkBoot;
    }

    // Org related functions
    // returns the org index for the org list
    function getOrgIndex(string memory _orgId) internal view returns (uint)
    {
        return OrgIndex[keccak256(abi.encodePacked(_orgId))] - 1;
    }

    function getOrgStatus(string memory _orgId) internal view returns (OrgStatus)
    {
        return orgList[OrgIndex[keccak256(abi.encodePacked(_orgId))]].status;
    }

    // Get network boot status
    function getNetworkBootStatus() external view returns (bool)
    {
        return networkBoot;
    }

    // function for adding a new master org
    function addOrg(string calldata _orgId) external
    {
        require(checkOrgExists(_orgId) == false, "Org already exists");

        orgNum++;
        OrgIndex[keccak256(abi.encodePacked(_orgId))] = orgNum;
        uint id = orgList.length++;
        orgList[id].orgId = _orgId;
        orgList[id].status = OrgStatus.Proposed;
        // org add has to be approved by network admin org. create an item for approval
        orgVoters.addVotingItem(adminOrgId, _orgId, OrgVoterManager.PendingOpType.OrgAdd);

        emit OrgPendingApproval(_orgId, OrgStatus.Proposed);
    }

    // function for adding a new master org
    function removeOrg(string calldata _orgId) external
    {
        require(checkOrgApproved(_orgId) == true, "Org does not exists or is not approved");
        uint id = getOrgIndex(_orgId);
        require(orgList[id].status == OrgStatus.Approved);
        orgList[id].status = OrgStatus.PendingRemoval;

        orgVoters.addVotingItem(adminOrgId, _orgId, OrgVoterManager.PendingOpType.OrgRemoval);
        emit OrgPendingApproval(_orgId, OrgStatus.Proposed);
    }

    function approveOrg(string calldata _orgId) external
    {
        require(checkOrgApproved(_orgId) == false, "Nothing to approve");
        bool majority = orgVoters.processVote(adminOrgId, msg.sender);
        // if majority achieved update the org status to approved
        if (majority) {
            uint id = getOrgIndex(_orgId);
            orgList[id].status = OrgStatus.Approved;
            emit OrgApproved(_orgId);
        }
    }

    function approveOrgRemoval(string calldata _orgId) external
    {
        require(checkOrgPendingRemoval(_orgId) == false, "Nothing to approve");
        bool majority = orgVoters.processVote(adminOrgId, msg.sender);
        // if majority achieved update the org status to approved
        if (majority) {
            uint id = getOrgIndex(_orgId);
            orgList[id].status = OrgStatus.Removed;
            emit OrgApproved(_orgId);
        }
    }

    // function to check if morg exists
    function checkOrgExists(string memory _orgId) public view returns (bool)
    {
        return (!(OrgIndex[keccak256(abi.encodePacked(_orgId))] == 0));
    }

    // function to check if morg exists
    function checkOrgApproved(string memory _orgId) public view returns (bool)
    {
        uint id = getOrgIndex(_orgId);
        return ((OrgIndex[keccak256(abi.encodePacked(_orgId))] != 0) && orgList[id].status == OrgStatus.Approved);
    }

    // function to check if morg exists
    function checkOrgPendingRemoval(string memory _orgId) public view returns (bool)
    {
        uint id = getOrgIndex(_orgId);
        return ((OrgIndex[keccak256(abi.encodePacked(_orgId))] != 0) && orgList[id].status == OrgStatus.PendingRemoval);
    }

    // returns org and master org details based on org index
    function getOrgInfo(uint _orgIndex) external view returns (string memory, OrgStatus status)
    {
        return (orgList[_orgIndex].orgId, orgList[_orgIndex].status);
    }

    // Account related functions
    function getContractAddresses() external view returns (address, address)
    {
        return (address(roles), address(orgVoters));
    }

    // Role related functions
    function addNewRole(string calldata _roleId, string calldata _orgId, RoleManager.AccountAccess _access, bool _voter) external
    {
        // org should be approved for the role to be added
        require(checkOrgApproved(_orgId) == true, "Org not approved");
        roles.addRole(_roleId, _orgId, _access, _voter);
    }

    function removeRole(string calldata _roleId, string calldata _orgId) external
    {
        require(checkOrgApproved(_orgId) == true, "Org not approved");
        roles.removeRole(_roleId, _orgId);
    }

    function getRoleDetails(string calldata _roleId, string calldata _orgId) external view returns (string memory roleId, string memory orgId, RoleManager.AccountAccess accessType, bool isVoter, bool active)
    {
        string memory locRoleId;
        string memory locOrgId;
        RoleManager.AccountAccess locAccessType;
        bool status;
        bool locVoter;

        (locRoleId, locOrgId, locAccessType, locVoter, status) = roles.getRoleDetails(_roleId, _orgId);

        return (locRoleId, locOrgId, accessType, locVoter, status);

    }

    // Org voter related functions
    function getNumberOfVoters(string calldata _orgId) external view returns (uint){

        uint voterCount = orgVoters.getNumberOfValidVoters(_orgId);
        return voterCount;
    }

    function checkIfVoterExists(string calldata _orgId, address _acct) external view returns (bool)
    {
        bool voterExists = orgVoters.checkIfVoterExists(_orgId, _acct);
        return voterExists;
    }

    function getVoteCount(string calldata _orgId) external view returns (uint, uint)
    {
        uint voteCnt = 0;
        uint totVoters = 0;

        (voteCnt, totVoters) = orgVoters.getVoteCount(_orgId);

        return (voteCnt, totVoters);
    }

    function getPendingOp(string calldata _orgId) external view returns (string memory orgId, string memory enodeId, OrgVoterManager.PendingOpType pendingOp)
    {
        string memory locEnodeId;
        string memory locOrgId;
        OrgVoterManager.PendingOpType locPendingOp;
        (locEnodeId, locOrgId, locPendingOp) = orgVoters.getPendingOpDetails(_orgId);

        return (locEnodeId, locOrgId, locPendingOp);
    }


    function assignAccountRole(address _acct, string memory _orgId, string memory _roleId) public
    {
//        OrgStatus status = getOrgStatus(_orgId);
//        require((status != OrgStatus.NotInList && status != OrgStatus.Removed), "Org status not valid for operation");
        // check if the account is already existing. If existing the account cannot be assigned to
        // another org except for NETWORKADMIN
//        address locAcct;
//        string memory locOrgId;
//        string memory locRoleId;
//        bool locStatus;
//
//        (locAcct, locOrgId, locRoleId, locStatus) = accounts.getAccountDetails(_acct);
//        // if account is already existing check if there is a difference in org. if yes
//        // operation not allowed
//
//        require(((keccak256(abi.encodePacked(locOrgId)) != keccak256(abi.encodePacked("NONE"))) &&
//            (keccak256(abi.encodePacked(locOrgId)) == keccak256(abi.encodePacked(_orgId)))),
//            "same account cannot be part of two different organization");

        bool newRoleVoter = roles.isVoterRole(_roleId, _orgId);
        // check the role of the account. if the current role is voter and new role is also voter
        // voterlist change is not required. else voter list needs to be changed
        string memory acctRole = accounts.getAccountRole(_acct);
        if (keccak256(abi.encodePacked(acctRole)) == keccak256(abi.encodePacked("NONE"))) {
            //new account
            if (newRoleVoter) {
                // add to voter list
                orgVoters.addVoter(_orgId, _acct);
            }
        }
        else {
            bool currRoleVoter = roles.isVoterRole(acctRole, _orgId);
            if (!(currRoleVoter && newRoleVoter)) {
                if (newRoleVoter) {
                    // add to voter list
                    orgVoters.addVoter(_orgId, _acct);
                }
                else {
                    // delete from voter list
                    orgVoters.deleteVoter(_orgId, _acct);
                }
            }
        }
//        accounts.assignAccountRole(_acct, _orgId, _roleId);
    }

    function getAccountDetails(address _acct) external view returns (address acct, string memory orgId, string memory role, bool active)
    {
        address locAcct;
        string memory locRole;
        string memory locOrgId;
        bool status;

        (locAcct, locOrgId, locRole, status) = accounts.getAccountDetails(_acct);

        return (locAcct, locOrgId, locRole, status);

    }


    // Node related functions
    //    function proposeNode(string calldata _enodeId, string calldata _orgId) external {
    //        nodes.proposeNode(_enodeId, _orgId);
    //    }
    //
    //    function approveNode(string calldata _enodeId) external {
    //        nodes.approveNode(_enodeId);
    //    }
    //
    //    function proposeNodeDeactivation(string calldata _enodeId) external {
    //        nodes.proposeDeactivation(_enodeId);
    //    }
    //
    //    function approveNodeDeactivation(string calldata _enodeId) external {
    //        nodes.deactivateNode(_enodeId);
    //    }
    //
    //    function proposeNodeActivation(string calldata _enodeId) external {
    //        nodes.proposeNodeActivation(_enodeId);
    //    }
    //
    //    function approveNodeActivation(string calldata _enodeId) external {
    //        nodes.activateNode(_enodeId);
    //    }
    //
    //    // Node related functions
    //    function proposeNodeBlacklisting(string calldata _enodeId, string calldata _orgId) external {
    //        nodes.proposeNodeBlacklisting(_enodeId, _orgId);
    //    }
    //
    //    function approveNodeBlacklisting(string calldata _enodeId) external {
    //        nodes.blacklistNode(_enodeId);
    //    }
    //    function addAdminRole(string memory _roleId, string memory _orgId) internal {
    //        require(networkBoot == false, "Invalid call: Network boot up completed");
    //        roles.addRole(_roleId, _orgId, RoleManager.AccountAccess.FullAccess, true);
    //    }

    //    function addAdminNodes(string calldata _enodeId) external {
    //        require(networkBoot == false, "Invalid call: Network boot up completed");
    //        nodes.addInitNode(_enodeId, adminOrgId);
    //    }


}