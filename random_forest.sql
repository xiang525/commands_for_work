SELECT * FROM Forest_Drive(
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




SELECT * FROM Forest_Predict(
    ON iris_test
    FOREST('iris_model')
    NUMERICINPUTS('iris_slen','iris_swidth','iris_plen','iris_pwidth') 
    CATEGORICALINPUTS('y_specis')
    IDCOL('id')
    detailed('true')
);









find . -name \*.jar -exec grep -l Drainable {} \;

select * from "forest_data_distn" (on "iris_train" ) as "forest_data_distn" ;

SELECT * FROM forest_builder(ON "iris_train" numTrees(5) response('"y_specis"') numericInputs('iris_slen','iris_swidth','iris_plen','iris_pwidth') categoricalInputs('y_specis') minNodeSize(4) maxDepth(6) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.2)MaxNumCategoricalValues(20)Mtry('-1'));

CREATE TABLE "iris_model" (partition key (task_index)) AS SELECT * FROM forest_builder(ON "iris_train" numTrees(5) response('"y_specis"') numericInputs('iris_slen','iris_swidth','iris_plen','iris_pwidth') categoricalInputs('y_specis') minNodeSize(4) maxDepth(6) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.2)MaxNumCategoricalValues(20)Mtry('-1'));









 SELECT * FROM GMMFit ( ON "gmm_init" as init_params PARTITION BY 1  OutputTable('test.myoutput1') InputTable('gmm_iris_train') ClusterNum('3') CovarianceType('spherical') MaxIterNum('10') PackOutput('TRUE') ) ;














