public inherited sharing class updateCurrency {

    private static String apiURL;
    private static String corpCurrency;
    private static List<String> otherCurrency = new List<String>();

    public updateCurrency() {

    }

    public static void fetchCurrency() {
        List<CurrencyType> lo_currencies = [SELECT IsoCode, ConversionRate, IsActive, IsCorporate FROM CurrencyType WHERE IsActive = true];
        for (CurrencyType curr : lo_currencies) {
            System.debug(curr);
            if (curr.IsCorporate) {
                corpCurrency = curr.IsoCode;
            } else {
                otherCurrency.add(curr.IsoCode);
            }
        }
    }


    private static void populateAPIData()
    {
        Currency_API__mdt ls_curr_api_det = [SELECT Host__c, 	Purpose__c, API_Key__c FROM Currency_API__mdt];
        apiURL = ls_curr_api_det.Host__c + ls_curr_api_det.Purpose__c + ls_curr_api_det.API_Key__c;
    }

    private static String getAPIData() {
        return apiURL;
    }

    @future(callout=true)
    public static void updateExchangeRate() {

        String lv_url;
        String lv_itr_part;
        String lv_final_url;
        List<DatedConversionRate> li_dcr = new List<DatedConversionRate>();

        populateAPIData();
        System.debug(apiURL);

        fetchCurrency();
        System.debug(otherCurrency);
        System.debug(corpCurrency);

        lv_url = apiURL + '&base=' + corpCurrency + '&symbols=';
        System.debug(lv_url);

        for (String i_corpCurrency : otherCurrency) {
            
            lv_itr_part =   i_corpCurrency + ',';
            lv_url = lv_url + lv_itr_part;
            lv_itr_part = '';
        }

        System.debug(lv_url);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(lv_url);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

if (response.getStatusCode() == 200) {
           Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(results);
            Map<String, Object> currencies = (Map<String, Object>)results.get('rates');
            System.debug(currencies);

            List<DatedConversionRate> datedcurrencies = [SELECT Id, IsoCode, ConversionRate, nextStartDate, startDate from DatedConversionRate];

            for (String key : currencies.keySet())
            {
                Decimal lv_exchange = (Decimal)currencies.get(key);
                System.debug(lv_exchange);
                System.debug(key);

                for (DatedConversionRate dcr : datedcurrencies) {
                    if (dcr.isoCode == key) {
                        dcr.conversionRate = lv_exchange;
                        dcr.IsoCode = key;
                        dcr.ConversionRate = lv_exchange;
                        dcr.StartDate = Date.valueOf((String)results.get('date'));
                        // dcr.nextStartDate = Date.valueOf((String)results.get('date'));
                        System.debug(dcr);
                        li_dcr.add(dcr);
                    }
                }
                // DatedConversionRate dcr = new DatedConversionRate();
                // dcr.IsoCode = key;
                // dcr.ConversionRate = lv_exchange;
                // dcr.StartDate = Date.valueOf((String)results.get('date'));
                // li_dcr.add(dcr);

            }

            // Update li_dcr;
    
        }
    }
}