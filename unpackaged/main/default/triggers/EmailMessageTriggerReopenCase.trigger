trigger EmailMessageTriggerReopenCase on EmailMessage (before insert) {

    Set<Id> caseIds = new Set<Id>();
    for (EmailMessage em : Trigger.new) {
        if (em.ParentId != null && em.ParentId.getSObjectType() == Case.sObjectType) {
            caseIds.add(em.ParentId);
        }
    }

    System.debug('EmailMessageTriggerReopenCase: caseIds: ' + String.valueOf(caseIds));

    Map<Id, Case> caseMap = new Map<Id, Case>([
        SELECT Id, Status, Reason
        FROM Case
        WHERE Id IN :caseIds
    ]);

    List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

    System.debug('EmailMessageTriggerReopenCase: caseMap: ' + String.valueOf(caseMap));

    for (EmailMessage em : Trigger.new) {
        if (caseMap.containsKey(em.ParentId) && caseMap.get(em.ParentId).Status == 'Closed' 
        && caseMap.get(em.ParentId).Reason == 'Other') {
            // em.addError('Cannot create an Email Message for a Closed Case.');

            // Send email notification to the sender
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // mail.setToAddresses(new String[]{caseMap.get(em.ParentId).ContactEmail});
            mail.setToAddresses(new String[]{em.FromAddress});
            mail.setSubject('Email Message Creation Failed');
            mail.setPlainTextBody('You cannot create an Email Message for a Closed Case.');
            emailsToSend.add(mail);
        }
    }

    if (!emailsToSend.isEmpty()) {
        Messaging.sendEmail(emailsToSend);
    }

    System.debug('EmailMessageTriggerReopenCase: finished');
}