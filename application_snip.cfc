<cfcomponent output="no">

<!--- init --->
<cffunction name="init" access="public" output="no">
<cfreturn this>
</cffunction>

<!--- Appliction.cfc --->
<cffunction name="CheckUserLogin" output="no">
<cfset LoggedIn=false>
<cfif isdefined("cookie.Login_Key") AND isdefined("cookie.Login_Password")>
<cfset request.Login_Key="#cookie.Login_Key#">
<cfset request.Login_Password="#cookie.Login_Password#">
	<!--- get user --->
	<cfinvoke component="#request.dbObj#" method="validateaccountbyKey" returnvariable="request.validateaccountqry">
		<cfinvokeargument name="Login_Key" value="#request.Login_Key#">
		<cfinvokeargument name="Login_Password" value="#request.Login_Password#">
	</cfinvoke>
	<cfif request.validateaccountqry.recordcount IS 1>
		<cfset request.Login_ID="#request.validateaccountqry.Login_ID#">
		<cfset request.Login_Roles="#request.validateaccountqry.Login_Roles#">
		<cfset request.Login_Key="#request.validateaccountqry.Login_Key#">
		<cfset request.Login_Account_Key="#request.validateaccountqry.Login_Account_Key#">
		<cfset request.Account_Key="#request.validateaccountqry.Login_Account_Key#">
		<cfset request.Login_Password="#request.validateaccountqry.Login_Password#">
		<cfset request.Account_Balance="#request.validateaccountqry.Account_Balance#">
		<cfset request.referredby="#request.validateaccountqry.Account_ReferredBy_key#">
		<cfset LoggedIn=true>
	</cfif>
</cfif>
<cfreturn LoggedIn>
</cffunction>

<cffunction name="doCheckUser">
<cfargument name="Role" type="string" default="user">
<cfinvoke component="#request.snipObj#" method="CheckUserLogin" returnvariable="LoggedIn">
<cfif LoggedIn IS false>
	<cfset errorList=ArrayAppend(request.errorArray, "Log in required.")>
	<cfset request.title="Login Required">
	<cfset request.pageheader="Please Login">
	<cfinclude template="#request.templatepath#/document_header.cfm">
	<cfinvoke component="#request.layoutObj#" method="doLoginRequired">
	<cfinclude template="#request.templatepath#/document_footer.cfm">
	<cfabort>
<cfelseif arguments.Role IS NOT "user" AND request.Login_Roles DOES NOT CONTAIN arguments.Role>
	<cfset errorList=ArrayAppend(request.errorArray, "Not Authorized.")>
	<cfset request.title="Not Authorized">
	<cfset request.pageheader="Not Authorized">
	<cfinclude template="#request.templatepath#/document_header.cfm">
<!-- begin not authorized -->
<tr><td><table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr><td align="center"><span class="Large">You must <a href="#request.snipObj.getURL("logout.cfm", "#request.cmd#", true, "#qryString#")#">log out</a>.</span></td></tr>
	<tr><td>#request.layoutObj.doPixel(height=10)#</td></tr>
	<tr><td align="center">Please login with <span class="emphasis">#arguments.role#</a> privileges.</td></tr>
</table></td></tr>
<!-- end not authorized -->
	<cfinclude template="#request.templatepath#/document_footer.cfm">
	<cfabort>
</cfif>
</cffunction>

<!--- indextemplate --->
<cffunction name="doCmdDefault"><cfsilent>
<cfparam name="request.cmdhome" default="home">

<cfif NOT isdefined("request.cmd")>

<cfif request.pagename IS "index.cfm">
	<cfif isdefined("url.page")>
		<cfparam name="request.cmd" default="none">
	<cfelse>
		<cfparam name="request.cmd" default="#request.cmdhome#">
	</cfif>
<cfelse>
	<cfparam name="request.cmd" default="none">
</cfif>

<!--- set nav bar cmd from url --->
<cfif isdefined("url.cmd")>
	<cfset request.cmd="#lcase(url.cmd)#">
</cfif>

</cfif>

</cfsilent></cffunction>

