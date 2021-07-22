trigger MetadataBeforeSaveFlowUpdateTrigger on Metadata_Before_Save_Flow_Update__c (before insert, before update, after insert, after update) {
    new MetadataTriggerHandler().run();
}