public with sharing class MetadataTriggerServiceModified {
    public class MetadataTriggerServiceException extends Exception {
    }
    private String objType = '';

    public MetadataTriggerServiceModified(String objectTypeName) {
        this.objType = objectTypeName;
    }

    /**
     * @description This query finds an ordered list trigger handler classes
     * to execute. It ignores any classes that are marked as disabled.
     *
     * Note: It will exclude any triggerHandler metadata records for which
     * the user's email address is found in a related disabled_for__mdt
     * record.
     *
     * Admin's and Developers can selectively disable trigger handlers
     * for all or selected individuals *without* deploying.
     * @return      `List<Metadata_Driven_Trigger__mdt>`
     */
    @suppressWarnings('PMD.ApexCRUDViolation')
    public List<Metadata_Driven_Trigger__mdt> getMetadataTriggers() {
        Map<String, Metadata_Driven_Trigger__mdt> classesToBeCalledAfterPermissionCheck = new Map<String, Metadata_Driven_Trigger__mdt>();
        List<sObject_Trigger_Setting__mdt> runningSObjectSettings = [
            SELECT Required_Permission__c, Bypass_Permission__c, Bypass_Execution__c 
            FROM sObject_Trigger_Setting__mdt 
            WHERE Object_API_Name__c = :this.objType
        ];
        if(runningSObjectSettings.size() > 0){
            for (sObject_Trigger_Setting__mdt runningSObjectSetting : runningSObjectSettings) {
                if (runningSObjectSetting.Bypass_Execution__c) {
                    return classesToBeCalledAfterPermissionCheck.values();
                }
                if (!String.isblank(runningSObjectSetting.Bypass_Permission__c)) {
                    if(FeatureManagement.checkPermission(runningSObjectSetting.Bypass_Permission__c)){
                        return classesToBeCalledAfterPermissionCheck.values();
                    }
                }
                if (!String.isblank(runningSObjectSetting.Required_Permission__c)) {
                    if (!FeatureManagement.checkPermission(runningSObjectSetting.Required_Permission__c)){
                        return classesToBeCalledAfterPermissionCheck.values();
                    }
                }
            }
        }
        List<Metadata_Driven_Trigger__mdt> classesToBeCalled = [
            SELECT Class__c, Execution_Order__c, Bypass_Permission__c, Required_Permission__c
            FROM Metadata_Driven_Trigger__mdt
            WHERE
                Object__c = :this.objType
                AND Enabled__c = TRUE
            ORDER BY Execution_Order__c
        ];
        for (Metadata_Driven_Trigger__mdt classCalled : classesToBeCalled) {
            if (!String.isblank(classCalled.Bypass_Permission__c)) {
                if(FeatureManagement.checkPermission(classCalled.Bypass_Permission__c)){
                    continue;
                    //Test
                }
            }
            if (!String.isblank(classCalled.Required_Permission__c)) {
                if (!FeatureManagement.checkPermission(classCalled.Required_Permission__c)){
                    continue;
                }
            }
            classesToBeCalledAfterPermissionCheck.put(classCalled.Class__c, classCalled);
        }
        return classesToBeCalledAfterPermissionCheck.values();
    }

    /**
     * @description This determines the active sObject type by describing the first
     * record in the trigger New / Old list
     * @return      `String`
     */
    public static String getSObjectType() {
        if (Trigger.new != null) {
            return Trigger.new[0].getSObjectType().getDescribe().getName();
        } else if (Trigger.old != null) {
            return Trigger.old[0].getSObjectType().getDescribe().getName();
        }
        throw new MetadataTriggerServiceException(
            'Trigger.new && Trigger.old are both null. Are you excercising this method outside of a trigger context?'
        );
    }
}