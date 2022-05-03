/**
* An apex page controller that supports self registration of users in communities that allow self registration
*/
public class CommunitiesSelfRegController {
    
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
    public CommunitiesSelfRegController() {
        String expid = ApexPages.currentPage().getParameters().get('expid');            
        if (expId != null) {
            Site.setExperienceId(expId); 
        }    
    }
    
    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    public PageReference registerUser() {
        
        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }    
        
        String profileId = [select id from profile where name = 'Customer Community User'].Id;
        System.debug('profileId =-------------------------'+profileId);
        String roleEnum = null; // To be filled in by customer.
        System.debug('roleEnum'+roleEnum);
        String accountId = System.Label.Community_Account_Id; // To be filled in by customer.
        System.debug('accountId'+accountId);
        String userName = email;
        System.debug('userName'+userName);
        //   String accountId = ''; // To be filled in by customer.
        
        List<User> existingUser = new List<User>([Select id from User where username=:userName and profileId=:profileId]);
        
        if(existingUser.size()>0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This Email Id has already been registered.'));
            return null;
        }
        
        SavePoint sp= Database.setSavepoint();
        contact con = new contact();
        con.FirstName= firstName;
        con.AccountId= accountId;
        con.LastName=lastName;  
        con.Email=email;
        insert con;
        
        
        User u = new User();
        u.ContactId=con.Id;
        u.Username = userName;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = communityNickname;
        u.ProfileId = profileId;
        u.PortalRole=roleEnum;
        
        
        String userId;
        
        try {
            userId = Site.createExternalUser(u, accountId, password);
        } catch(Site.ExternalUserCreateException ex) {
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error));
            }
            
            // This message is used for debugging. Do not display this in the UI to the end user.
            // It has the information around why the user creation failed.
            System.debug(ex.getMessage());
        }
        
        if (userId != null) { 
            if (password != null && password.length() > 1) {
       return Site.login(userName, password, ApexPages.currentPage().getParameters().get('startURL'));
             
            }
            else {
                PageReference page = System.Page.CommunitiesSelfRegConfirm;
                page.setRedirect(true);
                return page;
            }
        }
        return null;
    }
}