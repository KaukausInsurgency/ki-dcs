<a href='http://158.69.193.117:8080/job/KI-Test-DCS/'><img src='http://158.69.193.117:8080/job/KI-Test-DCS/badge/icon'></a>

# KI
Kaukasus Insurgency Main Development Branch

Tools Needed:

1. Visual Studio 2017 Community Edition (Install ASP.NET and .NET CORE)
2. Lua Development Tools for Eclipse / Zerobrane Studio (Lua IDE)
3. MySQL DB and MySQL WorkBench

Exploring the Code

1. /DCSMissions : Contains the .miz files that are used inside DCS (*.miz)
2. /DCSMod      : Server Side Mod that manages player accounts, connections, and TCP Traffic (*.lua)
3. /DCSScripts  : Core lua scripts that make the KI mission possible inside DCS (*.lua)
4. /SQL         : Contains the Schema of the database + mock data (*.sql)
5. /TCPServer   : Visual Studio Solution for TCP Server (*.cs)
6. /WebApp      : ASP.NET MVC Web Site (*.cs, *.js)

Technologies/Frameworks used:

1. SignalR - realtime web application updates
2. Tooltipster - web page tool tips
3. Mapbox - web page zoomable map (patched by Igneous01)
4. LuaSocket - UDP and TCP connections
5. LuaJSON - JSON library for Lua
6. Dynatable - web page tables
7. Highcharts - web page charts and graphs
8. Bootstrap - web page styles
9. JQuery
10. ASP.Net MVC Framework
11. Log4Net - web application logging
12. MySql .Net Connector
13. MySql Database
14. MOOSE DCS Scripting Framework
15. MIST DCS Scripting Framework
