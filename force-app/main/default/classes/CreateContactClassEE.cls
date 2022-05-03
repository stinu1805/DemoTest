public class CreateContactClassEE {
@Auraenabled
    public static  string createContactEE(Contact contObj){
        System.debug('contact::' + contObj.firstName);
        insert contObj;
        return contObj.Id;
    }
}