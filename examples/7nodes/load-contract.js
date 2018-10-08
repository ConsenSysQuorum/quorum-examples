a = eth.accounts[0]
web3.eth.defaultAccount = a;
var abi = [
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "NewNodeProposed",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_accountAddress",
          "type": "address"
        }
      ],
      "name": "VoteNodeApproval",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_ipAddrPort",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_discPort",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_raftPort",
          "type": "string"
        }
      ],
      "name": "NodeApproved",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "NodePendingDeactivation",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_accountAddress",
          "type": "address"
        }
      ],
      "name": "VoteNodeDeactivation",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_ipAddrPort",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_discPort",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_raftPort",
          "type": "string"
        }
      ],
      "name": "NodeDeactivated",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "NodePendingBlacklisting",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_accountAddress",
          "type": "address"
        }
      ],
      "name": "VoteNodeBlacklisting",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_enodeId",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_ipAddrPort",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_discPort",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "_raftPort",
          "type": "string"
        }
      ],
      "name": "NodeBlacklisted",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_address",
          "type": "address"
        },
        {
          "indexed": false,
          "name": "_access",
          "type": "uint8"
        }
      ],
      "name": "AccountAccessModified",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [],
      "name": "NoVotingAccount",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_address",
          "type": "address"
        }
      ],
      "name": "VoterAdded",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "_address",
          "type": "address"
        }
      ],
      "name": "VoterRemoved",
      "type": "event"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "getNumberOfNodes",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "getNumberOfAccounts",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "getNodeStatus",
      "outputs": [
        {
          "name": "",
          "type": "uint8"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "getVoteCount",
      "outputs": [
        {
          "name": "",
          "type": "uint256"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        },
        {
          "name": "_voter",
          "type": "address"
        }
      ],
      "name": "getVoteStatus",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "_index",
          "type": "uint256"
        }
      ],
      "name": "getEnodeId",
      "outputs": [
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "_index",
          "type": "uint256"
        }
      ],
      "name": "getAccountAddress",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        },
        {
          "name": "_ipAddrPort",
          "type": "string"
        },
        {
          "name": "_discPort",
          "type": "string"
        },
        {
          "name": "_raftPort",
          "type": "string"
        },
        {
          "name": "_canLead",
          "type": "bool"
        }
      ],
      "name": "proposeNode",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "approveNode",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "ProposeDeactivation",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "DeactivateNode",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        },
        {
          "name": "_ipAddrPort",
          "type": "string"
        },
        {
          "name": "_discPort",
          "type": "string"
        },
        {
          "name": "_raftPort",
          "type": "string"
        }
      ],
      "name": "ProposeNodeBlacklisting",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_enodeId",
          "type": "string"
        }
      ],
      "name": "BlacklistNode",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_address",
          "type": "address"
        },
        {
          "name": "_accountAccess",
          "type": "uint8"
        }
      ],
      "name": "updateAccountAccess",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_address",
          "type": "address"
        }
      ],
      "name": "addVoter",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_address",
          "type": "address"
        }
      ],
      "name": "removeVoter",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    }
  ];
var simple = web3.eth.contract(abi).at("0x0000000000000000000000000000000000000020");

