



drop table if exists singletree_predict2 ;
         
create table singletree_predict2 distribute by hash(pid) as

SELECT * FROM single_tree_predict (
ON iris_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON iris_attribute_output_merged as model_table DIMENSION  
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
OutputResponseProbDist('true','3')
Accumulate('actual_label') 
) ORDER BY pid;


drop table if exists singletree_predict_temp;
         
create table singletree_predict_temp distribute by hash(pid) as

SELECT * FROM single_tree_predict (
ON iris_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON tmp_output_junit as model_table DIMENSION  
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
OutputResponseProbDist('true','3')
OutputMajorityProbability('true')
) ORDER BY pid;







drop table if exists iris_model_junit ;
drop table if exists splits_small_junit;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('iris_attribute_train')
OutputTable('iris_model_junit')
IntermediateSplitsTable('splits_small_junit')
responsetablename('iris_response_train')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('5')
ApproxSplits('false')
OutputResponseProbDist('true')
ResponseProbDistType('laplace')
);



select * from iris_model_junit;

drop table if exists singletree_predict ;
         
create table singletree_predict distribute by hash(pid) as



SELECT * FROM single_tree_predict (
ON iris_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON iris_model_junit as model_table DIMENSION  
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
OutputResponseProbDist('true','3')
Accumulate('actual_label') 
) ORDER BY pid;





drop table if exists iris_attribute_output_merged;
drop table if exists splits_small_merged;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('iris_attribute_train')
OutputTable('iris_attribute_output_merged')
IntermediateSplitsTable('splits_small_merged')
responsetablename('iris_response_train')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('5')
ApproxSplits('false')
OutputResponseProbDist('true')
ResponseProbDistType('laplace')
);



select node_id,  left_label, left_label_probdist, prob_label_order,  right_label, right_label_probdist, prob_label_order_right from iris_attribute_output_junit;

 create dimension table "iris_attribute_output_junit" (node_id bigint, node_size bigint,"node_gini(p)" double,"node_entropy" double,"node_chisq_pv" double, node_label varchar,node_majorvotes bigint, split_value double , "split_gini(p)" double,"split_entropy" double,"split_chisq_pv" double, left_id bigint, left_size bigint, left_label varchar, left_majorvotes bigint, right_id bigint, right_size bigint, right_label  varchar, right_majorvotes bigint, left_bucket  varchar, right_bucket  varchar, left_label_probdist  varchar, right_label_probdist  varchar, prob_label_order  varchar, "attribute" varchar);






create dimension table "_temp_response_table_09_29_2016iris_attribute_output" as select 0::bigint as node_id, * from "iris_response_train" ;



select left_label, left_label_probdist, prob_label_order, right_label, right_label_probdist, prob_label_order_right from iris_attribute_output_diff;


select left_label, left_label_probdist, prob_label_order, right_label, right_label_probdist, prob_label_order_right from iris_attribute_output_test4;


select left_label, left_label_probdist, left_majorvotes, prob_label_order, right_label, right_label_probdist, prob_label_order_right, right_majorvotes from iris_attribute_output_junit;



select * from best_splits_by_nodes(on "_best_splits_by_attributes_09_16_2016iris_attribute_output_2" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp table "_best_splits_by_attributes_09_16_2016iris_attribute_output_2"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_09_16_2016 as attribute_table PARTITION BY "attribute" on "splits_small_2" as sample_splits PARTITION BY "attribute" on "_temp_response_table_09_16_2016iris_attribute_output_2" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('10')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
analyze "_best_splits_by_attributes_09_16_2016iris_attribute_output_2";



select * from best_splits_by_nodes(  on "_best_splits_by_attributes_09_16_2016iris_attribute_output_2" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp table "_best_splits_by_attributes_09_16_2016iris_attribute_output_2"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_09_16_2016 as attribute_table PARTITION BY "attribute" on "splits_small_2" as sample_splits PARTITION BY "attribute" on "_temp_response_table_09_16_2016iris_attribute_output_2" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('10')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));


# create a table

create table "housing_train" (sn Integer, price bigint, lotsize bigint, bedrooms Integer, bathrms Integer, stories Integer, driveway varchar, recroom varchar, fullbase varchar, gashw varchar, arico varchar, prefarea Integer, garagepl varchar, homestyle varchar) distribute by hash (sn);

# import a table into database
cat /root/adaboost/housing/housing_train.csv | /home/beehive/clients/act -h 10.80.163.170 -c 'copy  housing_train (sn, price, lotsize, bedrooms, bathrms, stories, driveway, recroom, fullbase, gashw, arico, prefarea, garagepl, homestyle) FROM STDIN CSV;' -U db_superuser -w db_superuser









