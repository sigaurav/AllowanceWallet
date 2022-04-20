// SPDX-License-Identifier: GPL-3.0


pragma solidity ^0.8.0;
/* 
    - Using Openzeppelin Ownable contract to implement Owner Restrictions 
    - Using SafeMath to avoid uint overflow and underflow calculation errors.
*/

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "./Allowance.sol";

contract SimpleWallet is Allowance{

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);


    function renounceOwnership() public view override onlyOwner{ 
        revert ("Can't renounce ownership here");
    }

    function withdraw(address payable _to, uint _amount) public isEligible(_amount) {

        /* Function to withdraw ether, can ber used by Owner and People approved by owner */
        require(address(this).balance > _amount, "!!!Not Enough Fund!!!");

        if(owner()!=msg.sender){
            reduceAllowance(msg.sender, _amount);
        } 
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent);
        emit MoneySent(_to, _amount);
    }

    

    // Function To Receive Ether
    fallback () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    } 
}