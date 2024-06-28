-- Declare the variables
DECLARE @ResultCurveId uniqueidentifier

-- Create a temporary table to store the results
CREATE TABLE #ResultsTable (ResultCurve_id varchar(50), n int, xtime float , xvalue float)

SELECT distinct resultcurve_id, OrderNo, Batch, unique_code as Sample_Code
INTO #Resultcurve_id_table
FROM ResultCurve
         JOIN vwResultDetail on ResultCurve.result_id = vwResultDetail.result_id
WHERE ResultCurve.variable_id = '8AE2CDE9-0986-47A7-8DC1-F9C56AD2C87B' --selectionner les courbes Torque
  and ResultCurve.result_id IN ()

-- Declare the cursor
DECLARE cur CURSOR FOR
    SELECT resultcurve_id FROM #Resultcurve_id_table

-- Open the cursor
OPEN cur

-- Fetch the first row
FETCH NEXT FROM cur INTO @ResultCurveId

-- Loop through the rows
WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Execute the stored procedure for each ResultCurveId and insert the result into the temporary table
        INSERT INTO #ResultsTable
            EXEC dbo.CurveData @ResultCurveId

        -- Fetch the next row
        FETCH NEXT FROM cur INTO @ResultCurveId
    END

-- Close and deallocate the cursor
CLOSE cur
DEALLOCATE cur;

-- Tables des ResultCurve_id de la commande
WITH T AS (
    SELECT Rit.OrderNo, #ResultsTable.ResultCurve_id, n, (xtime/60) AS xtime, (xvalue*10) AS xvalue, Batch, Sample_Code
    FROM #ResultsTable
             JOIN #Resultcurve_id_table Rit ON #ResultsTable.ResultCurve_id = Rit.resultcurve_id
    WHERE n != 0
),
     SlopeTable AS (
         SELECT T.OrderNo, T.Batch, T.Sample_Code, T.xtime, T.xvalue, (T.xvalue - T2.xvalue)/(T.xtime - T2.xtime) AS slope
         FROM T, T AS T2
         WHERE T.ResultCurve_id = T2.ResultCurve_id AND T.n = T2.n + 1 AND T.xtime > 0.4 AND T.xtime < 0.8 and (T.xtime - T2.xtime) != 0
     ),
     MaxSlopeSample AS (
         SELECT Sample_Code, MAX(slope) AS max_slope
         FROM SlopeTable
         GROUP BY Sample_Code
     ),
     TimeMaxSlopeSample AS (
         SELECT MaxSlopeSample.Sample_Code, xtime
         FROM MaxSlopeSample LEFT JOIN SlopeTable ON SlopeTable.Sample_Code = MaxSlopeSample.Sample_Code AND SlopeTable.slope = MaxSlopeSample.max_slope),
     MaxSlopeBatch AS (
         SELECT Batch, AVG(TimeMaxSlopeSample.xtime) AS avg_time_max_slopes
         FROM TimeMaxSlopeSample LEFT JOIN SlopeTable on TimeMaxSlopeSample.Sample_Code = SlopeTable.Sample_Code
         GROUP BY Batch
     ),
     STD_Sample AS (
         SELECT ST.OrderNo, Round(STDEV(MS.xtime)*1000,2) as std_dev_sample
         FROM TimeMaxSlopeSample MS
                  LEFT JOIN SlopeTable ST ON ST.Sample_Code = MS.Sample_Code
         group by ST.OrderNo),
     STD_Batch AS (
         SELECT OrderNo, ROUND((STDEV(avg_time_max_slopes)*1000), 2) AS std_dev_batch
         FROM MaxSlopeBatch MB
                  LEFT JOIN (select distinct Batch, OrderNo from SlopeTable) ST ON ST.Batch = MB.Batch
         group by OrderNo)
select STD_Sample.OrderNo, std_dev_batch, std_dev_sample from STD_Sample JOIN STD_Batch ON STD_Sample.OrderNo = STD_Batch.OrderNo


-- Drop the temporary table
DROP TABLE #ResultsTable
DROP TABLE #Resultcurve_id_table