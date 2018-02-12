pragma solidity ^0.4.19;
contract tokenRecipient { 
    
    function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData)public; 
    }

contract RBLXToken {

        string public name = 'Rublix Token';
    	string public symbol = 'RBLX';
    	uint256 public decimals = 18;
    	uint256 public totalSupply = 100000000 * 10 ** decimals;
    	address public creator;
        mapping (address => uint256) public balanceOf;
        mapping (address => mapping (address => uint256)) public allowance;
        event Transfer(address indexed from, address indexed to, uint256 value);
        event Approval(address indexed _owner, address indexed _spender, uint256 _value);
        event Burn(address indexed from, uint256 value);

 
    function RBLXToken(address creatoraddress) public {
        balanceOf[msg.sender] = totalSupply;                                    
        creator = creatoraddress;
    }


    function transfer(address _to, uint256 _value) public returns (bool success) {
        require (_to != 0x0);                               
        require (_value >0);
        require (balanceOf[msg.sender] >= _value);           
        require (balanceOf[_to] + _value > balanceOf[_to]); 
        balanceOf[msg.sender] -= _value;                     
        balanceOf[_to] += _value;                           
        Transfer(msg.sender, _to, _value);                   
        return true;
    }

    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success) {
        require (_to != 0x0);                             
        require (_value >0);
        require (balanceOf[_from] >= _value);
        require (balanceOf[_to] + _value > balanceOf[_to]);
        require (_value <= allowance[_from][msg.sender]);    
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value; 
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function balance(address _owner) public constant returns (uint256 balances) {
        return balanceOf[_owner];
    }


   function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require (msg.sender == creator);
        require(balanceOf[_from] >= _value); 
        balanceOf[_from] -= _value;                
        totalSupply -= _value;                            
        Burn(_from, _value);
        return true;
    }

}