SELECT * FROM adaboost_drive(
ON (SELECT 1) PARTITION BY 1 
AttributeTable('glass_attribute_table') 
ResponseTable('iris_attribute_output_ada') 
OutputTable('glass_output_table') 
IdColumns('pid') 
AttributeNameColumns('attribute') 
AttributeValueColumn('attrvalue') 
ResponseColumn('response') 
ApproxSplits('false') 
iterNum(5) 
NumSplits(10) 
maxDepth(3) 
MinNodeSize(5) 
dropOutputTable('true'));





SELECT * FROM adaboost_drive(
ON (SELECT 1) PARTITION BY 1 
AttributeTable('iris_attribute_train') 
ResponseTable('iris_response_train') 
OutputTable('iris_attribute_output_adaboost_test') 
IdColumns('pid') 
AttributeNameColumns('attribute') 
AttributeValueColumn('attrvalue') 
ResponseColumn('response') 
ApproxSplits('false') 
iterNum(5) 
NumSplits(10) 
maxDepth(3) 
MinNodeSize(5) 
dropOutputTable('true')
OutputResponseProbDist('true')
ResponseProbDistType('laplace')
);








drop table if exists adaboost_predict ;
         
create table adaboost_predict distribute by hash(pid) as

select * from adaboost_predict(
on iris_attribute_test as attributetable partition by pid
on  iris_attribute_output_adaboost_test as modeltable dimension
attrtablegroupbycolumns('attribute')
attrtablepidcolumns('pid')
attrtablevalcolumn('attrvalue')
OutputResponseProbDist ('true','')
Accumulate('actual_label') 
)
order by pid;

********************************************************************************************************************

create dimension table "_temp_response_table_11_05_2016iris_attribute_output_junit" as select 0::bigint as node_id, * from "iris_response_train";
create dimension table "iris_attribute_output_junit" (node_id bigint, node_size bigint,"node_gini(p)" double,"node_entropy" double,"node_chisq_pv" double, node_label varchar,node_majorvotes bigint, split_value double , "split_gini(p)" double,"split_entropy" double,"split_chisq_pv" double, left_id bigint, left_size bigint, left_label varchar, left_majorvotes bigint, right_id bigint, right_size bigint, right_label  varchar, right_majorvotes bigint, left_bucket  varchar, right_bucket  varchar, left_label_probdist  varchar, right_label_probdist  varchar, prob_label_order  varchar, prob_label_order_right  varchar, "attribute" varchar);
create dimension table _numeric_attribute_table_11_05_2016 as (select "pid","attribute",cast("attrvalue" as double precision) as "attrvalue" from "iris_attribute_train");
create fact table "splits_small_junit" (partition key("attribute")) as select * from percentile( on _numeric_attribute_table_11_05_2016 PARTITION BY "attribute" TARGET_COLUMNS('"attrvalue"')GROUP_COLUMNS('"attribute"')PERCENTILE('33.333333333333336','66.66666666666667','100.0'));

create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;


create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;


create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;


create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));

create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;


create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;


create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;


create table "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_05_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create table "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_05_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create dimension table "b__temp_response_table_11_05_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_05_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_05_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_05_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;


drop table _temp_response_table_11_05_2016iris_attribute_output_junit;
alter table b__temp_response_table_11_05_2016iris_attribute_output_junit rename to _temp_response_table_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_attributes_11_05_2016iris_attribute_output_junit;
drop table _best_splits_by_nodes_11_05_2016iris_attribute_output_junit;





SELECT * FROM Forest_Drive (
  ON (SELECT 1)
  PARTITION BY 1
  InputTable ('housing_train ')
  OutputTable ('rft_model')
  TreeType ('classification')
  ResponseColumn ('homestyle')
  NumericInputs ('price ', 'lotsize ', 'bedrooms ', 'bathrms ','stories ', 'garagepl')
  CategoricalInputs ('driveway ', 'recroom ', 'fullbase ', 'gashw ','airco ', 'prefarea')
  MaxDepth (12)
  MinNodeSize (1)
  NumTrees (50)
  Variance (0.0)
  Mtry ('3')
  MtrySeed ('100')
  Seed ('100')
);



select count(distinct "response", "pid", 0::bigint as node_id) from iris_altinput;

select count(distinct "response") as num_class from iris_altinput;




**********************************************************************************************************************

