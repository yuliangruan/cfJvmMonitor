<cfset jvmMonitor=new jvmMonitor()>
<cfset seriesLabels_group1=jvmMonitor.jvmMemData_cfchart_config(group=1)>
<cfset seriesLabels_group2=jvmMonitor.jvmMemData_cfchart_config(group=2)>
<cfset seriesLabels_group3=jvmMonitor.jvmMemData_cfchart_config(group=3)>
<cfset interval=120000> <!--- zingchart interval.   values < 50 are interpreted in seconds.  values >= 50 are interpreted in milliseconds --->

<cfset chartWidth=620>
<cfset chartHeight=280>

<cfset legend={"vertical-align"="top","align"="left"}>

<div style="float:left">
	<cfchart format="html" type="line" refresh="#{"type"="feed","interval":interval,"url":"jvmMonitor.cfc?method=jvmMemData_feed&group=1"}#" chartWidth="#chartWidth#" chartHeight="#chartHeight#" legend="#legend#">
		<cfloop list="#seriesLabels_group1#" item="lbl">
			<cfchartseries label="#lbl#" toolTip="#{'text'='%t\n%v MB'}#"/>
		</cfloop>
	</cfchart>
</div>
<div style="float:left">
	<cfchart format="html" type="line" refresh="#{"type"="feed","interval":interval,"url":"jvmMonitor.cfc?method=jvmMemData_feed&group=2"}#" chartWidth="#chartWidth#" chartHeight="#chartHeight#" legend="#legend#">
		<cfloop list="#seriesLabels_group2#" item="lbl">
			<cfchartseries label="#lbl#" toolTip="#{'text'='%t\n%v MB'}#"/>
		</cfloop>
	</cfchart>
</div>
<div style="float:left">
	<cfchart format="html" type="line" refresh="#{"type"="feed","interval":interval,"url":"jvmMonitor.cfc?method=jvmMemData_feed&group=3"}#" chartWidth="#chartWidth#" chartHeight="#chartHeight#" legend="#legend#">
		<cfloop list="#seriesLabels_group3#" item="lbl">
			<cfchartseries label="#lbl#" toolTip="#{'text'='%t\n%v MB'}#"/>
		</cfloop>
	</cfchart>
</div>
