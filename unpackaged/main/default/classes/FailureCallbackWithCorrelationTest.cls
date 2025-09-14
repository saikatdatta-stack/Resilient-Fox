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
@isTest
public class FailureCallbackWithCorrelationTest {

    @isTest
    static void myUnitTest() {
        // TO DO: implement unit test
    }

    @isTest
    static void testFailedEventsWithFail() {
        // Create test event
        Order_Event__e event = (Order_Event__e)Order_Event__e.sObjectType.newSObject(
            null, true);
        event.Order_Id__c='dummyOrderId';
        
        // Populate map
        Map<String,String> uuidMap = new Map<String,String>();
        uuidMap.put(event.EventUuid, 'dummyOrderId');
        
        // Create callback
        FailureCallbackWithCorrelation cb = new FailureCallbackWithCorrelation(uuidMap);
        
        // Make sure retry counter is 0
        Assert.areEqual(0, cb.getRetryCounter(),
            'Newly created callback should have retry counter at 0');
        
        // Publish an event with callback
        EventBus.publish(event, cb);
		
        // If we fail all publish attempts, callback should run MAX_RETRIES times.
        // For each attempt, the callback should republish the event,
        //    increase the counter, and update the map
        String prevUuid = event.EventUuid;
        for (Integer i = 1; i <= FailureCallbackWithCorrelation.MAX_RETRIES; i++) {
            Test.getEventBus().fail();
            Assert.areEqual(i, cb.getRetryCounter(), 'Retry counter should be ' + i);
            Assert.areEqual(1, cb.getUuidMap().size(), 'Map size should be 1');
            String currUuid = (new List<String>(cb.getUuidMap().keySet())).get(0);
            Assert.areNotEqual(prevUuid, currUuid,
                'Map should be updated with newly created event Uuid');
            Assert.areEqual('dummyOrderId', cb.getUuidMap().get(currUuid),
                'Map value should be the original Order Id');
            prevUuid = currUuid;
        }
        
        // If we publish another failed event, callback should not retry.
        Order_Event__e event2 = (Order_Event__e)Order_Event__e.sObjectType.newSObject(
            null, true);
        event2.Order_Id__c='dummyOrderId';
        EventBus.publish(event, cb);
        Test.getEventBus().fail();
        Assert.areEqual(FailureCallbackWithCorrelation.MAX_RETRIES, cb.getRetryCounter(),
                        'Retry counter should still be ' +
                         FailureCallbackWithCorrelation.MAX_RETRIES);
    }
}