<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>后台管理系统</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">

    <meta id="pageContext" staffId="22" contextName="${base.contextPath}" version="${version}"/>
    <#--开始--> <#--结束 -->
    <link rel="stylesheet" href="/layui/css/layui.css?v=${version}" media="all">
    <link rel="stylesheet" href="//at.alicdn.com/t/font_tnyc012u2rlwstt9.css" media="all" />
    <link rel="stylesheet" href="/css/fontxr.css?v=${version}" media="all">

    <link rel="stylesheet" href="/css/main.css?v=${version}" media="all">

    <script src="/layui/layui.all.js?v=${version}"></script>

    <script src="/js/home.js"></script>
    <script src="/login/js/login.util.js"></script>
    <script src="/js/util.js"></script>
    <style>
        /*.logo{ color: #fff; float: left; line-height:60px; font-size:20px; padding:0 25px; text-align: center; width:180px;}*/
        .layui-tab-title .layui-this { background-color:#009688; color: #eee;}
        .first-tab i.layui-tab-close{
            display:none!important;
        }
    </style>
</head>
<body class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域 -->
        <div class="layui-header">
            <div class="layui-main">
                <a href="/index/home" class="logo">后台管理系统</a>

                <!-- 显示/隐藏菜单 -->
                <a href="javascript:" class="iconfont hideMenu icon-menu1"></a>


                <!-- 天气信息 -->
                <div class="weather" pc>
                    <div id="tp-weather-widget"></div>
                    <script>(function(T,h,i,n,k,P,a,g,e){g=function(){P=h.createElement(i);a=h.getElementsByTagName(i)[0];P.src=k;P.charset="utf-8";P.async=1;a.parentNode.insertBefore(P,a)};T["ThinkPageWeatherWidgetObject"]=n;T[n]||(T[n]=function(){(T[n].q=T[n].q||[]).push(arguments)});T[n].l=+new Date();if(T.attachEvent){T.attachEvent("onload",g)}else{T.addEventListener("load",g,false)}}(window,document,"script","tpwidget","//widget.seniverse.com/widget/chameleon.js"))</script>
                    <script>tpwidget("init", {
                        "flavor": "slim",
                        "location": "WX4FBXXFKE4F",
                        "geolocation": "enabled",
                        "language": "zh-chs",
                        "unit": "c",
                        "theme": "chameleon",
                        "container": "tp-weather-widget",
                        "bubble": "disabled",
                        "alarmType": "badge",
                        "color": "#FFFFFF",
                        "uid": "U9EC08A15F",
                        "hash": "039da28f5581f4bcb5c799fb4cdfb673"
                    });
                    tpwidget("show");</script>
                </div>
                <!--头部右侧--><!-- 顶部右侧菜单 -->
                <ul class="layui-nav layui-layout-right">
                    <#--<li class="layui-nav-item" mobile>
                        <a href="javascript:" class="mobileAddTab" data-url="page/user/changePwd.html"><i class="iconfont icon-shezhi1" data-icon="icon-shezhi1"></i><cite>设置</cite></a>
                    </li>
                    <li class="layui-nav-item" mobile>
                        <a href="${base}/systemLogout" class="signOut"><i class="iconfont icon-loginout"></i> 退出</a>
                    </li>
                    <li class="layui-nav-item" pc>
                        <a href="javascript:"><i class="iconfont icon-gonggao"></i><cite>系统公告</cite></a>
                    </li>
                    -->
                    <li class="layui-nav-item" pc>
                        <a id="deptName" href="javascript:;"></a>
                    </li>
                    <li class="layui-nav-item">
                        <a href="javascript:" >
                            <i class="layui-icon layui-icon-username" style="font-size: 26px; color: #fff;"></i><span id="nickName"></span>
                        </a>
                        <dl class="layui-nav-child">
                            <dd><a href="javascript:;" data-id="userProper" data-title="基本资料" data-url="/index/users/info" class="menuNvaBar"><i class="iconfont icon-zhanghu" data-icon="icon-zhanghu"></i><cite>基本资料</cite></a></dd>
                            <dd><a href="javascript:;" data-id="userSafe" data-title="安全设置" data-url="/index/users/password"  class="menuNvaBar"><i class="iconfont icon-shezhi1" data-icon="icon-shezhi1"></i><cite>更换密码</cite></a></dd>
                            <dd><a href="javascript:;" class="menuNvaBar" id="logout"><i class="iconfont icon-loginout"></i><cite>退出</cite></a></dd>
                        </dl>
                    </li>
                </ul>
            </div>
        </div>
        <!-- 左侧菜单-->
         <div id="mainmenu" class="layui-side layui-bg-black">
                <div class="layui-side-scroll">
                    <div class="navBar layui-side-scroll" id="navBarId"></div>
             </div>
        </div>
        <!-- 内容主体区域 -->
        <div class="layui-body layui-form">
            <div class="layui-tab marg0" lay-filter="tab" lay-allowclose="true">
                <ul class="layui-tab-title">
                    <li class="first-tab layui-this">
                        <i class="layui-icon layui-icon-vercode" style="margin-right: 6px"></i>
                        后台首页
                    </li>
                </ul>
                <!-- 中间内容区域 -->
                <div class="layui-tab-content">
                    <div class="layui-tab-item layui-show"  >
                        <iframe src="${base}/index/main" style="display:block;" frameborder="0" name="content" width="100%" height="100px" id="home"></iframe>
                    </div>
                </div>
            </div>
        </div>

        <!-- 底部 -->
        <#--<div class="layui-footer footer"> <p>Copyright ©   Design By </p> </div>-->


    </div>
</div>
<!-- 移动导航 -->
<div class="site-tree-mobile layui-hide"><i class="layui-icon">&#xe602;</i></div>
<div class="site-mobile-shade"></div>
</body>
</html>