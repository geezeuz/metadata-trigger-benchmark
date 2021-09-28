trigger Trigger_Before_Insert_TAF on Trigger_Before_Insert_TAF__c (before insert, before update, after insert, after update) {
    new MetadataTriggerHandler().run();
}