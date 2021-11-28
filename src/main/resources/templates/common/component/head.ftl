<#assign ctx =springMacroRequestContext.contextPath/>
<#macro head title="">
<head>
    <title>${title}</title>
    <base id="base" href="${ctx}" content="${ctx}" version="${version}">
    <link type="text/css" rel="stylesheet" href="${ctx}/layui/css/layui.css?v=${version}" media="all">
    <link type="text/css" rel="stylesheet" href="//at.alicdn.com/t/font_tnyc012u2rlwstt9.css?v=${version}" media="all" />
    <link type="text/css" rel="stylesheet" href="${ctx}/css/fontxr.css?v=${version}" media="all">
    <link type="text/css" rel="stylesheet" href="${ctx}/css/main.css?v=${version}" media="all">
    <link type="text/css" rel="stylesheet" href="${ctx}/css/form.css?v=${version}">

    <script type="text/javascript" src="${ctx}/layui/layui.all.js?v=${version}"></script>
    <script type="text/javascript" src="${ctx}/js/util.js?v=${version}"></script>

    <link type="text/css" rel="stylesheet"  href="${ctx}/core/toastr/toastr.min.css?v=${version}">

    <script type="text/javascript" src="${ctx}/login/vendor/jquery/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="${ctx}/core/toastr/toastr.min.js?v=${version}"></script>

   <#nested/>
</head>
</#macro>

