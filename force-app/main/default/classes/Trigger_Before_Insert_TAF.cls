public with sharing class Trigger_Before_Insert_TAF implements TriggerAction.BeforeInsert {
    public void beforeInsert(List<SObject> newList){
        for(Trigger_Before_Insert_TAF__c record : (List<Trigger_Before_Insert_TAF__c>) newList){
            record.Text_1__c = 'Benchmark Test';
        }
    }
}
