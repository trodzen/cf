<cfsilent>
<cfset request.title="Reservations">
<cfset request.pageheader="Manage your Reservations">
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfinvoke component="#request.snipObj#" method="doSubmitKey">
<cfparam name="newForm" default="List">

<cfswitch expression="#newForm#">
<cfcase value="Change,Cancel">
</cfcase>
</cfswitch>

<cfswitch expression="#newForm#">
<cfcase value="List">
	<cfinvoke component="#request.db_ReserveObj#" method="getReserveByAccount_Key" returnvariable="getReserveByAccount_Keyqry">
	<cfinvokeargument name="Reserve_Account_Key" value="#request.Account_Key#">
	</cfinvoke>
	<cfif getReserveByAccount_Keyqry.recordcount IS 0>
		<cfset newForm="ListSchedule">
	</cfif>
</cfcase>
</cfswitch>

<cfswitch expression="#newForm#">
<cfcase value="ListSchedule">
	<cfinclude template="index_schedule_header_list.cfm">
</cfcase>
</cfswitch>

<cfswitch expression="#newForm#">
<cfcase value="Add,Change">
	<cfinvoke component="#request.db_ScheduleObj#" method="getScheduleBySchedule_Key" returnvariable="getScheduleBySchedule_Keyqry">
	<cfinvokeargument name="Schedule_Key" value="#newReserve_Schedule_Key#">
	</cfinvoke>
	<cfif getScheduleBySchedule_Keyqry.recordcount IS NOT 1>
		<cfset newForm="ListSchedule">
		<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
	</cfif>
	<cfset newSchedule_Date="#DateFormat(getScheduleBySchedule_Keyqry.Schedule_Date, "mm/dd/yyyy")# #timeformat(getScheduleBySchedule_Keyqry.Schedule_Date, "h:mm tt")#">
	<cfset newSchedule_SeatsAvailable="#getScheduleBySchedule_Keyqry.Schedule_SeatsAvailable#">
	<cfset newSchedule_MinSeats="#getScheduleBySchedule_Keyqry.Schedule_MinSeats#">
	<cfset newSchedule_FirstReservationMinSeats="#getScheduleBySchedule_Keyqry.Schedule_FirstReservationMinSeats#">
	<cfset newSchedule_Status="#getScheduleBySchedule_Keyqry.Schedule_Status#">
	<cfset newSchedule_StatusReason="#getScheduleBySchedule_Keyqry.Schedule_StatusReason#">
	<cfset newSchedule_Name="#getScheduleBySchedule_Keyqry.Schedule_Name#">
	<cfset newSchedule_OptionDetail_Key="#getScheduleBySchedule_Keyqry.Schedule_OptionDetail_Key#">
	<cfset newSchedule_Service_Key="#getScheduleBySchedule_Keyqry.Schedule_Service_Key#">
	<cfset newSchedule_Resource_Key="#getScheduleBySchedule_Keyqry.Schedule_Resource_Key#">
	<cfset newSchedule_Location_Key="#getScheduleBySchedule_Keyqry.Schedule_Location_Key#">
	<cfset newSchedule_Merchant_Key="#getScheduleBySchedule_Keyqry.Schedule_Merchant_Key#">

	<cfinvoke component="#request.db_ReserveObj#" method="checkFirstReserveBySchedule_Key" returnvariable="checkFirstReserveBySchedule_Keyqry">
	<cfinvokeargument name="Reserve_Schedule_Key" value="#newReserve_Schedule_Key#">
	</cfinvoke>
	<cfif checkFirstReserveBySchedule_Keyqry.recordcount IS 0>
		<cfset firstreserve=true>
		<cfif newSchedule_FirstReservationMinSeats GT 0>
			<cfset messageList=ArrayAppend(request.messageArray, "This is the first reservation for the schedule time. The minimum people for this reservation is #newSchedule_FirstReservationMinSeats#.")>
		</cfif>
	<cfelse>
		<cfset firstreserve=false>
	</cfif>

	<cfparam name="newGroupon_count" default="1">
	<cfparam name="newGroupon_Voucher.item1" default="">
	<cfparam name="newGroupon_Redeam.item1" default="">

	<cfparam name="newReserve_Schedule_Key" default="">
	<cfparam name="newReserve_Schedule_Date" default="">
	<cfparam name="newReserve_NumberOfPeople" default="Select">
	<cfparam name="OriginalReserve_NumberOfPeople" default="0">
	<cfparam name="newReserve_Name" default="">
	<cfparam name="newReserve_Phone" default="">
	<cfparam name="newReserve_Email" default="">
	<cfinvoke component="#request.db_ReserveObj#" method="getEmailsByAccount_KEy" returnvariable="getEmailsqry">
	<cfinvokeargument name="Email_Account_Key" value="#request.Account_Key#">
	</cfinvoke>
	<cfquery name="getConfirmedEmailsqry" dbtype="query" result="result">
SELECT * FROM getEmailsqry
WHERE Email_Confirmed = 1
	</cfquery>
	<cfif result.recordcount IS 0>
			<cfset temp=request.snipObj.getURL("index.cfm", "myaccount_accountprofile-email", false)>
			<cfset messageList=ArrayAppend(request.messageArray, "NOTE: Before you can complete a reservation, your email address must by confirmed. If you just signed up check your email. Please confirm it by clicking the link in the email that was sent to you when you signed up.")>
			<cfset messageList=ArrayAppend(request.messageArray, "Go to the <a href=""#temp#"">My Account Email</a> tab to change your email address or request a new confirmation email.")>	</cfif>
</cfcase>
</cfswitch>

</cfsilent>