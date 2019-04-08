pragma solidity ^0.5.3;

import "./RoleManager.sol";
import "./AccountManager.sol";
import "./VoterManager.sol";
import "./NodeManager.sol";

contract OrgManager {
    AccountManager private accounts;
    RoleManager private roles;
    VoterManager private voter;
    NodeManager private nodes;

    string private adminOrgId;
    string private adminRole;
    string private orgAdminRole;

    uint private fullAccess = 3;

    // checks if first time network boot up has happened or not
    bool private networkBoot = false;

    enum OrgStatus {NotInList, Proposed, Approved, PendingSuspension, Suspended, RevokeSuspension}
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
    event OrgSuspended(string _orgId);

    event Dummy(string _msg);

    // Checks if the given network boot up is pending exists
    modifier networkBootUpPending()
    {
        require(networkBoot == false, "Enode is not in the list");
        _;
    }

    // Checks if the given network boot up is pending exists
    modifier networkBootUpDone()
    {
        require(networkBoot == true, "Enode is not in the list");
        _;
    }

    modifier networkAdmin(address _account) {
        require(isNetworkAdmin(_account) == true, "Not an network admin");
        _;
    }

    modifier orgApproved(string memory _orgId) {
        require(checkOrgStatus(_orgId, OrgStatus.Approved) == true, "Org not approved");
        _;
    }

    modifier orgNotExists(string memory _orgId) {
        require(checkOrgExists(_orgId) == false, "Org already exists");
        _;
    }

    modifier orgExists(string memory _orgId) {
        require(checkOrgExists(_orgId) == true, "Org does not exists");
        _;
    }

    modifier orgAdmin(address _account, string memory _orgId) {
        require(isOrgAdmin(_account, _orgId) == true, "Not an org admin");
        _;
    }


    function init(address _rolesManager, address _acctManager, address _voterManager, address _nodeManager) external
    networkBootUpPending()
    {
        // init will be called only once when the network starts
        // networkBoot will be updated to true post init
        require(networkBoot == false, "Invalid call: Network boot up completed");

        adminOrgId = "NETWORKADMIN";
        adminRole = "NETWORKADMIN";
        orgAdminRole = "ORGADMIN";

        roles = RoleManager(_rolesManager);
        accounts = AccountManager(_acctManager);
        voter = VoterManager(_voterManager);
        nodes = NodeManager(_nodeManager);

        //        nodes = new NodeManager();

        // Create the new "NETWORKADMIN" org
        addAdminOrg(adminOrgId);
        addAdminRole(adminRole, adminOrgId);

    }

    function addAdminOrg(string memory _orgId) internal
    networkBootUpPending()
    {
        orgNum++;
        OrgIndex[keccak256(abi.encodePacked(_orgId))] = orgNum;
        uint id = orgList.length++;
        orgList[id].orgId = _orgId;
        orgList[id].status = OrgStatus.Approved;
        emit OrgApproved(_orgId);
    }

    function addAdminRole(string memory _roleId, string memory _orgId) internal
    networkBootUpPending()
    {
        roles.addRole(_roleId, _orgId, fullAccess, true);
    }

    function addAdminNodes(string calldata _enodeId) external
    networkBootUpPending() {
        nodes.addNode(_enodeId, adminOrgId);
        nodes.approveNode(_enodeId);
    }

    function addAdminAccounts(address _acct) external networkBootUpPending()
    {
        // add the account as a voter for the admin org
        voter.addVoter(adminOrgId, _acct);
        // add the account as an account with full access into the admin org
        accounts.assignAccountRole(_acct, adminOrgId, adminRole);
    }

    // update the network boot status as true
    function updateNetworkBootStatus() external networkBootUpPending() returns (bool)

    {
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
    function addOrg(string calldata _orgId, string calldata _enodeId) external
    networkBootUpDone()
    orgNotExists(_orgId)
    networkAdmin(msg.sender)
    {
        orgNum++;
        OrgIndex[keccak256(abi.encodePacked(_orgId))] = orgNum;
        uint id = orgList.length++;
        orgList[id].orgId = _orgId;
        orgList[id].status = OrgStatus.Proposed;
        // add the node to permissioned node list
        nodes.addNode(_enodeId, _orgId);

        // org add has to be approved by network admin org. create an item for approval
        voter.addVotingItem(adminOrgId, _orgId, _enodeId, address(0), VoterManager.PendingOpType.OrgAdd);

        emit OrgPendingApproval(_orgId, OrgStatus.Proposed);
    }

    // function for adding a new master org
    function suspendOrg(string calldata _orgId) external
    orgExists(_orgId)
    {
        require(checkOrgStatus(_orgId, OrgStatus.Approved) == true, "Org not in approved state");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = OrgStatus.PendingSuspension;
        voter.addVotingItem(adminOrgId, _orgId, "", address(0), VoterManager.PendingOpType.OrgSuspension);
        emit OrgPendingApproval(_orgId, OrgStatus.PendingSuspension);
    }

    function revokeOrgSuspension(string calldata _orgId) external
    orgExists(_orgId)
    {
        require(checkOrgStatus(_orgId, OrgStatus.Suspended) == true, "Org not in suspended state");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = OrgStatus.RevokeSuspension;
        voter.addVotingItem(adminOrgId, _orgId, "", address(0), VoterManager.PendingOpType.OrgRevokeSuspension);
        emit OrgPendingApproval(_orgId, OrgStatus.PendingSuspension);
    }

    function approveOrg(string calldata _orgId, string calldata _enodeId) external
    networkBootUpDone()
    {
        require(checkOrgStatus(_orgId, OrgStatus.Proposed) == true, "Nothing to approve");
        bool majority = voter.processVote(adminOrgId, msg.sender);
        // if majority achieved update the org status to approved
        if (majority) {
            uint id = getOrgIndex(_orgId);
            orgList[id].status = OrgStatus.Approved;
            nodes.approveNode(_enodeId);
            roles.addRole(orgAdminRole, _orgId, fullAccess, false);
            emit OrgApproved(_orgId);
        }
    }

    function approveOrgSuspension(string calldata _orgId) external
    {
        require(checkOrgStatus(_orgId, OrgStatus.PendingSuspension) == true, "Nothing to approve");
        bool majority = voter.processVote(adminOrgId, msg.sender);
        // if majority achieved update the org status to approved
        if (majority) {
            uint id = getOrgIndex(_orgId);
            orgList[id].status = OrgStatus.Suspended;
            emit OrgSuspended(_orgId);
        }
    }

    function approveOrgRevokeSuspension(string calldata _orgId) external
    {
        require(checkOrgStatus(_orgId, OrgStatus.RevokeSuspension) == true, "Nothing to approve");
        bool majority = voter.processVote(adminOrgId, msg.sender);
        // if majority achieved update the org status to approved
        if (majority) {
            uint id = getOrgIndex(_orgId);
            orgList[id].status = OrgStatus.Approved;
            emit OrgSuspended(_orgId);
        }
    }

    function checkOrgStatus(string memory _orgId, OrgStatus _orgStatus) internal view returns (bool){
        uint id = getOrgIndex(_orgId);
        return ((OrgIndex[keccak256(abi.encodePacked(_orgId))] != 0) && orgList[id].status == _orgStatus);
    }

    // function to check if morg exists
    function checkOrgExists(string memory _orgId) public view returns (bool)
    {
        return (!(OrgIndex[keccak256(abi.encodePacked(_orgId))] == 0));
    }

    // returns org and master org details based on org index
    function getOrgInfo(uint _orgIndex) external view returns (string memory, OrgStatus)
    {
        return (orgList[_orgIndex].orgId, orgList[_orgIndex].status);
    }

    // Account related functions
    function getContractAddresses() external view returns (address, address, address)
    {
        return (address(roles), address(voter), address (accounts));
    }

    // Role related functions
    function addNewRole(string calldata _roleId, string calldata _orgId, uint _access, bool _voter) external
    orgApproved(_orgId)
    orgAdmin(msg.sender, _orgId)
    {
        //add new roles can be created by org admins only
        roles.addRole(_roleId, _orgId, _access, _voter);
    }

    function removeRole(string calldata _roleId, string calldata _orgId) external
    orgApproved(_orgId)
    orgAdmin(msg.sender, _orgId)
    {
        roles.removeRole(_roleId, _orgId);
    }

    function getRoleDetails(string calldata _roleId, string calldata _orgId) external view returns (string memory, string memory, uint, bool, bool)
    {
        string memory roleId;
        string memory orgId;
        uint accessType;
        bool status;
        bool isVoter;

        (roleId, orgId, accessType, isVoter, status) = roles.getRoleDetails(_roleId, _orgId);

        return (roleId, orgId, accessType, isVoter, status);

    }

    // Org voter related functions
    function getNumberOfVoters(string calldata _orgId) external view returns (uint){

        uint voterCount = voter.getNumberOfValidVoters(_orgId);
        return voterCount;
    }

    function checkIfVoterExists(string calldata _orgId, address _acct) external view returns (bool)
    {
        bool voterExists = voter.checkIfVoterExists(_orgId, _acct);
        return voterExists;
    }

    function getVoteCount(string calldata _orgId) external view returns (uint, uint)
    {
        uint voteCnt = 0;
        uint totVoters = 0;

        (voteCnt, totVoters) = voter.getVoteCount(_orgId);

        return (voteCnt, totVoters);
    }

    function getPendingOp(string calldata _orgId) external view returns (string memory, string memory, address, VoterManager.PendingOpType)
    {
        string memory enodeId;
        string memory orgId;
        address account;

        VoterManager.PendingOpType pendingOp;
        ( orgId, enodeId, account, pendingOp) = voter.getPendingOpDetails(_orgId);

        return (orgId, enodeId, account, pendingOp);
    }

    function assignOrgAdminAccount(string calldata _orgId, address _account) external
    {
        // this function can be called only by network admin and assigns the
        // 1st account as admin account for newly creted org. Can only be called from
        // Network admin role
        require(isNetworkAdmin(msg.sender) == true, "can be called from network admin only");
        // check if orgAdmin already exists if yes then op cannot be performed
        require(accounts.orgAdminExists(_orgId) != true, "org admin exists");

        // assign the account org admin role and propose voting
        accounts.assignAccountRole(_account, _orgId, orgAdminRole);
        //add voting item
        voter.addVotingItem(adminOrgId, _orgId, "", _account, VoterManager.PendingOpType.AddOrgAdmin);
    }

    function approveOrgAdminAccount(address _account) external
    {
        require(isNetworkAdmin(msg.sender) == true, "can be called from network admin only");
        bool majority = voter.processVote(adminOrgId, msg.sender);
        if (majority){
            accounts.approveOrgAdminAccount(_account);
        }
    }


    function assignAccountRole(address _acct, string memory _orgId, string memory _roleId) public
    networkBootUpDone()
    orgApproved(_orgId)
    orgAdmin(msg.sender, _orgId)
    {
        // check if the account is part of another org. If yes then op cannot be done
        require(validateAccount(_acct, _orgId) == true, "Operation cannot be performed");
        // check if role is existing for the org. if yes the op can be done
        require(roles.roleExists(_roleId, _orgId) == true, "role does not exists");
        bool newRoleVoter = roles.isVoterRole(_roleId, _orgId);
        // check the role of the account. if the current role is voter and new role is also voter
        // voterlist change is not required. else voter list needs to be changed
        string memory acctRole = accounts.getAccountRole(_acct);
        if (keccak256(abi.encodePacked(acctRole)) == keccak256(abi.encodePacked("NONE"))) {
            //new account
            if (newRoleVoter) {
                // add to voter list
                voter.addVoter(_orgId, _acct);
            }
        }
        else {
            bool currRoleVoter = roles.isVoterRole(acctRole, _orgId);
            if (!(currRoleVoter && newRoleVoter)) {
                if (newRoleVoter) {
                    // add to voter list
                    voter.addVoter(_orgId, _acct);
                }
                else {
                    // delete from voter list
                    voter.deleteVoter(_orgId, _acct);
                }
            }
        }
        accounts.assignAccountRole(_acct, _orgId, _roleId);
    }

    function addNode(string calldata _orgId, string calldata _enodeId) external
    networkBootUpDone()
    orgApproved(_orgId)
    orgAdmin(msg.sender, _orgId)
    {
        // check that the node is not part of another org
        require(getNodeStatus(_enodeId) == 0, "Node present already");
        nodes.addOrgNode( _enodeId, _orgId);
    }

    function getNodeStatus(string memory _enodeId) public view returns (uint)
    {
        return (nodes.getNodeStatus(_enodeId));
    }

    function isNetworkAdmin(address _account) public view returns (bool)
    {
        string memory role = accounts.getAccountRole(_account);
        return (keccak256(abi.encodePacked(role)) == keccak256(abi.encodePacked("NETWORKADMIN")));
    }

    function isOrgAdmin(address _account, string memory _orgId) public view returns (bool)
    {
        return (accounts.checkOrgAdmin(_account,_orgId));
    }

    function validateAccount(address _account, string memory _orgId) public view returns (bool)
    {
        return (accounts.valAcctAccessChange(_account, _orgId));
    }
    function getAccountDetails(address _acct) external view returns (address, string memory, string memory, AccountManager.AccountStatus, bool)
    {
        address locAcct;
        string memory locRole;
        string memory locOrgId;
        AccountManager.AccountStatus status;
        bool oAdmin;

        (locAcct, locOrgId, locRole, status, oAdmin) = accounts.getAccountDetails(_acct);

        return (locAcct, locOrgId, locRole, status, oAdmin);

    }

}
