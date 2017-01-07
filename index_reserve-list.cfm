<cfoutput>

<cfswitch expression="#newForm#">

<cfcase value="Remove">
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td><form action="#request.snipObj.getURL("index.cfm", "myaccount_merchant-Location", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td>Are you sure you want to remove the following Location:<br>
&nbsp;<br>
		<span class="emphasis">#newLocation_Name#</span></td></tr>
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
		#request.layoutObj.doLine()#
		<tr><td><input type="submit" name="button" value="Remove"><input type="submit" name="button" value="Cancel"></td></tr>
	</table><input name="Location_Key" type="hidden" value="#newLocation_Key#"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="Remove"></form></td></tr>
</table>
</cfcase>

<cfcase value="Add,Change">
<table border="0" cellpadding="0" cellspacing="0">
		<tr><td><form action="#request.snipObj.getURL("index.cfm", "myaccount_merchant-Location", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
			<tr><td>Type your business Location then select the Save button.</td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td class="label">Location Name:</td></tr>
			<tr><td><input name="Location_Name" type="text" value="#newLocation_Name#" size="30"></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td class="label">Location URL Link:</td></tr>
			<tr><td><input name="Location_Link" type="text" value="#newLocation_Link#" size="70"></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			#request.layoutObj.doLine()#
			<tr><td><input type="submit" name="button" value="Save"><input type="submit" name="button" value="Cancel"></td></tr>
		</table><cfif newForm IS "Change"><input name="Location_Key" type="hidden" value="#newLocation_Key#"></cfif><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="#newForm#"></form></td></tr>
</table>
</cfcase>

<cfcase value="List">
<table border="0" cellpadding="0" cellspacing="0">
<!---	<tr><td>Manage your business reservations.</td></tr> --->
	<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
	<tr><td><form name="#newForm#" action="#request.snipObj.getURL("index.cfm", "reserve-list", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td>#request.layoutObj.doPageNavigator(name="Reservations", text="Reservation", total=getReserveByResource_Keyqry.recordcount, page=100, start="begin")#</td></tr>
		<tr><td><table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" class="DataTable">
			<tr class="DataTableRowHeading"><td nowrap width="75%" align="center">Reservation Date</td><td align="center">Resource</td><td align="center">Number of People</td><td align="center">Name</td><td align="center">Phone</td><td align="center">Email</td><td align="center">Updated Date</td></tr>
<cfloop query="getReserveByResource_Keyqry" startrow="#request.startrow#" endrow="#request.endrow#">
<cfset status="">
			<cfif getReserveByResource_Keyqry.CurrentRow MOD 2><tr class="DataTableRowOdd"><cfelse><tr class="DataTableRowEven"></cfif><!--- <td align="center"><input type="radio" name="Reserve_Key" value="#getReserveByResource_Keyqry.Reserve_Key#"></td>
			<td onMouseDown="selectradio(document.List.Reserve_Key, #evaluate(getReserveByResource_Keyqry.currentrow-request.startrow)#)" title="click to select" nowrap="nowrap"> ---><td nowrap="nowrap">#DateFormat(getReserveByResource_Keyqry.Reserve_Schedule_Date, "ddd m/d")#&nbsp;#request.layoutObj.doTimeFormat(getReserveByResource_Keyqry.Reserve_Schedule_Date)#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Resource_Short_Name# #getReserveByResource_Keyqry.Service_Alt_Name#</td><td nowrap="nowrap" align="center">#getReserveByResource_Keyqry.Reserve_NumberOfPeople#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Reserve_Name#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Reserve_Phone#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Reserve_Email#</td><td nowrap="nowrap">#DateFormat(getReserveByResource_Keyqry.Reserve_Add_ts, "m/d")#&nbsp;#request.layoutObj.doTimeFormat(getReserveByResource_Keyqry.Reserve_Add_ts)#</td></tr>
</cfloop>
		</table></td></tr>
	
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
<!---
		<tr><td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr><td><input type="submit" name="button" value="Change"><input type="submit" name="button" value="Remove"><input type="submit" name="button" value="Add"></td></tr>
		</table></td></tr>
--->
	</table><input name="Resource" type="hidden" value="#request.Resource_Key#"><input name="Resource2" type="hidden" value="#request.Resource_Key2#"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="List"></form></td></tr>
</table>
</cfcase>

<cfcase value="ListTotals">
<table border="0" cellpadding="0" cellspacing="0">
<!---	<tr><td>Manage your business reservations.</td></tr> --->
	<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
	<tr><td><form name="#newForm#" action="#request.snipObj.getURL("index.cfm", "reserve-list", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td>#request.layoutObj.doPageNavigator(name="Reservations", text="Reservation", total=getReserveByResource_Keyqry.recordcount, page=100, start="begin")#</td></tr>
		<tr><td><table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" class="DataTable">
			<tr class="DataTableRowHeading"><td nowrap width="75%" align="center">Reservation Date</td><td align="center">Resource</td><td align="center">Number of People</td></tr>
