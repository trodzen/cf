<cfsilent>
<cfinvoke component="db_Reserve" method="init" returnvariable="request.db_ReserveObj" />
<cfinvoke component="db_Schedule" method="init" returnvariable="request.db_ScheduleObj" />
<cfif isdefined("url.resource")>
	<cfset request.Resource_Key="#url.resource#">
</cfif>
<cfif isdefined("url.resource2")>
	<cfset request.Resource_Key2="#url.resource2#">
</cfif>
<cfif isdefined("url.list")>
	<cfset newForm="#url.list#">
</cfif>
</cfsilent>