<cfcomponent extends="db_Functions" output="no">

<!--- init --->
<cffunction name="init" access="public" output="no">
<cfreturn this>
</cffunction>

<!--- insert Schedule --->
<cffunction name="insertSchedule" output="no">
<cfargument name="Schedule_Date" required="yes">
<cfargument name="Schedule_SeatsAvailable" required="yes">
<cfargument name="Schedule_MinSeats" required="yes">
<cfargument name="Schedule_FirstReservationMinSeats" required="yes">
<cfargument name="Schedule_Status" required="yes">
<cfargument name="Schedule_StatusReason" required="yes">
<cfargument name="Schedule_Name" required="yes">
<cfargument name="Schedule_OptionDetail_Key" required="yes">
<cfargument name="Schedule_Service_Key" required="yes">
<cfargument name="Schedule_Resource_Key" required="yes">
<cfargument name="Schedule_Location_Key" required="yes">
<cfargument name="Schedule_Merchant_Key" required="yes">
<cfargument name="Schedule_Account_Key" required="yes">
<cfargument name="Repeat_Until_Date" required="yes">
<cfargument name="Repeat_Until_Days" required="yes">
<cfset Repeat_Schedule_Key="">
<cfif NOT isDate(arguments.Repeat_Until_Date)>
	<cfset arguments.Repeat_Until_Date=arguments.Schedule_Date>
	<cfset RepeatIt=false>
<cfelse>
	<cfset RepeatIt=true>