<!--- return formatted URL --->
<cffunction name="getURL">
	<cfargument name="page" type="string" required="yes">
	<cfargument name="cmd" type="string">
	<cfargument name="secure" type="boolean">
	<cfargument name="querystring" type="string">
	<cfargument name="urlkey" type="boolean"><cfsilent>

	<!--- optional secure argument --->
	<cfif isdefined("arguments.secure")>
		<cfif arguments.secure>
			<cfset setURL="#request.rooturl_secure#/#arguments.page#">
		<cfelse>
			<cfset setURL="#request.rooturl#/#arguments.page#">
		</cfif>
	<cfelse>
		<cfset setURL="#request.rooturl#/#arguments.page#">
	</cfif>

	<cfset setQryParms=false>
	<cfif isdefined("arguments.cmd") AND len(arguments.cmd)>
		<cfif setQryParms IS false>
			<cfset setQryParms=true>
			<cfset setURL="#setURL#?">
		<cfelse>
			<cfset setURL="#setURL#&">
		</cfif>
		<cfset setURL="#setURL#cmd=#arguments.cmd#">
		<cfif isdefined("arguments.querystring") AND len(arguments.querystring)>
			<cfset setURL="#setURL#&#arguments.querystring#">
		</cfif>
	<cfelse>
		<cfif isdefined("arguments.querystring") AND len(arguments.querystring)>
			<cfif setQryParms IS false>
				<cfset setQryParms=true>
				<cfset setURL="#setURL#?">
			<cfelse>
				<cfset setURL="#setURL#&">
			</cfif>
			<cfset setURL="#setURL##arguments.querystring#">
		</cfif>
	</cfif>

	<!--- whenever we have a querystring we want to add a key to prevent dup requests. --->
	<cfif isdefined("arguments.urlkey") AND arguments.urlkey AND isdefined("arguments.querystring") AND len(arguments.querystring)>
		<cfinvoke component="#request.snipObj#" method="doSubmitKey">
		<cfset setURL="#setURL#&skey=#request.submitkey#">
	</cfif>

	<cfreturn setURL>
</cfsilent></cffunction>

<!--- used by getURL --->
<cffunction name="doSubmitKey">
<cfif NOT isdefined("request.submitkey")>
	<!--- create a client variable that can be used by every href and form to prevent duplicate calls --->
	<!--- client submitkey was already defined - save it to check later --->
	<cfset request.submitkey=0>
	<cfif isdefined("cookie.submitkey")>
		<cfset request.submitkey=#cookie.submitkey#>
		<cfset request.checkkey=#request.submitkey#>
	</cfif>
	<cfset request.submitkey=#request.submitkey#+1>
	<cfcookie name="submitkey" value="#request.submitkey#" domain=".#request.domain#">
</cfif>
</cffunction>

<!--- produce document header --->
<cffunction name="doPageHeader">
<cfinclude template="#request.templatepath#/document_header.cfm">
</cffunction>

<!--- produce document footer --->
<cffunction name="doPageFooter">
<cfinclude template="#request.templatepath#/document_footer.cfm">
</cffunction>

<!--- produce page part - indextemplate --->
<cffunction name="doPagePart">
<cfargument name="page" type="string" required="yes">
<cfargument name="cmd" type="string" required="yes">
<cfargument name="part" type="string" required="yes">
<cfsilent>

<cfif isdefined("application.pages")>
	<cfset temppages="#application.pages#">
<cfelse>
	<cfset temppages="">
</cfif>

<cfset temppagepart=lcase(listgetat(arguments.page,1,"."))>
<cfif arguments.cmd IS "none">
	<cfset tempfile="#temppagepart#" & "#arguments.part#" & ".cfm">
<cfelse>
	<cfset tempfile="#temppagepart#_#arguments.cmd#" & "#arguments.part#" & ".cfm">
</cfif>

<cfif ListFind(temppages, "#application.templatefilepath#/#tempfile#=Y")>
	<!--- already found it exists --->
	<cfset pagefound=true>
<cfelseif ListFind(temppages, "#application.templatefilepath#/#tempfile#=N")>
	<!--- already looked it does not exist --->
	<cfif application.debugmode AND FileExists("#application.templatefilepath#/#tempfile#")>
		<!--- in debug mode AND recently added page - it exists now --->
		<cfset temppages=ListSetAt(temppages,ListFind(temppages, "#application.templatefilepath#/#tempfile#=N"),"#application.templatefilepath#/#tempfile#=Y")>
		<cfset pagefound=true>
	<cfelse>
		<!--- NOT debug mode OR didn't find it before and retried now - still not found --->
		<cfset pagefound=false>
	</cfif>
