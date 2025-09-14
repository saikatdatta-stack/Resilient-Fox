global class schUpdOpp implements Schedulable{
    global void execute(SchedulableContext sc) {

        batchUpdateOpp batch = new batchUpdateOpp();
        database.executebatch(batch, 200);
    }
}