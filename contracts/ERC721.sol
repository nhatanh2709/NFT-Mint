// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract ERC721 {
    event Transfer(address indexed _from, address indexed _to,uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    event Approval(address indexed _owner, address indexed _operator, uint256 indexed _approval);

    mapping (address => uint256) internal _balances;
    mapping (uint256 => address) internal _owner;
    mapping (address => mapping(address => bool)) private _operatorApprovals;
    mapping (uint256 => address) private _tokenApprovals;

    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0),"Address is zero");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address){
        address owner = _owner[tokenId];
        require(owner != address(0), "Token ID is not exist");
        return owner;
    }

    function setApprovalForAll(address operator, bool approval) external {
        _operatorApprovals[msg.sender][operator] = approval;
        emit ApprovalForAll(msg.sender,operator,approval);
    }

    function isApprovalForALL(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function approve(address to,uint256 tokenId) public payable{
        address onwer = ownerOf(tokenId);
        require(msg.sender == onwer || isApprovalForALL(onwer, msg.sender), "msg.dender is not the onwer for approval operator");
        _tokenApprovals[tokenId] = to;
        emit Approval(onwer ,to,tokenId);
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        require(_onwer[tokenId] != address(0),"Token ID does not exist");
        return _tokenApprovals[tokenId];
    }

    function transferFrom(address from ,address to, uint256 tokenId) public payable{
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || getApproved(tokenId) == msg.sender || isApprovalForALL(owner, msg.sender),
        "Msg.sender is not the owner or approved for transfer");
        require(owner == from,"from is not the owner");
        require(to != address(0), "Address is the zero address");
        require(_owner[tokenId] != address(0), "Token ID does not exist");
        approve(address(0), tokenId);
        _balances[from] -= 1;
        _balances[to] += 1;
        _owner[tokenId] = to;

        emit Transfer(from , to, tokenId);        
    }
    function safeTransferFrom(address from ,address to, uint256 tokenId, bytes memory data) public payable {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

    function _checkOnERC721Received() private pure returns (bool) {
        return true;
    }

    function safeTransferFrom(address from,address to, uint256 tokenId) external payable {
        safeTransferFrom(from,to,tokenId,"");
    }

    function supportInterface(bytes4 interfaceID) public pure virtual returns(bool) {
        return interfaceID == 0x80ac58cd;
    }
}