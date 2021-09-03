public with sharing class BeforeApexTriggerUpdateTriggerHandler extends TriggerHandler {
    public BeforeApexTriggerUpdateTriggerHandler() {

    }
    public override void beforeInsert(){
        for(Before_Apex_Trigger_Update__c record : (List<Before_Apex_Trigger_Update__c>) Trigger.new){
            record.Text_1__c = 'Benchmark Test';
        }
    }
}