<cfelse>
	<!--- didnt alread look it up --->
	<cfif FileExists("#application.templatefilepath#/#tempfile#")>
		<!--- file exists now --->
		<cfset temppages=ListAppend(temppages, "#application.templatefilepath#/#tempfile#=Y")>
		<cfset pagefound=true>
	<cfelse>
		<!--- file does not exist now --->
		<cfset temppages=ListAppend(temppages, "#application.templatefilepath#/#tempfile#=N")>
		<cfset pagefound=false>
	</cfif>
	<cflock name="pages" type="exclusive" timeout="10">
		<cfset application.pages="#temppages#">
	</cflock>
</cfif>

</cfsilent>
<cfif pagefound>
	<cfinclude template="#request.templatepath#/#tempfile#">
</cfif>
<cfreturn pagefound>
</cffunction>

<!--- create random secrete value --->
<cffunction name="doSecret">
	<cfset temprandnumber="#randrange(56778,56787)#">
<!---	<cfcookie name="secret_key" value="#temprandnumber#" domain=".#request.domain#"> --->
	<cfreturn temprandnumber>
</cffunction>

<!--- check answer against secrete value --->
<cffunction name="doCheckSecretAnswer">
	<cfargument name="answer" type="string" required="yes">
	<cfset validated=false>
	<cfif request.snipObj.EncodeKey(form.secret_hidden,true) IS answer>
		<cfset validated=true>
	</cfif>
	
<!---
	<!--- check secret key answer --->
	<cfif isdefined("cookie.secret_key")>
			<cfset request.secret_key="#cookie.secret_key#">
		<cfif request.secret_key IS answer>
			<cfset validated=true>
		</cfif>
	<cfelse>
		<cfset errorList=ArrayAppend(request.errorArray, "Oops.. your browser may not have cookies enabled. Sorry cookies are required for this system to operate. You might try enabling cookies or use another web browser or a different computer.")>
	</cfif>
--->

	<cfreturn validated>
</cffunction>

<!--- check to make sure the user is not logged in
used in: login, signup, forgotpassword
--->
<cffunction name="doCheckLogOut">
	<cfinvoke component="#request.snipObj#" method="CheckUserLogin" returnvariable="LoggedIn">
	<cfif LoggedIn>
		<cfset request.pagename="index.cfm">
		<cfinclude template="#request.templatepath#/indextemplate.cfm">
		<cfabort>
	</cfif>
</cffunction>

<!--- check to make sure the user is not logged in
used in: login, signup, forgotpassword
--->
<cffunction name="doCheckPassword">
<cfsilent>
	<cfif request.Login_Password IS NOT request.confirmpw>
		<cfset errorList=ArrayAppend(request.errorArray, "re-type your password in the confirm password field.")>
"#ListAppend(errorText>
	</cfif>
	<cfif Len(request.Login_Password) LT 6>
		<cfset errorList=ArrayAppend(request.errorArray, "Your password must be at least 6 characters long.")>
"#ListAppend(errorText>
	</cfif>
</cfsilent></cffunction>

<cffunction name="EncodeKey" output="no">
<cfargument name="Key" required="yes">
<cfargument name="isDecode" type="boolean" default="false">
<cfif isDecode>
	<!--- decode key --->
	<cfif FindOneOf("013568",arguments.key)>
		<!--- contains invalid numbers --->
		<cfset tkey=0>
	<cfelse>
		<cfset tkey=ReplaceList(arguments.key,"X,R,2,C,4,L,P,7,Y,9","0,1,2,3,4,5,6,7,8,9")>
	</cfif>
<cfelse>
	<!--- encode key --->
	<cfset tkey=numberformat(arguments.key,"000")>
	<cfset tkey=ReplaceList(tkey,"0,1,2,3,4,5,6,7,8,9","X,R,2,C,4,L,P,7,Y,9")>
</cfif>
<cfreturn tkey>
</cffunction>

<cffunction name="TrimList" output="no">
<cfargument name="list" required="yes">
<cfif len(arguments.list) IS 2 AND left(arguments.list,1) IS "," AND right(arguments.list,1) IS ",">
	<cfset trimlist="">
