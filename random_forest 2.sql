
\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip



\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_oob_predict.zip





SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('iris_test_di')
    OUTPUTTABLE('iris_model_di')
    RESPONSE('species')
    NUMERICINPUTS('sepal_length','sepal_width','petal_length','petal_width')  
    CategoricalInputs('species')  
    MONITORTABLE('iris_monitor_table_di')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('6')     
    numtrees('20')
    oob('true')    
);


drop table if exists predict_result;
create table predict_result(partition key (id)) as
SELECT * FROM Forest_Predict(
    ON iris_test
    FOREST('iris_model_di')
    NUMERICINPUTS('sepal_length','sepal_width','petal_length','petal_width')
    CATEGORICALINPUTS('species')
    IDCOL('id')
    Accumulate('species')
    detailed('false')
);



SELECT (SELECT count(id) FROM predict_result WHERE species <> prediction) / (SELECT count(id) FROM predict_result) as AP;


SELECT (SELECT count(prediction) FROM oob_predict_result WHERE response <> prediction) / (SELECT count(prediction) FROM oob_predict_result) as AP;

SELECT count(id) FROM predict_result WHERE species <> prediction;
SELECT count(id) FROM predict_result;


SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('iris_train_di')
    OUTPUTTABLE('iris_model_di')
    RESPONSE('species')
    NUMERICINPUTS('sepal_length','sepal_width','petal_length','petal_width')  
    CategoricalInputs('species')  
    MONITORTABLE('iris_monitor_table_di')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('6')     
    numtrees('5')
    oob('true')
    
);


drop table if exists predict_result_origin;
create table predict_result_origin (partition key (id)) as
SELECT * FROM Forest_Predict(
    ON iris
    FOREST('iris_model_origin')
    NUMERICINPUTS('sepal_length','sepal_width','petal_length','petal_width')
    CATEGORICALINPUTS('species')
    IDCOL('id')
    Accumulate('species')
    detailed('false')
);
SELECT (SELECT count(id) FROM predict_result_origin WHERE species <> prediction) / (SELECT count(id) FROM predict_result_origin) as AP;



/home/beehive/clients/ncluster_export -U db_superuser -w db_superuser -d random_forest -c airquality_test_di /root/air_test.csv

/home/beehive/clients/ncluster_export -U db_superuser -w db_superuser -d random_forest -c housing_train /root/housing_train.csv

/home/beehive/clients/ncluster_export -U db_superuser -w db_superuser -d random_forest -c iris_test /root/iris_test.csv

/home/beehive/clients/ncluster_loader -U db_superuser -w db_superuser -d frepath -c survey_test /root/Airport_Quarterly_Passenger_Survery_sample.csv


/home/beehive/clients/ncluster_loader -U db_superuser -w db_superuser -d random_forest -c airquality_di /root/airquality.csv

/home/beehive/clients/ncluster_export -U db_superuser -w db_superuser -d random_forest -c _temp_table_oob /root/temp_table_oob.csv


find . -name \*.jar -exec grep -l Drainable {} \;

select * from "forest_data_distn" (on "iris_train" ) as "forest_data_distn" ;

SELECT * FROM forest_builder(ON "iris_train" numTrees(5) response('"y_specis"') numericInputs('iris_slen','iris_swidth','iris_plen','iris_pwidth') categoricalInputs('y_specis') minNodeSize(4) maxDepth(6) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.2)MaxNumCategoricalValues(20)Mtry('-1'));

CREATE TABLE "iris_model" (partition key (task_index)) AS SELECT * FROM forest_builder(ON "iris_train" numTrees(5) response('"y_specis"') numericInputs('iris_slen','iris_swidth','iris_plen','iris_pwidth') categoricalInputs('y_specis') minNodeSize(4) maxDepth(6) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.2)MaxNumCategoricalValues(20)Mtry('-1'));


SELECT (SELECT count(tree_num) FROM oob_observation WHERE response = species) / (SELECT count(tree_num) FROM oob_observation) as AP;


select response, prediction, sum(response) from oob_predict_result;





 SELECT * FROM GMMFit ( ON "gmm_init" as init_params PARTITION BY 1  OutputTable('test.myoutput1') InputTable('gmm_iris_train') ClusterNum('3') CovarianceType('spherical') MaxIterNum('10') PackOutput('TRUE') ) ;



