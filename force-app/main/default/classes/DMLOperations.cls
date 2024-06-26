/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author John Jagoe
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        // Create a new Account instance
        // Set some fields on the Account
        Account acc = new Account();
        acc.Name = 'Cloud Code ' + String.valueOf(Datetime.now().getTime());

        // Insert the Account into the database
       insert acc;

        // Return the Id of the newly created Account
        acc = [SELECT Id, Name FROM Account WHERE Id = :acc.Id];

        return acc.ID;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline

        Account acc = new Account(name=name, industry=industry);

        // Insert the Account
        insert acc;
        
        Account testAccount = [SELECT Id, Name, Industry FROM Account WHERE Name = :acc.name];

    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        // Set some fields on the Contact
        // Set the AccountId field to the given accountId
        Contact newContact = new Contact(
            AccountId = accountId,
            LastName = 'Jagoe'
        );

        // Insert the Contact into the database
            insert newContact;

        // Return the Id of the newly created Contact
           return newContact.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact newContact = [SELECT Id, LastName FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        newContact.LastName = newLastName;

        // Update the Contact in the database.
        update newContact;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity newOpportunity = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage.
        newOpportunity.StageName = newStage;

        // Update the Opportunity in the database.
        Update newOpportunity;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        Account newAccount = [SELECT Id, Name, Industry FROM Account WHERE Id = :accountId];

        // Update the Account with the given Id with the new name and industry.
        newAccount.Name = newName;
        newAccount.Industry = newIndustry;

        update newAccount;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Iterate over the opportunities
            // Set the Opportunity's Stage to Qualification
            // Set the Opportunity's Close Date to 3 months from today
            // Set the Opportunity's Amount to 50000

            Date closeDate = Date.today().addMonths(3);
          
            for (Opportunity opp : opportunities){
                opp.StageName = 'Qualification';
                opp.CloseDate = closeDate;
                opp.Amount = 50000;
            }
  
        // Upsert the Opportunity.
           upsert opportunities;
    }


    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        // Loop through each Opportunity name
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
            List<Account> accList = [SELECT Id FROM Account WHERE Name = :accountName LIMIT 1];

            Account acc;
            if (!accList.isEmpty()) {
                // Account with the given name exists, use it
                acc = accList[0];
            }else {
                // Account with the given name doesn't exist, create a new one
                acc = new Account(Name = accountName);
                insert acc;
            }

        // Retrieve existing Opportunities related to the Account
        List<Opportunity> existingOpps = [SELECT Id, Name FROM Opportunity WHERE AccountId = :acc.Id];
    
        // Create a map to store existing Opportunity names
        Map<String, Opportunity> existingOppsMap = new Map<String, Opportunity>();
        for (Opportunity opp : existingOpps) {
            existingOppsMap.put(opp.Name, opp);
        }

        // Create a list to store Opportunity records
        List<Opportunity> opportunitiesToUpsert = new List<Opportunity>();
        // Loop through each Opportunity name
        for (String oppName : oppNames) {
            // Check if an Opportunity with the same name already exists
            if (existingOppsMap.containsKey(oppName)) {
                // If exists, update the existing Opportunity
                Opportunity existingOpp = existingOppsMap.get(oppName);
                existingOpp.StageName = 'Qualification';
                existingOpp.CloseDate = Date.today().addMonths(3);
                opportunitiesToUpsert.add(existingOpp);
           } else {
            // If not exists, create a new Opportunity and associate it with the Account
            Opportunity newOpp = new Opportunity(
                Name = oppName,
                AccountId = acc.Id,
                StageName ='Prospecting',
                CloseDate = Date.today().addDays(30)
            );
            opportunitiesToUpsert.add(newOpp);
          }
       }
         // Perform upsert operation on the list of Opportunities
        upsert opportunitiesToUpsert;
    }
 
  
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

		if (!accounts.isEmpty()) {
        // if the Account exists, update the description to Updated Account.
           Account updatedAcc = new Account();
           updatedAcc.Name = accountName;
           updatedAcc.Description = 'Updated Account';
           accounts.add(updatedAcc);
           upsert accounts;
           return updatedAcc;
   
        
    }  else { // otherwise, create a new Account and set the description to New Account
          Account acc = new Account();
          acc.Name = accountName;
          acc.Description = 'New Account';
          accounts.add(acc);
          insert accounts;
          return acc;
    }

   
}

    /**
     * Question 10
	 * Upserts accounts and links contacts to them based on the contact's last name and account name.
	 * Create or use existing account with contact last name. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
	 * Contacts are then linked to these accounts based on a full last name match.
     * Example Contact Last Name = Doe Link to Account Name = Doe 
     * Example Contact Last Name = Jane Link to Account Name = Jane
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
	    Set<String> accountNamesToQuery = new Set<String>();
        // How can we get an account Name based on its name? How to get all accounts?
        // Loop thru my contacts to get my account names, collect my accountNames via Set collection.
        // This gives us all the accounts that we would possible want to query in our for loop.
        for (Contact con : contactsToUpsert){
            accountNamesToQuery.add(con.LastName);
        }
        
        // This account doesn't exist in our database it doesn't have an Id yet. 
        // so we need to insert it into our database
        // insert acc;  If we insert acc here, we are doing a DML inside our for loop which is a no - no.
        // we need to collect all these accounts first. The easily way to do this is to put it back into our map because 
        // it didn't exist in our map to begin with. We can insert it later.
        Map<String, Account> parentAccountByAccountName = new Map<String, Account>();
        for(Account acc : [
            SELECT Id, Name
            FROM Account
            WHERE Name IN :accountNamesToQuery
        ]) {
            parentAccountByAccountName.put(acc.Name, acc);
        }
		// Loop through each Contact
        for(Contact con : contactsToUpsert) {
            // Get the account based on the name or create one if it doesn't exist
            if(parentAccountByAccountName.containsKey(con.LastName)) {
                continue;
            }
            parentAccountByAccountName.put(con.LastName, new Account(Name = con.LastName));
        }
        // Must do upsert outside of our for loop
        Database.upsert(parentAccountByAccountName.values());
        // Were going to loop over our cantacts one last time to link contact name to Account name.
        for(Contact con : contactsToUpsert) {
            //con.AccountId = parentAccountByAccountName.get(con.LastName)?.Id;
            Account parentAccount = parentAccountByAccountName.get(con.LastName);
            con.AccountId = parentAccount.Id;
        }
		// Upsert the Contacts
        upsert contactsToUpsert;
	}
        

    
        

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Loop through each Lead name
        List<Lead> leadsToInsert = new List<Lead>();
        for (String leadName : leadNames) {
            Lead newLead = new Lead(
                FirstName = leadName,
                LastName  = 'Test Last Name',
                Company   = 'Cloud Code Academy',
                Status    = 'Open - Not Contacted'
            );
           leadsToInsert.add(newlead);
        }

        // Insert the Leads
        insert leadsToInsert;

        // Delete the Leads
        delete leadsToInsert;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {

        List<Case> casesToInsert = new List<Case>();
        for (Integer i = 0; i < numOfCases; i++) {
            Case newCase = new Case();
            newCase.AccountId = accountId;
            newCase.Subject = 'Test Case ' + (i + 1);
            newCase.Status = 'New';
            newCase.Origin = 'Email';
            casesToInsert.add(newCase);
        }
        // Insert the cases.
        insert casesToInsert;
      
        // Delete the cases.
        delete casesToInsert;
    }
}