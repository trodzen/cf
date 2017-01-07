<cfsilent>
<cfparam name="request.title" default="">
<cfparam name="request.pageheader" default="">
<cfparam name="request.signupinprocess" default=false>
<cfparam name="request.logininprocess" default=false>
<cfparam name="submitform" default="">
<!--- set request cmd default --->
<cfinvoke component="#request.snipObj#" method="doCmdDefault" />
<!--- load html layout formatting object --->
<cfinvoke component="layout" method="init" returnvariable="request.layoutObj" />
</cfsilent>

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfheader name="expires" value="#GetHttpTimeString(Now())#"> 
<cfheader name="pragma" value="no-cache">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!---
<meta property="og:title" content="Hestia Cruises" />
<meta property="og:type" content="company" />
<meta property="og:site_name" content="Hestia Cruises" />
<meta property="fb:admins" content="619019459" />
--->
<meta property="og:url" content="#request.host_facebook_page#" />
<title>#request.host_fullname# - #request.title#</title>
<link href="#request.stylesheeturl#/application.css" rel="stylesheet" type="text/css" />
<script src="#request.javascripturl#/main.js" type="text/javascript"></script>
<cfif isdefined("request.loadeditor") AND request.loadeditor><script type="text/javascript" src="#request.rooturl#/editor/ckeditor.js"></script></cfif>
<cfif isdefined("request.loadweather") AND request.loadweather><link rel="STYLESHEET" type="text/css" href="#request.stylesheeturl#/weather.css"></cfif>
</head>
<body onLoad="init()"><DIV id="pagewrapper">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<td>#request.layoutObj.doPixel()#</td>
<td>#request.layoutObj.doPixel()#</td>
<tr>
<cfif request.isLoggedIn>
<td><span class="biggerheading">#request.host_fullname#</span>&nbsp;&nbsp;
<span class="SmallerItalicFade">#request.host_tagline#</span></td><td align="right">Welcome, #request.Login_ID#&nbsp;|&nbsp;<a href="#request.snipObj.getURL("logout.cfm", "none", false)#">Log Out</a><!--- <br>
<span class="Smaller">Account Balance #request.layoutObj.doDollarformat(request.Account_Balance)#</span> ---></td>
<cfelseif request.logininprocess IS false AND request.signupinprocess IS false>
<cfset qryString=request.snipObj.getQryString()>
<td><span class="biggerheading">#request.host_fullname#</span>&nbsp;&nbsp;
<span class="SmallerItalicFade">#request.host_tagline#</span></td><td align="right"><a href="#request.snipObj.getURL("signup.cfm", "#request.cmd#", false, "#qryString#")#"><span class="emphasis">Sign Up</span></a>&nbsp;|&nbsp;<a href="#request.snipObj.getURL("login.cfm", "#request.cmd#", false, "#qryString#")#">log in</a></td>
<cfelse>
<td><span class="biggerheading">#request.host_fullname#</span>&nbsp;&nbsp;
<span class="SmallerItalicFade">#request.host_tagline#</span></td>
</cfif>
</tr></table>

<tr><td>#request.layoutObj.doPixel(height=2)#</td></tr>
</table>

<!--- begin nav bar --->
<div class="navbar">
<ul>
<li>#request.layoutObj.doButton("Home")#</li>
<li>#request.layoutObj.doButton("myaccount", "My Account")#</li>
<li>#request.layoutObj.doButton("reserve", "Reservations")#</li>
<li>#request.layoutObj.doButton("Rates")#</li>
<li>#request.layoutObj.doButton("Schedule")#</li>
<li>#request.layoutObj.doButton("Directions")#</li>
</ul>
</div>
<!--- end nav bar --->
<div id="contentwrapper">
<DIV class="heading"><table width="760" border="0" cellpadding="0" cellspacing="0"><tr><td class="heading" width="670" nowrap="nowrap">#request.pageheader#</td>

<cfif len(request.host_facebook_page)>
<td align="right"><script src="http://connect.facebook.net/en_US/all.js##xfbml=1"></script><fb:like href="#request.host_facebook_page#" layout="button_count" show_faces="false" width="90"></fb:like></td>
</cfif>

</tr></table></DIV>
#request.layoutObj.doError()#
</cfoutput>