create dimension table "_temp_response_table_11_22_2016iris_attribute_output_junit" as select 0::bigint as node_id, * from "iris_response_train"
create dimension table "iris_attribute_output_junit" (node_id bigint, node_size bigint,"node_gini(p)" double,"node_entropy" double,"node_chisq_pv" double, node_label varchar,node_majorvotes bigint, split_value double , "split_gini(p)" double,"split_entropy" double,"split_chisq_pv" double, left_id bigint, left_size bigint, left_label varchar, left_majorvotes bigint, right_id bigint, right_size bigint, right_label  varchar, right_majorvotes bigint, left_bucket  varchar, right_bucket  varchar, left_label_probdist  varchar, right_label_probdist  varchar, prob_label_order  varchar, "attribute" varchar)
create temp dimension table _numeric_attribute_table_11_22_2016 as (select "pid","attribute",cast("attrvalue" as double precision) as "attrvalue" from "iris_attribute_train");
create fact table "splits_small_junit" (partition key("attribute")) as select * from percentile( on _numeric_attribute_table_11_22_2016 PARTITION BY "attribute" TARGET_COLUMNS('"attrvalue"')GROUP_COLUMNS('"attribute"')PERCENTILE('50.0','100.0'))
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
create temp table "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_attributes(  on _numeric_attribute_table_11_22_2016 as attribute_table PARTITION BY "attribute" on "splits_small_junit" as sample_splits PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table  DIMENSION order by "response" IMPURITY('GINI')MINSPLITSIZE('5')AttrTable_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')SplitsTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')NumResponseLabels('3')ResponseProbDistType('Laplace'));
create temp table "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit"( PARTITION KEY( node_id )) as select * from best_splits_by_nodes(  on "_best_splits_by_attributes_11_22_2016iris_attribute_output_junit" as "_bestsplits_node+attribute" PARTITION BY node_id ORDER BY "attribute"OutputResponseLabelProbDist ('1'));
create temp dimension table "b__temp_response_table_11_22_2016iris_attribute_output_junit" as select * from partition_data(  on _numeric_attribute_table_11_22_2016 as  attribute_table PARTITION BY "attribute" on "_temp_response_table_11_22_2016iris_attribute_output_junit" as response_table DIMENSION   on "_best_splits_by_nodes_11_22_2016iris_attribute_output_junit" as  nodesplits PARTITION BY "attribute"Attribute_GroupbyColumns('attribute')AttrTable_valColumn('attrvalue')AttrTable_pidColumns('pid')ResponseTable_pidColumns('pid')ResponseTable_nodeColumn('node_id')ResponseTable_responseColumn('response')) order by node_id;
drop table _temp_response_table_11_22_2016iris_attribute_output_junit
alter table b__temp_response_table_11_22_2016iris_attribute_output_junit rename to _temp_response_table_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_attributes_11_22_2016iris_attribute_output_junit
drop table _best_splits_by_nodes_11_22_2016iris_attribute_output_junit
Input tables:"iris_attribute_train", "iris_response_train",
Output model table: "iris_attribute_output_junit",
Depth of the tree is:7,





 ncluster_export -U db_superuser -w db_superuser -d multiclass -c _temp_response_table_11_22_2016iris_attribute_output_junit temp_response.csv



drop table if exists rf_model;
SELECT * FROM Forest_Drive (
  ON (SELECT 1)
  PARTITION BY 1
  InputTable ('iris_train ')
  OutputTable ('rft_model')
  TreeType ('classification')
  ResponseColumn ('y_specis')
  NumericInputs ('iris_slen ', 'iris_swidth ', 'iris_plen ', 'iris_pwidth ')
  MaxDepth (10)
  MinNodeSize (3)
  NumTrees (50)
  Variance (0.0)
  Mtry ('3')
  MtrySeed ('100')
  Seed ('100')
);



SELECT variable, SUM(importance)/50
  FROM Forest_Analyze (ON rft_model)
  GROUP BY variable
  ORDER BY 2 DESC;




drop table if exists rf_iris_predict;
CREATE TABLE rf_iris_predict DISTRIBUTE BY hash (id) AS
SELECT * FROM Forest_Predict (
  ON iris_test
  Forest ('rft_model')
  NumericInputs ('iris_slen ', 'iris_swidth ', 'iris_plen ', 'iris_pwidth ')  
  IdColumn ('id')
  Accumulate ('y_specis')
  Detailed ('false')
);




SELECT variable, SUM(importance)/50
  FROM Forest_Analyze (ON rft_model)
  GROUP BY variable
  ORDER BY 2 DESC;


 SELECT task_index, tree_num, variable, level, cnt
  FROM Forest_Analyze (ON rft_model)
  ORDER BY 1;




