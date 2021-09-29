trigger Trigger_After_Insert on Trigger_After_Insert__c (after insert) {

    List<Trigger_After_Insert__c> records = new List<Trigger_After_Insert__c>();
    for(Trigger_After_Insert__c record : Trigger.new){
        // if(String.isBlank(record.Text_1__c)){
            records.add(new Trigger_After_Insert__c(Id=record.Id, Text_1__c='Benchmark Update'));
        // }
    }
    // if(records.isEmpty()) return;
    update records;
}