<cfelseif len(arguments.list) GT 2 AND left(arguments.list,1) IS "," AND right(arguments.list,1) IS ",">
	<cfset trimlist=mid(arguments.list,2,len(arguments.list)-2)>
<cfelse>
	<cfset trimlist=arguments.list>
</cfif>
<cfreturn trimlist>
</cffunction>

<cffunction name="getKLocs">
<cfsilent>
	<!-- find out how many KLocs - Thousands Line of Code --->
	<cfif isdefined("application.kloc") AND isdefined("url.reset") IS false>
		<cfset tempcount=application.kloc>
	<cfelse>
		<cfset tempcount=0>
		<cfloop list="cfm,cfc,css,js" index="i">
			<cfdirectory action="list" directory="#Application.applicationfilepath#" filter="*.#i#" name="dirqry" recurse="yes">
			<cfloop query="dirqry">
				<cffile action="read" file="#dirqry.directory#\#dirqry.name#" variable="tempfile">
				<cfset tempcount=tempcount+listlen(tempfile,chr(13))>
			</cfloop>
		</cfloop>
	</cfif>
	<cfset application.kloc=tempcount>
	<cfset tempcount=numberformat(tempcount / 1000, "9.9")>
</cfsilent>
<cfreturn tempcount>
</cffunction>

<cffunction name="setShowSort">
<cfsilent>

	<cfparam name="request.Sort" default="player">
	<cfparam name="request.Order" default="down">

	<!--- set sort --->
	<cfif isdefined("url.sort")>
		<cfset request.Sort=url.sort>
		<cfcookie name="Show_Sort" value="#request.Sort#" domain=".#request.domain#">
	<cfelse>
		<cfif isdefined("cookie.show_sort")>
			<cfset request.Sort=cookie.Show_Sort>
		</cfif>
	</cfif>
	<cfif isdefined("url.order")>
		<cfset request.Order=lcase(url.order)>
		<cfcookie name="Show_Order" value="#request.Order#" domain=".#request.domain#">
	<cfelse>
		<cfif isdefined("cookie.show_order")>
			<cfset request.Order=cookie.show_Order>
		</cfif>
	</cfif>
</cfsilent>
</cffunction>

<cffunction name="formatTimetillStart">
<cfargument name="StartTime" type="date" required="yes">
<cfsilent>
	<!--- get time till start --->
	<cfset minstill=datediff("n",DateConvert("local2utc", Now()),StartTime)>
	<cfif minstill LE -480>
		<cfset Timetill="Completed">
	<cfelseif minstill LE 0>
		<cfset Timetill="In-progress or Completed">
	<cfelseif minstill LT 60>
		<cfset Timetill="#numberformat(minstill)# mins">
	<cfelseif minstill LT 1440>
		<cfset Timetill="#numberformat(int(minstill/60))# hrs #int(minstill mod 60)# mins">
	<cfelse>
		<cfset Timetill="#numberformat(int(minstill/1440))# days #numberformat(int((minstill mod 1440)/60))# hrs #int(minstill mod 60)# mins">
	</cfif>
</cfsilent>
<cfreturn Timetill>
</cffunction>

<cffunction name="getQryString">
<cfargument name="exclude" type="string" default="">
<cfsilent>
<!--- get query string --->
<cfif isStruct(url)>
<cfset qryString="">
<cfset exclude_list=ListAppend("tcfid,cmd,key,jsessionid,cfid,cftoken,skey",arguments.exclude)>
<cfloop collection=#url# item="urlkey">
<cfif listfind(exclude_list, lcase(urlkey)) IS false>
	<cfset qryString=ListAppend(qryString, "#lcase(urlkey)#=#StructFind(url, urlkey)#", "&")>
</cfif>
</cfloop>
</cfif>

</cfsilent>
<cfreturn qryString>
</cffunction>

<!--- find out if string contains bad stuff --->
<cffunction name="ismystring" output="no">
<cfargument name="data" type="string" required="yes">
<cfset myreply=false>
<cfif len(trim(arguments.data)) GT 0 AND arguments.data DOES NOT CONTAIN "''">
	<cfset myreply=true>
</cfif>
<cfreturn myreply>
</cffunction>

