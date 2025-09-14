@isTest
private class OpportunityControllerTest {


@IsTest
    static void testGetOpportunitiesAPI() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            Amount = 10000,
            CloseDate = Date.today(),
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        // Call the method to be tested
        List<Opportunity> opportunities = OpportunityController.getOpportunitiesAPI();

        // Assert the results
        System.assertEquals(1, opportunities.size(), 'Expected one opportunity to be returned');
        System.assertEquals(testOpportunity.Id, opportunities[0].Id, 'Unexpected opportunity ID');
    }
}