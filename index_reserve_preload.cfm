<cfsilent>
<cfinvoke component="db_Reserve" method="init" returnvariable="request.db_ReserveObj" />
<cfinvoke component="db_Schedule" method="init" returnvariable="request.db_ScheduleObj" />
<cfparam name="newReserve_Schedule_Key" default="">
</cfsilent>