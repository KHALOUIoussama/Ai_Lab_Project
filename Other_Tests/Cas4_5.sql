with MH as (
    SELECT
        [Result].result_id,
        [Batch].[identifier] as Palette,
        [Sample].[user13] as [Echantillon],
        (xvalue * 8.850732) as MH_value, --On multiplie par le Scale de la table Unit avec unit_id = '27317679-9CC8-4814-A935-E29605A239A4'
        SUM(CAST(xvalue * 8.850732 as float)) over (partition by [Enterprise].[dbo].[Batch].order_id) as sum_commande,
        Count(Cast(xvalue * 8.850732 as float)) over (partition by [Enterprise].[dbo].[Batch].order_id) as count_commande

    FROM [Enterprise].[dbo].[Result] WITH (NOLOCK)
             JOIN [Enterprise].[dbo].[Sample] WITH (NOLOCK) ON Sample.sample_id = Result.sample_id
             JOIN [Enterprise].[dbo].[ResultData] WITH (NOLOCK) ON ResultData.result_id = Result.result_id
             JOIN [Batch] WITH (NOLOCK) ON [Batch].batch_id = [Sample].[batch_id]

    where test_id = '83D8EF2E-C8BD-11E7-9EDD-CC3D82AA3DA8' --test MDR
      AND ResultData.variable_id = '7EC5AD18-440F-4871-A3F8-52EE5C3C2D92' -- filter on MH
      and [Result].status_symbol != 'I' -- remove ignored results
      and [Sample].order_id IN (Select order_id from xOrder WITH (NOLOCK) where identifier = '@OrderNo') --filter by Order
),
     MH_avg as(
         select result_id,
                Palette,
                Echantillon,
                MH_value,
                (sum_commande-MH_value)/NULLIF((count_commande-1), 0) as avg_Order
         from MH
         where count_commande>1),
     MH_status as (select  result_id,
                           Palette,
                           Echantillon,
                           MH_value,
                           Case when MH_value > (3*avg_Order)/2 then 'MH en haut de 50% du MH moyen'
                                when MH_value < avg_Order/2 then 'MH en bas de 50% du MH moyen'
                                else 'skip'
                               end  as variable_status
                   from MH_avg),
     ML as (SELECT
                [Result].result_id,
                [Batch].[identifier] as Palette,
                [Sample].[user13] as [Echantillon],
                (xvalue * 8.850732) as ML_value, --On multiplie par le Scale de la table Unit avec unit_id = '27317679-9CC8-4814-A935-E29605A239A4'
                MIN(CAST(xvalue * 8.850732 as float)) over ( partition by [Enterprise].[dbo].[Batch].order_id) as min_commande,
                MAX(Cast(xvalue * 8.850732 as float)) over ( partition by [Enterprise].[dbo].[Batch].order_id) as max_commande

            FROM [Enterprise].[dbo].[Result] WITH (NOLOCK)
                     JOIN [Enterprise].[dbo].[Sample] WITH (NOLOCK) ON Sample.sample_id = Result.sample_id
                     JOIN [Enterprise].[dbo].[ResultData] WITH (NOLOCK) ON ResultData.result_id = Result.result_id
                     JOIN [Batch] WITH (NOLOCK) ON [Batch].batch_id = [Sample].[batch_id]

            where test_id = '83D8EF2E-C8BD-11E7-9EDD-CC3D82AA3DA8' --test MDR
              AND ResultData.variable_id = '524A3163-EBC8-462C-A723-FEA150D5F785' -- filter on ML
              and [Result].status_symbol != 'I' -- remove ignored results
              and [Sample].order_id IN (Select order_id from xOrder WITH (NOLOCK) where identifier = '@OrderNo') --filter by Order
     ),
     extreme_MLs as (
         select distinct result_id
         from ML
         where ML_value = min_commande or ML_value = max_commande)
select MH_status.Palette,
       MH_status.Echantillon,
       case
           when MH_status.result_id in (SELECT result_id FROM extreme_MLs) then 'OUI'
           else 'NON'
           end as ML_different_des_autres,
       case
           when MH_value = ML_value then 'OUI'
           else 'NON'
           end as [MH=ML]
from MH_status JOIN ML on MH_status.result_id = ML.result_id
where variable_status != 'skip'