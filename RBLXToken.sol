pragma solidity 0.4.18;
contract RublixToken {

        string public name;
    	string public symbol;
    	uint256 public decimals = 18;
    	uint256 public totalSupply;
    	address public creator;
        mapping (address => uint256) public balanceOf;
        mapping (address => mapping (address => uint256)) public allowance;
        event Transfer(address indexed from, address indexed to, uint256 value);
        event Approval(address indexed _owner, address indexed _spender, uint256 _value);
        event Burn(address indexed from, uint256 value);

    function RublixToken(uint256 initialSupply, address _creator) public {
        require (msg.sender == _creator);
        
        creator=_creator;
        balanceOf[msg.sender] = initialSupply * 10**decimals;     
        totalSupply = initialSupply * 10**decimals;                        
        name = "Rublix";                                  		
        symbol = "RBLX";
       
    }

	// Allow Basic Tranfer
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
    
	// Allow Multiple Transactions Array
    function transferMulti(address[] _to, uint256[] _value) public returns (bool success) {
        require (_value.length==_to.length);
                 
        for(uint256 i = 0; i < _to.length; i++) {
            require (balanceOf[msg.sender] >= _value[i]); 
            require (_to[i] != 0x0);       
            
            balanceOf[msg.sender] -= _value[i];                     
            balanceOf[_to[i]] += _value[i];                           
            Transfer(msg.sender, _to[i], _value[i]);       
        }
        return true;
    }

	// Transfer from Other Address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
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

	// Set Default Allowance
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
   	// Burn for Future Token Swap
   function burnFrom(address _from, uint256 _value) public returns (bool success) {
       require(balanceOf[_from] >= _value); 
        require (msg.sender == creator);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    address burner = msg.sender;
   
    balanceOf[_from] -= _value;                
    totalSupply -= _value; 
    Transfer(burner, address(0), _value);
    Burn(burner, _value);
   
    return true;
    }

}