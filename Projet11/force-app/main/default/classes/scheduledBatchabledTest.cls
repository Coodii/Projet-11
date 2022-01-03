@isTest
public class scheduledBatchabledTest {
    @testSetup static void createData() {
        List<account> listAcc = new List<account>();
        Account acc1 = new Account(Name = 'Test Account 1');
        Account acc2 = new Account(Name = 'Test Account 2');
        Account acc3 = new Account(Name='Test Account 2');
        listAcc.add(acc1);
        listAcc.add(acc2);
        listAcc.add(acc3);
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
        List<Order> listOrd = new List<Order>();
        Order o1 = new Order(AccountId=acc1.Id, EffectiveDate=System.today(), Status='Draft', Pricebook2Id = Test.getStandardPricebookId());
        insert o1;
        listOrd.add(o1);
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe1.Id, Quantity=1, UnitPrice=20 );
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe1.Id, Quantity=2, UnitPrice=50);
        insert oi2;
        o1.Status = 'Activated';
        Task t = new Task(Subject='Email', Status='New', Priority='Normal', IsReminderSet = true,
                          ReminderDateTime = System.now()+5, WhatId = acc3.id);
        insert t;
        update listOrd;
        update listAcc;
    }
    
    @isTest
    public static void testScheduledBatchabled(){
        scheduledBatchabled batch = new scheduledBatchabled();
        String sch = '0 0 22 ? * 2#1';
        Test.startTest();
        system.schedule('Test', sch, batch);
        Test.stopTest();
    }
    
}