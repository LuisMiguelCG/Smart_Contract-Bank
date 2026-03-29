# 🏦 Decentralized Bank Smart Contract

![Solidity](https://img.shields.io/badge/Solidity-^0.8.x-blue)
![Status](https://img.shields.io/badge/status-learning--project-orange)
![License](https://img.shields.io/badge/license-GPL--3.0-green)

---

## 📖 Overview

This project implements a **decentralized banking system** using a smart contract in Solidity.

The contract allows users to:

* Deposit and withdraw ETH
* Request loans based on their activity
* Accrue interest over time
* Track debts and balances

Additionally, the system enforces a **cash reserve ratio**, simulating real-world banking constraints.

> 🧪 This is an academic project focused on learning smart contract development, system modeling, and Solidity best practices.

---

## 🎯 Objectives

* Model a simplified **on-chain bank**
* Allow deposits and withdrawals at any time
* Implement a **loan system with interest**
* Enforce a **cash reserve ratio (5%)**
* Track debtors and outstanding loans
* Generate benefits for the contract owner

---

## ⚙️ Core Features

### 💰 Deposits & Balances

* Users can deposit ETH into the contract
* Each deposit increases their personal balance
* Users can withdraw funds at any time (if liquidity allows)

### 🏦 Loan System

* Users can request loans based on their historical balance
* Loan limit is dynamically calculated:

  * Based on user’s **maximum balance**
  * Controlled by a configurable fraction

### 📈 Interest Mechanism

* Loans generate **interest over time**
* Interest is calculated dynamically based on:

  * Loan duration
  * Defined interest rate
* Accumulated interest is added to:

  * User debt
  * Bank benefits

### 📉 Cash Reserve Ratio

* The bank enforces a **5% reserve requirement**
* Only **95% of total deposits** can be lent

👉 This mimics real-world banking systems and prevents full liquidity depletion

### 👤 Debtor Tracking

* Borrowers are tracked in a debtor mapping
* Users are flagged as debtors only after certain conditions
* Debt increases over time if not repaid

### 👑 Owner Privileges

* The contract owner:

  * Initializes the bank with initial liquidity
  * Can withdraw accumulated **interest profits**

---

## 🧠 Design Decisions

### 📊 User Struct

Each user stores:

* Balance
* Maximum historical balance
* Debt
* Maximum loan allowed
* Loan start time

### ⏱️ Time-Based Logic

* Uses `block.timestamp` for:

  * Loan duration tracking
  * Interest calculation

### 🔄 Dynamic State Updates

* Debt is updated **lazily** (only when interacting)
* Avoids unnecessary gas consumption

### 💡 Simulation Parameters

Some values are simplified for testing:

* Short loan periods
* Faster interest accrual
* Scaled ETH units

---

## 🚀 How It Works

### 1. Deposit

User sends ETH → balance increases

### 2. Withdraw

User requests funds → contract checks:

* User balance
* Bank liquidity

### 3. Request Loan

* Loan is granted if:

  * User is within borrowing limits
  * Bank respects reserve ratio

### 4. Interest Accrual

* Interest increases over time
* Applied when:

  * User interacts with contract

### 5. Repayment

* Deposits are used to:

  * Pay debt first
  * Then increase balance

---

## ⚠️ Limitations

This implementation is **not production-ready**:

* No unit testing
* No frontend (DApp)
* Simplified interest model
* No liquidation mechanism
* Potential edge cases not fully handled
* Limited precision handling (due to test scaling)

---

## 🛠️ Tech Stack

* Solidity ^0.8.x
* Ethereum Virtual Machine (EVM)

---

## 🎓 Academic Context

This project is based on an exercise focused on:

* Modeling financial systems on blockchain
* Understanding lending mechanisms
* Applying real-world banking constraints (cash ratio)
* Practicing Solidity development lifecycle

---

## 👨‍💻 Author

**Luis Miguel CG**

---

## 📄 License

GPL-3.0
