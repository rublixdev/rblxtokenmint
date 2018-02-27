pragma solidity ^0.4.19;

contract tokenRecipient { 
    
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
}
