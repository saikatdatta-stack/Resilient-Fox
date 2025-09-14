/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@IsTest
public class AccountCSVUploaderTest {

    @IsTest
    static void testUploadCSV() {
        // Create a sample CSV content
        String csvContent = 'Name,AnnualRevenue,CurrencyIsoCode\nAcme Corp,1000000,USD\nSalesforce Inc,2000000,USD';

        // Call the static uploadCSV method without creating an instance of the class
        List<Account> accounts = AccountCSVUploader.uploadCSV(csvContent);

        // Verify the results
        System.assertEquals(2, accounts.size(), 'The number of accounts should be 2');

        Account account1 = accounts[0];
        System.assertEquals('Acme Corp', account1.Name, 'The name of the first account should be Acme Corp');
        System.assertEquals(1000000, account1.AnnualRevenue, 'The annual revenue of the first account should be 1000000');
        System.assertEquals('USD', account1.CurrencyIsoCode, 'The currency of the first account should be USD');

        Account account2 = accounts[1];
        System.assertEquals('Salesforce Inc', account2.Name, 'The name of the second account should be Salesforce Inc');
        System.assertEquals(2000000, account2.AnnualRevenue, 'The annual revenue of the second account should be 2000000');
        System.assertEquals('USD', account2.CurrencyIsoCode, 'The currency of the second account should be USD');
    }
}