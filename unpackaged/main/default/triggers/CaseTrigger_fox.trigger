trigger CaseTrigger_fox on Case (before insert, before update) {

    Set<Id> accountIds = new Set<Id>();
    
    for (Case c : Trigger.new) {
        if (c.AccountId != null) {
            accountIds.add(c.AccountId);
        }
    }

    if (!accountIds.isEmpty()) {
        Map<Id, List<Entitlement>> accountEntitlementsMap = new Map<Id, List<Entitlement>>();
        
        // Query entitlements associated with the accounts
        for (Entitlement ent : [SELECT Id, AccountId FROM Entitlement WHERE AccountId IN :accountIds]) {
            if (!accountEntitlementsMap.containsKey(ent.AccountId)) {
                accountEntitlementsMap.put(ent.AccountId, new List<Entitlement>());
            }
            accountEntitlementsMap.get(ent.AccountId).add(ent);
        }

        // Associate entitlements with cases
        for (Case c : Trigger.new) {
            if (c.AccountId != null && accountEntitlementsMap.containsKey(c.AccountId)) {
                List<Entitlement> entitlements = accountEntitlementsMap.get(c.AccountId);
                if (!entitlements.isEmpty()) {
                    // Assign the first entitlement to the case
                    c.EntitlementId = entitlements[0].Id; // Assuming EntitlementId is a field on Case
                }
            }
        }
    }
}