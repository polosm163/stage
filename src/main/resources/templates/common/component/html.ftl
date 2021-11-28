<#assign ctx = springMacroRequestContext.contextPath/>
<#macro html>
<!DOCTYPE html>
<html>
    <meta charset="utf-8">
    <meta name="copyright" content="亚信科技(南京)有限公司版权所有"/>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="expires" content="0"/>
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-cache, must-revalidate"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <meta id="pageContext" pageName="" contextName="${ctx}" version="${version}"/>

<#nested/>
</html>
</#macro>