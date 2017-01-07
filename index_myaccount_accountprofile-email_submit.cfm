<cfsilent>
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfinvoke component="#request.snipObj#" method="doCheckKey">
<cfinvokeargument name="keytype" value="form">
</cfinvoke>
<cfset request.Email_Account_Key=#request.Login_Account_Key#>
<cfif NOT isdefined("form.email_list")>
	<cfif isdefined("form.confirm") OR isdefined("form.remove") OR isdefined("form.makeprimary")>
		<cfset errorList=ArrayAppend(request.errorArray, "You must select an email address.")>
	</cfif>
	<cfelse>
	<cfif isdefined("form.remove") AND ArrayLen(request.errorArray) IS 0>
		<cfset request.Email_Key=#form.email_list#>
		<cfinvoke component="#request.dbObj#" method="getemailbyemail" returnvariable="getemailbyemailqry">
		<cfif getemailbyemailqry.recordcount IS NOT 1>
			<cfset errorList=ArrayAppend(request.errorArray, "System Error. Email not found.")>
			<cfelse>
			
			<!--- can not delete email if it equals the log in ID --->
			<cfinvoke component="#request.dbObj#" method="getLoginByAccount_Key" returnvariable="getLoginByAccount_Keyqry">
			<cfinvokeargument name="Account_Key" value="#getemailbyemailqry.Email_Account_Key#">
			</cfinvoke>
			
			<cfif ListFind(ValueList(getLoginByAccount_Keyqry.Login_ID),getemailbyemailqry.Email_Address)>
				<cfset msgtext="You must <a href=#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-login", false)#>change your log in ID</a> before you can remove this email address.">
				<cfset errorList=ArrayAppend(request.errorArray, msgtext)>
			</cfif>
			<cfif getemailbyemailqry.Email_Primary>
				<cfset errorList=ArrayAppend(request.errorArray, "You can not remove the primary email address.")>
				<cfelse>
				<cfif ArrayLen(request.errorArray) IS 0>
					<cfif isdefined("form.submitconfirmed")>
						<cfinvoke component="#request.dbObj#" method="deleteemail">
						<cfset messageList=ArrayAppend(request.messageArray, "The email address was successfully removed.")>
						<cfelse>
						<cfset confirmdelete=true>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfif isdefined("form.cancel") AND ArrayLen(request.errorArray) IS 0>
	<cfset messageList=ArrayAppend(request.messageArray, "Request cancelled. Your account profile was not changed.")>
</cfif>
<cfif isdefined("form.makeprimary") AND ArrayLen(request.errorArray) IS 0>
	<cfset request.Email_Key=#form.email_list#>
	
	<!--- you can not make an unconfirmed email primary. --->
	
	<cfinvoke component="#request.dbObj#" method="getemailbyemail" returnvariable="getemailbyemailqry">
	<cfif getemailbyemailqry.recordcount IS NOT 1>
		<cfset errorList=ArrayAppend(request.errorArray, "System Error. Email not found.")>
		<cfelse>
		<cfif NOT getemailbyemailqry.Email_Confirmed OR getemailbyemailqry.Email_Disabled>
			<cfif NOT getemailbyemailqry.Email_Primary>
				<cfset errorList=ArrayAppend(request.errorArray, "You must confirm the email address before you can make it primary.<br>Select the email address then press Confirm.")>
			</cfif>
			<cfelse>
			<cfinvoke component="#request.dbObj#" method="updateemailprimary">
			<cfset messageList=ArrayAppend(request.messageArray, "The primary email address was successfully changed.")>
		</cfif>
	</cfif>
</cfif>
<cfif form.submitform IS "add_save" AND NOT isdefined("form.cancel")>
	<cfset newEmail_Address="#form.Email_Address#">
	<cfif NOT isValid("email", "#form.Email_Address#")>
		<cfset errorList=ArrayAppend(request.errorArray, "Please enter a valid email address.")>
	</cfif>
	<cfset request.Email_Address="#form.Email_Address#">
	<cfinvoke component="#request.dbObj#" method="getemail" returnvariable="getemailqry">
	<cfinvokeargument name="email" value="#request.Email_Address#">
	</cfinvoke>
	<cfif getemailqry.recordcount GT 0>
		<cfset msgtext="Email already exists. If this email was created on a different account, you may want to log out and back in on that account. You can also retreive a lost password with the forgot password section of the log in page.">
		<cfset errorList=ArrayAppend(request.errorArray, msgtext)>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset request.Email_Primary=false>
		<cfinvoke component="#request.dbObj#" method="addemail">
		<cfelse>
		<cfset addemail=true>
	</cfif>
</cfif>
<cfif isdefined("form.add")>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset addemail=true>
	</cfif>
</cfif>
<cfif isdefined("form.confirm")>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfset request.Email_Key=#form.email_list#>
		<cfinvoke component="#request.emailObj#" method="doConfirmEmailbykey">
	</cfif>
</cfif>
</cfsilent>