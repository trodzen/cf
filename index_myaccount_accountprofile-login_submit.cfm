<cfsilent>
<cfinvoke component="#request.snipObj#" method="doCheckUser">
<cfinvoke component="#request.snipObj#" method="doCheckKey">
<cfinvokeargument name="keytype" value="form">
</cfinvoke>
<cfif submitform IS "changelogin">
	<cfset request.Login_ID="#lcase(form.login)#">
	<cfif isvalid("email",request.Login_ID)>
		<!--- it can only be an email if the email exists in the account email list --->
		<cfset request.Email_Address=request.Login_ID>
		<cfset request.Email_Account_Key=request.Login_Account_Key>
		<cfinvoke component="#request.dbObj#" method="getemailaddressbyaccount" returnvariable="getemailaddressbyaccountqry">
		<cfif getemailaddressbyaccountqry.recordcount IS NOT 1>
			<cfset msgtext="You must first, <a href=#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-email", true, "add=true")#>add the email address</a> to your list of email addresses.">
			<cfset errorList=ArrayAppend(request.errorArray, msgtext)>
		</cfif>
		<cfelse>
		<cfset charset="a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,_,-">
		<cfif len(request.Login_ID) LT 4 OR YesNoFormat(Len(ReplaceList(lcase(request.Login_ID),charset,"")))>
			<cfset errorList=ArrayAppend(request.errorArray, "Please enter a valid Log in ID.")>
		</cfif>
	</cfif>
	<cfif ArrayLen(request.errorArray) IS 0>
		<cfinvoke component="#request.dbObj#" method="SetLogin">
		<!--- set Account Name --->
		<cfset request.newAccount_Key=request.Login_Account_Key>
		<cfset request.newAccount_Name=request.Login_ID>
		<cfinvoke component="#request.dbObj#" method="updateaccountnamebykey">
		<cfset request.Account_Name=request.Login_ID>
		<!--- relog in under new login id --->
		<cfinvoke component="#request.dbObj#" method="getLogin" returnvariable="getLoginqry">
		<cfset request.Login_Password="#getLoginqry.Login_password#">
		<cfinclude template="#request.templatepath#/loginuser.cfm">
		<cfset messageList=ArrayAppend(request.messageArray, "Your Log in ID was successfully changed.")>
		<cfset messageList=ArrayAppend(request.messageArray, "Remember, you will now <span class=""emphasis"">LOGIN with this new ID</span>.")>
	</cfif>
</cfif>
</cfsilent>