<cfcomponent extends="db_Functions" output="no">

<!--- init --->
<cffunction name="init" access="public" output="no">
<cfreturn this>
</cffunction>

<!--- get getPageByPage_Name --->
<cffunction name="getPageContentByPage_Name" output="no">
<cfargument name="Page_Name" required="yes">
<cfargument name="Merchant_shortName" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Page 
LEFT OUTER JOIN Account ON (Page_Account_Key = Account_Key)
LEFT OUTER JOIN Merchant ON (Account_Key = Merchant_Account_Key)
WHERE Page_Name #where(iseq, arguments.Page_Name, ischar)# AND Merchant_shortName #where(iseq, arguments.Merchant_shortName, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!---  application_setvariables --->
<cffunction name="getHostName" output="no">
<cfargument name="HostName" required="yes">
<cfset request.qry="SELECT * FROM HostName
LEFT OUTER JOIN Merchant ON (Host_Merchant_Key = Merchant_Key)
WHERE Host_Name #where(iseq, arguments.HostName, ischar)#">
<cftry>
<cfquery name="query" datasource="#application.dsn#" timeout="10">
SELECT * FROM HostName
LEFT OUTER JOIN Merchant ON (Host_Merchant_Key = Merchant_Key)
WHERE Host_Name #where(iseq, arguments.HostName, ischar)#
</cfquery>
<cfcatch>
	<cfset errorList=ArrayAppend(request.errorArray, "System Error. Get Host Name.")>
	<cfset query="">
</cfcatch>
</cftry>
<cfreturn query>
</cffunction>

<!--- loginuser --->
<cffunction name="validatelogin" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Login WHERE Login_ID #where(iseq, request.Login, ischar)# AND Login_Password #where(iseq, request.Login_Password, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- loginuser --->
<cffunction name="getnonconfirmemail" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Account_Key #where(iseq, request.Email_Account_Key, isint)# AND Email_Confirmed #where(iseq, false, isbit)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- loginuser, logout --->
<cffunction name="updatelogin" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Login SET Login_Total_Hit #set(iseq, request.Login_Total_Hit, isint)#, Login_Last_Hit_ts #set(iseq, DateConvert("local2utc", Now()), ists)# WHERE Login_Key #where(iseq, request.Login_Key, isint)#
</cfquery>
</cffunction>

<!--- loginuser.cfm --->
<cffunction name="validateaccountbyID" output="no">
<cfargument name="Login_ID" required="yes">
<cfargument name="Login_Password" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account
LEFT OUTER JOIN Login ON (Account_Key = Login_Account_Key)
WHERE Login_ID #where(iseq, arguments.Login_ID, ischar)# AND Login_Password #where(iseq, arguments.Login_Password, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- loginuser.cfm --->
<cffunction name="validateaccountbyEmail" output="no">
<cfargument name="Login_Email" required="yes">
<cfargument name="Login_Password" required="yes">
<cfinvoke method="getemail" returnvariable="emailqry">
<cfinvokeargument name="email" value="#arguments.Login_Email#">
</cfinvoke>
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account
LEFT OUTER JOIN Login ON (Account_Key = Login_Account_Key)
WHERE Account_Key #where(iseq, emailqry.Email_Account_Key, isint)# AND Login_Password #where(iseq, arguments.Login_Password, ischar)# AND Login_Primary #where(iseq, "true", isbit)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- snip.CheckUserLogin --->
<cffunction name="validateaccountbyKey" output="no">
<cfargument name="Login_Key" required="yes">
<cfargument name="Login_Password" required="yes">
<cfquery name="request.query" datasource="#application.dsn#" timeout="5">
SELECT * FROM Account
LEFT OUTER JOIN Login ON (Account_Key = Login_Account_Key)
WHERE Login_Key #where(iseq, arguments.Login_Key, isint)# AND Login_Password #where(iseq, arguments.Login_Password, ischar)#
</cfquery>
<cfreturn request.query>
</cffunction>

<!--- signup --->
<cffunction name="signupaccount" output="no">
<cfargument name="Login_ID" required="yes">

<!--- make sure there is a valid redir --->
<cfset tempreferredby="">
<cfif isdefined("cookie.referredby")>
	<cfinvoke component="#request.dbObj#" method="getaccount" returnvariable="testaccountqry">
	<cfinvokeargument name="Account_Key" value="#cookie.referredby#">
	</cfinvoke>
	<cfif testaccountqry.recordcount IS 1 AND testaccountqry.Account_Disabled[1] IS false>
		<cfset tempreferredby="#cookie.referredby#">
	</cfif>
</cfif>

