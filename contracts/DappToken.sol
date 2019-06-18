pragma solidity ^0.5.8;

contract DappToken {

    // Constructor
    // Set the total number of tokens
    // Read the total number of tokens
    string  public name = "Grid Token";
    string  public symbol = "GRD";
    string  public standard = "Grid Token v1.0";
    uint256 public totalSupply;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor (uint256 _initialSupply) public {
        //allocate the initial supply tagged to the starting account
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }

//Transfer
    function transfer(address _to, uint256 _value) public returns (bool success) {
        //Expection if account doesn't have enough
        require(balanceOf[msg.sender] >= _value, "Balance not found.");
        //Transfer Event
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        //Return a boolean

        return true;
    }

//Approve
    function approve(address _spender, uint256 _value) public returns (bool success) {
        //handle the allowance
        allowance[msg.sender][_spender] = _value;
        //Trigger approve events
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

//TransferFrom
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {

        //require _from has enough tokens
        require(_value <= balanceOf[_from],"Balance of the account is lesser than value tranfer");

        //require allowance is big enough
        require(_value <= allowance[_from][msg.sender], "Value of allowance is not big enough.");

        //Change the allowance
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        //Update the allowance
        allowance[_from][msg.sender] -= _value;

        //Transfer event
        emit Transfer(_from, _to, _value);

        // Return a boolean
        return true;
    }
}
