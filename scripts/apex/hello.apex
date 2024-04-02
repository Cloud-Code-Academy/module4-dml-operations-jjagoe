// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//string tempvar = 'Enter_your_name_here';
//System.debug('Hello World!');
//System.debug('My name is ' + tempvar);

Account acc = new Account(Name='Test Account');
        
        // Insert the Account into the database
       // System.debug('Before Insert ' + acc);
        //insert acc;
      //System.debug('After Insert ' + acc);
     // Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
      //System.debug('After Insert ' + acc);
     Account retrievedAcc = [SELECT Id, Name FROM Account WHERE Name = 'Test Account'];
     System.debug('After Insert ' + retrievedAcc);