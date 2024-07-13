// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.19;
contract RealEstateScamChecker {
    
    struct Land {  // Details of a Land. I think it is better to rename it as Property ??
        address land; // Address (ID) of the land/property
        
        address[] owners; // A land/apartment can have owner/(s). No. of owners is the size of this variable
        
        uint256[] idsOfShare; // A land/apartment if divided into more than one part/flats, then these parts are identified by their IDs
        
        bytes data; // Data from off-chain like land coordinates, location, etc
    }

    struct Owner {
        address owner;

    }
    mapping (address => Land) landOwner;

    mapping (address => uint256) sharedIdOfOwner; // ID of a Share/flat for a given owner: assigning a land/apartment to owners as sub-lands/flats

    mapping (uint256 => bool) isShareRegistered; // checks if this share with its ID registered or not

    // In case of a land, if divided into more than one owner, this variable gives the share of each owner with his property ID
    mapping (address => mapping (uint256 => uint256)) percentageOfShare;

    mapping (address => bool) authorities; // only real estate authorities have an authority to register/modify

    Land[] public lands; // array of type Land to have a record of each land

     /**
     * Constructor
     * @param _authorities deploy the contract and give access to the real estate authorities
     */
    constructor(address[] memory _authorities) public {
        for(uint i = 0; i < _authorities.length; i++){
                authorities[_authorities[i]] = true;
        }
        authorities[msg.sender] = true;
    }
    
    /**
     * Function to register a land/property and it is registerd only by a Real Estate Authority
     * @param _land : the property/land to register
     * @param _data : the calldata to this smart contract regarding this land from outside the chain
     */
    function registerAProperty(address _land, address _owner, uint256[] memory _idsOfShare, bytes memory _data) external {
        require(authorities[msg.sender] == true);
        Land memory land;
        land.land = _land;
        landOwner[_owner] = land;

    }
    
   
}