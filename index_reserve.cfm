<cfoutput>

<cfif request.Login_Roles DOES NOT CONTAIN "user">
	<cfset newForm="Offline">
</cfif>

<cfswitch expression="#newForm#">

<cfcase value="Cancel">
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td><form action="#request.snipObj.getURL("index.cfm", "reserve", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td>Are you sure you want to cancel the following Reservation:<br>
&nbsp;<br>
		<span class="emphasis">#DateFormat(newReserve_Schedule_Date, "ddd mm/dd/yyyy")#&nbsp;#request.layoutObj.doTimeFormat(newReserve_Schedule_Date)#&nbsp;#newSchedule_Name#&nbsp;for #newReserve_NumberOfPeople# People</span></td></tr>
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
		#request.layoutObj.doLine()#
		<tr><td><input type="submit" name="button" value="Submit Cancellation" /><input type="submit" name="button" value="Don't Cancel" /></td></tr>
	</table><input name="Reserve_Schedule_Key" type="hidden" value="#newReserve_Schedule_Key#"><input name="Reserve_Key" type="hidden" value="#newReserve_Key#"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="Cancel"></form></td></tr>
</table>
</cfcase>

<cfcase value="Add,Change">
<cfif newForm IS "Add">
	<cfif firstreserve AND newSchedule_FirstReservationMinSeats GT 1>
		<cfset fromNumberOfPeople=newSchedule_FirstReservationMinSeats>
	<cfelse>
		<cfset fromNumberOfPeople=1>
	</cfif>
	<cfset toNumberOfPeople=newSchedule_SeatsAvailable>
<cfelse>
	<cfset fromNumberOfPeople=1>
	<cfset toNumberOfPeople=49>
</cfif>
<table border="0" cellpadding="0" cellspacing="0">
		<tr><td><form action="#request.snipObj.getURL("index.cfm", "reserve", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
<!---
<cfif newForm IS "Add">
		<tr><td><Span class="note">Reservations are NOW CLOSED for the season. The terms of all vouchers requires a reservation by Sept 1. If you have not contacted us and requested a date prior to Sept 1, please do not enter a new reservation now. <b>Your reservation will be cancelled.</b> This form may only be used by those with weather reservation cancellations that need to make replacement date request. </Span></td></tr>
</cfif>
--->
			<tr><td>Type your information then select the Submit button.</td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td><span class="highlightbold">#newSchedule_Date# #newSchedule_Name#</span></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td><table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="label">Total Number of People for this Reservation:</td><td>&nbsp;<select name="Reserve_NumberOfPeople">
<option value="Select">Select</option>
<cfloop from="#fromNumberOfPeople#" to="#toNumberOfPeople#" index="i">
<cfif newReserve_NumberOfPeople IS "#i#"><cfset sel="Selected"><cfelse><cfset sel=""></cfif>
<option value="#i#" #sel#>#i#</option>
</cfloop>
</select></td></tr>
			</table></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td><table border="0" cellpadding="0" cellspacing="0">
				<tr><td class="label">Voucher Number:</td><td>#request.layoutObj.doPixel(width=20)#</td><td class="label">Redemption Code:</td></tr>
<cfloop from="1" to="#newGroupon_count#" index="i">
				<tr><td><input name="Groupon_Voucher#i#" type="text" value="#Evaluate("newGroupon_Voucher.item#i#")#" size="30"></td><td></td><td><input name="Groupon_Redeam#i#" type="text" value="#Evaluate("newGroupon_Redeam.item#i#")#" size="15"></td></tr>
				<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
</cfloop>
				<tr>
<td class="Smaller">Enter the number printed on your voucher. Click Add a voucher button below to enter multiple vouchers. For direct paypal payments enter the paypal transaction ID.</td><td>#request.layoutObj.doPixel(width=20)#</td>
<td class="Smaller">For groupon enter the number under the bar code on the bottom of your printed groupon voucher. For all other vouchers including Travelzoo, LivingSocial and Eversave leave this field blank.</td></tr>
			</table></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
			<tr><td><input type="submit" name="button" value="Add another Voucher" /><input type="submit" name="button" value="Remove last Voucher" /></td></tr>
			<tr><td><ul class="check"><li>I Agree to the <a href="#request.snipObj.getURL("terms.cfm", "none", false)#">Terms and Release of Liability.</a></li></ul></td></tr>
			<tr><td class="Smaller">Fine print: Online reservations required. Subject to availability. Minimum 48hr notice required to schedule or cancel. Schedule subject to change. Must be 18 or older to reserve; must be 7 or older to board. Must be in good overall health with no pre-existing medical conditions; not pregnant, frail, or elderly. All passengers subject to full liability waiver. Tax and gratuity not included. Please reward your captain for their awesomeness. No show or cancellation within the 48-hour window before your reservation will result in forfeiture of vouchers. Reservations with less than 48-hour notice may be accepted at the discretion of Hestia Cruises. Call 617-398-7020 for less than 48-hour notice reservations.</td></tr>
			<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
			<tr><td><table border="0" cellpadding="0" cellspacing="0"><tr><td><span class="label"><cfif request.Login_Roles DOES NOT CONTAIN "admin">Your </cfif>Name:</span><br />
