public with sharing class getAccounts {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name, Industry, Phone
            FROM Account
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }
}