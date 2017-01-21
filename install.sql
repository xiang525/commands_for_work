\remove best_splits_by_attributes.zip
\remove best_splits_by_nodes.zip
\remove partition_data.zip
\remove percentile.zip
\remove single_tree_drive.zip
\remove single_tree_predict.zip
\remove single_tree.jar
\remove approxPercentileReduce.zip
\remove approx_percentile.zip
\remove approxPercentileMap.zip




\install /root/examples/files/best_splits_by_attributes.zip
\install /root/examples/files/best_splits_by_nodes.zip
\install /root/examples/files/partition_data.zip
\install /root/examples/files/percentile.zip
\install /root/examples/files/single_tree_drive.zip
\install /root/examples/files/single_tree_predict.zip
\install /root/examples/files/single_tree.jar
\install /root/examples/files/approxPercentileReduce.zip
\install /root/examples/files/approxPercentileMap.zip
\install /root/examples/files/approx_percentile.zip

\dF



\remove forest_analyze.zip
\remove forest_builder.zip
\remove forest_data_distn.zip
\remove forest_drive.zip
\remove forest_predict.zip
\remove tree_size_estimator.zip
\remove forest_drive_lib.jar


\install /root/random_forest/files/forest_analyze.zip
\install /root/random_forest/files/forest_builder.zip
\install /root/random_forest/files/forest_data_distn.zip
\install /root/random_forest/files/forest_drive.zip
\install /root/random_forest/files/forest_predict.zip
\install /root/random_forest/files/tree_size_estimator.zip
\install /root/random_forest/files/forest_drive_lib.jar

\dF




\remove frequentpaths.zip
\remove supportcountingmap.zip
\remove supportcountingreduce.zip
\remove seqmatchingmap.zip
\remove seqsymbolization.zip
\remove seqsymbolizemap.zip
\remove seqdesymbolizeforpattern.zip
\remove prefixspanmap.zip
\remove seqitemgenmap.zip
\remove seqcompress.zip


\install /root/frequentpaths/files/frequentpaths.zip
\install /root/frequentpaths/files/supportcountingmap.zip
\install /root/frequentpaths/files/supportcountingreduce.zip
\install /root/frequentpaths/files/seqmatchingmap.zip
\install /root/frequentpaths/files/seqsymbolization.zip
\install /root/frequentpaths/files/seqsymbolizemap.zip
\install /root/frequentpaths/files/seqdesymbolizeforpattern.zip
\install /root/frequentpaths/files/prefixspanmap.zip
\install /root/frequentpaths/files/seqitemgenmap.zip
\install /root/frequentpaths/files/seqcompress.zip


\dF

\install /root/frequentpaths/files600/frequentpaths.zip
\install /root/frequentpaths/files600/supportcountingmap.zip
\install /root/frequentpaths/files600/supportcountingreduce.zip
\install /root/frequentpaths/files600/seqmatchingmap.zip
\install /root/frequentpaths/files600/seqsymbolization.zip
\install /root/frequentpaths/files600/seqsymbolizemap.zip
\install /root/frequentpaths/files600/seqdesymbolizeforpattern.zip
\install /root/frequentpaths/files600/prefixspanmap.zip
\install /root/frequentpaths/files600/seqitemgenmap.zip
\install /root/frequentpaths/files600/seqcompress.zip


\dF





\remove GmmFit.zip
\remove GmmMap.zip
\remove GmmPredict.zip
\remove GmmProfile.zip



\install /root/gmm/files/GmmFit.zip
\install /root/gmm/files/GmmMap.zip
\install /root/gmm/files/GmmPredict.zip
\install /root/gmm/files/GmmProfile.zip
\install /root/gmm/files/sample.zip


\dF



drop table if exists gmm_output_ex11;
SELECT * FROM gmmfit(            
ON (SELECT 1) AS init_params PARTITION BY 1
InputTable ('test.gmm_iris_train')
OutputTable ('test.gmm_output_ex11')
ClusterNum (3)
CovarianceType ('spherical')
MaxIterNum (10)
PackOutput (1)
);

select * from "supportcountingmap" (on (select 'foo' ) partition by 1 testmemory ('true') ) as "supportcountingmap" ;

Hi, 

