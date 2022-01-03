public class BatchAccount01 implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext dbc){
        return Database.getQueryLocator([SELECT Id, Name FROM Account]);
    }
    
    public void execute (Database.BatchableContext dbc, List<Account> accounts){
		APAccount01.creatingNewTask(accounts);      
    }
    
    public void finish(Database.BatchableContext dbc){
        System.debug('Done');
    }
}