<cftransaction>
<cfquery name="query" datasource="#application.dsn#">
INSERT INTO Account (Account_Name, Account_Disabled, Account_Balance, Account_ReferredBy_Key) VALUES (#values(arguments.Login_ID, ischar)#, #values("false", isbit)#, 0, #values(tempreferredby, isint)#)
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cftransaction>
<cfreturn query>
</cffunction>

<!--- signupaccount --->
<cffunction name="getaccount" output="no">
<cfargument name="Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account WHERE Account_Key #where(iseq, arguments.Account_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- signup --->
<cffunction name="addlogin" output="no">
<cftransaction>
<cfquery name="query" datasource="#application.dsn#">
INSERT INTO Login (Login_ID, Login_Password, Login_Total_Hit, Login_First_Hit_ts, Login_Last_Hit_ts, Login_Roles, Login_Agree_ts, Login_Contact_Me, Login_Account_Key, Login_Primary) VALUES (#values(request.Login_ID, ischar)#, #values(request.Login_Password, ischar)#, #values(1, isint)#, #values(DateConvert("local2utc", Now()), ists)#, #values(DateConvert("local2utc", Now()), ists)#, #values("user", ischar)#, #values(DateConvert("local2utc", Now()), ists)#, #values(request.Login_Contact_Me, isbit)#, #values(request.Login_Account_Key, isint)#, 1)
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cftransaction>
<cfreturn query>
</cffunction>

<!--- signup, myaccount_accoutprofile-email --->
<cffunction name="addemail" output="no">
<cftransaction>
<cfquery name="query" datasource="#application.dsn#">
INSERT INTO Email (Email_Account_Key, Email_Address, Email_Primary, Email_Confirmed, Email_Disabled, Email_Update_ts) VALUES (#values(request.Email_Account_Key, isint)#, #values(request.Email_Address, ischar)#, #values(request.Email_Primary, isbit)#, #values("false", isbit)#, #values("false", isbit)#, #values(DateConvert("local2utc", Now()), ists)#)
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cftransaction>
<cfset request.Email_Key=query.Identity>
<!--- send email confirm --->
<cfinvoke component="#request.emailObj#" method="doConfirmEmailbyaddress">
<cfinvokeargument name="email" value="#request.Email_Address#">
</cfinvoke>
</cffunction>

<!--- doConfirmEmailbyaddress --->
<cffunction name="updateemailconfirmkey" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Email SET Email_Confirm_Key #set(iseq, request.Email_Confirm_Key, isint)# WHERE Email_Key #where(iseq, request.Email_Key, isint)#
</cfquery>
</cffunction>

<!--- email cfc doConfirmEmailbyaddress --->
<cffunction name="getemail" output="no">
<cfargument name="email" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Address #where(iseq, arguments.email, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-email_submit --->
<cffunction name="getemailbyconfirm" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Key #where(iseq, request.Email_Key, isint)# AND Email_Confirm_Key #where(iseq, request.Email_Confirm_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-email_submit --->
<cffunction name="updateemailbyconfirm" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Email SET Email_Confirmed #set(iseq, "true", isbit)#, Email_Confirm_ts #set(iseq, DateConvert("local2utc", Now()), ists)#, Email_Disabled #set(iseq, "false", isbit)# WHERE Email_Key #where(iseq, request.Email_Key, isint)# AND Email_Confirm_Key #where(iseq, request.Email_Confirm_Key, isint)#
</cfquery>
</cffunction>

<!--- myaccount_accountprofile-login --->
<cffunction name="updateaccountnamebykey" output="no">
<cfquery name="query" datasource="#application.dsn#" result="qry">
UPDATE Account SET Account_Name #set(iseq, request.newAccount_Name, ischar)# WHERE Account_Key #where(iseq, request.newAccount_Key, isint)#
</cfquery>
<cfreturn qry>
</cffunction>

<!--- myaccount_accountprofile-password, resetpassword --->
<cffunction name="SetPassword" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Login SET Login_Password #set(iseq, request.Login_Password, ischar)# WHERE Login_Key #where(iseq, request.Login_Key, isint)#
</cfquery>
</cffunction>

<!--- myaccount_accountprofile-security --->
<cffunction name="getSecurityQuestionbycode" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM SecurityQuestion WHERE Sec_Login_Key #where(iseq, request.Sec_Login_Key, isint)# AND Sec_Question #where(iseq, request.Sec_Question, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-security --->
<cffunction name="deleteSecurityQuestionbylogin" output="no">
<cfquery name="query" datasource="#application.dsn#" result="qry">
DELETE FROM SecurityQuestion WHERE Sec_Login_Key #where(iseq, request.Sec_Login_Key, isint)#
</cfquery>
<cfreturn qry>
</cffunction>

<!--- myaccount_accountprofile-security --->
<cffunction name="insertSecurityQuestion" output="no">
<cfquery name="query" datasource="#application.dsn#">
INSERT INTO SecurityQuestion (Sec_Login_Key, Sec_Question, Sec_Answer, Sec_Update_ts) VALUES (#values(request.Sec_Login_key, isint)#, #values(request.Sec_Question, ischar)#, #values(request.Sec_Answer, ischar)#, #values(DateConvert("local2utc", Now()), ists)#)
</cfquery>
</cffunction>

<!--- get standards --->
<cffunction name="getStd" output="no">
<cfargument name="Collection" required="yes">
<cfargument name="Sort" default="Std_Sort">
<cfswitch expression="#arguments.Sort#">
<cfcase value="Std_Code DESC">
<cfset sortText="Std_Code DESC, Std_Sort DESC">
</cfcase>
<cfcase value="Std_Code">
<cfset sortText="Std_Code, Std_Sort">
</cfcase>
<cfdefaultcase>
<cfset sortText="Std_Sort, Std_Code">
</cfdefaultcase>
</cfswitch>
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Standards WHERE Std_Collection #where(iseq, arguments.Collection, ischar)# ORDER BY #sortText#
</cfquery>
<cfreturn query>
</cffunction>






<!--- prob need these --->

<!--- forgotpassword --->
<cffunction name="updateloginaccess" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Login SET Login_Access_Code #set(iseq, request.Login_Access_Code, isint)#, Login_Access_Code_ts #set(iseq, DateConvert("local2utc", Now()), ists)# WHERE Login_Key #where(iseq, request.Login_Key, isint)#
</cfquery>
</cffunction>

<!--- delete email --->
<cffunction name="deleteemail" output="no">
<cfquery name="query" datasource="#application.dsn#" result="qry">
DELETE FROM Email WHERE Email_Key #where(iseq, request.Email_Key, isint)#
</cfquery>
<cfreturn qry>
</cffunction>

<!--- update email primary
used in: myaccount_accountprofile-email
--->
<cffunction name="updateemailprimary" output="no">

<cfinvoke method="getPrimaryEmailByEmailAccountKey" returnvariable="PrimaryEmailQry">
<cfinvokeargument name="Email_Account_Key" value="#request.Email_Account_Key#">
</cfinvoke>

<cfquery name="query" datasource="#application.dsn#">
UPDATE Email SET Email_Primary #set(iseq, "false", isbit)#, Email_Update_ts #set(iseq, DateConvert("local2utc", Now()), ists)# WHERE Email_Account_Key #where(iseq, request.Email_Account_Key, isint)# AND Email_Primary #where(iseq, "true", isbit)#
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
UPDATE Email SET Email_Primary #set(iseq, "true", isbit)# WHERE Email_Key #where(iseq, request.Email_Key, isint)#
</cfquery>

<!--- if login is primary email then change login to new primary email --->
<cfif PrimaryEmailQry.recordcount IS 1 AND PrimaryEmailQry.Account_Name IS PrimaryEmailQry.Email_Address>
	<cfinvoke method="getEmailByEmailKey" returnvariable="EmailByEmailKeyQry">
	<cfinvokeargument name="Email_Key" value="#request.Email_Key#">
	</cfinvoke>
	<cfset request.Login_ID="#EmailByEmailKeyQry.Email_Address#">
	<cfinvoke method="SetLogin">
	<cfset request.newAccount_Key=request.Login_Account_Key>
	<cfset request.newAccount_Name=request.Login_ID>
	<cfinvoke method="updateaccountnamebykey">
	<cfset request.Account_Name=request.Login_ID>
	<!--- relog in under new login id --->
	<cfinvoke method="getLogin" returnvariable="getLoginqry">
	<cfset request.Login_Password="#getLoginqry.Login_password#">
	<cfinclude template="#request.templatepath#/loginuser.cfm">
</cfif>

</cffunction>

<!--- myaccount_accountprofile-email --->
<cffunction name="getPrimaryEmailByEmailAccountKey" output="no">
<cfargument name="Email_Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account
LEFT OUTER JOIN Email ON (Account_Key = Email_Account_Key) WHERE Email_Account_Key #where(iseq, arguments.Email_Account_Key, isint)# AND Email_Primary #where(iseq, true, isbit)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-email --->
<cffunction name="getEmailByEmailKey" output="no">
<cfargument name="Email_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Key #where(iseq, arguments.Email_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- loginuser, logout --->
<cffunction name="updateloginaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Login SET Login_Last_Account_Key #set(iseq, request.Account_Key, isint)# WHERE Login_Key #where(iseq, request.Login_Key, isint)#
</cfquery>
</cffunction>

<!--- myaccount_accountprofile-login --->
<cffunction name="SetLogin" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Login SET Login_ID #set(iseq, request.Login_ID, ischar)# WHERE Login_Key #where(iseq, request.Login_Key, isint)#
</cfquery>
</cffunction>

<!--- myaccount_accountprofile-timezone --->
<cffunction name="SetTimeZone" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Account SET Account_tz #set(iseq, request.Display_tz, ischar)# WHERE Account_Key #where(iseq, request.Account_Key, isint)#
</cfquery>
</cffunction>












<!--- dont know if i need these --->

<!--- Update Standard Settings --->
<cffunction name="updatestd" output="no">
<cfargument name="standard" required="yes">
<cfargument name="code" required="yes">
<cfargument name="value" required="yes">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Standards SET Std_Usage #set(iseq, arguments.value, ischar)# WHERE Std_Standard #where(iseq, arguments.standard, ischar)# AND Std_Code #where(iseq, arguments.code, isint)#; SELECT @@ROWCOUNT AS 'rowcount'
</cfquery>
<cfif query.rowcount IS 0>
<!--- create the bloggers standard record if it does not already exist --->
<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO Standards (Std_Standard, Std_Sort, Std_Code, Std_Usage) VALUES (#values(arguments.standard, ischar)#, #values(arguments.code, isint)#, #values(arguments.code, isint)#, #values(arguments.value, ischar)#); SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cfif>
</cffunction>

<!--- news --->
<cffunction name="getnews" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM News ORDER BY News_Update_ts
</cfquery>
<cfreturn query>
</cffunction>

<!--- news --->
<cffunction name="getnewsnonexpired" output="no">
<!--- hold in application memory --->
<cfquery name="nonexpired" datasource="#application.dsn#">
SELECT * FROM News WHERE News_Expire_ts #where(isgt, dateconvert("local2utc", Now()), ists)# OR News_Expire_ts IS NULL ORDER BY News_Expire_ts
</cfquery>
<cfquery name="Lobby_nonexpired" dbtype="query">
SELECT * FROM nonexpired WHERE News_isLobby #where(iseq, true, isbit)# ORDER BY News_Expire_ts
</cfquery>
<cfquery name="Cashier_nonexpired" dbtype="query">
SELECT * FROM nonexpired WHERE News_isCashier #where(iseq, true, isbit)# ORDER BY News_Expire_ts
</cfquery>
<cfquery name="EmailTag_nonexpired" dbtype="query">
SELECT * FROM nonexpired WHERE News_isEmailTag #where(iseq, true, isbit)# ORDER BY News_Expire_ts
</cfquery>
<cfquery name="nextexpire" dbtype="query">
SELECT * FROM nonexpired WHERE News_Expire_ts IS NOT NULL ORDER BY News_Expire_ts
</cfquery>
<cfif nextexpire.recordcount GT 0 AND isdate(nextexpire.News_Expire_ts[1])>
	<cfset nextexpire=dateconvert("utc2local",nextexpire.News_Expire_ts[1])>
<cfelse>
	<!--- reload the news file once a week - just in case --->
	<cfset nextexpire=dateadd("d",7,Now())>
</cfif>
<cflock name="News" type="exclusive" throwontimeout="yes" timeout="10">
	<cfset application.LobbyNews=Lobby_nonexpired>
	<cfset application.CashierNews=Cashier_nonexpired>
	<cfset application.EmailTagNews=EmailTag_nonexpired>
	<cfset application.News_Expire_ts=nextexpire>
</cflock>

</cffunction>

<!--- play_lobby --->
<cffunction name="insertHideNews" output="no">
<cfargument name="Item_Key" required="yes">
<cfargument name="Login_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
UPDATE NewsHide SET HideNews_Update_ts #set(iseq, DateConvert("local2utc", Now()), ists)# WHERE HideNews_Item_Key #where(iseq, arguments.Item_Key, isint)# AND HideNews_Login_Key #where(iseq, arguments.Login_Key, isint)#; SELECT @@ROWCOUNT AS 'rowcount'
</cfquery>
<cfif query.rowcount IS 0>
<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO NewsHide (HideNews_Item_Key, HideNews_Login_Key, HideNews_Update_ts) VALUES (#values(arguments.Item_Key, isint)#, #values(arguments.Login_Key, isint)#, #values(DateConvert("local2utc", Now()), ists)#); SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cfif>
<cfset request.Filter_HideNews=ListAppend(request.Filter_HideNews, arguments.Item_Key)>
<cfcookie name="Filter_HideNews" value="#request.Filter_HideNews#" domain=".#request.domain#">
</cffunction>

<!--- play_lobby --->
<cffunction name="deleteHideNews" output="no">
<cfargument name="Login_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
DELETE FROM NewsHide WHERE HideNews_Login_Key #where(iseq, arguments.Login_Key, isint)#
</cfquery>
<cfset request.Filter_HideNews="">
<cfcookie name="Filter_HideNews" value="#request.Filter_HideNews#" domain=".#request.domain#">
</cffunction>

<!--- loginuser --->
<cffunction name="getHideNews" output="no">
<cfargument name="Login_Key" required="yes">
<cfquery name="getHideNews" datasource="#application.dsn#">
SELECT * FROM NewsHide 
LEFT OUTER JOIN News ON (HideNews_Item_Key = News_Key)
WHERE HideNews_Login_Key #where(iseq, arguments.Login_Key, isint)# AND (News_Expire_ts #where(isgt, dateconvert("local2utc", Now()), ists)# OR News_Expire_ts IS NULL)
</cfquery>
<cfset request.Filter_HideNews=ValueList(getHideNews.HideNews_Item_Key)>
<cfcookie name="Filter_HideNews" value="#request.Filter_HideNews#" domain=".#request.domain#">
</cffunction>

<!--- news --->
<cffunction name="getnewsitem" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM News WHERE News_Key #where(iseq, request.newNews_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- news --->
<cffunction name="insertnewsitem" output="no">
<cftransaction>
<cfquery name="query" datasource="#application.dsn#">
INSERT INTO News (News_Header, News_Detail, News_isLobby, News_isCashier, News_isEmailTag, News_Expire_ts, News_Update_ts) VALUES (#values(request.newNews_Header, ischar)#, #values(request.newNews_Detail, ischar)#, #values(request.newNews_isLobby, isbit)#, #values(request.newNews_isCashier, isbit)#, #values(request.newNews_isEmailTag, isbit)#, #values(request.newNews_Expire_ts, ists)#, #values(DateConvert("local2utc", Now()), ists)#)
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
SELECT @@IDENTITY AS 'Identity'
</cfquery>
</cftransaction>
<cfinvoke method="getnewsnonexpired">
<cfreturn query>
</cffunction>

<!--- news --->
<cffunction name="updatenewsitem" output="no">
<cftransaction>
<cfquery name="query" datasource="#application.dsn#">
UPDATE News SET News_Header #set(iseq, request.newNews_Header, ischar)#, News_Detail #set(iseq, request.newNews_Detail, ischar)#, News_isLobby #set(iseq, request.newNews_isLobby, isbit)#, News_isCashier #set(iseq, request.newNews_isCashier, isbit)#, News_isEmailTag #set(iseq, request.newNews_isEmailTag, isbit)#, News_Expire_ts #set(iseq, request.newNews_Expire_ts, ists)#, News_Update_ts #set(iseq, DateConvert("local2utc", Now()), ists)# WHERE News_Key #where(iseq, request.newNews_Key, isint)#
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
</cftransaction>
<cfinvoke method="getnewsnonexpired">
<cfreturn query>
</cffunction>

<!--- news --->
<cffunction name="deletenewsitem" output="no">
<cftransaction>
<cfquery name="query" datasource="#application.dsn#">
DELETE FROM News WHERE News_Key #where(iseq, request.newNews_Key, isint)#
</cfquery>
<cfquery name="query" datasource="#application.dsn#">
SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
</cftransaction>
<cfinvoke method="getnewsnonexpired">
<cfreturn query>
</cffunction>

<!--- email_list --->
<cffunction name="insertemailfromaccounts" output="no">

<cfparam name="request.newCount_Insert" default=0>

<cfquery name="getemail" datasource="#application.dsn#">
SELECT Email.* FROM Email 
LEFT OUTER JOIN EmailList ON (Email.Email_Address = EmailList.Email_Address)
WHERE EmailList.Email_Address IS NULL
</cfquery>

<cfif getemail.recordcount IS NOT 0>

<cfloop query="getemail">

<!--- double check it doesnt already exist --->
<cfquery name="getemail2" datasource="#application.dsn#">
SELECT * FROM EmailList WHERE Email_Address #where(iseq, getemail.Email_Address, ischar)#
</cfquery>

<cfif getemail2.recordcount IS 0>
<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO EmailList (Email_Address, Email_Tournaments, Email_Secure, Email_Update_ts) VALUES (#values(lcase(getemail.Email_Address), ischar)#, #values(true, isbit)#, #values(false, isbit)#, #values(DateConvert("local2utc", Now()), ists)#); SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>

	<cfset request.newEmail_Update_List=ListAppend(request.newEmail_Update_List,"Insert|#getemail.Email_Address#")>
	<cfset request.newCount_Insert=request.newCount_Insert+1>

</cfif>

</cfloop>

</cfif>
</cffunction>

<!--- email_list --->
<cffunction name="insertemaillist" output="no">
<cfargument name="Email_Address" required="yes">
<cfargument name="Email_Tournaments" required="yes">
<cfargument name="Email_Secure" required="yes">
<cfargument name="Email_From" required="yes">

<cfquery name="getemail" datasource="#application.dsn#">
SELECT * FROM EmailList WHERE Email_Address #where(iseq, arguments.Email_Address, ischar)#
</cfquery>

<cfif getemail.recordcount IS NOT 0>

	<cfif arguments.Email_Secure>
		<!--- secured from future overides by the admin --->
<cfquery name="query" datasource="#application.dsn#">
UPDATE EmailList SET Email_Tournaments #set(iseq, arguments.Email_Tournaments, isbit)#, Email_Secure #set(iseq, arguments.Email_Secure, isbit)#, Email_Update_ts #set(iseq, DateConvert("local2utc", Now()), ists)#
WHERE Email_Address #where(iseq, arguments.Email_Address, ischar)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
		<cfif query.recordcount IS NOT 0>
			<cfset request.newEmail_Update_List=ListAppend(request.newEmail_Update_List,"Update|#arguments.Email_Address#")>
			<cfset request.newCount_Update=request.newCount_Update+query.recordcount>
		</cfif>

	<cfelseif getemail.Email_Secure IS false>
	
		<!--- not prior secured from future overides by the admin --->
<cfquery name="query" datasource="#application.dsn#">
UPDATE EmailList SET Email_Tournaments #set(iseq, arguments.Email_Tournaments, isbit)#, Email_Secure #set(iseq, arguments.Email_Secure, isbit)#, Email_Update_ts #set(iseq, DateConvert("local2utc", Now()), ists)#
WHERE Email_Address #where(iseq, arguments.Email_Address, ischar)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
		<cfif query.recordcount IS NOT 0>
			<cfset request.newEmail_Update_List=ListAppend(request.newEmail_Update_List,"Update|#arguments.Email_Address#")>
			<cfset request.newCount_Update=request.newCount_Update+query.recordcount>
		</cfif>

	<cfelse>
		<cfset request.newEmail_Update_List=ListAppend(request.newEmail_Update_List,"NOT UPDATED|#arguments.Email_Address#")>
	</cfif>
	
<cfelse>

<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO EmailList (Email_Address, Email_Tournaments, Email_Secure, Email_From, Email_Update_ts) VALUES (#values(lcase(arguments.Email_Address), ischar)#, #values(arguments.Email_Tournaments, isbit)#, #values(arguments.Email_Secure, isbit)#, #values(arguments.Email_From, ischar)#, #values(DateConvert("local2utc", Now()), ists)#); SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
	<cfset request.newEmail_Update_List=ListAppend(request.newEmail_Update_List,"Insert|#arguments.Email_Address#")>
	<cfset request.newCount_Insert=request.newCount_Insert+1>

</cfif>
</cffunction>

<!--- affiliates_links --->
<cffunction name="getaffiliatelinkbysite" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM AffiliateLinks 
LEFT OUTER JOIN Sites ON (Sites.Site_Key = AffiliateLinks.Link_Site_Key)
LEFT OUTER JOIN Affiliates ON (Affiliates.Affiliate_Key = AffiliateLinks.Link_Affiliate_Key)
WHERE Link_Account_Key #where(iseq, request.Login_Account_Key, isint)# AND Link_Site_Key #where(iseq, request.newLink_Site_Key, isint)# ORDER BY Site_Name
</cfquery>
<cfreturn query>
</cffunction>

<!--- affiliates_links --->
<cffunction name="getaffiliatelinksbyaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM AffiliateLinks 
LEFT OUTER JOIN Sites ON (Sites.Site_Key = AffiliateLinks.Link_Site_Key)
LEFT OUTER JOIN Affiliates ON (Affiliates.Affiliate_Key = AffiliateLinks.Link_Affiliate_Key)
WHERE Link_Account_Key #where(iseq, request.Login_Account_Key, isint)# ORDER BY Site_Name
</cfquery>
<cfreturn query>
</cffunction>

<!--- affiliates_links --->
<cffunction name="getlink" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM AffiliateLinks 
LEFT OUTER JOIN Sites ON (Sites.Site_Key = AffiliateLinks.Link_Site_Key)
LEFT OUTER JOIN Affiliates ON (Affiliates.Affiliate_Key = AffiliateLinks.Link_Affiliate_Key)
WHERE Link_Key #where(iseq, request.newLink_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- affiliates_links --->
<cffunction name="insertaffiliatelink" output="no">
<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO AffiliateLinks (Link_Account_Key, Link_Site_Key, Link_Affiliate_Key, Link_URL, Link_Image2, Link_html, Link_Update_ts, Link_Clickthru_Email, Link_Clickthru_Count) VALUES (#values(request.Login_Account_Key, isint)#, #values(request.newLink_Site_Key, isint)#, #values(request.newLink_Affiliate_Key, isint)#, #values(request.newLink_URL, ischar)#, #values(request.newLink_Image2, ischar)#, #values(request.newLink_html, ishtml)#, #values(DateConvert("local2utc", Now()), ists)#, #values(request.newLink_Clickthru_Email, ischar)#, 0); SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
<cfreturn query>
</cffunction>

<!--- affiliates_links --->
<cffunction name="updateaffiliatelink" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE AffiliateLinks SET Link_Site_Key #set(iseq, request.newLink_Site_Key, isint)#, Link_Affiliate_Key #set(iseq, request.newLink_Affiliate_Key, isint)#, Link_URL #set(iseq, request.newLink_URL, ischar)#, Link_Image2 #set(iseq, request.newLink_Image2, ischar)#, Link_html #set(iseq, request.newLink_html, ishtml)#, Link_Update_ts #set(iseq, DateConvert("local2utc", Now()), ists)#, Link_Clickthru_Email #set(iseq, request.newLink_Clickthru_Email, ischar)#, Link_Clickthru_Count #set(iseq, request.newLink_Clickthru_Count, isint)# WHERE Link_Key #where(iseq, request.newLink_Key, isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- affiliates_links --->
<cffunction name="deleteaffiliatelink" output="no">
<cfquery name="query" datasource="#application.dsn#">
DELETE FROM AffiliateLinks WHERE Link_Key #where(iseq, request.newLink_Key, isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- check_server --->
<cffunction name="deletecfid" output="no">
<cfargument name="cfid" required="yes">  
<cfquery name="query" datasource="#application.dsn#">
DELETE FROM cdata WHERE cfid LIKE '#arguments.cfid#:%';
DELETE FROM cglobal WHERE cfid LIKE '#arguments.cfid#:%'; SELECT @@ROWCOUNT AS 'rowcount'
</cfquery>

<!--- remove client recs for nocookie clients older than 1day --->
<cfquery name="nocookie" datasource="#application.dsn#">
SELECT cdata.cfid FROM cdata 
INNER JOIN cglobal ON (cdata.cfid = cglobal.cfid) 
WHERE cdata.data LIKE '%nocookie=true%' AND cglobal.lvisit #where(islt, dateadd("n",-1,Now()), ists)#
</cfquery>
<cfloop query="nocookie">
<cfquery name="deletenocookie" datasource="#application.dsn#">
DELETE FROM cglobal WHERE cfid #where(iseq, nocookie.cfid, ischar)#;
DELETE FROM cdata WHERE cfid #where(iseq, nocookie.cfid, ischar)#;
</cfquery>
</cfloop>

<cfreturn query>
</cffunction>

<!--- gridfile --->
<cffunction name="insertgridfile" output="no">
<cfargument name="file" type="string" required="yes">
<cfargument name="field" type="string" required="yes">
<cfargument name="gridfields" type="struct" required="yes">
<cfargument name="row" type="numeric" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO #arguments.file#(
<cfloop collection=arguments.gridfields item="gridfield">
	#gridfield#,
</cfloop>
#arguments.field#_Account_Key) VALUES(
<cfloop collection=arguments.gridfields item="gridfield">
	#set(iseq, Evaluate("request.griddata.#gridfield#[row]"),Evaluate("#arguments.gridfields.gridfield#"))#,
</cfloop>
#values(request.Account_Key, isint)#);SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
<cfreturn query>
</cffunction>

<!--- gridfile --->
<cffunction name="updategridfile" output="no">
<cfargument name="file" type="string" required="yes">
<cfargument name="field" type="string" required="yes">
<cfargument name="gridfields" type="struct" required="yes">
<cfargument name="row" type="numeric" required="yes">
<cfquery name="query" datasource="#application.dsn#">
UPDATE #arguments.file# SET 
<cfloop collection=arguments.gridfields item="gridfield">
	#gridfield# #set(iseq, Evaluate("request.griddata.#gridfield#[row]"),Evaluate("#arguments.gridfields.gridfield#"))#,
</cfloop>
#arguments.field#_Account_Key #set(iseq, request.Account_Key, isint)#
WHERE #arguments.field#_Key #where(iseq, Evaluate("form.griddata.original.#arguments.field#_Key[arguments.row]"), isint)#
</cfquery>
</cffunction>

<!--- gridfile --->
<cffunction name="deletegridfile" output="no">
<cfargument name="file" type="string" required="yes">
<cfargument name="field" type="string" required="yes">
<cfargument name="gridfields" type="struct" required="yes">
<cfargument name="row" type="numeric" required="yes">
<cfquery name="query" datasource="#application.dsn#">
DELETE FROM #arguments.file# WHERE #arguments.field#_Key #where(iseq, Evaluate("form.griddata.original.#arguments.field#_Key[arguments.row]"), isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- getsubset list --->
<cffunction name="getfullfile" output="no">
<cfargument name="file" type="string" required="yes">
<cfargument name="orderby" type="string" default="">
<cfargument name="expired" type="boolean" default=false>

<cfif arguments.expired OR isdefined("url.reset")>
	<cfset tempgetquery=true>
<cfelseif isdefined("application.file_#arguments.file#_expired") AND isdefined("application.file_#arguments.file#") AND isdefined("application.file_#arguments.file#_orderby")>
	<cflock name="getfile_#arguments.file#" type="readonly" throwontimeout="yes" timeout="10">
	<cfset tempexpired=Evaluate("application.file_#arguments.file#_expired")>
	<cfset temporderby=Evaluate("application.file_#arguments.file#_orderby")>
	<cfset tempquery=Evaluate("application.file_#arguments.file#")>
	</cflock>
	<cfif tempexpired>
		<cfset tempgetquery=true>
	<cfelse>
		<cfset tempgetquery=false>
	</cfif>
<cfelse>
		<cfset tempgetquery=true>
</cfif>

<cfif tempgetquery>
	<cfif len(arguments.orderby)>
		<cfquery name="query" datasource="#application.dsn#">
		SELECT * FROM #arguments.file# ORDER BY #arguments.orderby#
		</cfquery>
	<cfelse>
		<cfquery name="query" datasource="#application.dsn#">
		SELECT * FROM #arguments.file#
		</cfquery>
	</cfif>
	<cflock name="getfile_#arguments.file#" type="exclusive" throwontimeout="yes" timeout="10">
	<cfset "application.file_#arguments.file#"=query>
	<cfset "application.file_#arguments.file#_expired"=false>
	<cfset "application.file_#arguments.file#_orderby"=arguments.orderby>
	</cflock>
<cfelse>
	<cfif arguments.orderby IS NOT temporderby>
		<cfquery name="query" dbtype="query">
		SELECT * FROM tempquery ORDER BY #arguments.orderby#
		</cfquery>
	<cfelse>
		<cfset query=tempquery>
	</cfif>
</cfif>

<cfreturn query>
</cffunction>

<!--- set Sort Order --->
<cffunction name="setSortOrder" output="no">
<cfparam name="request.Sort" default="date">
<cfparam name="request.Order" default="down">
<cfswitch expression="#request.Sort#">
<cfcase value="date">
<cfset orderby="Tournament_Start_ts">
<cfset orderby2="Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfcase value="site">
<cfset orderby="Site_Name">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfcase value="id">
<cfset orderby="Tournament_id">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfcase value="game">
<cfset orderby="Tournament_Game">
<cfset orderby2="Tournament_Start_ts, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfcase value="buyin">
<cfset orderby="Tournament_Buyin">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfcase value="sponsor">
<cfset orderby="Affiliate_Name">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfcase value="player">
<cfset orderby="Bounty_Player_Name">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Amount DESC">
</cfcase>
<cfcase value="bounty">
<cfset orderby="Bounty_Amount">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Player_Name">
</cfcase>
<cfcase value="register">
<cfset orderby="Tournament_Reg_Amount">
<cfset orderby2="Tournament_Start_ts, Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfcase>
<cfdefaultcase>
<cfset orderby="Tournament_Start_ts">
<cfset orderby2="Tournament_Game, Tournament_Key, Bounty_Amount DESC, Bounty_Player_Name">
</cfdefaultcase>
</cfswitch>
<cfswitch expression="#request.Order#">
<cfcase value="up">
<cfset direction="desc">
</cfcase>
<cfdefaultcase>
<cfset direction="asc">
</cfdefaultcase>
</cfswitch>

<cfparam name="request.Filter_gtTime" default="6">
<cfparam name="request.Filter_ltTime" default="48">
<cfset CurrentHour_ts=CreateDateTime(Year(Now()),Month(Now()),Day(Now()),Hour(Now()),0,0)>
<cfset gttime=dateadd("h",-#request.Filter_gtTime#,request.timezoneObj.casttoUTC(CurrentHour_ts,application.defaultTZ))>
<cfset lttime=dateadd("h",#request.Filter_ltTime#,request.timezoneObj.casttoUTC(CurrentHour_ts,application.defaultTZ))>
<cfif isdefined("request.Filter_HideComplete") AND request.Filter_HideComplete>
	<cfset gttime=DateConvert("local2utc", Now())>
</cfif>

<!--- set where clause --->
<cfif isdefined("request.Filter_Bounty") AND request.Filter_Bounty>
	<cfset wherecl="Bounty.Bounty_Key IS NOT Null">
	<cfif isdefined("request.Filter_MyTournaments") AND request.Filter_MyTournaments AND isdefined("request.Login_Key")>
		<cfset wherecl="#wherecl# AND Tournaments.Tournament_CreatedBy_Login_Key #where(iseq, request.Login_Key, isint)#">
	</cfif>
<cfelse>
	<cfset wherecl="">
	<cfif isdefined("request.Filter_MyTournaments") AND request.Filter_MyTournaments AND isdefined("request.Login_Key")>
		<cfset wherecl="Tournaments.Tournament_CreatedBy_Login_Key #where(iseq, request.Login_Key, isint)#">
	<cfelseif isdefined("request.Filter_HideRegular") AND request.Filter_HideRegular>
		<cfset request.setOrcl=true>
	</cfif>
</cfif>
</cffunction>

<!--- addbounty,ipn --->
<cffunction name="insertpp" output="no">

<cfparam name="request.newPP_TXN_TYPE" default="">
<cfparam name="request.newPP_FIRST_NAME" default="">
<cfparam name="request.newPP_LAST_NAME" default="">
<cfparam name="request.newPP_PAYER_EMAIL" default="">
<cfparam name="request.newPP_PAYER_ID" default="">
<cfparam name="request.newPP_PAYER_BUSINESS_NAME" default="">
<cfparam name="request.newPP_PAYER_STATUS" default="">
<cfparam name="request.newPP_QUANTITY" default="">
<cfparam name="request.newPP_ITEM_NAME" default="">
<cfparam name="request.newPP_ITEM_NUMBER" default="">
<cfparam name="request.newPP_PAYMENT_GROSS" default="">
<cfparam name="request.newPP_PAYMENT_FEE" default="">
<cfparam name="request.newPP_SHIPPING" default="">
<cfparam name="request.newPP_TAX" default="">
<cfparam name="request.newPP_MC_GROSS" default="">
<cfparam name="request.newPP_MC_FEE" default="">
<cfparam name="request.newPP_MC_CURRENCY" default="">
<cfparam name="request.newPP_PAYMENT_TYPE" default="">
<cfparam name="request.newPP_PAYMENT_STATUS" default="">
<cfparam name="request.newPP_VERIFY_SIGN" default="">
<cfparam name="request.newPP_TXN_ID" default="">
<cfparam name="request.newPP_RECEIVER_EMAIL" default="">
<cfparam name="request.newPP_BUSINESS" default="">
<cfparam name="request.newPP_RECEIVER_ID" default="">
<cfparam name="request.newPP_CUSTOM" default="">
<cfparam name="request.newPP_CHARSET" default="">
<cfparam name="request.newPP_NOTIFY_VERSION" default="">
<cfparam name="request.newPP_Other_Fields" default="">

<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO PayPalIPN (PP_TXN_TYPE, PP_FIRST_NAME, PP_LAST_NAME, PP_PAYER_EMAIL, PP_PAYER_ID, PP_PAYER_BUSINESS_NAME, PP_PAYER_STATUS, PP_QUANTITY, PP_ITEM_NAME, PP_ITEM_NUMBER, PP_PAYMENT_GROSS, PP_PAYMENT_FEE, PP_SHIPPING, PP_TAX, PP_MC_GROSS, PP_MC_FEE, PP_MC_CURRENCY, PP_PAYMENT_TYPE, PP_PAYMENT_STATUS, PP_VERIFY_SIGN, PP_TXN_ID, PP_RECEIVER_EMAIL, PP_BUSINESS, PP_RECEIVER_ID, PP_CUSTOM, PP_CHARSET, PP_NOTIFY_VERSION, PP_Other_Fields) VALUES (#values(request.newPP_TXN_TYPE, ischar)#, #values(request.newPP_FIRST_NAME, ischar)#, #values(request.newPP_LAST_NAME, ischar)#, #values(request.newPP_PAYER_EMAIL, ischar)#, #values(request.newPP_PAYER_ID, ischar)#, #values(request.newPP_PAYER_BUSINESS_NAME, ischar)#, #values(request.newPP_PAYER_STATUS, ischar)#, #values(request.newPP_QUANTITY, isint)#, #values(request.newPP_ITEM_NAME, ischar)#, #values(request.newPP_ITEM_NUMBER, ischar)#, #values(request.newPP_PAYMENT_GROSS, isdec)#, #values(request.newPP_PAYMENT_FEE, isdec)#, #values(request.newPP_SHIPPING, isdec)#, #values(request.newPP_TAX, isdec)#, #values(request.newPP_MC_GROSS, isdec)#, #values(request.newPP_MC_FEE, isdec)#, #values(request.newPP_MC_CURRENCY, ischar)#, #values(request.newPP_PAYMENT_TYPE, ischar)#, #values(request.newPP_PAYMENT_STATUS, ischar)#, #values(request.newPP_VERIFY_SIGN, ischar)#, #values(request.newPP_TXN_ID, ischar)#, #values(request.newPP_RECEIVER_EMAIL, ischar)#, #values(request.newPP_BUSINESS, ischar)#, #values(request.newPP_RECEIVER_ID, ischar)#, #values(request.newPP_CUSTOM, ischar)#, #values(request.newPP_CHARSET, ischar)#, #values(request.newPP_NOTIFY_VERSION, ischar)#, #values(request.newPP_Other_Fields, ischar)#); SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanger --->
<cffunction name="getaccountbycreatedkey" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account WHERE Account_Key #where(iseq, request.newAccount_Key, isint)# AND Account_Disabled #where(iseq, "false", isbit)# AND Account_Created_By_Key #where(iseq, request.Account_Created_By_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="getaccountsbyaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account WHERE Account_Created_By_Key #where(iseq, request.Account_Created_By_Key, isint)# AND Account_Disabled #where(iseq, "false", isbit)# ORDER BY Account_Name ASC
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="getaccounts" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account ORDER BY Account_Name ASC
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="updateaccountname" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Account SET Account_Name #set(iseq, request.newAccount_Name, ischar)# WHERE Account_Key #where(iseq, request.newAccount_Key, isint)# AND Account_Created_By_Key #where(iseq, request.Account_Created_By_Key, isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="setaccountdisabled" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Account SET Account_Disabled #set(iseq, "true", isbit)# WHERE Account_Key #where(iseq, request.newAccount_Key, isint)# AND Account_Created_By_Key #where(iseq, request.Account_Created_By_Key, isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="setaccountdisabledbykey" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Account SET Account_Disabled #set(iseq, "true", isbit)# WHERE Account_Key #where(iseq, request.newAccount_Key, isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="setaccountenabledbykey" output="no">
<cfquery name="query" datasource="#application.dsn#">
UPDATE Account SET Account_Disabled #set(iseq, "false", isbit)# WHERE Account_Key #where(iseq, request.newAccount_Key, isint)#; SELECT @@ROWCOUNT AS 'recordcount'
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools_accountmanager --->
<cffunction name="getaccountsbynamenekey" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account WHERE Account_Name #where(iseq, request.newAccount_Name, ischar)# AND Account_Disabled #where(iseq, "false", isbit)# AND Account_Key #where(isne, request.newAccount_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- merchanttools-accountmanager --->
<cffunction name="deleteaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
DELETE FROM Account WHERE Account_Key #where(iseq, request.newAccount_Key, isint)#
DELETE FROM SecurityQuestion WHERE Sec_Login_Key IN 
(SELECT Login_Key FROM Login WHERE Login_Account_Key #where(iseq, request.newAccount_Key, isint)#)

DELETE FROM Login WHERE Login_Account_Key #where(iseq, request.newAccount_Key, isint)#

DELETE FROM Email WHERE Email_Account_Key #where(iseq, request.newAccount_Key, isint)#
DELETE FROM Questions WHERE Question_Account_Key #where(iseq, request.newAccount_Key, isint)#
</cfquery>
</cffunction>

<!--- submitquestion --->
<cffunction name="insertquestion" output="no">
<cfquery name="query" datasource="#application.dsn#">
SET NOCOUNT ON; INSERT INTO Questions (Question_Account_Key, Question_ts, Question_From, Question_To, Question_Subject, Question_Body) VALUES (#values(request.Question_Account_Key, isint)#, #values(DateConvert("local2utc", Now()), ists)#, #values(request.Question_From, ischar)#, #values(request.Question_To, ischar)#, #values(request.Question_Subject, ischar)#, #values(request.Question_Body, ischar)#);SET NOCOUNT OFF; SELECT @@IDENTITY AS 'Identity'
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-quesions --->
<cffunction name="getquestionsbyaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Questions WHERE Question_Account_Key #where(iseq, request.Question_Account_Key, isint)# ORDER BY Question_ts ASC
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-notifications --->
<cffunction name="getaccountaffiliate" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Account
LEFT OUTER JOIN Affiliates ON (Account.Account_Affiliate_Key = Affiliates.Affiliate_Key)
LEFT OUTER JOIN Account ON (Affiliates.Affiliate_Account_Key = Account.Account_Key)
WHERE Account_Key #where(iseq, request.Login_Account_Key, isint)# AND Account_Disabled #where(iseq, "false", isbit)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- forgotpassword --->
<cffunction name="getlogin" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Login WHERE Login_ID #where(iseq, request.Login_ID, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- access --->
<cffunction name="getloginbyaccess" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Login WHERE Login_ID #where(iseq, request.Login_ID, ischar)# AND Login_Access_Code #where(iseq, request.Login_Access_Code, isint)# AND Login_Access_Code_ts > #request.testdate#
</cfquery>
<cfif query.recordcount IS NOT 1>
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email
LEFT OUTER JOIN Login ON (Email_Account_Key = Login_Account_Key)
WHERE Email_Address #where(iseq, request.Login_ID, ischar)# AND Login_Primary = 1 AND Login_Access_Code #where(iseq, request.Login_Access_Code, isint)# AND Login_Access_Code_ts > #request.testdate#
</cfquery>
</cfif>
<cfreturn query>
</cffunction>

<!--- resetpassword --->
<cffunction name="getSecurityQuestion" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM SecurityQuestion WHERE Sec_Login_Key #where(iseq, request.Sec_Login_Key, isint)# AND Sec_Question #where(iseq, request.Sec_Question, ischar)# AND Lower(Sec_Answer) #where(iseq, request.Sec_Answer, ischar)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- forgotpassword --->
<cffunction name="getloginbyaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Login WHERE Login_Account_Key #where(iseq, request.Login_Account_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-login --->
<cffunction name="getemailaddressbyaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Address #where(iseq, request.Email_Address, ischar)# AND Email_Account_Key #where(iseq, request.Email_Account_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- forgotpassword --->
<cffunction name="getemailbyaccount" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Account_Key #where(iseq, request.Email_Account_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- submitquestion --->
<cffunction name="getprimaryemail" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email 
LEFT OUTER JOIN Notifications ON (Email_Account_Key = Notify_Account_Key)
WHERE Email_Account_Key #where(iseq, request.Email_Account_Key, isint)# AND Email_Primary #where(iseq, "true", isbit)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-email_submit --->
<cffunction name="getemailbyemail" output="no">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Email WHERE Email_Key #where(iseq, request.Email_Key, isint)# AND Email_Account_Key #where(iseq, request.Email_Account_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

<!--- myaccount_accountprofile-email_submit --->
<cffunction name="getLoginByAccount_Key" output="no">
<cfargument name="Account_Key" required="yes">
<cfquery name="query" datasource="#application.dsn#">
SELECT * FROM Login WHERE Login_Account_Key #where(iseq, arguments.Account_Key, isint)#
</cfquery>
<cfreturn query>
</cffunction>

</cfcomponent>