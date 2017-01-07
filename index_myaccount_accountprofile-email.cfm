<cfoutput>

<cfif confirmdelete>
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td><form action="#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-email", false)#" method=post><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr><td>Are you sure you want to remove the following email address:<br><br>
		<span class="emphasis">#getemailbyemailqry.Email_Address#</span></td></tr>
		<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
		#request.layoutObj.doLine()#
		<tr><td><input type="submit" name="remove" value="Remove"><input type="submit" name="cancel" value="Cancel"></td></tr>
	</table><input name="email_list" type="hidden" value="#getemailbyemailqry.Email_Key#"><input name="submitconfirmed" type="hidden" value="true"><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="remove"></form></td></tr>
</table>
<cfelseif addemail>
<table border="0" cellpadding="0" cellspacing="0">
		<tr><td><form action="#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-email", false)#" method=post><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr><td>Type the email address you want to add then select the Save button.</td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			<tr><td>Email Address:&nbsp;<input name="Email_Address" type="text" value="#newEmail_Address#" size="25"></td></tr>
			<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
			#request.layoutObj.doLine()#
			<tr><td><input type="submit" name="add_save" value="Save"><input type="submit" name="cancel" value="Cancel"></td></tr>
		</table><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="add_save"></form></td></tr>
</table>
<cfelse>
<table border="0" cellpadding="0" cellspacing="0">
	<tr><td>Manage your email addresses linked to your account.</td></tr>
	<tr><td>#request.layoutObj.doPixel(height=5)#</td></tr>
	<tr><td><form name="myform" action="#request.snipObj.getURL("index.cfm", "myaccount_accountprofile-email", false)#" method=post><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr><td>#request.layoutObj.doPageNavigator(name="EmailAddresses", text="Email Addresses", total=getemailbyaccountqry.recordcount, page=5, start="begin")#</td></tr>
		<tr><td><table width="100%" align="center" border="0" cellpadding="2" cellspacing="0" class="DataTable">
			<tr class="DataTableRowHeading"><td colspan="2" nowrap width="75%">Select Email Address</td>
			<td align="center" nowrap width="25%">Status</td></tr>
	
	<cfloop query="getemailbyaccountqry" startrow="#request.startrow#" endrow="#request.endrow#">
			<cfset status=""><cfif getemailbyaccountqry.CurrentRow MOD 2><tr class="DataTableRowOdd"><cfelse><tr class="DataTableRowEven"></cfif><td align="center"><input type="radio" name="email_list" value="#getemailbyaccountqry.Email_Key#"></td>
			<td width="100%" onMouseDown="selectradio(document.myform.email_list, #evaluate(getemailbyaccountqry.currentrow-request.startrow)#)" title="click to select">#getemailbyaccountqry.Email_Address#<cfif NOT getemailbyaccountqry.Email_Confirmed><span class="SmallerItalic"><br>(Please confirm this email address)</span></cfif></td><td align="center" nowrap><cfif getemailbyaccountqry.Email_Primary><cfset status=ListAppend(status, " Primary")></cfif><cfif NOT getemailbyaccountqry.Email_Confirmed><cfset status=ListAppend(status, " Unconfirmed")></cfif><cfif getemailbyaccountqry.Email_Disabled><cfset status=ListAppend(status, " Disabled")></cfif><cfif ListLen(status)>#status#<cfelse>#request.layoutObj.doPixel()#</cfif></td></tr>
	</cfloop>
	
		</table></td></tr>
	
	<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
	<tr><td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		<tr><td><input type="submit" name="makeprimary" value="Make Primary"><input type="submit" name="confirm" value="Confirm"><input type="submit" name="remove" value="Remove"><input type="submit" name="add" value="Add"></td></tr>
		</table></td></tr>
	
	</table><input name="submitkey" type="hidden" value="#request.submitkey#"><input name="submitform" type="hidden" value="true"></form></td></tr>
</table>
</cfif></cfoutput>