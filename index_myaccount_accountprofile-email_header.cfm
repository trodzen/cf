<cfsilent>
<cfset request.title="Account Profile - Email">
<cfset request.pageheader="Email">
<cfparam name="confirmdelete" default=false>
<cfparam name="addemail" default=false>
<cfparam name="newEmail_Address" default="">
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfif isdefined("url.add") AND ArrayLen(request.errorArray) IS 0>
	<cfset addemail=true>
</cfif>
<cfif NOT confirmdelete AND NOT addemail>
	<cfset request.Email_Account_Key=#request.Login_Account_Key#>
	<cfinvoke component="#request.dbObj#" method="getemailbyaccount" returnvariable="getemailbyaccountqry">
</cfif>
<cfinvoke component="#request.snipObj#" method="doSubmitKey">
</cfsilent>