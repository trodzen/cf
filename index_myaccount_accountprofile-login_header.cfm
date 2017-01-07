<cfsilent>
<cfset request.title="Account Profile - Log In">
<cfset request.pageheader="Change your Log in ID">
<cfparam name="newLogin" default="">
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfset newLogin="#request.Login_ID#">
<cfinvoke component="#request.snipObj#" method="doSubmitKey">
</cfsilent>