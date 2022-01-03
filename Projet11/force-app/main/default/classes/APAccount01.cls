public class APAccount01 {
    /**
 * @description This method checks if an account has at least an order or a task.
 *  If not it will create a new task for this account.
 * @param   List<Order> accounts A list of accounts. 
 */
    public static void creatingNewTask(List<Account> accounts){
        List<Task> newTasks = new List<Task>();
        for (account a :([Select Id, (Select id from Orders), (Select id from Tasks) from Account where id in :accounts])){
            if (a.orders.size()<1 && a.tasks.size()<1){
                Task t = new Task(Subject='Call', Status='New', Priority='Normal', IsReminderSet = true,
				ReminderDateTime = System.now()+5, WhatId = a.id);
                newTasks.add(t);
            }
        }
        insert newTasks;
    }
}