iris.p <- classCenter(iris[,-5], iris[,5], iris.rf$prox)
plot(iris[,3], iris[,4], pch=21, xlab=names(iris)[3], ylab=names(iris)[4],
     bg=c("red", "blue", "green")[as.numeric(factor(iris$Species))],
     main="Iris Data with Prototypes")
points(iris.p[,3], iris.p[,4], pch=21, cex=2, bg=c("red", "blue", "green"))

summary(iris.rf)



data(iris)
rf1 <- randomForest(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf2 <- randomForest(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf3 <- randomForest(Species ~ ., iris, ntree=50, norm.votes=FALSE)
rf.all <- combine(rf1, rf2, rf3)
print(rf.all)


setwd("~/Documents/machine_learning/random_forest/rcodes")
#install.packages("randomForest")
library(randomForest)
#set.seed(100)
data(iris)
iris.rf <- randomForest(Species ~ ., data=iris, ntree=100, keep.forest=FALSE, importance=TRUE, mtry=3)
print(iris.rf)
importance(iris.rf)
#importance(iris.rf, type=1)


DROP TABLE if exists iris;
CREATE FACT TABLE iris (ID int, SEPAL_LENGTH double, SEPAL_WIDTH double, PETAL_LENGTH double, PETAL_WIDTH double, SPECIES varchar, PARTITION KEY (id));

/home/beehive/clients/ncluster_loader -U db_superuser -w db_superuser -d random_forest iris_input_di /root/iris.csv -c

select * from oob_observation where sepal_length, sepal_width, petal_length, petal_width not in (select * from ob2);


create table result (partition key (prediction)) as select * from forest_oob_predict(ON oob_observation  forest('"iris_model"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species')) as pred;


select (select count(prediction) from (select * from forest_oob_predict(ON oob_observation  forest('"iris_model"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species')) as pred) where prediction=response) / 


CREATE TABLE pred_result (partition key (prediction)) AS select * from forest_oob_predict(ON oob_observation  forest('"iris_model"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species')) as pred;


CREATE TABLE oob_predict_result (partition key (prediction)) AS select * from forest_oob_predict(ON oob_observation  forest('"iris_model"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species'));

SELECT (SELECT count(prediction) FROM oob_predict_result WHERE response = prediction) / (SELECT count(prediction) FROM oob_predict_result) as AP;


 SELECT * FROM forest_builder(ON "iris_train" numTrees(2) response('"species"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species') minNodeSize(4) maxDepth(60) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.44999999999999996) MaxNumCategoricalValues(20) Mtry('-1') OOB('true'));


SELECT * FROM forest_builder(ON "iris" numTrees(2) response('"species"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species') minNodeSize(4) maxDepth(60) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.44999999999999996)MaxNumCategoricalValues(20)Mtry('-1')oob('true'));


 SELECT * FROM forest_builder(ON "iris" numTrees(2) response('"species"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species') minNodeSize(4) maxDepth(60) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.36)MaxNumCategoricalValues(20)Mtry('-1')oob('true'));




SELECT (SELECT count(id) FROM predict_result_origin WHERE species <> prediction) / (SELECT count(id) FROM predict_result_origin) as AP;




\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip



\install /root/random_forest/files_origin/forest_analyze.zip
\install /root/random_forest/files_origin/forest_builder.zip
\install /root/random_forest/files_origin/forest_data_distn.zip
\install /root/random_forest/files_origin/forest_drive.zip
\install /root/random_forest/files_origin/forest_predict.zip
\install /root/random_forest/files_origin/tree_size_estimator.zip


\dF

 SELECT * FROM forest_builder(ON "iris" numTrees(2) response('"species"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species') minNodeSize(4) maxDepth(60) variance(0.0) numSurrogates(0) treeType('classification') poisson(0.36)MaxNumCategoricalValues(20)Mtry('-1')oob('true')) ;


 select * from forest_oob_predict(ON oob_observation  forest('"iris_model"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species'));

/home/beehive/clients/ncluster_loader -U db_superuser -w db_superuser -d random_forest hist_di /root/histdata.csv -c



SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('hist_train')
    OUTPUTTABLE('hist_model')
    RESPONSE('nsp')
    NUMERICINPUTS('lb','ac','fm','uc','astv','mstv','altv','mltv','dl','ds','dp','width','min','max','nzeros','mode','mean','median','variance','tendency','class')  
    MONITORTABLE('hist_monitor_table')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('6')     
    numtrees('20')
    mtry('3')
    oob('true')    
);


