@RestResource(urlMapping='/v1/Welcome/*')
global with sharing class WelcomeClass{
global final static  String WELCOME_MESSAGE = 'WELCOME TO SNEHAS MESSAGE';

@httpGet
global static String greeting(){
return WELCOME_MESSAGE;
}
 
}