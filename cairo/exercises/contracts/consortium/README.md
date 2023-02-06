# Consortium contract  

## Contract overview  

A consortium is an association of two or more individuals with the objective of participating in a common activity or pooling their resources for achieving a common goal.  

Contract allows people to propose issues, solutions to theses issues and for others to vote on the best solution to a given issue. Chairperson can add new members and propose issues.  

## Flow:  

**1. Create consortium:** `create_consortium`  

Consortium is initialised. Creator becomes chairperson and a member.  

**2. Chairperson adds a new member:**  `add_member`  

This action can only be done by the chairperson. Member is initialised.  

**3. Proposal is created:** `add_proposal`  

This action can only be done by any member that has right to add proposals.  

**4. Answer is proposed:** `add_answer`  

This action can only be done by a permitted member. Proposal has to allow additions. One member can add only one answer.  

**5. Member casts vote:** `vote_answer`  

This action can only be done by the member with at least 1 vote who didn't voted on the proposal yet.  

**6. Chairperson ends the vote:** `tally`  

This action can only be done by the chairperson anytime or by anyone provided vote deadline has expired.  

Index of the answer with the highest amount of votes is returned as the winner.  

## Load Selector method  

Contract allow to store arbitrarily large string for the URL for the proposal, and the title, whilst the asnwers are one felt.

One felt can only store a short string.

Load selector is a helper function that allows you to split a string over multiple felts and write it to the storage. Allows you to write longer strings to either:  
- proposal title  
- proposal link URL  

## Features to implement  

As in other exercises, functions declarations are provided, their names and parameters are not to be changed as it would break the tests (further). Likewise, tests are not to be changed but can be used for reference.  

### Create consortium  

Creates consortium with caller as a chairperson. It makes chairperson a member with 100 votes with ability to add proposal and answers.  

### Add proposal  

Adds a proposal to be voted on. Title, link and answers are arrays. Type s a boolean decided if new answers can be added. Deadline is a timestamp.  

### Add member  

Add a member to a consortium. Booleans decide if member can add proposal and answers. Votes is an integer with member votes weight.

### Add answer  

### Vote answer  

### Tally  

Finishes voting on a proposal. Returns id of winning answer. Verifies if caller is chairperson or time has expired  
