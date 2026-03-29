// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Bank {
    uint256 deposit;
    uint8 constant cashRatio = 5;
    uint256 constant interestRate = 2; 
    uint256 benefits;
    address owner;
    uint256 constant loanPeriod = 20 seconds; 
    uint256 constant periodInterest = 10 seconds;    
    uint256 constant fractionMaxLoan = 2;           

    struct User {

        uint256 balance;                
        uint256 maxBalance;             
        uint256 debt;                   
        uint256 maxLoan;                
        uint256 startDebtTime;          
    }

    mapping(address => User) Users;
    mapping(address => uint256) Debtors;

    modifier onlyOwner() {

        require(msg.sender == owner, "Access Denied");
        _;
    }

    constructor() payable {

        deposit = msg.value;
        owner = msg.sender;
    }

    function checkDebtPeriod(uint256 _startTime) private view returns (bool, uint256) {

        uint256 startTime = _startTime;
        bool periodExpired = Debtors[msg.sender] > 0 ? true : block.timestamp >= startTime + loanPeriod;
        uint256 interest = periodExpired ? ((block.timestamp - startTime) * interestRate) / periodInterest : 0;   

        return (periodExpired, interest);
    }

    function depositMoney() external payable {

        require(msg.value >= 0, "Invalid Value");
        uint256 amount = msg.value;

        User memory user = Users[msg.sender];

        if (user.debt == 0) {
        
            Users[msg.sender].balance += amount;
            deposit += amount;
            return;
        }

        if(user.debt != 0) {

            (bool periodExpired, uint256 interest) = checkDebtPeriod(user.startDebtTime);
            Users[msg.sender].debt += interest;
            benefits += interest;
            Debtors[msg.sender] = periodExpired ? Users[msg.sender].debt : 0;
        }

        if (amount >= user.debt) {

            uint256 value = amount - user.debt;
            user.debt = 0;
            user.balance += value;
            user.maxBalance = user.balance > user.maxBalance ? user.balance : user.maxBalance;
            user.maxLoan = user.maxBalance / fractionMaxLoan;   
            user.startDebtTime = 0;

            Users[msg.sender] = user;
            delete Debtors[msg.sender];
            deposit += amount;
            return;
        }

        if (amount < user.debt) {

            Users[msg.sender].debt -= amount;
            deposit += amount;
            return;
        }

    }

    function withdrawMoney(uint256 _amount) external payable {

        uint256 amount = _amount;
        require(deposit >= amount, "Bank without sufficient funds");
        require(Users[msg.sender].balance >= amount, "Insufficient funds");

        amount *= 1 ether;  
        Users[msg.sender].balance -= amount;
        deposit -= amount;

        (bool result,) = msg.sender.call{value: amount}("");
        require(result, "Error while withdrawing money");
    }

    function viewDeposit() public view returns (uint256) {

        return Users[msg.sender].balance / 1 ether; 
    }

    function lendMoney(uint256 _loan) public {

        User memory user = Users[msg.sender];
        uint256 loan = _loan;
        require(loan > 0, "Invalid Value");
        require(user.debt + loan <= user.maxLoan || user.debt == 0, "Loan limit exceeded");
        
        loan *=  1 ether;  
        uint256 dpst = deposit;
        uint256 maxLoanAmount = dpst - ((dpst * cashRatio) / 100);
        require(maxLoanAmount >= loan, "Bank without sufficient funds");

        if (user.debt == 0) {

            deposit -= loan;
            user.debt += loan;
            user.startDebtTime = block.timestamp;

            Users[msg.sender] = user;

            (bool result,) = payable(msg.sender).call{value: loan}("");
            require(result, "Error when lending money");
            return;
        }

        if (user.debt != 0) {

            (bool periodExpired, uint256 interest) = checkDebtPeriod(user.startDebtTime);

            deposit -= loan;
            user.debt += loan + interest;
            benefits += interest;

            Users[msg.sender] = user;
            Debtors[msg.sender] = periodExpired ? user.debt : 0;

            (bool result,) = payable(msg.sender).call{value: loan}("");
            require(result, "Error when lending money");
            return;
        }
    }

    function viewDebt(address _debtor) public returns (uint256) {

        User memory user = Users[_debtor];

        if(user.debt != 0) {

            (bool periodExpired, uint256 interest) = checkDebtPeriod(user.startDebtTime);
            Users[msg.sender].debt += interest;
            benefits += interest;
            Debtors[msg.sender] = periodExpired ? Users[msg.sender].debt : 0;
        }
        return user.debt / 1 ether; 
    }

    function withdrawBenefits() public onlyOwner {

        uint256 amount = benefits;
        benefits = 0;

        (bool result,) = payable(msg.sender).call{value: amount}("");
        require(result, "Error while withdrawing benefits");
    }
}
