public class NewDestination {
@Auraenabled
    public static  string NewDestination(AddTrip__c contObj){
        insert contObj;
        return contObj.Id;
    }
}