trigger Trigger_Before_Insert_Trigger_Handler on Trigger_Before_Insert_Trigger_Handler__c (before insert) {
    new Trigger_Before_Insert_Trigger_Handler().run();
}