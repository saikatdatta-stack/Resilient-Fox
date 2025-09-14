public with sharing class AccountPaginationController {
    public AccountPaginationController() {

        
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer pageNumber, Integer pageSize) {
        Integer offset = (pageNumber - 1) * pageSize;
        return [
            SELECT Id, Name, Industry, Rating
            FROM Account
            ORDER BY Name
            LIMIT :pageSize
            OFFSET :offset
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Integer getAccountCount() {
        return [SELECT COUNT() FROM Account];
    }

}