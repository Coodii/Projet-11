public class APOrder01 {
    /**
* @description This method checks if an updated order has at least one product.
*  If not a message will be throw and the status of the order will be changed to 'Draft'.
* @param   List<Order> listOrd A list of Order. 
*/
    public static void checkOrderProducts (List<Order> listOrd){
        for (order o: [SELECT Id, Status, (SELECT Id, UnitPrice, Quantity, OrderId FROM OrderItems)FROM Order WHERE Id in :listOrd]){
            Order orderOldValue = (order)Trigger.newMap.get(o.id);
            if (o.orderItems.size()<1 && o.Status=='Activated' && (orderOldValue.Status == 'Draft')){
                 	o.addError('PLEASE ADD A PRODUCT FOR THIS ORDER');
            }
        }
    }
    
    /**
* @description This method checks if the account related to an order has at least one order. If no, the field Active__c will be changed to 'No'.
* @param   listOrd A list of orders. 
*/       
    public static void checkAssociatedAccounts(List<Order> listOrd){
        List<Id> lstAccountId = new list<Id>();
        List<Account> updatedAcc = new List<account>();
        for (Order o: listOrd) {
            lstAccountId.add(o.accountId);
        }
        for (account a: [SELECT Id, Active__c, (SELECT Id FROM Orders)FROM Account WHERE Id in :lstAccountId]){
            if(a.orders.size()<1){
               a.Active__c= 'No';
               updatedAcc.add(a);
            } 
        }
        update updatedAcc;
    }
}