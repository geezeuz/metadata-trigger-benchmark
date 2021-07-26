trigger MetadataBeforeSaveFlowUpdateTrigger on Metadata_Before_Save_Flow_Update__c (before insert, before update, after insert, after update) {
    System.debug('HEY');
    // new MetadataTriggerHandler().run();
    Flow.Interview myFlow = Flow.Interview.createInterview('Benchmark_Metadata_Before_Save_Flow_Update', 
        new Map<String, Object>{
            'newList' => Trigger.new,
            'oldList' => Trigger.old
        }
    );
    myFlow.start();
}