drop table if exists glass_model ;
drop table if exists splits_glass;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('glass_attribute_train')
OutputTable('glass_model')
IntermediateSplitsTable('splits_glass')
responsetablename('simple_glass_response_table')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('5')
ApproxSplits('false')
OutputResponseProbDist('true')
ResponseProbDistType('laplace'));




drop table if exists glass_model2 ;
drop table if exists splits_glass2;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('glass_attribute_table')
OutputTable('glass_model2')
IntermediateSplitsTable('splits_glass2')
responsetablename('glass_wresponse_table')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('5')
ApproxSplits('false')
OutputResponseProbDist('true')
ResponseProbDistType('laplace'));


drop table if exists singletree_predict ;         
create table singletree_predict distribute by hash(pid) as

SELECT * from  single_tree_predict (
ON glass_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON glass_model2 as model_table DIMENSION 
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
OutputResponseprobdist('true', 'glass_model2')
 
) ORDER BY pid;


drop table if exists singletree_predict ;         
create table singletree_predict distribute by hash(pid) as

SELECT * from  single_tree_predict (
ON glass_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON glass_attribute_output_s as model_table DIMENSION 
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
OutputResponseprobdist('true', 'glass_attribute_output_s')
accumulate('actual_label') 
) ORDER BY pid;



drop table if exists singletree_predict;
create table singletree_predict distribute by hash(pid) as

SELECT * from  single_tree_predict (
ON iris_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON iris_model_cat as model_table DIMENSION 
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
OutputResponseprobdist('true', 'iris_model_cat')
) ORDER BY pid;


update iris_response_train set response = 'setosa' where response = 1;




drop table if exists iris_model_cat ;
drop table if exists splits_iris_cat;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('iris_attribute_train')
OutputTable('iris_model_cat')
IntermediateSplitsTable('splits_iris_cat')
responsetablename('iris_response_train')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('5')
ApproxSplits('false')
OutputResponseProbDist('true')
ResponseProbDistType('laplace'));

select left_label,left_label_probdist,right_label,right_label_probdist,prob_label_order from iris_model_cat;




drop table 





ncluster_export -U db_superuser -w db_superuser -d beehive -c iris_response_train iris_response_train.csv


uniClassQuery = "select distinct "
                  + responseColumnName_.getColumnNameWithQuotes()
                  // + Util.customConcatenate(idColumnNames_, "\"", ",")
                  + " from " + responseTableNameParser_.getFullName() + ";";





drop table if exists glass_attribute_output_s ;
drop table if exists splits_small_s ;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('glass_attribute_table')
OutputTable('glass_attribute_output_s')
IntermediateSplitsTable('splits_small_s')
responsetablename('glass_wresponse_table')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('10')
ApproxSplits('true')
OutputResponseProbDist('true')
ResponseProbDistType('laplace')
);



SELECT * from  single_tree_predict (
ON glass_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON glass_attribute_output_s as model_table DIMENSION 
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue') 
Accumulate('actual_label') 
OutputResponseProbDist('true','glass_attribute_output_s')
) ORDER BY pid;


SELECT * from  single_tree_predict (
ON glass_attribute_test AS attribute_table PARTITION BY pid
ORDER BY attribute
ON glass_attribute_output_s as model_table DIMENSION
AttrTable_GroupbyColumns ('attribute')
AttrTable_pidColumns ('pid')
AttrTable_valColumn ('attrvalue')
OutputResponseProbDist('true','glass_attribute_output_s')
) ORDER BY pid;


drop table if exists glass_output_table_lap;

SELECT * FROM adaboost_drive(ON (SELECT 1) PARTITION BY 1 
AttributeTable('glass_attribute_table') 
ResponseTable('glass_response_table') 
OutputTable('glass_output_table_lap') 
IdColumns('pid') 
AttributeNameColumns('attribute') 
AttributeValueColumn('attrvalue') 
ResponseColumn('response') 
ApproxSplits('false') 
iterNum(5) 
NumSplits(10) 
maxDepth(3) 
MinNodeSize(5) 
OutputResponseProbDist('true')

dropOutputTable('true'));


drop table if exists model_rawcount;

SELECT * FROM adaboost_drive(ON (SELECT 1) PARTITION BY 1 
AttributeTable('iris_attribute_train') 
ResponseTable('iris_response_train') 
OutputTable('model_rawcount') 
IdColumns('pid') 
AttributeNameColumns('attribute') 
AttributeValueColumn('attrvalue') 
ResponseColumn('response') 
ApproxSplits('false') 
iterNum(5) 
NumSplits(10) 
maxDepth(3) 
MinNodeSize(5) 
OutputResponseProbDist('true')
dropOutputTable('true'));


