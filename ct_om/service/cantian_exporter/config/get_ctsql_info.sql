SELECT START_TIME,COMPLETION_TIME,MAX_BUFFER_SIZE FROM SYS_BACKUP_SETS;
SELECT NAME,VALUE FROM DV_PARAMETERS WHERE NAME='CHECKPOINT_PAGES';
SELECT NAME,VALUE FROM DV_PARAMETERS WHERE NAME='CHECKPOINT_PERIOD';
SELECT * FROM DV_DRC_RES_RATIO WHERE DRC_RESOURCE='GLOBAL_LOCK';
SELECT * FROM DV_DRC_RES_RATIO WHERE DRC_RESOURCE='LOCAL_LOCK';
SELECT * FROM DV_DRC_RES_RATIO WHERE DRC_RESOURCE='LOCAL_TXN';
SELECT * FROM DV_DRC_RES_RATIO WHERE DRC_RESOURCE='GLOBAL_TXN';