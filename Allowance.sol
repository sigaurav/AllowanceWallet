// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;
/* 
    - Using Openzeppelin Ownable contract to implement Owner Restrictions 
    - Using SafeMath to avoid uint overflow and underflow calculation errors.
*/

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable{

    using SafeMath for uint;
    event AllowanceChanged(address indexed _forWho, address indexed _fromWhom, uint _oldAmount, uint _newAmount);
    // Mapping to track who is allowed how much allowance
    mapping (address => uint) public allowance;

    modifier isEligible (uint _amount){
        /* To check if a person is eligible to withdraw ether */
        require((owner() == msg.sender) || allowance[msg.sender] > _amount, "Not Allowed To Withdraw");
        _;
    }
    
    function addAllowance(address _person, uint _amount) public onlyOwner{
        /* 
        Function to add allowance, Only Owner of Contract can add people
        */
        emit AllowanceChanged(_person, msg.sender, allowance[_person], allowance[_person].add(_amount));
        allowance[_person].add(_amount); // allowance[_person] += amount, change in event too
        
    } 

    function reduceAllowance(address _person, uint _amount) internal {
        emit AllowanceChanged(_person, msg.sender, allowance[_person], allowance[_person].sub(_amount));
        allowance[_person].sub(_amount);
        
    }

}