<input name="Reserve_Name" type="text" value="#newReserve_Name#" size="25"></td><td>#request.layoutObj.doPixel(width=20)#</td><td><cfif request.Login_Roles CONTAINS "admin">
<span class="label">Email:</span><br /><input name="Reserve_Email" type="text" value="#newReserve_Email#" size="35">
<cfelse>
<cfinvoke component="#request.layoutObj#" method="doInputSelect">
<cfinvokeargument name="label" value="Your Email Address">
<cfinvokeargument name="query" value="#getEmailsqry#">
<cfinvokeargument name="inputname" value="Reserve_Email">
<cfinvokeargument name="inputvalue" value="Email_Address">
<cfinvokeargument name="inputtext" value="Email_Address">
<cfinvokeargument name="selectlist" value="#newReserve_Email#">
</cfinvoke>&nbsp;<span class="Smaller"><a href="#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-email", false)#">add email</a></span></cfif></td></tr></table></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td class="label"><cfif request.Login_Roles DOES NOT CONTAIN "admin">Your </cfif>Mobile Phone:</td></tr>
			<tr><td><input name="Reserve_Phone" type="text" value="#newReserve_Phone#" size="15"> <span class="Smaller">Contact mobile phone for the day of the reservation.</span></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			#request.layoutObj.doLine()#
<!---
<cfif newForm IS "Add">
		<tr><td><Span class="note">Reservations are NOW CLOSED for the season. The terms of all vouchers requires a reservation by Sept 1. If you have not contacted us and requested a date prior to Sept 1, please do not enter a new reservation now. <b>Your reservation will be cancelled.</b> This form may only be used by those with weather reservation cancellations that need to make replacement date request. </Span></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td class="label">Reservation Security Password:</td></tr>
			<tr><td><input name="Reserve_Password" type="text" value="" size="15"> <span class="Smaller">This form may only be used to enter reservations for weather cancellations and those that placed a reservation request before the Sept 1 date. The password is available by contacting us by phone or email. NEW reservation requests will not be accepted according to the terms of the vouchers.</span></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
</cfif>
---><input name="Reserve_Password" type="hidden" value="hestia">

			<tr><td><cfif newForm IS "Change"><input name="Reserve_Key" type="hidden" value="#newReserve_Key#"><input type="submit" name="button" value="Submit Reservation" /><input type="submit" name="button" value="Don't Change" /><cfelse><input type="submit" name="button" value="Submit Reservation" /><input type="submit" name="button" value="Cancel" /></cfif></td></tr>
		</table><input name="OriginalReserve_NumberOfPeople" type="hidden" value="#OriginalReserve_NumberOfPeople#"><input name="Groupon_count" type="hidden" value="#newGroupon_count#"><input name="Reserve_Schedule_Key" type="hidden" value="#newReserve_Schedule_Key#"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="#newForm#"></form></td></tr>
</table>
</cfcase>

<cfcase value="List">
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td>Manage your Reservations.</td></tr>
	<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
	<tr><td><form name="#newForm#" action="#request.snipObj.getURL("index.cfm", "reserve", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td>#request.layoutObj.doPageNavigator(name="Reserves", text="Reserve Name", total=getReserveByAccount_Keyqry.recordcount, page=10, start="begin")#</td></tr>
		<tr><td><table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" class="DataTable">
			<tr class="DataTableRowHeading"><td colspan="3" nowrap width="75%">Select your Reservation</td><td align="center">Location</td><td align="center">Reserved Number<br />of People</td></tr>
<cfloop query="getReserveByAccount_Keyqry" startrow="#request.startrow#" endrow="#request.endrow#">
<cfset status="">
			<cfif getReserveByAccount_Keyqry.CurrentRow MOD 2><tr class="DataTableRowOdd"><cfelse><tr class="DataTableRowEven"></cfif><td align="center"><input type="radio" name="Reserve_Key" value="#getReserveByAccount_Keyqry.Reserve_Key#"></td>
			<td onMouseDown="selectradio(document.List.Reserve_Key, #evaluate(getReserveByAccount_Keyqry.currentrow-request.startrow)#)" title="click to select" nowrap="nowrap">#DateFormat(getReserveByAccount_Keyqry.Reserve_Schedule_Date, "ddd mm/dd/yyyy")#&nbsp;#request.layoutObj.doTimeFormat(getReserveByAccount_Keyqry.Reserve_Schedule_Date)#</td><td onMouseDown="selectradio(document.List.Reserve_Key, #evaluate(getReserveByAccount_Keyqry.currentrow-request.startrow)#)" title="click to select" nowrap="nowrap">#getReserveByAccount_Keyqry.Schedule_Name#</td><td nowrap="nowrap" align="center"><a href="#getReserveByAccount_Keyqry.Location_Link#">#getReserveByAccount_Keyqry.Location_Name#</a></td><td nowrap="nowrap" align="center">#getReserveByAccount_Keyqry.Reserve_NumberOfPeople#</td></tr>
</cfloop>
		</table></td></tr>
	
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
		<tr><td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr><td><input type="submit" name="button" value="Change a Reservation" /><input type="submit" name="button" value="Cancel a Reservation" /><input type="submit" name="button" value="Add a Reservation" /></td></tr>
		</table></td></tr>
	</table><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="List"></form></td></tr>
</table>
</cfcase>

<cfcase value="ListSchedule">
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td><form name="#newForm#" action="#request.snipObj.getURL("index.cfm", "reserve", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td><Span class="note">Please complete an online payment and have a voucher number or transaction ID ready before making a reservation</Span></td></tr>
		<tr><td>Select a date from the Schedule then click <em>Make a Reservation</em>.</td></tr>
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
<cfinclude template="index_schedule_list.cfm">
	</table><input name="hold_Subset_OptionDetail_Key" type="hidden" value="#newSubset_OptionDetail_Key#" /><input name="hold_minseats" type="hidden" value="#minseats#" /><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="ListSchedule"></form></td></tr>
</table>
</cfcase>

<cfcase value="Offline">
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td class="conflictheading">Reservations are not available now. Please check back later.</td></tr>
</table>
</cfcase>

</cfswitch>
</cfoutput>