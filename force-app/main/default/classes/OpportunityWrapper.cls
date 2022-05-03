public class OpportunityWrapper {
    
    public Static Opportunity oppName{set;get;}
    public Static list<OpportunityLineItem> accList{set;get;}
       
    @AuraEnabled
    public static String getOppName(ID oppId)
    {
        oppName= [SELECT Id, Name,StageName,CreatedDate FROM Opportunity WHERE Id = :oppId]; 
        System.debug(oppName.Name + '-------');
        return oppName.Name;
    }
    
    @AuraEnabled
    public static List <OpportunityLineItem> fetchAccounts(ID oppId)
    {
        oppName= [SELECT Id, Name,StageName,CreatedDate FROM Opportunity WHERE Id = :oppId];
        accList=[SELECT Id, Name,ProductCode, Quantity, UnitPrice, TotalPrice,PricebookEntry.UnitPrice, PricebookEntry.Name, 
                 PricebookEntry.Product2.Name, PricebookEntry.Product2.Family , PricebookEntry.Product2.Product_Class__r.Product_Class__c,
                 PricebookEntry.Product2.Product_Class__r.GST__c,
                 PricebookEntry.Product2.Product_Class__r.Profit__c,
                 PricebookEntry.Product2.Product_Class__r.VAT__c
                 FROM OpportunityLineItem WHERE OpportunityId = :oppName.Id];
        System.debug(accList);
        return accList;
    }
    
    @AuraEnabled    
    public static boolean updateOpps(ID oppId, List < OpportunityLineItem > updatedOppList ) {    
        try {  
            update updatedOppList;  
            return true;  
        } catch(Exception e) {  
            System.debug(e);
            return false;  
        }  
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts.'+allOpts);
        return allOpts;
    }
        
    @AuraEnabled
    public static OpportunityLineItem getColumnData(String recId){
     
        List<Contact> conList = new List<Contact>();
        OpportunityLineItem con = [SELECT Id, PricebookEntry.Product2.Product_Class__r.Product_Class__c FROM OpportunityLineItem where Id = :recId];
        
        return con;
    }
    
     @AuraEnabled
    public static void updateOppProduct(Map<String, String> m1, String recId , String classVal)
    {
        
       OpportunityLineItem op =  [SELECT Id, Name,ProductCode, Quantity, UnitPrice, TotalPrice,PricebookEntry.UnitPrice, PricebookEntry.Name, 
                 PricebookEntry.Product2.Name, PricebookEntry.Product2.Family , PricebookEntry.Product2.Product_Class__r.Product_Class__c
           FROM OpportunityLineItem Where Id =:recId];
        
        String PriceBookId = op.PricebookEntryId;
        PricebookEntry pb = [SELECT Id, Name, Product2.Family , Product2.Product_Class__r.Product_Class__c FROM PricebookEntry Where Id =:PriceBookId];
       
        String ProductClassificationId = pb.Product2.Product_Class__r.Id;
        String ProductId = pb.Product2.Id;

        Product_Classification__c pdc = [SELECT Id, Product_Class__c, Name FROM Product_Classification__c Where Product_Class__c =:classVal];
        
        String ProdClassId= pdc.Id;
        String objName = 'Product2' ;
        
        sobject sObj = Schema.getGlobalDescribe().get(objName).newSObject(ProductId) ;
        for(String m : m1.keyset())
        {
           sObj.put(m,ProdClassId) ;
        }
         
        try
        {
        update sObj ;
        }
        catch(Exception ex){ 
        system.debug(ex);   
        }
    }
    
    
}