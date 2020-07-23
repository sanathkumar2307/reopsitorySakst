use vpdc

drop table if exists tempdb..#temp1Months
select * into tempdb..#temp1Months
from
pa.LPF_V903MW_1months_VMP_global

drop table if exists tempdb..#temp12Months
select * into tempdb..#temp12Months
from
pa.LPF_V903MW_12months_VMP_Global 
