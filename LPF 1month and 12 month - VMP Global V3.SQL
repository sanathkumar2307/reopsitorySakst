use vpdc

drop table if exists tempdb..#temp1Months
select * into tempdb..#temp1Months
from
pa.LPF_V903MW_1months_VMP_global

drop table if exists tempdb..#temp12Months
select * into tempdb..#temp12Months
from
pa.LPF_V903MW_12months_VMP_Global 


select 
replace(replace(lpf6.Error_Category, char(10), ''), char(13), '') as Error_Category
,coalesce(lpf6.Shortunittype,lpf1.Shortunittype) as [ShortUnitType]
--, concat(lpf6.Error_Category,' (',lpf6.WTGs_Affected,',',lpf1.WTGs_Affected,')') as [Error_Category(WTGs_Affected-6,1)]
, coalesce(lpf6.LPF_CombinedNumerator_FinalCategory,lpf1.LPF_CombinedNumerator_FinalCategory) as [Category_Vestas/Non-Vestas]
, format(lpf6.LPF_12months,'P') as [LPF_12months]
,lpf6.WTGs_Affected as [WTGsAffected_6Months]
, format(lpf1.LPF_1months,'P') as [LPF_1month]
,lpf1.WTGs_Affected as [WTGsAffected_1Months]
,Case when lpf6.[Error_Category] in ('151 High temp. Gen bearing _:___°C','546 High watertemp.gen.:____°C','713 RT,NotReady Hi.Rot.Cu. _:____A','715 RT,NotReady Rot.HW.Err._:____A','333 High cur.rotor inv. L_:____A') then 'Work Started'
when lpf6.[Error_Category] in ('Work in Turbine','Park Wide Outage / Remote Pause / Grid and Ambient Errors','Scheduled Service','Hydraulic System leakage','602/603/604 Low Press pitchblock A/B/C','Yaw Systems') then 'Root Cause Known' 
else 'Not Started' end as WorkingStatus
from #temp12Months lpf6
left join #temp1Months lpf1 on lpf1.Error_Category = lpf6.Error_Category and replace(lpf1.LPF_CombinedNumerator_FinalCategory,'_1months','') = replace(lpf6.LPF_CombinedNumerator_FinalCategory,'_6months','')