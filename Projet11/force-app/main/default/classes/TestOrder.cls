@isTest
private class TestOrder {
    @isTest static void testCheckOrderProducts() {
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        List<Account> listAcc = new list<Account>();
        listAcc.add(acc1);
        listAcc.add(acc2);
        insert listAcc;
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
        PricebookEntry pbe1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 20,
            IsActive = true
        );
        Insert pbe1;
        Order o1 = new Order(AccountId=listAcc[0].Id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId());
        insert o1;
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe1.Id, Quantity=1, UnitPrice=20 );
        insert oi1;
        o1.Status = 'Activated';
        Test.startTest();
        update o1;
        Test.stopTest();    
        Order updatedO1 = [select Id, Status from Order where Id = :o1.Id];
        System.assertEquals('Activated', updatedO1.Status);            
    }
    
    
    @isTest static void testCheckAssociatedAccount() {
        Account acc1 = new Account(Name = 'Test Account 1', Active__c = 'Yes');
        Account acc2 = new Account(Name = 'Test Account 2', Active__c = 'Yes' );
        list<Account> listAcc = new list<Account>();
        listAcc.add(acc1);
        listAcc.add(acc2);
        insert listAcc;
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
        PricebookEntry pbe1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 20,
            IsActive = true
        );
        Insert pbe1;
        list<Order> listOrd = new list<Order>();
        String account1Id = listAcc[0].id;
        String account2Id = listAcc[1].id;
        Order o1 = new Order(AccountId=listAcc[0].id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId());
        listOrd.add(o1);
        Order o2 = new Order(AccountId=listAcc[1].id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId());
        Order o3 = new Order(AccountId=listAcc[1].id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId());
        listOrd.add(o2);
        listOrd.add(o3);
        insert listOrd;
        System.assertEquals('Yes', acc1.Active__c);
        System.assertEquals('Yes', acc2.Active__c);
        o1 = [select Id from Order where AccountId =:account1Id ];
        o2 = [select Id from Order where AccountId =: account2Id Limit 1];
        list<Order> listOrdToDelete = new list<Order>();
        listOrdToDelete.add(o1);
        listOrdToDelete.add(o2);
        Test.startTest();
        delete listOrdToDelete;
        Test.stopTest();
        Account updatedAcc1 = [select Id, Active__c from Account where Id =:account1Id];
        System.assertEquals('No', updatedAcc1.Active__c);
        Account updatedAcc2 = [select Id, Active__c from Account where Id =:account2Id];
        System.assertEquals('Yes', updatedAcc2.Active__c);
    }   
}