I tried to reproduce the same problem mentioned above with the supplied dataset but cannot reproduce it with virtual machine or a real cluster. 
When debuging the codes line by line, I also didn't get any problem with line 82 in supportcountingmap.java where the crash happened in the above error message.
Could someone provide more detailed information about whether the input dataset was preprocessed (e.g., format changes) and how to do that?
Does this issue appear only when the dataset has 100,000 lines? How about sampling 50,000 or 80,000 lines from the dataset?

Thanks, 

-Xiang (Emily)


create dimension table "__temp_table_for_gmmfit__test.gmm_output_ex1" ( "cluster_id" integer, "points_assigned" integer, "covariance_type" character varying, "weight" double precision, "mean" character varying, "covariance" character varying, "log_determinant" double precision, "prec" character varying) storage row compress none ;

1) Create schema test and create input table in schema test

create schema test ;

CREATE fact TABLE test.gmm_iris_train (
id   integer,
sepal_length float,
sepal_width float,
petal_length  float,
petal_width   float ) distribute by hash(id);

insert into test.gmm_iris_train values 
( 1, 5.1, 3.5, 1.4, 0.2 ), 
( 2, 4.9, 3, 1.4, 0.2 ), 
( 3, 4.7, 3.2, 1.3, 0.2 ),
( 4, 4.6, 3.1, 1.5, 0.2 ),
( 5, 5, 3.6, 1.4, 0.2 ),
( 6, 5.4, 3.9, 1.7, 0.4 ),
( 7, 4.6, 3.4, 1.4, 0.3 ),
( 8, 5, 3.4, 1.5, 0.2 ),
( 9, 4.4, 2.9, 1.4, 0.2 ),
( 10, 4.9, 3.1, 1.5, 0.1 );


2) Create user usr1 and grant execute on GmmFit and GmmMap function as well as necessary rights for schema test

CREATE USER usr1 PASSWORD 'usr1';
GRANT EXECUTE ON FUNCTION gmmfit TO usr1;
GRANT EXECUTE ON FUNCTION gmmmap TO usr1;
GRANT SELECT on test.gmm_iris_train to usr1; 
grant usage on schema test to usr1 ;
grant create on schema test to usr1 ;


3) Execute GmmFit as usr1 with input/output table in test schema

SELECT * FROM gmmfit(            
ON (SELECT 1) AS init_params PARTITION BY 1
InputTable ('test.gmm_iris_train')
OutputTable ('test.gmm_output_ex1')
ClusterNum (3)
CovarianceType ('spherical')
MaxIterNum (10)
PackOutput (1)
);


// add these two lines to solve the problem of using schema
      // when using schema, the temp tale name is alter. So it is impossible to
      // find the temp table.
      // replaceing "." with "_" can solve this problem.
      if(this.outputTable.contains(".")){
         this.outputTable = this.outputTable.replace(".","_");
      }


create table "r_wj186001_14939_1484946974316954_3".r_wj186001_t__aa_gmm1n1484947038379837 as SELECT * from "gmm_iris_train"; 

create table "r_wj186001_14939_1484946974316954_3".input_table as select * from "gmm_iris_train"; 


SELECT * FROM GMMFit ( ON "gmm_init" as init_params PARTITION BY 1 OutputTable('"r_wj186001_14939_1484946974316954_3".r_wj186001_t_aa_gmm0_1484947038378213') InputTable('"r_wj186001_14939_1484946974316954_3".input_table') ClusterNum('3') CovarianceType('spherical') MaxIterNum('10') PackOutput('TRUE') ) ;


insert into "##tempseq_output_1484775202066" select * from PREFIXSPANMAP(on "##tempseq_prefixspan_seed1484775202066" as prefix PARTITION BY ANY on (select sequence from "##temp_seqcompress_8715426874023772470") as sequence DIMENSION PREFIXCOLUMN('prefix') SUPPORTCOLUMN('support') SIZECOLUMN('size') SEQUENCECOLUMN('sequence') RUNLEVEL('-1') MAXLENGTH('2147483647') THRESHOLD('285') CLOSEDPATTERN('false'));


SELECT * FROM GMMFit ( ON "gmm_init" as init_params PARTITION BY 1  OutputTable('myoutput12') InputTable('gmm_iris_train') ClusterNum('3') CovarianceType('spherical') MaxIterNum('10') PackOutput('TRUE') ) ;