<!--- find out if string contains bad stuff --->
<cffunction name="escapemystring" output="no">
<cfargument name="data" type="string" required="yes">
<cfset data=replacelist(data,"'","''")>
<cfreturn data>
</cffunction>

<!--- strip bad stuff from string --->
<cffunction name="stripmystring" output="no">
<cfargument name="data" type="string" required="yes">
<cfargument name="type" type="string">
<cfif isdefined("arguments.type") AND arguments.type IS "email">
<cfset data=replacelist(data," ,+,/,',""","")>
<cfelseif isdefined("arguments.type") AND arguments.type IS "groupon">
<cfset data=replacelist(data," ,+,.,_,##,/,',""","")>
<cfelse>
<cfset data=replacelist(data," ,+,.,_,-,/,',""","")>
</cfif>
<cfreturn data>
</cffunction>

<cffunction name="doCheckKey">
<cfargument name="keytype" type="string"><cfsilent>

<cfinvoke component="#request.snipObj#" method="doSubmitKey">

<cfif lcase(arguments.keytype) IS "url">
	<cfset keyvar="url.skey">
<cfelse>
	<cfset keyvar="form.submitkey">
</cfif>
<cfif isdefined("#keyvar#")>
	<cfif isdefined("request.checkkey") IS false>
		<cfset errorList=ArrayAppend(request.errorArray, "Your session timed out, please re-submit your request.")>
	</cfif>
</cfif>

</cfsilent></cffunction>

<cffunction name="doGridUpdate">
<cfargument name="file" type="string" required="yes">
<cfargument name="field" type="string" required="yes">
<cfargument name="gridfields" type="struct" required="yes"><cfsilent>
	<cfif isdefined("request.action")>
		<cfloop index="row" from="1" to="#Arraylen(request.action)#">
			<cfswitch expression="#request.action[row]#">
				<cfcase value="I">
					<!--- insert --->
					<cfinvoke component="#request.dbObj#" method="insertgridfile">
					<cfinvokeargument name="file" value="#arguments.file#">
					<cfinvokeargument name="field" value="#arguments.field#">
					<cfinvokeargument name="gridfields" value="#arguments.gridfields#">
					<cfinvokeargument name="row" value="#row#">
					<cfset request.dbupdate=true>
				</cfcase>
				<cfcase value="U">
					<!--- update --->
					<cfinvoke component="#request.dbObj#" method="updategridfile">
					<cfinvokeargument name="file" value="#arguments.file#">
					<cfinvokeargument name="field" value="#arguments.field#">
					<cfinvokeargument name="gridfields" value="#arguments.gridfields#">
					<cfinvokeargument name="row" value="#row#">
					<cfset request.dbupdate=true>
				</cfcase>
				<cfcase value="D">
					<!--- delete --->
					<cfinvoke component="#request.dbObj#" method="deletegridfile">
					<cfinvokeargument name="file" value="#arguments.file#">
					<cfinvokeargument name="field" value="#arguments.field#">
					<cfinvokeargument name="gridfields" value="#arguments.gridfields#">
					<cfinvokeargument name="row" value="#row#">
					<cfset request.dbupdate=true>
				</cfcase>
			</cfswitch>	
		</cfloop>
	</cfif>
</cfsilent></cffunction>

<cffunction name="getInputFormFields"><cfsilent>

<!--- get input fields from form --->
<cfset fields=form.fieldnames>
<cfloop condition="#listcontainsnocase(fields,"IKEY_")#">
	<cfset i=listcontainsnocase(form.fieldnames,"IKEY_")>
	<cfset key=listgetat(fields,i)>
	<cfif lcase(Left(key,5)) IS "ikey_" AND Evaluate("form.#key#") IS NOT Evaluate("form.original_#key#")>
		<cfset request.Input[key]=Evaluate("form.#key#")>
		<cfset request.Input_Original[key]=Evaluate("form.original_#key#")>
	</cfif>
	<cfset fields=listdeleteat(fields,i)>
</cfloop>

</cfsilent></cffunction>

<cffunction name="doInputFormSubmit">
<cfargument name="file" type="string" required="yes">
<cfargument name="field" type="string" required="yes">
<cfargument name="inputfield" type="string" required="yes">
<cfargument name="format" type="string"><cfsilent>

