public with sharing class MDT_TriggerBeforeInsertTAFModified_Test extends TriggerHandler{
    override public void beforeInsert(){
        for (Trigger_Before_Insert_TAFModified__c c : (List<Trigger_Before_Insert_TAFModified__c>) Trigger.new) {
            c.Test_1__c = 'Benchmark Test';
        }
    }
}
