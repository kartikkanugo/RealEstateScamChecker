// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.19;
contract RealEstateScamChecker {

    struct OwnerDetails {
        uint256 id;
        string name;
        uint256 share;
    }

    struct Owner {
        uint256 noOfOwners;
        // address owner; ??
        // OwnerDetails[] ownerDetails;
    }
    mapping (uint256 => OwnerDetails) ownerDetails;

    enum LandType {
        Plot,
        SingleHouse,
        Apartment
    }

    struct LandCoordinates {
        uint256 lattitude;
        uint256 longitude;
        uint256 area;
        uint256 floor;
        uint256 flatNo;
        string localAddress;
    }

    // Details of a Land
    struct LandDetails {
        LandCoordinates landCoordinates;
        Owner owner;
        LandType landtype;
    }
    
    // mapping (address => bool) authorities; // only real estate authorities have an authority to register/modify

    LandDetails[] lands; // array of type Land to have a record of each land

    /**
     * Function to register a Property
     * @param _lattitude lattitude
     * @param _longitude longitude
     * @param _area area
     * @param _floor floor
     * @param _flatNo flatNo
     * @param _localAddress localAddress
     * @param _noOfOwners noOfOwners
     * @param _id id
     * @param _name name
     * @param _share share
     * @param _landType landtype
     */
    function registerAProperty(uint256 _lattitude, uint256 _longitude, uint256 _area, uint256 _floor, 
    uint256 _flatNo, string memory _localAddress, uint256 _noOfOwners, uint256[] calldata _id, string[] calldata _name, uint256[] calldata _share, uint256 _landType) external {
        require(_landType <= 2, "Invalid PlotType");
        LandDetails memory landDetails;
        landDetails.landCoordinates.lattitude = _lattitude;
        landDetails.landCoordinates.longitude = _longitude;
        landDetails.landCoordinates.area = _area;
        landDetails.landCoordinates.floor = _floor;
        landDetails.landCoordinates.flatNo = _flatNo;
        landDetails.landCoordinates.localAddress = _localAddress;
        landDetails.owner.noOfOwners = _noOfOwners;
        
        for (uint256 i = 0; i < _noOfOwners; i++) {
            ownerDetails[i].id = _id[i];
            ownerDetails[i].name = _name[i];
            ownerDetails[i].share = _share[i];
        }
    
        landDetails.landtype = LandType(_landType);
        lands.push(landDetails);
    }
    
}