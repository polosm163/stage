/*CoreUtil*/
/*工具类，类似java静态工具类*/
var CoreUtil = (function () {
    var coreUtil = {};

    var $ = layui.$ ;

    //工程根路径
    coreUtil.ctx = $("#pageContext").attr("contextName");
    //当前页面
    coreUtil.page = $("#pageContext").attr("pageName");

    /*ajax请求*/
    coreUtil.sendAjax = function (url, params, ft, method, headers,noAuthorityFt,contentType, async) {
        var roleSaveLoading = top.layer.msg('数据提交中 ...'+url,{icon: 16,time:false,shade: [0.3, '#333']});
        //var loadIndex =  top.layer.load(2, { shade: [0.3, '#333'] });

        //alert("util.js "+ coreUtil.ctx + url);
        toastr.info("util.js "+ coreUtil.ctx + url);

        $.ajax({
            url: coreUtil.ctx + url,
            cache: false,
            async: async == undefined ? true : async,
            data: params,
            type: method == undefined ? "POST" : method,
            contentType: contentType == undefined ? 'application/json; charset=UTF-8': contentType ,
            dataType: "json",
            beforeSend: function(request) {
                if(headers == undefined){

                }else if(headers){
                    request.setRequestHeader("authorization", CoreUtil.getData("access_token"));
                    request.setRequestHeader("refresh_token", CoreUtil.getData("refresh_token"));
                }else {
                    request.setRequestHeader("authorization", CoreUtil.getData("access_token"));
                }

            },
            success: function (res) {
                top.layer.close(roleSaveLoading);
                //top.layer.close(loadIndex);
                if (typeof ft == "function") {
                    if(res.code==401001){ //凭证过期重新登录
                        layer.msg("凭证过期请重新登录")
                        top.window.location.href=CoreUtil.ctx +"/index/login"
                    }else if(res.code==401002){  //根据后端提示刷新token
                        /*记录要重复刷新的参数*/
                        var reUrl=url;
                        var reParams=params;
                        var reFt=ft;
                        var reMethod=method;
                        var reHeaders=headers;
                        var reNoAuthorityFt=noAuthorityFt;
                        var reContentType=contentType;
                        var reAsync=async;
                        /*刷新token  然后存入缓存*/
                        CoreUtil.sendAjax("/sys/user/token",null,function (res) {
                            if(res.code==0){
                                CoreUtil.setData("access_token",res.data);
                                /*刷新成功后继续重复请求*/
                                CoreUtil.sendAjax(reUrl,reParams,reFt,reMethod,reHeaders,reNoAuthorityFt,reContentType,reAsync);
                            }else {
                                layer.msg("凭证过期请重新登录");
                                top.window.location.href=CoreUtil.ctx +"/index/login"
                            }
                        },"GET",true)
                    }else if(res.code==0) {
                        if(ft!=null&&ft!=undefined){
                            ft(res);
                        }

                    }else if(res.code==401008){//无权限响应
                        if(ft!=null&&ft!=undefined){
                            noAuthorityFt(res);
                        }

                    } else {
                        layer.msg(res.msg)
                    }

                }
            },
            error:function (XMLHttpRequest, textStatus, errorThrown) {
                top.layer.close(roleSaveLoading);
                if(XMLHttpRequest.status==404){
                    top.window.location.href=CoreUtil.ctx +"/index/404";
                }else{
                    layer.msg("服务器好像除了点问题！请稍后试试");
                }
            }
        });
    };
    /*表单数据封装成 json String*/
    coreUtil.formJson = function (frm) {  //frm：form表单的id
        var o = {};
        var a = $("#"+frm).serializeArray();
        $.each(a, function() {
            if (o[this.name] !== undefined) {
                if (!o[this.name].push) {
                    o[this.name] = [ o[this.name] ];
                }
                o[this.name].push(this.value || '');
            } else {
                o[this.name] = this.value || '';
            }
        });
        return JSON.stringify(o);
    };
    /*存入本地缓存*/
    coreUtil.setData = function(key, value){
        layui.data('LocalData',{
            key :key,
            value: value
        })
    };
    /*从本地缓存拿数据*/
    coreUtil.getData = function(key){
        var localData = layui.data('LocalData');
        return localData[key];
    };


    coreUtil.formattime=function (val) {
        var date=new Date(val);
        var year=date.getFullYear();
        var month=date.getMonth()+1;
        month=month>9?month:('0'+month);
        var day=date.getDate();
        day=day>9?day:('0'+day);
        var hh=date.getHours();
        hh=hh>9?hh:('0'+hh);
        var mm=date.getMinutes();
        mm=mm>9?mm:('0'+mm);
        var ss=date.getSeconds();
        ss=ss>9?ss:('0'+ss);
        var time=year+'-'+month+'-'+day+' '+hh+':'+mm+':'+ss;
        return time;
    };

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

    return coreUtil;
})(CoreUtil, window);
