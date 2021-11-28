<#--<!DOCTYPE html>-->
<#--<html lang="en">-->
<#--<head>-->
    <#--<meta charset="UTF-8">-->
    <#--<link rel="stylesheet" href="/layui/css/layui.css">-->
    <#--<title>Title</title>-->
    <#--<style>-->
        <#--#banner{-->
            <#--background: url("/images/404.png") no-repeat;-->
            <#--background-size: 100%;-->
            <#--overflow: hidden;-->
        <#--}-->
        <#--h1{-->
            <#--font-size: 40px;-->
        <#--}-->
    <#--</style>-->
<#--</head>-->
<#--<body class="childrenBody">-->
<#--<div class="layui-container" style="height: 500px;width: 600px;" id="banner">-->
<#--</div>-->
<#--<div class="layui-container" style="text-align: center;margin-top: 20px;">-->
    <#--<h1>404</h1>-->
    <#--<h3>您访问的页面好像不存在哦！</h3>-->
<#--</div>-->
<#--</body>-->


<#--&lt;#&ndash;<body>&ndash;&gt;-->
<#--&lt;#&ndash;<div class="layui-fluid">&ndash;&gt;-->
    <#--&lt;#&ndash;<div class="layui-card">&ndash;&gt;-->
        <#--&lt;#&ndash;<div class="layui-card-header">表单组合</div>&ndash;&gt;-->
        <#--&lt;#&ndash;<div class="layui-card-body">&ndash;&gt;-->

 <#--&lt;#&ndash;&ndash;&gt;-->
        <#--&lt;#&ndash;</div>&ndash;&gt;-->
    <#--&lt;#&ndash;</div>&ndash;&gt;-->
<#--&lt;#&ndash;</div>&ndash;&gt;-->
<#--&lt;#&ndash;</body>&ndash;&gt;-->


<#--<script>-->

<#--</script>-->
<#--</html>-->







<@html>
<@head title="shouye">




</@head>




	<div>
        <ul>
            <li><button type="button" id="ccc" >2222</button></li>
            <li><button type="button" onclick="success1()">success</button></li>
            <li><button type="button" onclick="error1()">error</button></li>
            <li><button type="button" onclick="info1()">info</button></li>
            <li><button type="button" onclick="warning1()">warning</button></li>
        </ul>
    </div>

	<script type="text/javascript">



        //第一种：主动加载jquery模块
        layui.use(['layer'], function(){


            /*
           参数说明：
               positionClass，消息框在页面显示的位置
                   toast-top-left  顶端左边
                   toast-top-right    顶端右边
                   toast-top-center  顶端中间
                   toast-top-full-width 顶端，宽度铺满整个屏幕
                   toast-botton-right
                   toast-bottom-left
                   toast-bottom-center
                   toast-bottom-full-width
            */
            $(function(){    //自定义参数
                toastr.options = {
                    closeButton: false,  	//是否显示关闭按钮（提示框右上角关闭按钮）。
                    debug: false,  			//是否为调试。
                    progressBar: true,  	//是否显示进度条（设置关闭的超时时间进度条）
                    positionClass: "toast-top-right",  	//消息框在页面显示的位置
                    onclick: null,  		//点击消息框自定义事件
                    showDuration: "300",  	//显示动作时间
                    hideDuration: "1000",  	//隐藏动作时间
                    timeOut: "2000",  		//自动关闭超时时间
                    extendedTimeOut: "1000",
                    showEasing: "swing",
                    hideEasing: "linear",
                    showMethod: "fadeIn",  	//显示的方式，和jquery相同
                    hideMethod: "fadeOut"  	//隐藏的方式，和jquery相同
                    //等其他参数
                };
            });
            function success1(){
                toastr.success('success有消息了');	//ajax回调函数 toastr.success(data.message);
            }
            function error1(){
                toastr.error('error有消息了');
            }
            function info1(){
                toastr.info('info有消息了');
            }
            function warning1(){
                toastr.warning('warning有消息了');
            }

            // function success22() {
            //     alert("22");
            // }

            //提示成功
            var success22 = function(msg) {
                alert("22");
            }
            // $(document).on("click", "#ccc", function() {
            //     alert("22");
            // }
            $("#ccc").on("click",function () {
                toastr.success('success有消息了');	//ajax回调函数 toastr.success(data.message);
            });

        });




    </script>


</@html>

