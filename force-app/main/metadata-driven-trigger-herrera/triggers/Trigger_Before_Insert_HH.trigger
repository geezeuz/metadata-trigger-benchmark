trigger Trigger_Before_Insert_HH on Trigger_Before_Insert_HH__c (before insert) {
    new MetadataTriggerHandlerHH().run();
}