<!--- update file --->
<cfif isdefined("request.Input")>
	<cfloop collection="#request.Input#" item="key">
		<cfset keyvalue=Listgetat(key,2,"_")>
		<cfset value=request.Input[key]>
		<cfif isdefined("arguments.format")>
			<cfset value=Evaluate("#arguments.format#(value)")>
		</cfif>
		<cfinvoke component="#request.dbObj#" method="updateinputfield" returnvariable="updateinputfieldqry">
			<cfinvokeargument name="file" value="#arguments.file#">
			<cfinvokeargument name="field" value="#arguments.field#">
			<cfinvokeargument name="inputfield" value="#arguments.inputfield#">
			<cfinvokeargument name="keyvalue" value="#keyvalue#">
			<cfinvokeargument name="value" value="#value#">
		</cfinvoke>
	</cfloop>
	<cfset temp=StructDelete(request,"Input")>
	<cfset request.setPageReset=true>
	<cfset messageList=ArrayAppend(request.messageArray, "Update completed successfully.")>
</cfif>
	
</cfsilent></cffunction>

<cffunction name="getSubsetField">
<cfargument name="subsetfield" type="string" required="yes"><cfsilent>

<cfif isdefined("form.subset_#arguments.subsetfield#")>
	<cfset "cookie.subset.#arguments.subsetfield#"=Evaluate("form.subset_#arguments.subsetfield#")>
	<cfset "request.subset_#arguments.subsetfield#"=Evaluate("form.subset_#arguments.subsetfield#")>
<cfelseif NOT isdefined("request.subset_#arguments.subsetfield#") AND isdefined("cookie.subset.#arguments.subsetfield#")>
		<cfset "request.subset_#arguments.subsetfield#"=Evaluate("cookie.subset.#arguments.subsetfield#")>
</cfif>

</cfsilent></cffunction>

<cffunction name="getSelectHeading">
<cfargument name="subsetfield" type="string" required="yes">
<cfargument name="file" type="string" required="yes">
<cfargument name="field" type="string" required="yes">
<cfargument name="orderby" type="string" required="yes"><cfsilent>

<cfinvoke method="getsubsetfield">
<cfinvokeargument name="subsetfield" value="#arguments.subsetfield#">
</cfinvoke>

<cfinvoke component="#request.dbObj#" method="getfullfile" returnvariable="getfullfileqry">
<cfinvokeargument name="file" value="#arguments.file#">
<cfinvokeargument name="orderby" value="#arguments.orderby#">
</cfinvoke>

<!--- make sure it exists --->
<cfif isdefined("request.subset_#arguments.subsetfield#") AND Evaluate("request.subset_#arguments.subsetfield#") IS NOT "All" AND Evaluate("request.subset_#arguments.subsetfield#") IS NOT "None">
	<cfset value=Evaluate("request.subset_#arguments.subsetfield#")>
	<cfquery name="check" dbtype="query">
	SELECT * FROM getfullfileqry WHERE #arguments.field#Key = #value#
	</cfquery>
	<cfif check.recordcount IS 0>
		<cfset temp=structdelete(request, "subset_#arguments.subsetfield#")>
	</cfif>
</cfif>

<cfif isdefined("form.cmd_list") AND form.cmd_list IS "subset_#arguments.subsetfield#">
	<cfset request.setPageReset=true>
</cfif>

</cfsilent><cfreturn getfullfileqry></cffunction>

<cffunction name="parseDollarFormat">
<cfargument name="value" type="any" required="yes"><cfsilent>

<cftry>
<cfif len(value) AND LSIsCurrency("#value#")>
	<cfset value=LSParseCurrency(value)>
<cfelse>
	<cfset value=0.0>
</cfif>

<cfcatch>
	<cfset value=0.0>
</cfcatch>

</cftry>

</cfsilent><cfreturn value></cffunction>

<cffunction name="parseDecimalFormat">
<cfargument name="value" type="any" required="yes"><cfsilent>

<cftry>
<cfif IsNumeric(arguments.value) IS false>
	<cfset value=0>
<cfelse>
	<cfset value=arguments.value>
</cfif>

<cfcatch>
	<cfset value=0>
</cfcatch>

</cftry>

</cfsilent><cfreturn value></cffunction>

</cfcomponent>