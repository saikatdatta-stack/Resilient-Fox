public with sharing class Dummy {
    public Dummy() {

    }

    public static void mapVariable()
    {
        String corpCurrency = '';
       List<String> otherCurrency = new List<String>();
        List<DatedConversionRate> li_dcr = new List<DatedConversionRate>();

        String lv_url = 'http://data.fixer.io/api/latest?access_key=80b83b76c6abd71d6f0186a823808ac4&base=EUR&symbols=INR,BDT';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(lv_url);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) 
        {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            System.debug(results);

            Map<String, Object> currencies = (Map<String, Object>)results.get('rates');
            System.debug(currencies);
        
        for (String key : currencies.keySet())
            {
                Decimal lv_exchange = (Decimal)currencies.get(key);
                System.debug(lv_exchange);
                System.debug(key);
                System.debug(results.get('date'));

                DatedConversionRate dcr = new DatedConversionRate();
                dcr.IsoCode = key;
                dcr.ConversionRate = lv_exchange;
                dcr.StartDate = Date.valueOf((String)results.get('date'));
                li_dcr.add(dcr);

            }
        }

            System.debug(li_dcr);
    }
}