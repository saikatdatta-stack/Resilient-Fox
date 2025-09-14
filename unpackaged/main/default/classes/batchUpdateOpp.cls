public with sharing class batchUpdateOpp implements Database.Batchable<sObject>,Database.Stateful{
    public batchUpdateOpp() {

    }

    public Integer recordsProcess = 0;

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Amount FROM Opportunity');
    }

    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(Opportunity opp: scope){
            opp.Amount = 20000;
            oppsToUpdate.add(opp);
            recordsProcess++;
        }
        if (!oppsToUpdate.isEmpty()) {
            upsert oppsToUpdate Id;
        }
    }

    public void finish(Database.BatchableContext bc){
        // Get the ID of the AsyncApexJob representing this batch job
            System.debug(recordsProcess);
        // from AsyncApexJob column Id
        AsyncApexJob lo_job = [SELECT Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        System.debug(lo_job);
    }
}