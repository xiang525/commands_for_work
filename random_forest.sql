SELECT COUNT(*) > 1 FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('iris_train')
    OUTPUTTABLE('iris_model')
    RESPONSE('y_specis')
    NUMERICINPUTS('iris_slen','iris_swidth','iris_plen','iris_pwidth')  
    CategoricalInputs('y_specis')  
    MONITORTABLE('iris_monitor_table')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('3')
    maxdepth('6')
    treesize('10')
);




find . -name \*.jar -exec grep -l Drainable {} \;