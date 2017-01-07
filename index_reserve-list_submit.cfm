<cfsilent>
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfinvoke component="#request.snipObj#" method="doCheckKey">
	<cfinvokeargument name="keytype" value="form">
</cfinvoke>
<cfset newForm="#form.submitform#">
<cfswitch expression="#newForm#">

<!--- Add or Change form --->
<cfcase value="Add,Change">
<cfset newLocation_Name="#form.Location_Name#">
<cfset newLocation_Link="#form.Location_Link#">
<cfif form.button IS "Cancel">
	<!--- Cancel button --->
	<cfset messageList=ArrayAppend(request.messageArray, "Request cancelled.")>
	<cfset NewForm="List">
<cfelse>
	<!--- Save button --->
	<cfif len(newLocation_Name) IS 0>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter a valid Location Name.")>
	</cfif>
	<cfif len(newLocation_Link) AND isValid("URL",newLocation_Link) IS false>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter a valid Location URL Link.")>
	</cfif>
	<cfif newForm IS "Add">
		<cfset exclude_Key="">
	<cfelse>
		<cfset newLocation_Key="#form.Location_Key#">
		<cfset exclude_Key="#form.Location_Key#">
	</cfif>
	<cfinvoke component="#request.db_LocationObj#" method="getLocationByLocation_Name" returnvariable="getLocationByLocation_Nameqry">
	<cfinvokeargument name="Location_Name" value="#newLocation_Name#">
	<cfinvokeargument name="Location_Account_Key" value="#request.Account_Key#">
	<cfinvokeargument name="Exclude_Location_Key" value="#exclude_Key#">
	</cfinvoke>
	<cfif getLocationByLocation_Nameqry.recordcount IS 1>
		<cfset errorList=ArrayAppend(request.errorArray, "Record already exists. Please enter a unique Location Name.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfif newForm IS "Add">
			<cfinvoke component="#request.db_LocationObj#" method="insertLocation" returnvariable="Result">
			<cfinvokeargument name="Location_Name" value="#newLocation_Name#">
			<cfinvokeargument name="Location_Link" value="#newLocation_Link#">
			<cfinvokeargument name="Location_Account_Key" value="#request.Account_Key#">
			</cfinvoke>
		<cfelse>
			<cfinvoke component="#request.db_LocationObj#" method="updateLocation_NameByLocation_Key" returnvariable="Result">
			<cfinvokeargument name="Location_Key" value="#newLocation_Key#">
			<cfinvokeargument name="Location_Name" value="#newLocation_Name#">
			<cfinvokeargument name="Location_Link" value="#newLocation_Link#">
			</cfinvoke>
		</cfif>
		<cfif Result.recordcount IS 1>
			<cfset messageList=ArrayAppend(request.messageArray, "Request completed. The record was saved.")>
			<cfset newForm="List">
		<cfelse>
			<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
		</cfif>
	</cfif>
</cfif>
</cfcase>

<!--- Remove form --->
<cfcase value="Remove">
<cfset newLocation_Key="#form.Location_Key#">
<cfif form.button IS "Cancel">
	<!--- Cancel button --->
	<cfset messageList=ArrayAppend(request.messageArray, "Request cancelled.")>
	<cfset newForm="List">
<cfelse>
	<!--- Remove button --->
	<cfinvoke component="#request.db_LocationObj#" method="deleteLocationByLocation_Key" returnvariable="Result">
	<cfinvokeargument name="Location_Key" value="#newLocation_Key#">
	</cfinvoke>
	<cfif Result.recordcount IS 1>
		<cfset messageList=ArrayAppend(request.messageArray, "Request completed. The record was removed.")>
		<cfset newForm="List">
	<cfelse>
		<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
	</cfif>
</cfif>
</cfcase>

<!--- List form --->
<cfcase value="List,ListTotals,ListVouchers">
<cfset request.Resource_Key="#form.resource#">
<cfset request.Resource_Key2="#form.resource2#">
<cfif isdefined("form.button")>
<cfswitch expression="#form.button#">
<!--- Add button --->
<cfcase value="Add">
	<cfset newForm="#form.button#">
</cfcase>
<!--- Change or Remove button --->
<cfcase value="Change,Remove">
	<!--- no select --->
	<cfif NOT isdefined("form.Location_Key")>
		<cfset errorList=ArrayAppend(request.errorArray, "You must select the item you want to #lcase(form.button)#.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset newLocation_Key=form.Location_Key>
		<cfset newForm="#form.button#">
	</cfif>
</cfcase>
</cfswitch>
</cfif>
</cfcase>

<!--- Custom Layout Design form --->
<cfcase value="Custom Layout Design">
<cfset newLocation_Key="#form.Location_Key#">
<cfset newLocation_Support_Email="#form.Location_Support_Email#">
<cfset newLocation_Tag_Line="#form.Location_Tag_Line#">
<cfif form.button IS "Cancel">
	<!--- Cancel button --->
	<cfset messageList=ArrayAppend(request.messageArray, "Request cancelled.")>
	<cfset NewForm="List">
<cfelse>
	<!--- Save button --->
	<cfif NOT isValid("email",newLocation_Support_Email)>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter a valid email address.")>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfinvoke component="#request.db_LocationObj#" method="updateLocation_LayoutByLocation_Key" returnvariable="Result">
		<cfinvokeargument name="Location_Key" value="#newLocation_Key#">
		<cfinvokeargument name="Location_Support_Email" value="#newLocation_Support_Email#">
		<cfinvokeargument name="Location_Tag_Line" value="#newLocation_Tag_Line#">
		</cfinvoke>
		<cfif Result.recordcount IS 1>
			<cfset messageList=ArrayAppend(request.messageArray, "Request completed. The record was saved.")>
			<cfset newForm="List">
		<cfelse>
			<cfset errorList=ArrayAppend(request.errorArray, "System Error. Try again or report the issue.")>
		</cfif>
	</cfif>
</cfif>
</cfcase>

</cfswitch>
</cfsilent>