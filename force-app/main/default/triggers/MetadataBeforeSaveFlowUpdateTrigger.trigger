trigger MetadataBeforeSaveFlowUpdateTrigger on Metadata_Before_Save_Flow_Update__c (before insert, before update, after insert, after update) {
    System.debug('HEY');
    // new MetadataTriggerHandler().run();
    if(Trigger.isInsert && Trigger.isBefore){
        Flow.Interview myFlow = Flow.Interview.createInterview('Benchmark_Metadata_Before_Save_Flow_Update', 
            new Map<String, Object>{
                'newList' => Trigger.new,
                'oldList' => Trigger.old
            }
        );
        myFlow.start();

        List<Metadata_Before_Save_Flow_Update__c> newListAfterFlow = (List<sObject>) myFlow.getVariableValue('newListAfterFlow');

        for (Integer i = 0; i < Trigger.new.size(); i++) {
            Trigger.new[i].put('Text_1__c',newListAfterFlow[i].Text_1__c);
        }
    }
}