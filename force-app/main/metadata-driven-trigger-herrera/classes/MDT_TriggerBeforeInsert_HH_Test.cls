public with sharing class MDT_TriggerBeforeInsert_HH_Test extends TriggerHandler{
    override public void beforeInsert(){
        for (Trigger_Before_Insert_HH__c c : (List<Trigger_Before_Insert_HH__c>) Trigger.new) {
            c.Test_1__c = 'Benchmark Test';
        }
    }
}
