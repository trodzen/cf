<cfsilent>
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfinvoke component="#request.snipObj#" method="doCheckKey">
	<cfinvokeargument name="keytype" value="form">
</cfinvoke>
<cfset newForm="#form.submitform#">
<cfswitch expression="#newForm#">

<!--- Add or Change form --->
<cfcase value="Add,Change">

<cfset grouponerror=false>
<cfset newGroupon_count="#form.Groupon_count#">
<cfloop from="1" to="#newGroupon_count#" index="i">
	<cfset "newGroupon_Voucher.item#i#"=request.snipObj.stripmystring(Evaluate("form.Groupon_Voucher#i#"),"groupon")>
	<cfset "newGroupon_Redeam.item#i#"=request.snipObj.stripmystring(Evaluate("form.Groupon_Redeam#i#"),"groupon")>
<!---	<cfif len(Evaluate("newGroupon_Voucher.item#i#")) IS 0 OR len(Evaluate("newGroupon_Redeam.item#i#")) IS 0> --->
	<cfif len(Evaluate("newGroupon_Voucher.item#i#")) IS 0>
		<cfset grouponerror=true>
	</cfif>
</cfloop>

<cfset newReserve_Schedule_Key="#form.Reserve_Schedule_Key#">
<cfset OriginalReserve_NumberOfPeople="#form.OriginalReserve_NumberOfPeople#">
<cfset newReserve_NumberOfPeople="#form.Reserve_NumberOfPeople#">
<cfset newReserve_Name="#form.Reserve_Name#">
<cfset newReserve_Phone="#form.Reserve_Phone#">
<cfset newReserve_Email="#form.Reserve_Email#">

<cfif form.button IS "Cancel" OR form.button IS "Don't Change">
	<!--- Cancel button --->
	<cfset messageList=ArrayAppend(request.messageArray, "Nothing Changed.")>
	<cfset NewForm="List">
<cfelseif form.button IS "Add another Voucher">
	<!--- add groupon button --->
	<cfif newGroupon_count LT 20>
		<cfset newGroupon_count=newGroupon_count+1>
		<cfset "newGroupon_Voucher.item#i#"="">
		<cfset "newGroupon_Redeam.item#i#"="">
	</cfif>
	<cfif isdefined("form.Reserve_Key")>
		<cfset newReserve_Key="#form.Reserve_Key#">
	</cfif>
<cfelseif form.button IS "Remove last Voucher">
	<!--- add groupon button --->
	<cfif newGroupon_count GT 1>
		<cfset newGroupon_count=newGroupon_count-1>
	</cfif>
	<cfif isdefined("form.Reserve_Key")>
		<cfset newReserve_Key="#form.Reserve_Key#">
	</cfif>