</cfif>
<cfset testDate=arguments.Schedule_Date>
<cfset firstSet=false>
<cfloop condition="testDate LE arguments.Repeat_Until_Date">
<cfif ListFind(arguments.Repeat_Until_Days,DayofWeek(testDate))>
<cftransaction>
<cfquery name="query" datasource="#application.dsn#" result="result">
INSERT INTO Schedule (Schedule_Date, Schedule_SeatsAvailable, Schedule_MinSeats, Schedule_FirstReservationMinSeats, Schedule_Status, Schedule_StatusReason, Schedule_Name, Schedule_OptionDetail_Key, Schedule_Service_Key, Schedule_Resource_Key, Schedule_Location_Key, Schedule_Merchant_Key, Schedule_Account_Key, Schedule_Repeat_Schedule_Key) VALUES (#values(testDate, ists)#, #values(arguments.Schedule_SeatsAvailable, isint)#, #values(arguments.Schedule_MinSeats, isint)#, #values(arguments.Schedule_FirstReservationMinSeats, isint)#, #values(arguments.Schedule_Status, ischar)#, #values(arguments.Schedule_StatusReason, ischar)#, #values(arguments.Schedule_Name, ischar)#, #values(arguments.Schedule_OptionDetail_Key, isint)#, #values(arguments.Schedule_Service_Key, isint)#, #values(arguments.Schedule_Resource_Key, isint)#, #values(arguments.Schedule_Location_Key, isint)#, #values(arguments.Schedule_Merchant_Key, isint)#, #values(arguments.Schedule_Account_Key, isint)#, #values(Repeat_Schedule_Key, isint)#)
</cfquery>
<cfquery name="query2" datasource="#application.dsn#">
SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cftransaction>
<cfif RepeatIt AND NOT firstSet>
	<cfset firstSet=true>
	<cfset Repeat_Schedule_Key="#query2.Identity#">
<cfquery name="query3" datasource="#application.dsn#">
UPDATE Schedule SET Schedule_Repeat_Schedule_Key #set(iseq, Repeat_Schedule_Key, isint)# WHERE Schedule_Key #where(iseq, Repeat_Schedule_Key, isint)#
</cfquery>
</cfif>
</cfif>
<cfset testDate=dateadd("d",1,testDate)>
</cfloop>
<cfreturn result>
</cffunction>

<!--- update Schedule --->
<cffunction name="updateSchedule_NameBySchedule_Key" output="no">
<cfargument name="Schedule_Key" required="yes">
<cfargument name="Schedule_Date" required="yes">
<cfargument name="Schedule_SeatsAvailable" required="yes">
<cfargument name="Schedule_MinSeats" required="yes">
<cfargument name="Schedule_FirstReservationMinSeats" required="yes">
<cfargument name="Schedule_Status" required="yes">
<cfargument name="Schedule_StatusReason" required="yes">
<cfargument name="Schedule_Name" required="yes">
<cfargument name="Schedule_OptionDetail_Key" required="yes">
<cfargument name="Schedule_Service_Key" required="yes">
<cfargument name="Schedule_Resource_Key" required="yes">
<cfargument name="Schedule_Location_Key" required="yes">
<cfargument name="Schedule_Merchant_Key" required="yes">
<cfargument name="Schedule_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#" result="result">
UPDATE Schedule SET Schedule_Date #set(iseq, arguments.Schedule_Date, ists)#, Schedule_SeatsAvailable #set(iseq, arguments.Schedule_SeatsAvailable, isint)#, Schedule_MinSeats #set(iseq, arguments.Schedule_MinSeats, isint)#, Schedule_FirstReservationMinSeats #set(iseq, arguments.Schedule_FirstReservationMinSeats, isint)#, Schedule_Status #set(iseq, arguments.Schedule_Status, ischar)#, Schedule_StatusReason #set(iseq, arguments.Schedule_StatusReason, ischar)#, Schedule_Name #set(iseq, arguments.Schedule_Name, ischar)#, Schedule_OptionDetail_Key #set(iseq, arguments.Schedule_OptionDetail_Key, isint)#, Schedule_Service_Key #set(iseq, arguments.Schedule_Service_Key, isint)#, Schedule_Resource_Key #set(iseq, arguments.Schedule_Resource_Key, isint)#, Schedule_Location_Key #set(iseq, arguments.Schedule_Location_Key, isint)#, Schedule_Merchant_Key #set(iseq, arguments.Schedule_Merchant_Key, isint)# WHERE Schedule_Key #where(iseq, arguments.Schedule_Key, isint)# AND Schedule_Account_Key #where(iseq, arguments.Schedule_Account_Key, isint)#
</cfquery>
<cfreturn result>
</cffunction>

<!--- get ScheduleBySchedule_Key --->
<cffunction name="getScheduleBySchedule_Key" output="no">
<cfargument name="Schedule_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Schedule 
LEFT OUTER JOIN Standards AS Reason ON (Schedule_StatusReason = Reason.Std_Code AND Reason.Std_Collection = 'StatusReason')
LEFT OUTER JOIN OptionDetail ON (Schedule_OptionDetail_Key = OptionDetail_Key)
LEFT OUTER JOIN Service ON (Schedule_Service_Key = Service_Key)
LEFT OUTER JOIN Resource ON (Schedule_Resource_Key = Resource_Key)
LEFT OUTER JOIN Location ON (Schedule_Location_Key = Location_Key)
WHERE Schedule_Key #where(iseq, arguments.Schedule_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- get ScheduleBySchedule_Repeat_Schedule_Key --->
<cffunction name="getScheduleBySchedule_Repeat_Schedule_Key" output="no">
<cfargument name="Schedule_Repeat_Schedule_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Schedule 
LEFT OUTER JOIN Standards AS Reason ON (Schedule_StatusReason = Reason.Std_Code AND Reason.Std_Collection = 'StatusReason')
LEFT OUTER JOIN OptionDetail ON (Schedule_OptionDetail_Key = OptionDetail_Key)
LEFT OUTER JOIN Service ON (Schedule_Service_Key = Service_Key)
LEFT OUTER JOIN Resource ON (Schedule_Resource_Key = Resource_Key)
LEFT OUTER JOIN Location ON (Schedule_Location_Key = Location_Key)
WHERE Schedule_Repeat_Schedule_Key #where(iseq, arguments.Schedule_Repeat_Schedule_Key, isint)#
ORDER BY Schedule_Date
</cfquery>
<cfreturn query>
</cffunction>

<!--- get ScheduleByAccount_Key --->
<cffunction name="getScheduleByAccount_Key" output="no">
<cfargument name="Schedule_Account_Key" required="yes">
<cfargument name="hostAccount_Key" required="yes">
<cfargument name="hostMerchant_Key" required="yes">
<cfargument name="Subset_OptionDetail_Key" required="yes">
<cfargument name="minseats" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Schedule 
LEFT OUTER JOIN Standards AS Reason ON (Schedule_StatusReason = Reason.Std_Code AND Reason.Std_Collection = 'StatusReason')
LEFT OUTER JOIN OptionDetail ON (Schedule_OptionDetail_Key = OptionDetail_Key)
LEFT OUTER JOIN Service ON (Schedule_Service_Key = Service_Key)
LEFT OUTER JOIN Resource ON (Schedule_Resource_Key = Resource_Key)
LEFT OUTER JOIN Location ON (Schedule_Location_Key = Location_Key)
LEFT OUTER JOIN Merchant ON (Schedule_Merchant_Key = Merchant_Key)
LEFT OUTER JOIN IncludeMerchant ON (Schedule_Merchant_Key = Include_ThisMerchant_Key AND Include_Merchant_Key #where(iseq, arguments.hostMerchant_Key, isint)#)
WHERE Schedule_Date #where(isgt, Now(), ists)# AND Schedule_Status #where(iseq, "Available", ischar)# AND <cfif isnumeric(arguments.Subset_OptionDetail_Key)>OptionDetail_Key #where(iseq, arguments.Subset_OptionDetail_Key, isint)# AND <cfelseif left(arguments.Subset_OptionDetail_Key,8) IS "resource">Resource_Key #where(iseq, right(arguments.Subset_OptionDetail_Key,(len(arguments.Subset_OptionDetail_Key)-8)), isint)# AND </cfif>Schedule_SeatsAvailable #where(isge, arguments.minseats, isint)# AND (Schedule_Account_Key #where(iseq, arguments.Schedule_Account_Key, isint)# OR
Schedule_Account_Key #where(iseq, arguments.hostAccount_Key, isint)# OR 
Include_Merchant_Key #where(iseq, arguments.hostMerchant_Key, isint)#)
ORDER BY Schedule_Date
</cfquery>
<cfreturn query>
</cffunction>

<!--- get getScheduleBySchedule_Name --->
<cffunction name="getScheduleBySchedule_Name" output="no">
<cfargument name="Schedule_Date" required="yes">
<cfargument name="Schedule_Name" required="yes">
<cfargument name="Exclude_Schedule_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Schedule 
WHERE Schedule_Key #where(isne, arguments.Exclude_Schedule_Key, isint)# AND
Schedule_Date #where(iseq, arguments.Schedule_Date, ists)# AND
Schedule_Name #where(iseq, arguments.Schedule_Name, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- get getServices --->
<cffunction name="subsetOptionDetails" output="no">
<cfargument name="hostAccount_Key" required="yes">
<cfargument name="hostMerchant_Key" required="yes">
<cfargument name="Scheduleqry" required="yes">
<cfquery name="query" dbtype="query">
SELECT Resource_Name, Resource_Key, OptionDetail_SortOrder, OptionDetail_Name, OptionDetail_Key FROM Scheduleqry
GROUP BY Resource_Name, Resource_Key, OptionDetail_SortOrder, OptionDetail_Name, OptionDetail_Key
ORDER BY Resource_Name, Resource_Key, OptionDetail_SortOrder, OptionDetail_Name, OptionDetail_Key
</cfquery>
<cfset aVals=ArrayNew(1)>
<cfset vIndex=0>
<cfloop query="query">
	<cfset vIndex=vIndex+1>
	<cfset aVals[vIndex]="#query.Resource_Name# #query.OptionDetail_Name#">
</cfloop>
<cfset tRows=QueryAddColumn(query,"sValue","VarChar",aVals)>

<cfquery name="query2" datasource="#application.dsn#">
SELECT Resource_Name, Resource_Key, OptionDetail_SortOrder, OptionDetail_Name, OptionDetail_Key FROM OptionDetail 
LEFT OUTER JOIN Service ON (OptionDetail_Service_Key = Service_Key)
LEFT OUTER JOIN Resource ON (Service_Resource_Key = Resource_Key)
LEFT OUTER JOIN IncludeMerchant ON (Service_Merchant_Key = Include_ThisMerchant_Key AND Include_Merchant_Key #where(iseq, arguments.hostMerchant_Key, isint)#)
WHERE Include_Merchant_Key #where(iseq, arguments.hostMerchant_Key, isint)# OR
OptionDetail_Account_Key #where(iseq, arguments.hostAccount_Key, isint)# 
ORDER BY Resource_Name, OptionDetail_SortOrder
</cfquery><cfset request.testqry=query2>
<cfset aVals2=ArrayNew(1)>
<cfset vIndex2=0>
<cfloop query="query2">
	<cfset vIndex2=vIndex2+1>
	<cfset aVals2[vIndex2]="#query2.Resource_Name# #query2.OptionDetail_Name#">
</cfloop>
<cfset tRows=QueryAddColumn(query2,"sValue","VarChar",aVals2)>

<cfquery name="query3" dbtype="query">
Select * from query
UNION
Select * from query2
ORDER BY Resource_Name, OptionDetail_SortOrder, OptionDetail_Name, OptionDetail_Key
</cfquery>
<cfset aVals3=ArrayNew(1)>
<cfset vIndex3=0>
<cfloop query="query3">
	<cfset vIndex3=vIndex3+1>
	<cfset aVals3[vIndex3]="#query3.OptionDetail_Key#">
</cfloop>
<cfset tRows=QueryAddColumn(query3,"sKey","VarChar",aVals3)>

<cfquery name="query4" dbtype="query">
Select Resource_Name, Resource_Key from query3
GROUP BY Resource_Name, Resource_Key
ORDER BY Resource_Name
</cfquery>
<cfset aVals4=ArrayNew(1)>
<cfset vIndex4=0>
<cfloop query="query4">
	<cfset vIndex4=vIndex4+1>
	<cfset aVals4[vIndex4]="- All #query4.Resource_Name# Cruises">
</cfloop>
<cfset tRows=QueryAddColumn(query4,"sValue","VarChar",aVals4)>
<cfset aVals5=ArrayNew(1)>
<cfset vIndex5=0>
<cfloop query="query4">
	<cfset vIndex5=vIndex5+1>
	<cfset aVals5[vIndex5]="resource#query4.Resource_Key#">
</cfloop>
<cfset tRows=QueryAddColumn(query4,"sKey","VarChar",aVals5)>
<cfset aVals5=ArrayNew(1)>
<cfset tRows=QueryAddColumn(query4,"OptionDetail_SortOrder","Integer",aVals5)>
<cfquery name="query5" dbtype="query">
Select sValue, sKey, Resource_Name, OptionDetail_SortOrder from query3
UNION
Select sValue, sKey, Resource_Name, OptionDetail_SortOrder from query4
ORDER BY Resource_Name, OptionDetail_SortOrder
</cfquery>
<cfreturn query5>
</cffunction>

<!--- get getServices --->
<cffunction name="getOptionDetails" output="no">
<cfargument name="OptionDetail_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM OptionDetail 
LEFT OUTER JOIN ServiceOption ON (OptionDetail_ServiceOption_Key = ServiceOption_Key)
LEFT OUTER JOIN Service ON (OptionDetail_Service_Key = Service_Key)
LEFT OUTER JOIN Resource ON (Service_Resource_Key = Resource_Key)
WHERE OptionDetail_Account_Key #where(iseq, arguments.OptionDetail_Account_Key, isint)#
ORDER BY OptionDetail_SortOrder
</cfquery>
<cfset aVals=ArrayNew(1)>
<cfset vIndex=0>
<cfloop query="query">
	<cfset vIndex=vIndex+1>
	<cfset aVals[vIndex]="#query.Service_Alt_Name# #query.Resource_Name# #query.OptionDetail_Name#">
</cfloop>
<cfset tRows=QueryAddColumn(query,"sValue","VarChar",aVals)>
<cfreturn query>
</cffunction>

<!--- get getMerchants --->
<cffunction name="getMerchants" output="no">
<cfargument name="Merchant_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Merchant 
WHERE Merchant_Account_Key #where(iseq, arguments.Merchant_Account_Key, isint)#
ORDER BY Merchant_Name
</cfquery>
<cfreturn query>
</cffunction>

<!--- get getServices --->
<cffunction name="getServices" output="no">
<cfargument name="Service_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Service 
LEFT OUTER JOIN Resource ON (Service_Resource_Key = Resource_Key)
WHERE Service_Account_Key #where(iseq, arguments.Service_Account_Key, isint)#
ORDER BY Service_Name
</cfquery>
<cfreturn query>
</cffunction>

<!--- get getServices --->
<cffunction name="getResources" output="no">
<cfargument name="Resource_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Resource 
WHERE Resource_Account_Key #where(iseq, arguments.Resource_Account_Key, isint)#
ORDER BY Resource_Name
</cfquery>
<cfreturn query>
</cffunction>

<!--- get getServices --->
<cffunction name="getLocations" output="no">
<cfargument name="Location_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Location 
WHERE Location_Account_Key #where(iseq, arguments.Location_Account_Key, isint)#
ORDER BY Location_Name
</cfquery>
<cfreturn query>
</cffunction>

<!--- delete ScheduleBySchedule_Key --->
<cffunction name="deleteScheduleBySchedule_Key" output="no">
<cfargument name="Schedule_Key" required="yes">
<cfargument name="Schedule_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#" result="result">
DELETE FROM Schedule WHERE Schedule_Key #where(iseq, arguments.Schedule_Key, isint)# AND Schedule_Account_Key #where(iseq, arguments.Schedule_Account_Key, isint)#
</cfquery>
<cfreturn result>
</cffunction>

<!--- delete ScheduleBySchedule_Repeat_Schedule_Key --->
<cffunction name="deleteScheduleBySchedule_Repeat_Schedule_Key" output="no">
<cfargument name="Schedule_Repeat_Schedule_Key" required="yes">
<cfargument name="Schedule_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#" result="result">
DELETE FROM Schedule WHERE Schedule_Repeat_Schedule_Key #where(iseq, arguments.Schedule_Repeat_Schedule_Key, isint)# AND Schedule_Account_Key #where(iseq, arguments.Schedule_Account_Key, isint)#
</cfquery>
<cfreturn result>
</cffunction>

<!--- get OptionDetailByOptionDetail_Key --->
<cffunction name="getOptionDetailByOptionDetail_Key" output="no">
<cfargument name="OptionDetail_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM OptionDetail 
LEFT OUTER JOIN Service ON (OptionDetail_Service_Key = Service_Key)
WHERE OptionDetail_Key #where(iseq, arguments.OptionDetail_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- get SeatsAvailableDefault --->
<cffunction name="getSeatsAvailableDefault" output="no">
<cfargument name="Service_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#" maxrows="1">
SELECT * FROM Service
LEFT OUTER JOIN Schedule ON (Service_Key = Schedule_Service_Key)
WHERE Service_Account_Key #where(iseq, arguments.Service_Account_Key, isint)#
ORDER BY Schedule_Date DESC
</cfquery>
<cfreturn query>
</cffunction>

</cfcomponent>