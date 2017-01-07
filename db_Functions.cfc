<cfcomponent output="no">

<!--- simple values --->
<cfset itcontains="LIKE">
<cfset iseq="=">
<cfset isne="<>">
<cfset isgt=">">
<cfset islt="<">
<cfset isge=">=">
<cfset isle="<=">
<cfset isin="IN">
<cfset isnotin="NOT IN">
<cfset isint="integer">
<cfset ischar="varchar">
<cfset ists="timestamp">
<cfset isdate="date">
<cfset isbit="bit">
<cfset islist="list">
<cfset ishtml="html">
<cfset isdec="decimal">
<cfset null="">

<!--- return query values --->
<cffunction name="values" output="no">
<cfargument name="data" type="string" required="yes">
<cfargument name="type" type="string" required="yes">
<cfargument name="format" default="0.99">

<cfset setcomplete=false>
<cfset myoutput="">

<cfswitch expression="#arguments.type#">
<cfcase value="decimal">
	<cfif isnumeric(arguments.data)>
		<cfset myoutput="#numberformat(arguments.data, arguments.format)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="integer">
	<cfif isnumeric(arguments.data)>
		<cfset myoutput=#arguments.data#>
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="varchar,html">
	<cfif request.snipObj.ismystring(arguments.data)>
		<cfset myoutput="'#request.snipObj.escapemystring(arguments.data)#'">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="list">
	<cfif request.snipObj.ismystring(arguments.data)>
		<cfset myoutput="',#request.snipObj.escapemystring(arguments.data)#,'">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="timestamp">
	<cfif isdate(arguments.data)>
		<cfset myoutput="#CreateODBCDateTime(arguments.data)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="date">
	<cfif isdate(arguments.data)>
		<cfset myoutput="#CreateODBCDate(arguments.data)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="bit">
	<cfif isboolean(arguments.data)>
		<cfif arguments.data>
			<cfset myoutput=1>
			<cfset setcomplete=true>
		<cfelse>
			<cfset myoutput=0>
			<cfset setcomplete=true>
		</cfif>
	</cfif>
</cfcase>
</cfswitch>
<cfif lcase(arguments.data) IS "null" OR Len(trim(arguments.data)) IS 0 OR NOT setcomplete>
	<cfset myoutput="NULL">
</cfif>

<cfreturn myoutput>
</cffunction>

<!--- return query where clause --->
<cffunction name="where" output="no">
<cfargument name="operator" type="string" required="yes">
<cfargument name="data" type="string" required="yes">
<cfargument name="type" type="string" required="yes">
<cfargument name="format" default="0.99">

<cfset setcomplete=false>
<cfset myoutput="">

<cfswitch expression="#arguments.type#">
<cfcase value="decimal">
	<cfif isnumeric(arguments.data)>
		<cfset myoutput="#arguments.operator# #numberformat(arguments.data, arguments.format)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="integer">
	<cfif request.snipObj.ismystring(arguments.data) AND arguments.operator CONTAINS "IN">
		<cfset myoutput="#arguments.operator# (#request.snipObj.escapemystring(arguments.data)#)">
		<cfset setcomplete=true>
	<cfelseif isnumeric(arguments.data)>
		<cfset myoutput="#arguments.operator# #arguments.data#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="varchar,html">
	<cfif request.snipObj.ismystring(arguments.data)>
		<cfset myoutput="#arguments.operator# '#request.snipObj.escapemystring(arguments.data)#'">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="list">
	<cfif request.snipObj.ismystring(arguments.data)>
		<cfif arguments.operator IS itcontains>
			<cfset myoutput="#arguments.operator# '%,#request.snipObj.escapemystring(arguments.data)#,%'">
			<cfset setcomplete=true>
		<cfelse>
			<cfset myoutput="#arguments.operator# ',#request.snipObj.escapemystring(arguments.data)#,'">
			<cfset setcomplete=true>
		</cfif>
	</cfif>
</cfcase>
<cfcase value="timestamp">
	<cfif isdate(data)>
		<cfset myoutput="#arguments.operator# #CreateODBCDateTime(arguments.data)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="date">
	<cfif isdate(data)>
		<cfset myoutput="#arguments.operator# #CreateODBCDate(arguments.data)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="bit">
	<cfif isboolean(data)>
		<cfif arguments.data>
			<cfset myoutput="#arguments.operator# 1">
			<cfset setcomplete=true>
		<cfelse>
			<cfset myoutput="#arguments.operator# 0">
			<cfset setcomplete=true>
		</cfif>
	</cfif>
</cfcase>
</cfswitch>
<cfif lcase(arguments.data) IS "null" OR Len(trim(arguments.data)) IS 0 OR NOT setcomplete>
	<cfswitch expression="#arguments.operator#">
	<cfcase value="=,LIKE,IN">
		<cfset myoutput="IS NULL">
	</cfcase>
	<cfcase value="<>,NOT IN">
		<cfset myoutput="IS NOT NULL">
	</cfcase>
	<cfdefaultcase>
		<cfset myoutput="#arguments.operator# NULL">
	</cfdefaultcase>
	</cfswitch>
</cfif>

<cfreturn myoutput>
</cffunction>

<!--- return query set clause --->
<cffunction name="set" output="no">
<cfargument name="operator" type="string" required="yes">
<cfargument name="data" type="string" required="yes">
<cfargument name="type" type="string" required="yes">
<cfargument name="format" default="0.99">

<cfset setcomplete=false>
<cfset myoutput="">

<cfswitch expression="#arguments.type#">
<cfcase value="decimal">
	<cfif isnumeric(arguments.data)>
		<cfset myoutput="#arguments.operator# #numberformat(arguments.data, arguments.format)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="integer">
	<cfif isnumeric(arguments.data)>
		<cfset myoutput="#arguments.operator# #arguments.data#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="varchar,html">
	<cfif request.snipObj.ismystring(arguments.data)>
		<cfset myoutput="#arguments.operator# '#request.snipObj.escapemystring(arguments.data)#'">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="list">
	<cfif request.snipObj.ismystring(arguments.data)>
		<cfset myoutput="#arguments.operator# ',#request.snipObj.escapemystring(arguments.data)#,'">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="timestamp">
	<cfif isdate(arguments.data)>
		<cfset myoutput="#arguments.operator# #CreateODBCDateTime(arguments.data)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="date">
	<cfif isdate(arguments.data)>
		<cfset myoutput="#arguments.operator# #CreateODBCDate(arguments.data)#">
		<cfset setcomplete=true>
	</cfif>
</cfcase>
<cfcase value="bit">
	<cfif isboolean(arguments.data)>
		<cfif arguments.data>
			<cfset myoutput="#arguments.operator# 1">
			<cfset setcomplete=true>
		<cfelse>
			<cfset myoutput="#arguments.operator# 0">
			<cfset setcomplete=true>
		</cfif>
	</cfif>
</cfcase>
</cfswitch>
<cfif lcase(arguments.data) IS "null" OR Len(trim(arguments.data)) IS 0 OR NOT setcomplete>
	<cfset myoutput="#arguments.operator# NULL">
</cfif>

<cfreturn myoutput>
</cffunction>

</cfcomponent>