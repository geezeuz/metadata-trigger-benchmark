trigger AfterApexTriggerUpdateTrigger on After_Apex_Trigger_Update__c (after insert) {

    List<After_Apex_Trigger_Update__c> records = new List<After_Apex_Trigger_Update__c>();
    for(After_Apex_Trigger_Update__c record : Trigger.new){
        if(String.isBlank(record.Text_1__c)){
            records.add(new After_Apex_Trigger_Update__c(Id=record.Id, Text_1__c='Benchmark Update'));
        }
    }
    if(records.isEmpty()) return;
    update records;
}