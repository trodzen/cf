<cfoutput>
<table border="0" cellpadding="0" cellspacing="0"><tr><td><form action="#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-login", false)#" method=post><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr><td>You can assign a different and shorter login ID. This also allows you to hide your email address during the login and when viewed by other users.</td></tr>
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
		<tr><td>Log in ID:&nbsp;<input name="login" type="text" value="#newLogin#" size="25"></td></tr>
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
		<tr><td><input type="submit" name="cmd_save" value=" Save "></td></tr>
	</table><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="changelogin"></form></td></tr>
</table>
#request.layoutObj.doLine()#
<table border="0" cellpadding="0" cellspacing="0"><tr><td>Here are the Log in ID rules:<br><br>
1. Your ID must be atleast four (4) characters long.<br>
2. Your ID must contain letters or numbers (a-z and 0-9) only.<br>
3. Your ID can not contain any special characters or spaces.<br>
4. Your Log in ID can be in the format of a valid email address<br>
only if the email address is already in your list of email addresses.<br>
5. Your Log in ID is not case sensitive.</td></tr>
<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
</table>
</cfoutput>