public with sharing class AccountCSVUploader {

    @AuraEnabled
    public static List<Account> uploadCSV(String csvBody) {
          
        List<Account> accsToInsert = new List<Account>();
        List<String> lines = csvBody.split('\n');

        try {
        for (Integer i = 1; i <= lines.size(); i++) {

               List<String> columns = lines[i].split(',');
                Account acc = new Account();
                acc.Name = columns[0].trim();
                acc.AnnualRevenue = Decimal.valueOf(columns[1].trim());
                acc.CurrencyIsoCode = columns[2].trim();
    
                accsToInsert.add(acc);
            
        }

        insert accsToInsert;

       
    } catch (DmlException e) {
            System.debug('DML Error: ' + e.getMessage());
            System.debug('Failed Fields: ' + e.getDmlFieldNames(0));
        } catch (Exception ex) {
            System.debug('General Error: ' + ex.getMessage());
        }

        return accsToInsert;
    }
}