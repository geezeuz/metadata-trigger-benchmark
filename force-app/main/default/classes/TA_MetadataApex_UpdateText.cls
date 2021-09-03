public with sharing class TA_MetadataApex_UpdateText implements TriggerAction.BeforeInsert {
    public void beforeInsert(List<SObject> newList){
        for(Metadata_Before_Save_Apex_Update__c record : (List<Metadata_Before_Save_Apex_Update__c>) newList){
            record.Text_1__c = 'Benchmark Test';
        }
    }
}