drop table if exists predict_result;
create table predict_result as
SELECT * FROM Forest_Predict(
    ON hist_test
    FOREST('hist_model')
    NUMERICINPUTS('lb','ac','fm','uc','astv','mstv','altv','mltv','dl','ds','dp','width','min','max','nzeros','mode','mean','median','variance','tendency','class')  
    IDCOL('id')
    Accumulate('nsp')
    detailed('false')
);
SELECT (SELECT count(id) FROM predict_result WHERE nsp <> prediction) / (SELECT count(id) FROM predict_result) as AP;


CREATE dimension TABLE hist_di (ID int, LB NUMERIC, AC NUMERIC, FM NUMERIC, UC NUMERIC, ASTV NUMERIC, MSTV NUMERIC, ALTV NUMERIC, MLTV NUMERIC, DL NUMERIC, DS NUMERIC, DP NUMERIC, Width NUMERIC, Min NUMERIC, Max NUMERIC, Nmax NUMERIC, Nzeros NUMERIC, Mode NUMERIC, Mean NUMERIC, Median NUMERIC, Variance NUMERIC, Tendency NUMERIC, Class NUMERIC, NSP varchar);

CREATE dimension TABLE hist_train_di AS
SELECT * FROM Sample (
  ON hist_di 
  SampleFraction ('0.7')
  Seed ('2'));

CREATE dimension TABLE hist_test_di AS
SELECT * FROM hist_di EXCEPT (SELECT * FROM hist_train_di); 

It is a homework style and the code tests focus on data structure, algorithm, and programming language skills. We usually ask candidates to provide at least one test case for each question. 

I will email you programming questions at 1pm. You will give me your answers within 3 hours and email back to me. During the 3 hours, I will not disturb you but you can ask me questions.




\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip
\remove forest_oob_predict_dimension.zip


\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_oob_predict.zip
\install /root/random_forest/files/forest_oob_predict_dimension.zip

SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('hist_train_di')
    OUTPUTTABLE('hist_model_di')
    RESPONSE('nsp')
    NUMERICINPUTS('lb','ac','fm','uc','astv','mstv','altv','mltv','dl','ds','dp','width','min','max','nzeros','mode','mean','median','variance','tendency','class')  
    MONITORTABLE('hist_monitor_table_di')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('6')     
    numtrees('5')
    mtry('3')
    oob('true')    
);


drop table if exists predict_result;
create table predict_result(partition key (id)) as
SELECT * FROM Forest_Predict(
    ON hist_test_di
    FOREST('hist_model_di')
    NUMERICINPUTS('lb','ac','fm','uc','astv','mstv','altv','mltv','dl','ds','dp','width','min','max','nzeros','mode','mean','median','variance','tendency','class')  
    IDCOL('id')
    Accumulate('nsp')
    detailed('false')
);
SELECT (SELECT count(id) FROM predict_result_di WHERE nsp <> prediction) / (SELECT count(id) FROM predict_result_di) as AP;




SELECT (SELECT count(prediction) FROM oob_predict_result WHERE response != prediction) / (SELECT count(prediction) FROM oob_predict_result) as AP;

"lb","ac","fm","uc","astv","mstv","altv","mltv","dl","ds","dp","width","min","max","nzeros","mode","mean","median","variance","tendency","class"




SELECT * FROM tree_size_estimator(ON "hist_train_di" numericInputs('lb','ac','fm','uc','astv','mstv','altv','mltv','dl','ds','dp','width','min','max','nzeros','mode','mean','median','variance','tendency','class') categoricalInputs('nsp'));

DROP TABLE if exists iris_train_di;
CREATE dimension TABLE iris_train_di AS SELECT * FROM iris WHERE ID%5 != 0;

CREATE dimension TABLE iris_test_di AS SELECT * FROM iris WHERE ID%5 = 0;

SELECT * FROM iris_train ORDER BY ID;

SELECT count(prediction) FROM oob_predict_result WHERE response != prediction;

select tree_num from iris_model_di where tree_num in (0,1,3);

SELECT * FROM forest_builder(ON "iris_test_di" numTrees(100) response('"species"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species') minNodeSize(3) maxDepth(6) variance(0.0) numSurrogates(0) treeType('classification') poisson(1.0)MaxNumCategoricalValues(20)Mtry('2')oob('true'))

create dimension table oob_predict_result as select * from forest_oob_predict(ON oob_observation  forest('"iris_model_di"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species'));


CREATE dimension TABLE airquality_di (ID int, ozone NUMERIC, solar integer, wind NUMERIC, temp integer, month integer, day integer);

