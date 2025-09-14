@RestResource(urlMapping='/opportunities/')
global with sharing class OpportunityController {
    // public OpportunityController() {

    // }

    // @AuraEnabled(cacheable=true)
    // public static List<Opportunity> getOpportunities() {
    //     return [
    //         SELECT Id, Name, StageName, Amount, CloseDate
    //         FROM Opportunity
    //         WITH SECURITY_ENFORCED
    //         LIMIT 10
    //     ];
    // }
    
    @HttpGet
    global static List<Opportunity> getOpportunitiesAPI() {
        return [
            SELECT Id, Name, StageName, Amount, CloseDate
            FROM Opportunity
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }

}