drop table if exists adaboost_predict ;
         
create table adaboost_predict distribute by hash(pid) as
select * from adaboost_predict(
on glass_attribute_test as attributetable partition by pid
on  glass_output_table as modeltable dimension
attrtablegroupbycolumns('attribute')
attrtablepidcolumns('pid')
attrtablevalcolumn('attrvalue')
OutputResponseProbDist ('true','glass_output_table')
Accumulate('actual_label') 
)
order by pid;



select * from approxPercentileReduce( on ( select * from approxPercentileMap( on _numeric_attribute_table_12_01_2016 TARGET_COLUMN('"attrvalue"')ERROR('33.333333333333336')GROUP_COLUMNS('"attribute"')) )PARTITION BY "attribute" PERCENTILE('33.333333333333336','66.66666666666667','100.0')GROUP_COLUMNS('"attribute"'));


SELECT * from  adaboost_predict (
ON glass_attribute_test AS attributetable PARTITION BY pid
ON glass_ada_attribute_output as modeltable DIMENSION 
AttrTableGroupbyColumns ('attribute')
AttrTablepidColumns ('pid')
AttrTablevalColumn ('attrvalue') 
OutputResponseprobdist('f','gg')

) ORDER BY pid;



approxPercentileMap.zip
approxPercentileReduce.zip
approx_percentile_summary.zip
approx_percentile.zip



select * from approxPercentileMap( on _numeric_attribute_table_12_02_2016 TARGET_COLUMN('"attrvalue"')ERROR('33.333333333333336')GROUP_COLUMNS('"attribute"')) ;


create  



	dimension table _numeric_attribute_table_12_02_2016 as (select "pid","attribute",cast("attrvalue" as double precision) as "attrvalue" from
 "glass_attribute_table");

select "pid","attribute",cast("attrvalue" as double precision) as "attrvalue" from  "glass_attribute_table";

create dimension table _numeric_attribute_table_12_02_2017 as (select "pid","attribute",cast("attrvalue" as double precision) as "attrvalue" from "glass_attribute_table" where "attrvalue" is not NULL;



drop table if exists glass_attribute_output_1s ;
drop table if exists splits_small_1s ;
select * from single_tree_drive(
on (select 1) partition by 1 attributetablename('glass_attribute_table')
OutputTable('glass_attribute_output_1s')
IntermediateSplitsTable('splits_small_1s')
responsetablename('glass_wresponse_table')
numsplits('3')
SplitMeasure('gini')
max_depth('10')
idcolumns('pid')
attributenamecolumns('attribute')
attributevaluecolumn('attrvalue')
responsecolumn('response')
minnodesize('10')
ApproxSplits('false')
OutputresponseprobDist('tRue')
ResponseprobDisttype('laPlace'));



diff ~/beehive/test/vm_test_predictive_modeling/single_decision_tree/expectedQueryResults/SDT_AA621_SparseInput_run.results.queryResults ~/beehive/build/testoutput/vm_test_predictive_modeling/single_decision_tree_test/single_decision_tree_test/bhDone/single_tree_drive.results.queryResults


drop table if exists glm_lrtest1, glm_lrtest2;
SELECT * FROM GLM (ON (SELECT 1) PARTITION BY 1
inputTable('glm_salary') 
outputTable('glm_lrtest1') 
columnNames('yr','yd', 'sl') 
family('LOGISTIC') 
link('CANONICAL') 
weight('60') 
threshold('0.01') 
maxIterNum('10'));


SELECT * FROM Forest_Drive ( ON (SELECT 1)
PARTITION BY 1
InputTable ('train_1m')
OutputTable ('rf_train_10m_model')
ResponseColumn ('dep_delayed_15min')
NumericInputs ('Deptime' , 'Distance')
CategoricalInputs ('Month','DayOfWeek','UniqueCarrier')
TreeType ('classification') 
NumTrees ('50')
Mtry ('3')
MtrySeed ('100')
Seed ('100')
);


./ncluster_loader --username db_superuser --password db_superuser -h 10.80.163.170 -d random_forest -D ',' --verbose --csv train   ./data/train.csv;


SELECT * FROM Forest_Drive ( ON (SELECT 1)
PARTITION BY 1
InputTable ('train_1m')
OutputTable ('rf_train_10m_model')
ResponseColumn ('dep_delayed_15min')
NumericInputs ('Deptime' , 'Distance')
CategoricalInputs ('Month','DayOfWeek','UniqueCarrier')
TreeType ('classification') 
NumTrees ('50')
MtrySeed ('100')
Seed ('100')
);







