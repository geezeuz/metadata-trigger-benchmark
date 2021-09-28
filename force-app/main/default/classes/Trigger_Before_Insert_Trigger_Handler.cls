public with sharing class Trigger_Before_Insert_Trigger_Handler extends TriggerHandler {
    public Trigger_Before_Insert_Trigger_Handler() {

    }
    public override void beforeInsert(){
        for(Trigger_Before_Insert_Trigger_Handler__c record : (List<Trigger_Before_Insert_Trigger_Handler__c>) Trigger.new){
            record.Text_1__c = 'Benchmark Test';
        }
    }
}