CREATE dimension TABLE airquality_train_di AS
SELECT * FROM Sample (
  ON airquality_di 
  SampleFraction ('0.7')
  Seed ('2'));

CREATE dimension TABLE airquality_test_di AS SELECT * FROM airquality_di EXCEPT (SELECT * FROM airquality_train_di); 





\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip



\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_oob_predict.zip

SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('airquality_train_di')
    OUTPUTTABLE('airquality_model_di')
    RESPONSE('ozone')
    NUMERICINPUTS('solar','wind','temp','month','day')  
    MONITORTABLE('airquality_monitor_table_di')
    TREETYPE('regression')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('5')     
    numtrees('10')
    mtry('2')
    oob('true')    
);



SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('housing_train')
    OUTPUTTABLE('rft_model')
    RESPONSE('homestyle')
    NUMERICINPUTS('price','lotsize','bedrooms','bathrms','stories', 'garagepl') 
    CategoricalInputs('driveway','recroom','fullbase','gashw','airco','prefarea') 
    MONITORTABLE('housing_monitor_table')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('12')     
    numtrees('1')
    mtry('3')
    oob('true')    
);




select avg(CAST (response as double)) from oob_observation;

/home/xz186023/beehive/analytics/utilities/CrossValidation/src/com/asterdata/sqlmr/analytics/utilities/cv/args


/home/xz186023/beehive/analytics/predictive_modeling/coxph/src/com/asterdata/analytics/predictive_modeling/coxph/mapreduce/CoxPH_qa.json

/home/xz186023/beehive/analytics/predictive_modeling/coxph/src/com/asterdata/analytics/predictive_modeling/coxph/mapreduce/src/com/asterdata/analytics/predictive_modeling/coxph/mapreduce/CoxPH_qa.json/src/com/asterdata/analytics/predictive_modeling/coxph/mapreduce/CoxPH_qa.json

create dimension table housing_predict_result as
SELECT * FROM Forest_Predict(
    ON housing_test
    FOREST('housing_model')
    NUMERICINPUTS('lotsize', 'bedrooms', 'bathrms', 'stories', 'garagepl' )
    CATEGORICALINPUTS('driveway', 'recroom', 'fullbase', 'gashw', 'airco', 'prefarea' )
    IDCOL('sn')
    Accumulate('price')
    detailed('false')
);






\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip

\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_oob_predict.zip

SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('iris_train')
    OUTPUTTABLE('iris_model')
    RESPONSE('species')
    NUMERICINPUTS('sepal_length','sepal_width','petal_length','petal_width')  
    CategoricalInputs('species')  
    MONITORTABLE('iris_monitor_table')
    TREETYPE('classification')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('6')     
    numtrees('18')
    oob('')    
);




SELECT * FROM Forest_Drive(
    ON (SELECT 1)  PARTITION BY 1
    INPUTTABLE('boston_fact')
    OUTPUTTABLE('boston_model_fact')
    RESPONSE('medv')
    NUMERICINPUTS('crim','zn','indus','chas','nox','rm','age','dis','rad','tax','ptratio','black','lstat')      
    MONITORTABLE('boston_monitor_table_fact')
    TREETYPE('regression')
    DROPMONITORTABLE('t')
    minnodesize('2')
    maxdepth('6')     
    numtrees('36')
    oob('true')    
);


create table boston_fact (sn integer, crim numeric, zn numeric, indus numeric, chas numeric, nox numeric, rm numeric, age numeric, dis numeric,rad numeric, tax numeric,ptratio numeric, black numeric , lstat numeric, medv numeric, partition key(sn)) ;



\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip



\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_oob_predict.zip

SELECT * FROM Forest_Predict(
    ON iris
    MODELFILE('test_json.txt')
    NUMERICINPUTS('sepal_length','sepal_width','petal_length','petal_width')
    CATEGORICALINPUTS('species')
    IDCOL('id')
    Accumulate('species')
    detailed('false')
);


create table oob_predict_result (partition key (prediction)) as select * from forest_oob_predict(ON oob_observation  forest('"iris_model"') numericInputs('sepal_length','sepal_width','petal_length','petal_width') categoricalInputs('species') IDCOL('id'));

\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_oob_predict.zip



\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_oob_predict.zip
select * from forest_oob_predict(
    ON oob_observation  
    modelfile('test_json.txt') 
    numericInputs('sepal_length','sepal_width','petal_length','petal_width') 
    categoricalInputs('species'));









