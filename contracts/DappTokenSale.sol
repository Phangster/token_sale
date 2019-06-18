pragma solidity ^0.5.8;

import "./DappToken.sol";

contract DappTokenSale {

    address admin;
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);

    constructor (DappToken _tokenContract, uint256 _tokenPrice) public {
        //Assign Admin
        admin = msg.sender;
        //Token Contract
        tokenContract = _tokenContract;
        //Token Price
        tokenPrice = _tokenPrice;
    }

    //Build multiply function
    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "error if unsucessful");
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        //Require that value is equal to tokens
        require(msg.value == multiply(_numberOfTokens, tokenPrice), "Error in multiply call");
        //Require that contract has enough tokens
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens, "Not enough tokens");
        //Require that a transfer is successful
        require(tokenContract.transfer(msg.sender, _numberOfTokens), "Transfer failed");

        //Keep track of the number of tokenSold
        tokensSold += _numberOfTokens;

        //Trigger Sell event
        emit Sell(msg.sender, _numberOfTokens);
    }

    //Ending tokenSale
    function endSale() public {
        require(msg.sender == admin, "Admin not found");
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))), "Admin not found");

        // UPDATE: Let's not destroy the contract here
        // Just transfer the balance to the admin
       address(uint160(admin)).transfer(address(this).balance);
    }
}
