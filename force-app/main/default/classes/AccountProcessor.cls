public class AccountProcessor {
 
    public AccountProcessor() {
      
    }
    public static void countContacts() {
       
        Account acc = [Select Id, Name from Account where name = 'chandra'][0];
        Contact[] con = [SELECT Id,FirstName,LastName FROM Contact where AccountId =:acc.Id];
        acc.Number_of_Contacts__c = con.size();
        update acc;
        
        
    }
}