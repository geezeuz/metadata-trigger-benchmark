trigger BeforeApexTriggerUpdateTrigger on Before_Apex_Trigger_Update__c (before insert, before update, after insert, after update) {
    new BeforeApexTriggerUpdateTriggerHandler().run();
}