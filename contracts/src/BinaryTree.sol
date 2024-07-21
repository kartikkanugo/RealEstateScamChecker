// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.19;

// Courtesy of https://mirror.xyz/deor.eth/heTN1aNCTVHCpN8vN1zdAjOxQcNZto7zSxjoFrQNrPw
contract BinaryTree {
    /**
     * @notice struct Node
     */
    struct Node {
        uint256 value;
        bytes32 left;
        bytes32 right;
    }

    mapping (bytes32 => Node) public tree;

    bytes32 public rootId;

    // Events
    event Insert(bytes32 rootId, uint256 value, bytes32 left, bytes32 right);

    /**
     * Inserts a new node to the tree, always traversing from the root
     * @param _value value of the node
     */
    function insert(uint256 _value) public {
        Node memory root = tree[rootId];

        // if the tree is empty with 0 nodes
        if (root.value == 0) {
            root = Node(_value, 0, 0);
            tree[0] = root;
            rootId = generateId(_value, 0); // generate a rootId only once during first insertion
            tree[rootId] = root; // adding the root to the tree
            emit Insert(rootId, root.value, root.left, root.right);
        } else {
            // if the tree is not empty
            // find the correct location to insert the new value to this parentNode
            insertHelper(_value, rootId);
        }
    }

    /**
     * Helper function to traverse recursively to find a correct location for insertion
     * @param _value value to be inserted
     * @param _parentNodeId parent node Id
     */
    function insertHelper(uint256 _value, bytes32 _parentNodeId) internal {
        
        // parent node
        Node memory parentNode = tree[_parentNodeId];

        // if the value is less than the current node, insert it to the left
        if(_value < parentNode.value) {
            
            // check and insert if the left node is empty
            if (parentNode.left == 0) {
                insertNode(_value, _parentNodeId, 0);
            } else {
                insertHelper(_value, _parentNodeId); // check recursively till an empty left node is found
            }
        } else { // if the value is greater than the current node, insert it to the right

            // check and insert if the right node is empty
            if (parentNode.right == 0) {
                // if the right node is empty
                // insert the value
                insertNode(_value, _parentNodeId, 1);
            } else {
                // if the right node is not empty
                // recursively call the function
                insertHelper(_value, parentNode.right);
            }
        }
    }

    /**
     * The actual insert function
     * @param _value value to be inserted
     * @param _parentNodeId parent node Id to insert
     * @param _location point of insertion
     */
    function insertNode(uint256 _value, bytes32 _parentNodeId, uint256 _location) internal {
        Node memory parentNode = tree[_parentNodeId];
        bytes32 nodeId = generateId(_value, _parentNodeId);
        
        // 0 or 1 value to indicate where to add the new node, left or right to the parentNode
        if(_location == 0) {
            parentNode.left = nodeId; // if the value is less than the current node
        } else {
            parentNode.right = nodeId; // if the value is greater than the current node
        }

        // update the tree
        tree[_parentNodeId] = parentNode;
        tree[nodeId] = Node(_value, 0, 0); // adding the new node to the tree
    }

    /**
     * generates a Id for a new node
     * @param _value value of the node
     * @param parentId parentId
     */
    function generateId(uint256 _value, bytes32 parentId) internal view returns (bytes32 id){
        id = keccak256(abi.encodePacked(_value, parentId, block.timestamp));
    }
}