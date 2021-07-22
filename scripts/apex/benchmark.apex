



// SELECT FIELDS(ALL) FROM After_Save_Field_Update__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Delete_Child__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Delete_Example__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Delete_Trigger_Example__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Save_Field_Update__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Save_Multiple_Flow_Single_Update__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Save_Single_Flow_Multi_Update__c LIMIT 200
// SELECT FIELDS(ALL) FROM Before_Trigger_Field_Update__c LIMIT 200
// SELECT FIELDS(ALL) FROM Process_Builder__c LIMIT 200
// SELECT FIELDS(ALL) FROM Workflow_Field_Update__c LIMIT 200

SELECT FIELDS(ALL) FROM Benchmark_Result__c LIMIT 200

SELECT COUNT(ID),BENCHMARK_NAME__C,AVG(DURATION_MILLISECONDS__C) FROM Benchmark_Result__c GROUP BY BENCHMARK_NAME__C


COUNT(ID)  BENCHMARK_NAME__C                           AVG(DURATION_MILLISECONDS__C)
─────────  ──────────────────────────────────────────  ─────────────────────────────
15         Trigger Update Field On Insert              75.26666666666667
15         Before Save Flow On Insert                  78.73333333333333
15         Workflow Update Field On Insert             99.66666666666667
15         Single Flow Multi Criteria Field Update     103.93333333333334
15         Before Delete Trigger Insert Child Records  106.46666666666667
30         Before Delete Flow Insert Child Records     204.13333333333333
15         Multiple Flow Single Criteria Field Update  312.73333333333335
15         After Save Flow On Insert                   443.53333333333336
15         Process Builder No Criteria On Insert       568.0666666666667



Before Record Save Flow
    NO Apex
    NO Subflow
    No DML

MetadataTrigger
    Apex Classes
    Autolaunched Flow

After Record Flow
    Invocable Method





delete [SELECT ID FROM Benchmark_Result__c WHERE BENCHMARK_NAME__C='Workflow Update Field On Insert'];


new RecordAutomationBenchmarking().runBeforeSaveFlowOnInsertBenchmark();
// new RecordAutomationBenchmarking().runAfterSaveFlowOnInsertBenchmark();
// new RecordAutomationBenchmarking().runProcessBuilderOnInsertBenchmark();
// new RecordAutomationBenchmarking().runTriggerUpdateFieldOnInsertBenchmark();
// new RecordAutomationBenchmarking().runWorkflowUpdateFieldOnInsertBenchmark();
// new RecordAutomationBenchmarking().runBeforeDeleteFlowInsertChildRecordsBenchmark();
// new RecordAutomationBenchmarking().runBeforeDeleteTriggerInsertChildRecordsBenchmark();
// new RecordAutomationBenchmarking().runSingleFlowMultipleCriteriaEvalOnInsertBenchmark();
// new RecordAutomationBenchmarking().runMultipleFlowSingleCriteriaEvalOnInsertBenchmark();






Trigger_Action__mdt




insert new Metadata_Before_Save_Flow_Update__c();

SELECT FIELDS(ALL) FROM Metadata_Before_Save_Flow_Update__c LIMIT 200

ID                  OWNERID             ISDELETED  NAME             CREATEDDATE                   CREATEDBYID         LASTMODIFIEDDATE              LASTMODIFIEDBYID    SYSTEMMODSTAMP                TEXT_1__C
──────────────────  ──────────────────  ─────────  ───────────────  ────────────────────────────  ──────────────────  ────────────────────────────  ──────────────────  ────────────────────────────  ─────────
a0CP0000007xm0QMAQ  005P000000859hmIAA  false      Test             2021-07-20T03:42:24.000+0000  005P000000859hmIAA  2021-07-20T03:42:24.000+0000  005P000000859hmIAA  2021-07-20T03:42:24.000+0000  null
a0CP0000007xm0VMAQ  005P000000859hmIAA  false      Test             2021-07-20T03:43:07.000+0000  005P000000859hmIAA  2021-07-20T03:43:07.000+0000  005P000000859hmIAA  2021-07-20T03:43:07.000+0000  null
a0CP0000007xm0kMAA  005P000000859hmIAA  false      Test             2021-07-20T03:46:13.000+0000  005P000000859hmIAA  2021-07-20T03:46:13.000+0000  005P000000859hmIAA  2021-07-20T03:46:13.000+0000  null
a0CP0000007xm0GMAQ  005P000000859hmIAA  false      a0CP0000007xm0G  2021-07-20T03:38:19.000+0000  005P000000859hmIAA  2021-07-20T03:38:19.000+0000  005P000000859hmIAA  2021-07-20T03:38:19.000+0000  null
Total number of records retrieved: 4.