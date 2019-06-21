pragma solidity ^0.5.3;

import "./PermissionsUpgradable.sol";

contract OrgManager {
    string private adminOrgId;
    PermissionsUpgradable private permUpgradable;
    // checks if first time network boot up has happened or not
    bool private networkBoot = false;

    // variables which control the breadth and depth of the sub org tree
    uint private DEPTH_LIMIT = 4;
    uint private BREADTH_LIMIT = 4;
    //    enum OrgStatus {0- NotInList, 1- Proposed, 2- Approved, 3- PendingSuspension, 4- Suspended, 5- RevokeSuspension}
    struct OrgDetails {
        string orgId;
        uint status;
        string parentId;
        string fullOrgId;
        string ultParent;
        uint pindex;
        uint level;
        uint [] subOrgIndexList;
    }

    OrgDetails [] private orgList;
    mapping(bytes32 => uint) private OrgIndex;
    uint private orgNum = 0;

    // events related to Master Org add
    event OrgApproved(string _orgId, string _porgId, string _ultParent, uint _level, uint _status);
    event OrgPendingApproval(string _orgId, string _porgId, string _ultParent, uint _level, uint _status);
    event OrgSuspended(string _orgId, string _porgId, string _ultParent, uint _level);
    event OrgSuspensionRevoked(string _orgId, string _porgId, string _ultParent, uint _level);

    // checks if the caller is implementation contracts
    modifier onlyImpl
    {
        require(msg.sender == permUpgradable.getPermImpl());
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

    // constructor. sets the upgradable address
    constructor (address _permUpgradable) public {
        permUpgradable = PermissionsUpgradable(_permUpgradable);
    }

    // returns the implementation contract address
    function getImpl() public view returns (address) {
        return permUpgradable.getPermImpl();
    }

    // called at the time of network init to set the depth breadth and create the
    // default network admin org as per config file
    function setUpOrg(string calldata _orgId, uint _breadth, uint _depth) external
    onlyImpl
    {
        addNewOrg("", _orgId, 1, 2);
        DEPTH_LIMIT = _depth;
        BREADTH_LIMIT = _breadth;
    }

    // function to add a new organization
    function addNewOrg(string memory _pOrg, string memory _orgId, uint _level, uint _status) internal
    {
        bytes32 pid = "";
        bytes32 oid = "";
        uint parentIndex = 0;

        if (_level == 1) {//root
            oid = keccak256(abi.encodePacked(_orgId));
        } else {
            pid = keccak256(abi.encodePacked(_pOrg));
            oid = keccak256(abi.encodePacked(_pOrg, ".", _orgId));
        }
        orgNum++;
        OrgIndex[oid] = orgNum;
        uint id = orgList.length++;
        if (_level == 1) {
            orgList[id].level = _level;
            orgList[id].pindex = 0;
            orgList[id].fullOrgId = _orgId;
            orgList[id].ultParent = _orgId;
        } else {
            parentIndex = OrgIndex[pid] - 1;

            require(orgList[parentIndex].subOrgIndexList.length < BREADTH_LIMIT, "breadth level exceeded");
            require(orgList[parentIndex].level < DEPTH_LIMIT, "depth level exceeded");

            orgList[id].level = orgList[parentIndex].level + 1;
            orgList[id].pindex = parentIndex;
            orgList[id].ultParent = orgList[parentIndex].ultParent;
            uint subOrgId = orgList[parentIndex].subOrgIndexList.length++;
            orgList[parentIndex].subOrgIndexList[subOrgId] = id;
            orgList[id].fullOrgId = string(abi.encodePacked(_pOrg, ".", _orgId));
        }
        orgList[id].orgId = _orgId;
        orgList[id].parentId = _pOrg;
        orgList[id].status = _status;
        if (_status == 1) {
            emit OrgPendingApproval(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level, 1);
        }
        else {
            emit OrgApproved(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level, 2);
        }
    }

    // returns the number of orgs
    function getNumberOfOrgs() public view returns (uint)
    {
        return orgList.length;
    }

    // Org related functions
    // returns the org index for the org list
    function getOrgIndex(string memory _orgId) public view returns (uint)
    {
        return OrgIndex[keccak256(abi.encodePacked(_orgId))] - 1;
    }

    function getOrgStatus(string memory _orgId) public view returns (uint)
    {
        return orgList[OrgIndex[keccak256(abi.encodePacked(_orgId))]].status;
    }

    // function for adding a new master org
    function addOrg(string calldata _orgId) external
    onlyImpl
    orgNotExists(_orgId)
    {
        addNewOrg("", _orgId, 1, 1);
    }

    // function for adding a sub org under a master org
    function addSubOrg(string calldata _pOrg, string calldata _orgId) external
    onlyImpl
    orgNotExists(string(abi.encodePacked(_pOrg, ".", _orgId)))
    {
        addNewOrg(_pOrg, _orgId, 2, 2);
    }

    // updates the status of an org for master orgs. The new status
    // is valid once majority approval is achieved
    function updateOrg(string calldata _orgId, uint _action) external
    onlyImpl
    orgExists(_orgId)
    returns (uint)
    {
        require((_action == 1 || _action == 2), "Operation not allowed");
        uint id = getOrgIndex(_orgId);
        require(orgList[id].level == 1, "not a master org. operation not allowed");

        uint reqStatus;
        uint pendingOp;
        if (_action == 1) {
            reqStatus = 2;
            pendingOp = 2;
        }
        else if (_action == 2) {
            reqStatus = 4;
            pendingOp = 3;
        }
        require(checkOrgStatus(_orgId, reqStatus) == true, "Operation not allowed");
        if (_action == 1) {
            suspendOrg(_orgId);
        }
        else {
            revokeOrgSuspension(_orgId);
        }
        return pendingOp;
    }

    // function to approve org status change
    function approveOrgStatusUpdate(string calldata _orgId, uint _action) external
    onlyImpl
    orgExists(_orgId)
    {
        if (_action == 1) {
            approveOrgSuspension(_orgId);
        }
        else {
            approveOrgRevokeSuspension(_orgId);
        }
    }


    // updates the status of org as suspended
    function suspendOrg(string memory _orgId) internal
    {
        require(checkOrgStatus(_orgId, 2) == true, "Org not in approved state");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = 3;
        emit OrgPendingApproval(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level, 3);
    }

    // revokes the suspension of an org
    function revokeOrgSuspension(string memory _orgId) internal

    {
        require(checkOrgStatus(_orgId, 4) == true, "Org not in suspended state");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = 5;
        emit OrgPendingApproval(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level, 5);
    }

    // approval for new org add
    function approveOrg(string calldata _orgId) external
    onlyImpl
    {
        require(checkOrgStatus(_orgId, 1) == true, "Nothing to approve");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = 2;
        emit OrgApproved(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level, 2);
    }

    // approval for org suspension
    function approveOrgSuspension(string memory _orgId) internal
    {
        require(checkOrgStatus(_orgId, 3) == true, "Nothing to approve");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = 4;
        emit OrgSuspended(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level);
    }

    // approval for org suspension revoke
    function approveOrgRevokeSuspension(string memory _orgId) internal
    {
        require(checkOrgStatus(_orgId, 5) == true, "Nothing to approve");
        uint id = getOrgIndex(_orgId);
        orgList[id].status = 2;
        emit OrgSuspensionRevoked(orgList[id].orgId, orgList[id].parentId, orgList[id].ultParent, orgList[id].level);
    }

    // confirms that org status is same as passed status
    function checkOrgStatus(string memory _orgId, uint _orgStatus) public view returns (bool){
        uint id = getOrgIndex(_orgId);
        return ((OrgIndex[keccak256(abi.encodePacked(_orgId))] != 0) && orgList[id].status == _orgStatus);
    }

    // function to check if org exists
    function checkOrgExists(string memory _orgId) public view returns (bool)
    {
        return (!(OrgIndex[keccak256(abi.encodePacked(_orgId))] == 0));
    }

    // returns org  details based on org index
    function getOrgInfo(uint _orgIndex) external view returns (string memory, string memory, string memory, uint, uint)
    {
        return (orgList[_orgIndex].orgId, orgList[_orgIndex].parentId, orgList[_orgIndex].ultParent, orgList[_orgIndex].level, orgList[_orgIndex].status);
    }

    // returns the sub org info based on index
    function getSubOrgInfo(uint _orgIndex) external view returns (uint[] memory)
    {
        return orgList[_orgIndex].subOrgIndexList;
    }

    // returns total numbers of sub orgs under a org or sub org
    function getSubOrgIndexLength(uint _orgIndex) external view returns (uint)
    {
        return orgList[_orgIndex].subOrgIndexList.length;
    }

    function getSubOrgIndexLength(uint _orgIndex, uint _subOrgIndex) external view returns (uint)
    {
        return orgList[_orgIndex].subOrgIndexList[_subOrgIndex];
    }

    // returns the master org id for the given org
    function getUltimateParent(string calldata _orgId) external view returns (string memory)
    {
        return orgList[getOrgIndex(_orgId)].ultParent;
    }
}
