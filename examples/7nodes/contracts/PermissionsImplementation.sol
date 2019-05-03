pragma solidity ^0.5.3;

import "./RoleManager.sol";
import "./AccountManager.sol";
import "./VoterManager.sol";
import "./NodeManager.sol";
import "./OrgManager.sol";
import "./PermissionsUpgradable.sol";

contract PermissionsImplementation {
    AccountManager private accounts;
    RoleManager private roles;
    VoterManager private voter;
    NodeManager private nodes;
    OrgManager private org;
    PermissionsUpgradable private permUpgradable;

    string private adminOrg;
    string private adminRole;
    string private orgAdminRole;


    uint private fullAccess = 3;

    // checks if first time network boot up has happened or not
    bool private networkBoot = false;

    modifier onlyProxy
    {
        require(msg.sender == permUpgradable.getPermInterface(), "can be called by proxy only");
        _;
    }
    // Modifiers
    // Checks if the given network boot up is pending exists
    modifier networkBootStatus(bool _status)
    {
        require(networkBoot == _status, "Incorrect network boot status");
        _;
    }
    modifier networkAdmin(address _account) {
        require(isNetworkAdmin(_account) == true, "Not an network admin");
        _;
    }

    modifier orgAdmin(address _account, string memory _orgId) {
        require(isOrgAdmin(_account, _orgId) == true, "Not an org admin");
        _;
    }

    modifier orgNotExists(string memory _orgId) {
        require(checkOrgExists(_orgId) != true, "Org already exists");
        _;
    }


    modifier orgExists(string memory _orgId) {
        require(checkOrgExists(_orgId) == true, "Org does not exists");
        _;
    }

    modifier orgApproved(string memory _orgId) {
        require(checkOrgApproved(_orgId) == true, "Org not approved");
        _;
    }

    constructor (address _permUpgradable) public {
        permUpgradable = PermissionsUpgradable(_permUpgradable);
    }

    // initial set up related functions
    // set policy related attributes
    function setPolicy(string calldata _nwAdminOrg, string calldata _nwAdminRole, string calldata _oAdminRole) external
    onlyProxy
    networkBootStatus(false)
    {
        adminOrg = _nwAdminOrg;
        adminRole = _nwAdminRole;
        orgAdminRole = _oAdminRole;
    }

    function init(address _orgManager, address _rolesManager, address _acctManager, address _voterManager, address _nodeManager, uint _breadth, uint _depth) external
    onlyProxy
    networkBootStatus(false)
    {
        org = OrgManager(_orgManager);
        roles = RoleManager(_rolesManager);
        accounts = AccountManager(_acctManager);
        voter = VoterManager(_voterManager);
        nodes = NodeManager(_nodeManager);

        org.setUpOrg(adminOrg, _breadth, _depth);
        roles.addRole(adminRole, adminOrg, fullAccess, true, true);
        accounts.setDefaults(adminRole, orgAdminRole);
    }

    function addAdminNodes(string calldata _enodeId) external
    onlyProxy
    networkBootStatus(false)
    {
        nodes.addAdminNode(_enodeId, adminOrg);
    }

    function addAdminAccounts(address _acct) external
    onlyProxy
    networkBootStatus(false)
    {
        updateVoterList(adminOrg, _acct, true);
        accounts.assignAdminRole(_acct, adminOrg, adminRole, 2);
    }

    // update the network boot status as true
    function updateNetworkBootStatus() external
    onlyProxy
    networkBootStatus(false)
    returns (bool)
    {
        networkBoot = true;
        return networkBoot;
    }

    function addOrg(string calldata _orgId, string calldata _enodeId, address _account, address _caller) external
    onlyProxy
    networkBootStatus(true)
    networkAdmin(_caller)
    {
        voter.addVotingItem(adminOrg, _orgId, _enodeId, _account, 1);
        org.addOrg(_orgId);
        nodes.addNode(_enodeId, _orgId);
        require(validateAccount(_account, _orgId) == true, "Operation cannot be performed");
        accounts.assignAdminRole(_account, _orgId, orgAdminRole, 1);
    }

    function approveOrg(string calldata _orgId, string calldata _enodeId, address _account, address _caller) external
    onlyProxy
    networkAdmin(_caller)
    {
        require(checkOrgStatus(_orgId, 1) == true, "Nothing to approve");
        if ((processVote(adminOrg, _caller, 1))) {
            org.approveOrg(_orgId);
            roles.addRole(orgAdminRole, _orgId, fullAccess, true, true);
            nodes.approveNode(_enodeId, _orgId);
            accounts.addNewAdmin(_orgId, _account);
        }
    }

    // function for adding a new master org
    function addSubOrg(string calldata _pOrg, string calldata _orgId, string calldata _enodeId, address _account, address _caller) external
    orgExists(_pOrg)
    orgAdmin(_caller, _pOrg)
    {
        org.addSubOrg(_pOrg, _orgId);
        string memory pid = string(abi.encodePacked(_pOrg, ".", _orgId));
        if (bytes(_enodeId).length > 0) {
            nodes.addNode(_enodeId, pid);
        }
        if (_account != address(0)) {
            require(validateAccount(_account, pid) == true, "Operation cannot be performed");
            accounts.assignAccountRole(_account, pid, orgAdminRole, true);
        }
    }

    function updateOrgStatus(string calldata _orgId, uint _status, address _caller) external
    onlyProxy
    networkAdmin(_caller)
    {
        uint pendingOp;
        pendingOp = org.updateOrg(_orgId, _status);
        voter.addVotingItem(adminOrg, _orgId, "", address(0), pendingOp);
    }

    function approveOrgStatus(string calldata _orgId, uint _status, address _caller) external
    onlyProxy
    networkAdmin(_caller)
    {
        require((_status == 3 || _status == 5), "Operation not allowed");
        uint pendingOp;
        if (_status == 3) {
            pendingOp = 2;
        }
        else if (_status == 5) {
            pendingOp = 3;
        }
        require(checkOrgStatus(_orgId, _status) == true, "Operation not allowed");
        if ((processVote(adminOrg, _caller, pendingOp))) {
            org.approveOrgStatusUpdate(_orgId, _status);
        }
    }

    // Role related functions
    function addNewRole(string calldata _roleId, string calldata _orgId, uint _access, bool _voter, bool _admin, address _caller) external
    onlyProxy
    orgApproved(_orgId)
    orgAdmin(_caller, _orgId)
    {
        //add new roles can be created by org admins only
        roles.addRole(_roleId, _orgId, _access, _voter, _admin);
    }

    function removeRole(string calldata _roleId, string calldata _orgId, address _caller) external
    onlyProxy
    orgApproved(_orgId)
    orgAdmin(_caller, _orgId)
    {
        require(((keccak256(abi.encodePacked(_roleId)) != keccak256(abi.encodePacked(adminRole))) &&
        (keccak256(abi.encodePacked(_roleId)) != keccak256(abi.encodePacked(orgAdminRole)))), "Admin roles cannot be removed");
        roles.removeRole(_roleId, _orgId);
    }

    // Account related functions
    function assignAdminRole(string calldata _orgId, address _account, string calldata _roleId, address _caller) external
    onlyProxy
    orgExists(_orgId)
    networkAdmin(_caller)
    {
        accounts.assignAdminRole(_account, _orgId, _roleId, 1);
        //add voting item
        voter.addVotingItem(adminOrg, _orgId, "", _account, 4);
    }

    function approveAdminRole(string calldata _orgId, address _account, address _caller) external
    onlyProxy
    networkAdmin(_caller)
    {
        if ((processVote(adminOrg, _caller, 4))) {
            (bool ret, address acct) = accounts.removeExistingAdmin(_orgId);
            if (ret) {
                updateVoterList(adminOrg, acct, false);
            }
            bool ret1 = accounts.addNewAdmin(_orgId, _account);
            if (ret1) {
                updateVoterList(adminOrg, _account, true);
            }
        }
    }

    function assignAccountRole(address _acct, string memory _orgId, string memory _roleId, address _caller) public
    onlyProxy
    orgAdmin(_caller, _orgId)
    orgApproved(_orgId)
    {
        require(validateAccount(_acct, _orgId) == true, "Operation cannot be performed");
        require(roleExists(_roleId, _orgId) == true, "role does not exists");
        bool admin = roles.isAdminRole(_roleId, _orgId, getUltimateParent(_orgId));
        accounts.assignAccountRole(_acct, _orgId, _roleId, admin);
    }

    function updateAccountStatus(string calldata _orgId, address _account, uint _status, address _caller) external
    onlyProxy
    orgAdmin(_caller, _orgId)
    {
        accounts.updateAccountStatus(_orgId, _account, _status);
    }

    // Node related functions
    function addNode(string calldata _orgId, string calldata _enodeId, address _caller) external
    onlyProxy
    orgApproved(_orgId)
    orgAdmin(_caller, _orgId)
    {
        // check that the node is not part of another org
        nodes.addOrgNode(_enodeId, _orgId);
    }

    function updateNodeStatus(string calldata _orgId, string calldata _enodeId, uint _status, address _caller) external
    onlyProxy
    orgAdmin(_caller, _orgId)
    {
        nodes.updateNodeStatus(_enodeId, _orgId, _status);
    }

    //    Get network boot status
    function getNetworkBootStatus() external view
    returns (bool)
    {
        return networkBoot;
    }

    // Voter related functions
    function updateVoterList(string memory _orgId, address _account, bool _add) internal
    {
        if (_add) {
            voter.addVoter(_orgId, _account);
        }
        else {
            voter.deleteVoter(_orgId, _account);
        }
    }

    function processVote(string memory _orgId, address _caller, uint _pendingOp) internal
    returns (bool)
    {
        return voter.processVote(_orgId, _caller, _pendingOp);
    }

    function getPendingOp(string calldata _orgId) external view
    returns (string memory, string memory, address, uint)
    {
        return voter.getPendingOpDetails(_orgId);
    }

    // helper functions
    function isNetworkAdmin(address _account) public view
    returns (bool)
    {
        return (keccak256(abi.encodePacked(accounts.getAccountRole(_account))) == keccak256(abi.encodePacked(adminRole)));
    }

    function isOrgAdmin(address _account, string memory _orgId) public view
    returns (bool)
    {
        if (accounts.checkOrgAdmin(_account, _orgId, getUltimateParent(_orgId))) {
            return true;
        }
        return roles.isAdminRole(accounts.getAccountRole(_account), _orgId, getUltimateParent(_orgId));
    }

    function validateAccount(address _account, string memory _orgId) public view
    returns (bool)
    {
        return (accounts.validateAccount(_account, _orgId));
    }

    function checkOrgExists(string memory _orgId) internal view
    returns (bool)
    {
        return org.checkOrgExists(_orgId);
    }

    function checkOrgApproved(string memory _orgId) internal view
    returns (bool)
    {
        return org.checkOrgStatus(_orgId, 2);
    }

    function checkOrgStatus(string memory _orgId, uint _status) internal view
    returns (bool)
    {
        return org.checkOrgStatus(_orgId, _status);
    }

    function checkOrgAdminExists(string memory _orgId) internal view
    returns (bool)
    {
        return accounts.orgAdminExists(_orgId);
    }

    function roleExists(string memory _roleId, string memory _orgId) internal view
    returns (bool)
    {
        return roles.roleExists(_roleId, _orgId, org.getUltimateParent(_orgId));
    }

    function isVoterRole(string memory _roleId, string memory _orgId) internal view
    returns (bool)
    {
        return roles.isVoterRole(_roleId, _orgId, getUltimateParent(_orgId));
    }

    function getUltimateParent(string memory _orgId) internal view
    returns (string memory)
    {
        return org.getUltimateParent(_orgId);
    }

}