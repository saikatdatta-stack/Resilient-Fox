global with sharing class ValidateAttachmentsEmailService implements Messaging.InboundEmailHandler
{
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        String emailBody = email.plainTextBody;
        String emailSubject = email.subject;

        // Define allowed extensions
        Set<String> allowedExtensions = new Set<String>{'pdf', 'xlsx', 'png', 'jpg'};

        System.debug(email.toAddresses);
        System.debug(email.binaryAttachments);
        System.debug(email.binaryAttachments.size());
        System.debug(emailBody);
        System.debug(emailSubject);
        
        try{
            if(email.toAddresses.contains('block_dox_attachments'))
            {
            if (email.binaryAttachments.size() >0) 
            {            
                for (Messaging.InboundEmail.BinaryAttachment Attachment : email.binaryAttachments) 
                {
                // Get the file extension
                String filename = attachment.fileName;
                String extension = filename.substringAfterLast('.'); 
                if (allowedExtensions.contains(extension)) {
                    System.debug('Valid attachment: ' + filename);
                    // You can save or process this file here
                } else {
                    System.debug('Invalid attachment: ' + filename);
                    // Optional: Log or notify for invalid format
                    break;
                }
       
            }
        }
    }
        }catch (Exception e)
        {
        result.success = false;
        result.message = 'Oops, I failed.';
        }

        result.success = true;
        return result;
    }
}