<cfelse>
	<!--- Save button --->
	<cfif len(newReserve_Name) LT 4>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter your Name.")>
	</cfif>
	<cfif NOT isnumeric(newReserve_NumberOfPeople)>
		<cfset errorList=ArrayAppend(request.errorArray, "Please select the total number of guests for this reservation.")>
	</cfif>
	<cfif NOT isvalid("Telephone", newReserve_Phone)>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter your Phone Number.")>
	</cfif>
	<cfif grouponerror>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter the Voucher Number(s) and Redemption Code(s).")>
	</cfif>
	<cfif newForm IS "Add">
		<cfset exclude_Key="">
	<cfif form.Reserve_Password IS NOT "hestia">
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter a valid new reservation password.")>
	</cfif>
	<cfelse>
		<cfset newReserve_Key="#form.Reserve_Key#">
		<cfset exclude_Key="#form.Reserve_Key#">
	</cfif>
	<cfinvoke component="#request.db_ScheduleObj#" method="getScheduleBySchedule_Key" returnvariable="getScheduleBySchedule_Keyqry">
	<cfinvokeargument name="Schedule_Key" value="#newReserve_Schedule_Key#">
	</cfinvoke>
	<cfif getScheduleBySchedule_Keyqry.recordcount IS NOT 1>
		<cfset newForm="ListSchedule">
		<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
	</cfif>
	<cfset newSchedule_Date="#getScheduleBySchedule_Keyqry.Schedule_Date#">
	<cfset newSchedule_Resource_Key="#getScheduleBySchedule_Keyqry.Schedule_Resource_Key#">
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

	<cfif isnumeric(newReserve_NumberOfPeople)>
		<cfset tempReserve_NumberOFPeople=newReserve_NumberOfPeople-OriginalReserve_NumberOfPeople>
		<cfif tempReserve_NumberOfPeople GT newSchedule_SeatsAvailable>
			<cfset tempMSG="Not enough seats available. Please select a different schedule. Someone may have booked this schedule just before you. Please <a href=""#request.snipObj.getURL("index.cfm", "reserve", false)#"">Go Back</a> and try another time.">
			<cfset errorList=ArrayAppend(request.errorArray, "#tempMSG#")>
		</cfif>
	</cfif>

	<cfinvoke component="#request.db_ReserveObj#" method="getReserveByReserve_Name" returnvariable="getReserveByReserve_Nameqry">
	<cfinvokeargument name="Reserve_Schedule_Key" value="#newReserve_Schedule_Key#">
	<cfinvokeargument name="Reserve_Name" value="#newReserve_Name#">
	<cfinvokeargument name="Exclude_Reserve_Key" value="#exclude_Key#">
	</cfinvoke>
	<cfif getReserveByReserve_Nameqry.recordcount IS NOT 0>
		<cfset errorList=ArrayAppend(request.errorArray, "Reservation already exists for the scheduled date and name. Please change the existing reservation.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfif newForm IS "Add">
			<cfinvoke component="#request.db_ReserveObj#" method="insertReserve" returnvariable="Result">
			<cfinvokeargument name="Reserve_Schedule_Key" value="#newReserve_Schedule_Key#">
			<cfinvokeargument name="Reserve_Schedule_Date" value="#newSchedule_Date#">
			<cfinvokeargument name="Reserve_Schedule_Resource_Key" value="#newSchedule_Resource_Key#">
			<cfinvokeargument name="Reserve_NumberOfPeople" value="#newReserve_NumberOfPeople#">
			<cfinvokeargument name="Reserve_Name" value="#newReserve_Name#">
			<cfinvokeargument name="Reserve_Phone" value="#newReserve_Phone#">
			<cfinvokeargument name="Reserve_Email" value="#newReserve_Email#">
			<cfinvokeargument name="Reserve_Account_Key" value="#request.Account_Key#">
			<cfinvokeargument name="Groupon_Count" value="#newGroupon_count#">
			<cfinvokeargument name="Groupon_Voucher" value="#newGroupon_Voucher#">
			<cfinvokeargument name="Groupon_Redeam" value="#newGroupon_Redeam#">
			</cfinvoke>
		<cfelse>
			<cfinvoke component="#request.db_ReserveObj#" method="updateReserve_NameByReserve_Key" returnvariable="Result">
			<cfinvokeargument name="Reserve_Key" value="#newReserve_Key#">
			<cfinvokeargument name="Reserve_Schedule_Key" value="#newReserve_Schedule_Key#">
			<cfinvokeargument name="Reserve_Schedule_Date" value="#newSchedule_Date#">
			<cfinvokeargument name="Reserve_NumberOfPeople" value="#newReserve_NumberOfPeople#">
			<cfinvokeargument name="Reserve_Name" value="#newReserve_Name#">
			<cfinvokeargument name="Reserve_Phone" value="#newReserve_Phone#">
			<cfinvokeargument name="Reserve_Email" value="#newReserve_Email#">
			<cfinvokeargument name="Reserve_Account_Key" value="#request.Account_Key#">
			<cfinvokeargument name="Groupon_Count" value="#newGroupon_count#">
			<cfinvokeargument name="Groupon_Voucher" value="#newGroupon_Voucher#">
			<cfinvokeargument name="Groupon_Redeam" value="#newGroupon_Redeam#">
			</cfinvoke>
		</cfif>
		<cfif Result.recordcount IS 1>
			<cfset msgText="<span class=""goodheading"">Request completed. You have reserved the cruise(s) listed below.</span>">
			<cfset messageList=ArrayAppend(request.messageArray, "#msgText#")>
			<cfset msgText="We look forward to seeing you aboard. You will receive an email with general cruise and boarding details closer to the reservation date.">
			<cfset messageList=ArrayAppend(request.messageArray, "#msgText#")>
			<cfset msgText="Fine print: Online reservations required. Subject to availability. Minimum 48hr notice required to schedule or cancel. Schedule subject to change. Must be 18 or older to reserve; must be 7 or older to board. Must be in good overall health with no pre-existing medical conditions; not pregnant, frail, or elderly. All passengers subject to full liability waiver. Tax and gratuity not included. Please reward your captain for their awesomeness. No show or cancellation within the 48-hour window before your reservation will result in forfeiture of vouchers. Reservations with less than 48-hour notice may be accepted at the discretion of Hestia Cruises. Call 617-398-7020 for less than 48-hour notice reservations.">
			<cfset messageList=ArrayAppend(request.messageArray, "#msgText#")>
			<cfset newForm="List">
		<cfelse>
			<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
		</cfif>
	</cfif>
</cfif>
</cfcase>

<!--- Remove form --->
<cfcase value="Cancel">
<cfset newReserve_Key="#form.Reserve_Key#">
<cfset newReserve_Schedule_Key="#form.Reserve_Schedule_Key#">
<cfif form.button IS "Don't Cancel">
	<!--- Cancel button --->
<!---	<cfset messageList=ArrayAppend(request.messageArray, "Request cancelled.")> --->
	<cfset newForm="List">
<cfelse>
	<!--- Remove button --->
	<cfinvoke component="#request.db_ReserveObj#" method="deleteReserveByReserve_Key" returnvariable="Result">
		<cfinvokeargument name="Reserve_Key" value="#newReserve_Key#">
		<cfinvokeargument name="Reserve_Account_Key" value="#request.Account_Key#">
	</cfinvoke>
	<cfif Result.recordcount IS 1>
		<cfset msgText="<span class=""goodheading"">The reservation was cancelled.</span>">
		<cfset messageList=ArrayAppend(request.messageArray, "#msgText#")>
		<cfset newForm="List">
	<cfelse>
		<cfset errorList=ArrayAppend(request.errorArray, "The reservation record could not be cancelled. Please contact us for more information.")>
		<cfset newForm="List">
	</cfif>
</cfif>
</cfcase>
</cfswitch>

<cfswitch expression="#newForm#">
<!--- List form --->
<cfcase value="List">
<cfif isdefined("form.button")>
<!--- Add button --->
<cfif form.button IS "Add a Reservation">
	<cfset newForm="ListSchedule">
<!--- Change or Remove button --->
<cfelseif form.button IS "Change a Reservation" OR form.button IS "Cancel a Reservation">
	<!--- no select --->
	<cfif NOT isdefined("form.Reserve_Key")>
		<cfset errorList=ArrayAppend(request.errorArray, "You must select a reservation.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset newReserve_Key=form.Reserve_Key>
		<cfset newForm="#left(form.button,6)#">

	<cfinvoke component="#request.db_ReserveObj#" method="getReserveByReserve_Key" returnvariable="getReserveByReserve_Keyqry">
	<cfinvokeargument name="Reserve_Key" value="#newReserve_Key#">
	</cfinvoke>
	<cfinvoke component="#request.db_ReserveObj#" method="getReserveGrouponByReserve_Key" returnvariable="ReserveGrouponqry">
	<cfinvokeargument name="Reserve_Key" value="#newReserve_Key#">
	</cfinvoke>
	<cfset grouponerror=false>
	<cfset newGroupon_count="#ReserveGrouponqry.recordcount#">
	<cfloop from="1" to="#newGroupon_count#" index="i">
		<cfset "newGroupon_Voucher.item#i#"="#ReserveGrouponqry.ReserveGroupon_Voucher[i]#">
		<cfset "newGroupon_Redeam.item#i#"="#ReserveGrouponqry.ReserveGroupon_Redeam[i]#">
		<cfif len(Evaluate("newGroupon_Voucher.item#i#")) IS 0 OR len(Evaluate("newGroupon_Redeam.item#i#")) IS 0>
			<cfset grouponerror=true>
		</cfif>
	</cfloop>

	<cfif getReserveByReserve_Keyqry.recordcount IS NOT 1>
		<cfset newForm="List">
		<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
	</cfif>
	<cfset newReserve_Schedule_Key="#getReserveByReserve_Keyqry.Reserve_Schedule_Key#">
	<cfset newReserve_Schedule_Date="#getReserveByReserve_Keyqry.Reserve_Schedule_Date#">
	<cfset newReserve_NumberOfPeople="#getReserveByReserve_Keyqry.Reserve_NumberOfPeople#">
	<cfset OriginalReserve_NumberOfPeople="#getReserveByReserve_Keyqry.Reserve_NumberOfPeople#">
	<cfset newReserve_Name="#getReserveByReserve_Keyqry.Reserve_Name#">
	<cfset newReserve_Phone="#getReserveByReserve_Keyqry.Reserve_Phone#">
	<cfset newReserve_Email="#getReserveByReserve_Keyqry.Reserve_Email#">
	<cfset newSchedule_Name="#getReserveByReserve_Keyqry.Schedule_Name#">


	</cfif>
<!--- Make a Reservation button --->
<cfelseif form.button IS "Make a Reservation">
	<!--- no select --->
	<cfif NOT isdefined("form.Schedule_Key")>
		<cfset errorList=ArrayAppend(request.errorArray, "Please select a schedule from the list.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset newReserve_Schedule_Key=form.Schedule_Key>
		<cfset newForm="Add">
	</cfif>
</cfif>
</cfif>
</cfcase>

<!--- List Schedules form --->
<cfcase value="ListSchedule">
<cfif isdefined("form.button")>
<cfswitch expression="#form.button#">
<!--- Make a Reservation button --->
<cfcase value="Make a Reservation">
	<!--- no select --->
	<cfif NOT isdefined("form.Schedule_Key")>
		<cfset errorList=ArrayAppend(request.errorArray, "Please select a schedule from the list.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset newReserve_Schedule_Key=form.Schedule_Key>
		<cfset newForm="Add">
	</cfif>
</cfcase>
</cfswitch>
</cfif>
</cfcase>

</cfswitch>
</cfsilent>