<cfloop query="getReserveByResource_Keyqry" startrow="#request.startrow#" endrow="#request.endrow#">
<cfset status="">
			<cfif getReserveByResource_Keyqry.CurrentRow MOD 2><tr class="DataTableRowOdd"><cfelse><tr class="DataTableRowEven"></cfif><!--- <td align="center"><input type="radio" name="Reserve_Key" value="#getReserveByResource_Keyqry.Reserve_Key#"></td>
			<td onMouseDown="selectradio(document.List.Reserve_Key, #evaluate(getReserveByResource_Keyqry.currentrow-request.startrow)#)" title="click to select" nowrap="nowrap"> ---><td nowrap="nowrap">#DateFormat(getReserveByResource_Keyqry.Reserve_Schedule_Date, "ddd m/d")#&nbsp;#request.layoutObj.doTimeFormat(getReserveByResource_Keyqry.Reserve_Schedule_Date)#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Resource_Short_Name# #getReserveByResource_Keyqry.Service_Alt_Name#</td><td nowrap="nowrap" align="center">#getReserveByResource_Keyqry.totals#</td></tr>
</cfloop>
		</table></td></tr>
	
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
<!---
		<tr><td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr><td><input type="submit" name="button" value="Change"><input type="submit" name="button" value="Remove"><input type="submit" name="button" value="Add"></td></tr>
		</table></td></tr>
--->
	</table><input name="Resource" type="hidden" value="#request.Resource_Key#"><input name="Resource2" type="hidden" value="#request.Resource_Key2#"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="ListTotals"></form></td></tr>
</table>
</cfcase>

<cfcase value="ListVouchers">
<table border="0" cellpadding="0" cellspacing="0">
<!---	<tr><td>Manage your business reservations.</td></tr> --->
	<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
	<tr><td><form name="#newForm#" action="#request.snipObj.getURL("index.cfm", "reserve-list", false)#" method=post><table border="0" cellpadding="0" cellspacing="0">
		<tr><td>#request.layoutObj.doPageNavigator(name="Reservations", text="Reservation", total=getReserveByResource_Keyqry.recordcount, page=100, start="begin")#</td></tr>
		<tr><td><table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" class="DataTable">
			<tr class="DataTableRowHeading"><td nowrap width="75%" align="center">Reservation Date</td><td align="center">Resource</td><td align="center">Number of People</td><td align="center">Name</td><td align="center">Phone</td><td align="center">Email</td><td align="center">Voucher</td></tr>
<cfloop query="getReserveByResource_Keyqry" startrow="#request.startrow#" endrow="#request.endrow#">
<cfset status="">
			<cfif getReserveByResource_Keyqry.CurrentRow MOD 2><tr class="DataTableRowOdd"><cfelse><tr class="DataTableRowEven"></cfif><!--- <td align="center"><input type="radio" name="Reserve_Key" value="#getReserveByResource_Keyqry.Reserve_Key#"></td>
			<td onMouseDown="selectradio(document.List.Reserve_Key, #evaluate(getReserveByResource_Keyqry.currentrow-request.startrow)#)" title="click to select" nowrap="nowrap"> ---><td nowrap="nowrap">#DateFormat(getReserveByResource_Keyqry.Reserve_Schedule_Date, "ddd m/d")#&nbsp;#request.layoutObj.doTimeFormat(getReserveByResource_Keyqry.Reserve_Schedule_Date)#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Resource_Short_Name# #getReserveByResource_Keyqry.Service_Alt_Name#</td><td nowrap="nowrap" align="center">#getReserveByResource_Keyqry.Reserve_NumberOfPeople#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Reserve_Name#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Reserve_Phone#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.Reserve_Email#</td><td nowrap="nowrap">#getReserveByResource_Keyqry.ReserveGroupon_Voucher# <cfif len(getReserveByResource_Keyqry.ReserveGroupon_Redeam) >/ #getReserveByResource_Keyqry.ReserveGroupon_Redeam#</cfif></td></tr>
</cfloop>
		</table></td></tr>
	
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
<!---
		<tr><td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr><td><input type="submit" name="button" value="Change"><input type="submit" name="button" value="Remove"><input type="submit" name="button" value="Add"></td></tr>
		</table></td></tr>
--->
	</table><input name="Resource" type="hidden" value="#request.Resource_Key#"><input name="Resource2" type="hidden" value="#request.Resource_Key2#"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="ListVouchers"></form></td></tr>
</table>
</cfcase>

</cfswitch>

<table border="0" cellpadding="0" cellspacing="5">
	<tr><td>
	<cfset data="<span class=""emphasis"">Reservation Information</span>">
	<table width=260 align="left" border="0" cellpadding="0" cellspacing="5">
		<tr><td>#request.layoutObj.doTable(data="#data#", class="DataTable")#</td></tr>
		<tr><td>&nbsp;<a href="#request.snipObj.getURL("index.cfm", "reserve-list",false,"list=List&resource=#request.Resource_Key#&resource2=#request.Resource_Key2#")#">Reservations</a></td></tr>
		<tr><td>&nbsp;<a href="#request.snipObj.getURL("index.cfm", "reserve-list",false,"list=ListTotals&resource=#request.Resource_Key#&resource2=#request.Resource_Key2#")#">Reservations total by date/time</a></td></tr>
		<tr><td>&nbsp;<a href="#request.snipObj.getURL("index.cfm", "reserve-list",false,"list=ListVouchers&resource=#request.Resource_Key#&resource2=#request.Resource_Key2#")#">Reservation Voucher Details</a></td></tr>
	</table>
</td></tr></table>


</cfoutput>