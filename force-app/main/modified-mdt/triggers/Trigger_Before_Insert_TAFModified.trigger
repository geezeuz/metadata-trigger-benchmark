trigger Trigger_Before_Insert_TAFModified on Trigger_Before_Insert_TAFModified__c (before insert) {
    new MetadataTriggerHandlerModified().run();
}