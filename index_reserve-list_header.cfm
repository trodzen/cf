<cfsilent>
<cfset request.title="Reservation - List">
<cfset request.pageheader="Current Reservations">
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfinvoke component="#request.snipObj#" method="doSubmitKey">
<cfparam name="newForm" default="List">
<cfparam name="request.Resource_Key2" default="0">
<cfswitch expression="#newForm#">
<cfcase value="Change,Remove">
		<cfinvoke component="#request.db_LocationObj#" method="getLocationByLocation_Key" returnvariable="getLocationByLocation_Keyqry">
		<cfinvokeargument name="Location_Key" value="#newLocation_Key#">
		</cfinvoke>
		<cfif getLocationByLocation_Keyqry.recordcount IS NOT 1>
			<cfset newForm="List">
			<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
		</cfif>
	<cfset newLocation_Name="#getLocationByLocation_Keyqry.Location_Name#">
	<cfset newLocation_Link="#getLocationByLocation_Keyqry.Location_Link#">
</cfcase>
</cfswitch>
<cfswitch expression="#newForm#">
<cfcase value="List">
	<cfinvoke component="#request.db_ReserveObj#" method="getReserveByResource_Key" returnvariable="getReserveByResource_Keyqry">
	<cfinvokeargument name="Resource_Key" value="#request.Resource_Key#">
	<cfinvokeargument name="Resource_Key2" value="#request.Resource_Key2#">
	</cfinvoke>
	<cfif getReserveByResource_Keyqry.recordcount IS 0>
		<cfset newForm="Add">
	</cfif>
</cfcase>
<cfcase value="ListTotals">
	<cfinvoke component="#request.db_ReserveObj#" method="getReserveByResourceTotals_Key" returnvariable="getReserveByResource_Keyqry">
	<cfinvokeargument name="Resource_Key" value="#request.Resource_Key#">
	<cfinvokeargument name="Resource_Key2" value="#request.Resource_Key2#">
	</cfinvoke>
	<cfif getReserveByResource_Keyqry.recordcount IS 0>
		<cfset newForm="Add">
	</cfif>
</cfcase>
<cfcase value="ListVouchers">
	<cfinvoke component="#request.db_ReserveObj#" method="getReserveByResourceVouchers_Key" returnvariable="getReserveByResource_Keyqry">
	<cfinvokeargument name="Resource_Key" value="#request.Resource_Key#">
	<cfinvokeargument name="Resource_Key2" value="#request.Resource_Key2#">
	</cfinvoke>
	<cfif getReserveByResource_Keyqry.recordcount IS 0>
		<cfset newForm="Add">
	</cfif>
</cfcase>
</cfswitch>
</cfsilent>