trigger Trigger_Before_Insert on Trigger_Before_Insert__c (before insert) {
    for (Trigger_Before_Insert__c newRecord : Trigger.new) {
        newRecord.Test_1__c = 'Benchmark Test';
    }
}