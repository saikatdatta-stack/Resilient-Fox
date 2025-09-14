@RestResource(urlMapping='/uploadFileToOpportunityBearer/*')
global inherited sharing class BearerToken {


    public BearerToken() {

    }

    @HttpPost
    global static String uploadFileToOpp() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(req.requestBody.toString());

        String opportunityId = (String)params.get('opportunityId');
        String fileName = (String)params.get('fileName');
        String base64Data = (String)params.get('fileContent');

        System.debug('Opportunity Id  ' + opportunityId);
        System.debug('File Name  ' + fileName);

        Blob blob_file = EncodingUtil.base64Decode(base64Data);

        ContentVersion objContentVersion = new ContentVersion();
        objContentVersion.ContentLocation = 'S'; // S: File is in Salesforce, E: External files
        objContentVersion.PathOnClient = fileName;
        objContentVersion.Title = fileName;
        objContentVersion.VersionData = blob_file;

        insert objContentVersion;

        ContentDocumentLink contentlink = new ContentDocumentLink();

        contentlink.LinkedEntityId=opportunityId;
        contentlink.ShareType= 'V';
        contentlink.Visibility = 'AllUsers';
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: objContentVersion.id].contentdocumentid;

        insert contentlink;

        res.statusCode = 200;
        return 'File upload successfully';

        
        //Get the body of the request
    }
}