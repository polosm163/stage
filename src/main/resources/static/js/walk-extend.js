/**
 * walk框架通用函数库，依赖jquery加载
 */
var $walk = {
	//工程根路径
	ctx : $("#pageContext").attr("contextName"),
	//当前页面
	page : $("#pageContext").attr("pageName"),
	//服务器是否支持combo。在app.properties中指定
	comboAble : ($("#pageContext").attr("comboAble") == true),
	
	//判断浏览器是否ie8以下
	isIE8Under : function(){
		return $.browser.msie && $.browser.version < 8;
	},
	
	//判断浏览器是否ie9以下
	isIE9Under : function(){
		return $.browser.msie && $.browser.version < 9;
	},
	
	//弹出信息框。 默认是从最顶层窗口弹出，但如果写了回调方法则从调用窗口处弹出
	alert : function (msg, typeOrFn, fn){
		//第二个参数可能传入回调函数
		if(typeOrFn && $.isFunction(typeOrFn)){
			fn = typeOrFn;
		}
		//第一个参数可能传入一个json
		if($.isJson(msg) && msg.type != ''){
			typeOrFn = msg.type;
			msg = msg.text;
		} 
		//第一个参数可能传入一个消息字符串 格式：<div><div id='type'>success</div><div id='text'>成功</div></div>
		else{
			try{
				var json = this.parseMessageJSON($(msg));
				if(json.type){
					typeOrFn = json.type;
					msg = json.text;
				}
			}catch(e){}
		}
		var title = "提示";
		if(typeOrFn == "warning"){
			title = "警告";
		} else if(typeOrFn == "success"){
			title = "成功";
		} else if(typeOrFn == "error"){
			title = "错误";
		} else {
			typeOrFn = "info";
		}
		
		//如果有回调函数将会从调用页面处弹出，否则从顶层窗口弹出
		// title:_12,msg:msg,icon:_13,fn:fn
		var dialogObj = null;
		var buttons = $.walk.mergeBtns({"确认" : function(){dialogObj && dialogObj.dialog("close");}});
		easyloader.load("messager", function(){
			if(fn && $.isFunction(fn)){
				dialogObj = $.messager.alert({title : title, msg:msg, icon:typeOrFn, buttons : buttons,top:$.walk.setMessagerTop('curr'), onClose : function(){
					fn && $.isFunction(fn) && fn();
				}});
			}else{
				dialogObj = $.messager.alert({title : title, msg:msg, icon:typeOrFn, buttons : buttons,top:$.walk.setMessagerTop('top')});
			}
			buttons.find('a').bind('keydown',function(e){
				if(e.keyCode==32){
					$(this).trigger('click');
				 }
			})
		});
	},
	
	//确认框
	confirm : function (msg, titleOrFn, fn){
		//第二个参数可能传入回调函数
		if(titleOrFn && $.isFunction(titleOrFn)){
			fn = titleOrFn;
			titleOrFn = "确认";
		}
		titleOrFn = titleOrFn ? titleOrFn : "确认";
		var dialogObj = null;
		var buttons = $.walk.mergeBtns({"确认" : function(){dialogObj && dialogObj.dialog("close"); fn && $.isFunction(fn) && fn(true)},
			"取消" : function(){dialogObj && dialogObj.dialog("close"); fn && $.isFunction(fn) && fn(false)}});
		easyloader.load("messager", function(){
			dialogObj = $.messager.confirm({title : titleOrFn, msg:msg, buttons : buttons,top : $.walk.setMessagerTop('curr')});
			dialogObj.find(".panel-tool-close").click(function(){
				 fn && $.isFunction(fn) && fn(false);
			});
		});
	},
	
	//对话框
	prompt : function (msg, titleOrFn, fn){
		//第二个参数可能传入回调函数
		if(titleOrFn && $.isFunction(titleOrFn)){
			fn = titleOrFn;
			titleOrFn = "对话框";
		}
		titleOrFn = titleOrFn ? titleOrFn : "对话框";
		var dialogObj = null;
		var buttons = $.walk.mergeBtns({"确认" : function(){
				var msg = dialogObj ? dialogObj.find(".messager-input").val() : "";
				dialogObj && dialogObj.dialog("close"); 
				fn && $.isFunction(fn) && fn(msg);
			},
			"取消" : function(){dialogObj && dialogObj.dialog("close"); fn && $.isFunction(fn) && fn();}});
		easyloader.load("messager", function(){
			dialogObj = $.messager.prompt({title : titleOrFn, msg:msg, buttons : buttons});
			dialogObj.find(".panel-tool-close").click(function(){
				 fn && $.isFunction(fn) && fn();
			});
		});
	},
	
	//进度框
	progress : function (optionsOrMethod){
		easyloader.load("messager", function(){
			$.messager.progress(optionsOrMethod);
		});
	},
	
	//show
	show : function (options){
		easyloader.load("messager", function(){
			$.messager.show(options);
		});
		
	},
	setMessagerTop :function(winType){
		var topHeight = 0;
		var scrollTopHeight = 0;
		if(winType =='curr'){
			scrollTopHeight = $(document).scrollTop();
		}else{
			scrollTopHeight = $($.walk.getTopWindow().document).scrollTop();
		}
		topHeight = scrollTopHeight + 80;
		return topHeight;
	},
	//获取工程最顶端窗口。不用top的原因：可能会有其他工程iframe嵌套
	getTopWindow : function (){
		var parents = this._getParents();
		for(var i = (parents.length - 1); i >= 0; i--){
			try{
				if(parents[i].$ && parents[i].$.walk){
					return parents[i];
				}
			}catch(e){}
		}
	},
	
	//获取父窗口集合
	_getParents : function(){
		var parents = [];
		var win = window;
		parents[0] = win;
		for (var i = 1; win != top; i++) {
			if (win.parent) {
				win = win.parent;
				parents[i] = win;
				continue;
			}
			break;
		}
		return parents;
	},
	
	/**
     * 取当前url参数
     */
    getValueByUrl : function(name, defaultValue, url) {
    	url = !(url) ? window.location.search : url;
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = url.substr(1).match(reg);
        if (r != null) {
            return decodeURIComponent(r[2]);
        }
        return defaultValue;
    },
	
	//获取blockUI配置信息
	getBlockDefaults : function(){
		$.blockUI.defaults = {
			showOverlay : true,
		    css : {
		        padding : 2,
		        left : '20%',
		    	top : '3%',
		        color : '#333',
		        border : 'none',
		        backgroundColor : 'none',
		        cursor : 'default'
		    },
		    overlayCSS : {
		        backgroundColor : '#EEE',
		        opacity : 0.3,
		        cursor : 'default'
		    }
		};
		return $.blockUI.defaults;
	},
	
	/**
	 * 取随机数
	 */
	getRandomParam : function() {
		var date = new Date();
		return "" + date.getYear() + (date.getMonth() + 1) + date.getDate() + date.getHours() + date.getMinutes() + date.getSeconds() + date.getMilliseconds();
	},
	formate:function(source,args){
        var result = source;
        if(typeof(args) == "object"){
            if(args.length==undefined){
                for (var key in args) {
                    if(args[key]!=undefined){
                        var reg = new RegExp("({" + key + "})", "g");
                        result = result.replace(reg, args[key]);
                    }
                }
            }else{
                for (var i = 0; i < args.length; i++) {
                    if (args[i] != undefined) {
                        var reg = new RegExp("({[" + i + "]})", "g");
                        result = result.replace(reg, args[i]);
                    }
                }
            }
        }
        return result;
    },
	/**
	 * 获取请求URL
	 * 调用示例：$.walk.getRequestURL($.walk.ctx + '/example', "queryList", "roleId=1&roleCode=2");
	 * @param baseUrl： 页面访问路径，例如$.walk.ctx + '/example'
	 * @param method：调用方法，例如：queryList
	 * @param params：传入参数，例如：roleId=1&roleCode=2
	 * @return
	 */
	getRequestURL : function(baseUrl, method, params, conditionFormId) {
		if(!baseUrl) return null;
		var url = baseUrl.startsWith(this.ctx) ? baseUrl : (this.ctx + "/" + baseUrl);
		if (method != null) url += "/" + method;
		
		if (params) {
			if($.isJson(params)){
				if(conditionFormId){
					$.extend(params, this.getQueryParams(conditionFormId))
				}
				url += "?" + $.param(params) + "&random=" + this.getRandomParam();
			} else {
				url += "?" + params + $.param(this.getQueryParams(conditionFormId)) + "&random=" + this.getRandomParam();
			}
		} else {
			url += "?random=" + this.getRandomParam();
		}
		return url;
	},
	
	/**
	 * 序列化指定区域
	 */
	serializeArea : function(areaId){
		var serializeStr = null;
		if(!areaId){
			alert("请指定区域Id！");
			return;
		}
		var area = $("#" + areaId);
		if(area.size() == 0){
			alert("区域Id[" + areaId + "]不存在！");
			return;
		}
		
		//如果指定区域是表单，则直接序列化
		if(area.is("form")){
			serializeStr = area.serialize()
		} else {
			serializeStr = $.param(area.find("input,select,textarea").serializeArray());
		}
		return serializeStr;
	},
	
	/**
	 * 参数串转json对象
	 */
	param2json : function(param){
		if(!param){
			return {};
		}
		var obj = {};
	    var pairs = param.split('&');
	    var name,value;
	    $.each(pairs, function(i, pair) {
	        pair = pair.split('=');
	        name = decodeURIComponent(pair[0]);
	        if(name){
		        value = decodeURIComponent(pair[1]);
		        obj[name] =  !obj[name] ? value :[].concat(obj[name]).concat(value);//若有多个同名称的参数，则拼接
	        }
	    });
	    return obj;
	},
	
	/***
	 * 适配当前1.8.3版本jquery，serialize之后会把空格转换为"+"，在将此字符串参数还原为json之后需要把字符串里的"+"还原回"%20"
	 * 
	 * @param serializedParamStr
	 */
	revertSerializedParamStr : function(serializedParamStr) {
		return serializedParamStr && serializedParamStr.length > 0 ? serializedParamStr.replace( /\+/g, "%20" ) : serializedParamStr;
	},
	
	/**
	 * 将指定form参数转换为json对象
	 */
	getQueryParams : function (conditionAreaId, otherParams){
		var queryParams = {};
		conditionAreaId && $.extend(queryParams, this.param2json(this.revertSerializedParamStr(this.serializeArea(conditionAreaId))));
	    
	    //扩展额外参数
	    if(otherParams){
	    	if($.isJson(otherParams)){
			    $.extend(queryParams, otherParams)
	    	} else if($.isString(otherParams)){
	    		$.extend(queryParams, this.param2json(otherParams))
	    	}
		}
	    return queryParams;
	},
	
	//获取message信息
	parseMessageJSON : function(resp){
		var type = resp.find("#type").text();
		var text = resp.find("#text").html();
		return {
			type : type,
			text : text,
			isSuccess : type == "success",
			isInfo : type == "info",
			isWarning : type == "warning",
			isError : type == "error"
		};
	},
	
	//释放iframe内存
	clearFrameCache : function(iframe){
		iframe.src = '';
		iframe.contentWindow.document.write('');
		iframe.contentWindow.close();
		if($.browser.msie){
            CollectGarbage();
            CollectGarbage();
        }
	},
	
	/**
	 * 查询列表
	 * 
	 * @param gridId easyui的数据表格
	 * @param conditionAreaId 查询条件区域
	 * @param otherParams 其他参数
	 */
	queryList : function (gridId, conditionAreaId, otherParams){
		if(!gridId){
			alert("请指定第一个参数，easyUI表格Id！");
			return;
		}
		if(!conditionAreaId){
			alert("请指定第二个参数，条件所在区域Id！");
			return;
		}
		var queryParams = this.getQueryParams(conditionAreaId, otherParams);
		var opts = {
			queryParams : queryParams,
			pageNumber : 1
		};
		var grid = $("#" + gridId);
		if(grid.hasClass("easyui-datagrid")){
			grid.datagrid(opts);
		} else if(grid.hasClass("easyui-treegrid")){
			grid.treegrid(opts);
		}else if(gridId=="commQryGrid"){//去掉页面class 避免二次请求
			grid.datagrid(opts);
		}
	},
	
	//验证表单(form)
	validateForm : function (form){
		var formValidator = form.attr("validXml");
		var validate = $.parseJSON(formValidator);
		seajs.use(['$validate'], function(){
			form.validate({
			    /* 设置验证规则 */
			    rules: validate.rules,
			
			    /* 设置错误信息 */
			    messages: validate.messages,
			
			    /* 设置验证触发事件 */
			    focusInvalid: false,
			    onkeyup: false,
			
			    /* 设置错误信息提示DOM */
			    errorPlacement: function(error, element) {
					error.appendTo(element.parent());
			    }
			});
		});
	},
	
	//模拟ajax方式提交form
	ajaxSubmit : function (formId, action, callbackFunc){
		if(!formId){
			alert("请指定formId！");
			return;
		}
		var form = $("#" + formId);
		if(form.size() == 0){
			//form无id有name也可
			form = $("form[name='" + formId + "']");
			if(form.size() == 0){
				alert("form[" + formId + "]不存在！");
				return;
			}
		}
		//第二个参数可能传入回调函数
		if(action && $.isFunction(action)){
			callbackFunc = action;
			action = form.attr("action");
			if(!action){
				alert("请指定form[" + formId + "]action属性！");
				return;
			}
		}
		//开始提交
		seajs.use(['$form','$validate'], function(){
			var formValidator = form.attr("validXml");
			if(formValidator && !form.valid()) return false;//校验失败返回
			
			form.form('submit', {
				url: action,
				method : "post",
				onSubmit : function(param){
					$.walk.showLoading();
					
					//如果后端一直未返回数据，10秒后隐藏遮罩层。
					setTimeout(function(){
						$.walk.hideLoading();
					}, 10000);
				},
				success : function(response) {
					$.walk.hideLoading();
					
					var isMessageMethod = false;
					var resp = response;
					if(resp){
						//后端调用了message.xxx方法
						if(resp.indexOf('_MESSAGE_RESPONSE') > -1){
							isMessageMethod = true;
							resp = $.walk.parseMessageJSON($(resp));
							
							//如果消息类型错误直接弹出错误信息
							if(resp.isError == true){
								$.walk.alert(resp);
								return ;
							}
						} else {
							//尝试转成json
							try{
								resp = $.parseJSON(resp);
							}catch(e){}
						}
					}
					//如果写了回调函数，逻辑在回调函数里自处理，否则在后端调用了message.xxx方法后前台自动弹出消息。
					if(callbackFunc && $.isFunction(callbackFunc)){
						callbackFunc.call(this, resp);
					} else {
						//后端调用了message.xxx方法后前台自动弹出消息
						if(isMessageMethod){
							$.walk.alert(resp);
						}
					}
				}
			});
		});
	},
	
	/* ajax局部刷新
	 * url: 请求url
	 * params:参数
	 * partids：刷新区域ID，多个以逗号分隔
	 * callbackFunc：回调方法
	*/
	ajaxRefresh : function(url, params, partids, callbackFunc) {
		if(params){
			params._page_name = this.page;
		}
		$.ajax({
			url : url,
			data : params,
			type : "POST",
			dataType : "html",
			cache: false,
			success : function(data){
				if(partids) {
					var parts = partids.split(",");
					for(var i=0; i<parts.length; i++){
						if(parts[i] && parts[i].trim()) {
							var partId = parts[i].trim();
							//初始化jQuery.select2组件
							if($.walk.isIE9Under()){
								$("#"+partId).replaceWith($(data).find("#"+partId));
							} else {
								if($("#"+partId).hasClass("w-select2")){
									seajs.use('$select2',function(){
										$("#"+partId).select2("destroy");
										$("#"+partId).replaceWith($(data).find("#"+partId));
										$("#"+partId).select2();
									});
								} else {
									$("#"+partId).replaceWith($(data).find("#"+partId));
								}
							}
							
						}
					}
				}
				if(callbackFunc && $.isFunction(callbackFunc)){
					callbackFunc.call(this, data);
				}
			}
		});
	},
	
	/** 手工显示的遮罩层不能通过ajaxStop关闭 */
	isLoadingManual : false,
	isLoading : false,
	//显示遮罩层
	showLoading : function (opts){
		opts = opts || {};
		if (this.isLoading && opts.isAjax) {return;}// 已经显示的弹出，ajax不会再弹出
		this.isLoading = true;
		this.isLoadingManual = !opts.isAjax;
		var loadingTarget = opts.loadingTarget, top = opts.top || "50%", left = opts.left|| "50%",iframeSrc = opts.iframeSrc || "";
		var loadingText = opts.text || "";
		var loadingStyle = opts.cls || "";
		var message = "<div class='loadingArea " + loadingStyle+ "'>"+ loadingText + "</div>";
		
		seajs.use(['$blockui'], function(){
			$.walk.getBlockDefaults();
			var bOpts = {
				message : message,
				css:{
					top : top,
					left : left
				},
				iframeSrc:iframeSrc
			};
			if (loadingTarget) {// 指定区域显示加载中效果
				bOpts.css.top = (loadingTarget.height()/2) - 12;
	            loadingTarget.block(bOpts);
	        } else {// 全页面显示加载中效果
				$.blockUI(bOpts);
	        }
	        if($.walk.isIE8Under()){
		        //ie6遮罩select
		        $(".blockOverlay").bgiframe();
	        }
		});
	},
	
	//隐藏遮罩层
	hideLoading : function(loadingTarget, isAjax){
		if (this.isLoadingManual && isAjax) {
			return;
		}
		this.isLoading = false;
		this.isLoadingManual = false;
		seajs.use(['$blockui'], function(){
			if (loadingTarget) {// 指定区域隐藏加载中效果
	            loadingTarget.unblock();
	        } else {// 全页面隐藏加载中效果
	            $.unblockUI();
	        }
		});
	},
	
	//dialog方式打开url
	openUrlDialog : function(url, title, width, height, top, scrolling, onloadSuccess,onClose, closable){
		url = url.indexOf('?') > -1 ? (url + "&random=" + this.getRandomParam()) :(url + "?random=" + this.getRandomParam());
		var dialogframediv = $("#dialogframediv");
		if(scrolling && scrolling == 'auto'){
			if($("#dialogframediv2").size() == 0){
				$(document.body).append("<div id='dialogframediv2' class='dialogframediv2' style='display: none'><iframe id='dialogframe2' name='dialogframe2' scrolling='auto' frameborder='0' width='100%' height='100%' allowTransparency='true'></iframe></div>");
			}
			dialogframediv = $("#dialogframediv2");
		}
		if(onloadSuccess){
			dialogframediv.find('iframe').load(function(){
				onloadSuccess(dialogframediv.find('iframe').get(0));
			});
		}
		dialogframediv.show();
		easyloader.load("window", function(){
			dialogframediv.window({
				title: title ? title : "操作",
				width: width ? width : 800,
				height: height ? height : 400,
				top: top ? top : 40,
				modal: true,
				minimizable: false,
                closable:closable ?  false : true,
				onOpen : function(){
					dialogframediv.find("iframe").attr("src", url);
				},
				onClose : function(){
					//释放iframe内存
					var iframe = dialogframediv.find("iframe").get(0);
					$.walk.clearFrameCache(iframe);
					if($.isFunction(onClose)){
						onClose();
					}
				}
			}).window("hcenter");
		});
		
		//返回页面顶部
		this.pageScrollTop();
	},

	//关闭弹窗
	closeDialog : function(win, dialogId){
		var w = win;
		if(!w){
			var parents = this._getParents();
			for(var i = 0; i < parents.length; i++){
				if(parents[i] && parents[i].$(".window:visible").size() > 0){
					w = parents[i];
					break;
				}
			}
		}
		if (dialogId) {
			w.$("#" + dialogId).dialog("close");
		} else {
			w.$(".window:visible").last().find('.panel-tool-close').click();
		}
	},
	
	//datagrid:将选中行的数组转换成以特殊符号分隔的字符串，分隔符默认逗号
	checkeds2str : function(checkeds, idName, divide){
		if(!divide) divide = ",";
		var ids = "";
		$.each(checkeds, function(i, checked){
			ids += eval("checked." + idName) + divide;
		});
		return ids.substr(0, ids.length-1);
	},
	
	//导出普通表格当页表格
	exportCurrentPage : function (exportName, table){
		this.confirm("确认导出吗？", function(ok){
			if(ok){
			    $("<div id='expTemp'></div>").appendTo($(document.body));
			    $('#expTemp').css({'position': 'absolute','top': '-9000px'});
			    $("#expTemp").append('<iframe name="IF_4down"></iframe>').append('<form id="exportform" action="'+$.walk.ctx+'/fileserver/exportCurrentPage" method="post" target="IF_4down"><input type="hidden" id="pData" name="pData"/><input type="hidden" id="exportName" name="exportName"/></form>');
			    $("#pData").val("<table>" + table.html() + "</table>");
				$("#exportName").val(exportName);
			    $("#exportform").submit().remove();
			    $('#expTemp').remove();
			}
		});
	},
	
	//返回页面顶部
	pageScrollTop : function (){
		this.getTopWindow().$("html, body").animate({scrollTop:"0px"}, 400);
	},
	
	/****************************扩展区域********************************/
	/** 提示类型 */
	messageType : {info: "info", "1" : "success", warning : "warning", "0" : "error"},
	
	getRespInfo : function(data) {
		if($.isPlainObject(data)){
			return data;
		}
		var predict = data && data.indexOf("respCode") > -1 && data.indexOf("respDesc") > -1;
		try {
			return predict ? $.parseJSON(data) : null;
		}catch(e){}
		return null;
	},
	
	/**
	 * 判断返回的respInfo是否为成功
	 * 
	 * @param respInfo
	 * @returns {Boolean}
	 */
	isRespSuccess : function(respInfo) {
		return respInfo && respInfo.respCode == "1";
	},
	/**
	 * 模拟ajax方式提交form
	 * 
	 * @param formId 表单编码
	 * @param action 表单action
	 * @param callbackFunc 回调函数
	 */
	ajaxFormSubmit : function (formId, action, callbackFunc){
		if(!formId){
			alert("请指定formId！");
			return;
		}
		var form = $("#" + formId);
		if(form.size() == 0){
			//form无id有name也可
			form = $("form[name='" + formId + "']");
			if(form.size() == 0){
				alert("form[" + formId + "]不存在！");
				return;
			}
		}
		//第二个参数可能传入回调函数
		if(action && $.isFunction(action)){
			callbackFunc = action;
			action = form.attr("action");
			if(!action){
				alert("请指定form[" + formId + "]action属性！");
				return;
			}
		}
		var _this = this;
		//开始提交
		seajs.use(['$form','$validate'], function(){
			var formValidator = form.attr("validXml");
			if(formValidator && !form.valid()) return false;//校验失败返回
			
			form.form('submit', {
				url: action,
				method : "post",
				onSubmit : function(){
					//$.walk.showLoading();
					
					//如果后端一直未返回数据，10秒后隐藏遮罩层。
					/*setTimeout(function(){
						$.walk.hideLoading();
					}, 10000);*/
					
					//jquery.form请求特殊标识
					if(form.find("#JQUERY_FORM_AJAX_REQUEST").size() == 0){
						form.append("<input id='JQUERY_FORM_AJAX_REQUEST' name='JQUERY_FORM_AJAX_REQUEST' value='true' style='display: none'/>");
					}
				},
				success : function(response) {
					//$.walk.hideLoading();
					
					var respInfo = _this.getRespInfo(response);
					var isRespInfo = (null != respInfo);
					//如果写了回调函数，逻辑在回调函数里自处理，否则判断为公共的RespInfo时自动提示
					if(callbackFunc && $.isFunction(callbackFunc)){
						callbackFunc.call(this, isRespInfo? respInfo : response, isRespInfo? _this.isRespSuccess(respInfo) : undefined);
					} else if (isRespInfo && respInfo.respDesc){
						$walk.alert(respInfo.respDesc, $.walk.messageType[respInfo.respCode]);
					}
				}
			});
		});
	},
	
	/**
	 * ajax方式提交(默认post）请求，不做数据校验
	 * 
	 * @param areaId 条件区域ID，可选
	 * @param params 自定义的请求参数，可选
	 * @param url 要请求的后台服务
	 * @param callback 回调函数，回传返回的数据，及通用respInfo时，结果是否为成功
	 * @param error 指定错误时的回调函数，可选
	 * @param method 指定请求时的方法，可选，默认"POST"
	 * @param global boolean, 是否触发公共的loading遮罩与错误处理，默认true
	 */
	ajaxRequest : function (inParams){
		var areaId = inParams.areaId, 
			url = inParams.url, 
			params = inParams.params,
			callback = inParams.callback,
			errorCallback = inParams.error,
			reqMethod = inParams.method || "POST",
			global = inParams.global||true,
			dataType=inParams.dataType,
            contentType=inParams.contentType||"application/x-www-form-urlencoded";

		params = this.getQueryParams(areaId, params);
		params && (params._page_name = this.page);
		if(contentType.match("application/json")){
            params=JSON.stringify(params);
		}
		var _this = this;
		$.ajax({
			url : url,
			data : params,
			type : reqMethod,
			dataType : !dataType?"json":dataType,
			cache: false,
			global: global,
            contentType:contentType,
			success : function(response){
				var respInfo = _this.getRespInfo(response);
				var isRespInfo = (null != respInfo);
				var isRespSuccess = _this.isRespSuccess(respInfo);
				if(callback && $.isFunction(callback)){
					callback.call(this, respInfo || response, isRespInfo ? isRespSuccess : undefined);
				} else if (isRespInfo && respInfo.respDesc){
					_this.alert(respInfo.respDesc, $.walk.messageType[respInfo.respCode]);
				}
			},
			error : errorCallback || function(){}
		});
	},
	/**
	 * 入参形如：{"确认":function(){}}
	 */
	mergeBtns : function(btnObj) {
		var wrapper = $("<div></div>");
		var templateCom = "<a class='w2-btn w2-btn-dorg mb10' href='javascript:void(0)'>#{text}</a>";
		var templateCancel = "<a class='w2-btn w2-btn-org mb10' href='javascript:void(0)'>#{text}</a>";
		for (var key in btnObj) {
			if (key == "取消") {
				$(templateCancel.replace("#{text}", key)).on("click", btnObj[key]).appendTo(wrapper);
			} else {
				$(templateCom.replace("#{text}", key)).on("click", btnObj[key]).appendTo(wrapper);
			}
		}
		return wrapper;
	},
	/**
	 * 扩展的打开弹出窗口函数
	 * @param id  指定唯一的元素编码
	 * @param url 指定要打开的链接
	 * @param title 指定弹出窗口的标题
	 * @param opts 其他参数，除了如下自定义回调，和dialog的参数一样，详见easyui.dialog的使用文档
	 * 			okCallback ：     增加确认按钮，注册点击确认按钮后的回调函数，传入iframe中的所有元素及当前dialog对象（可用来关闭dialog）
	 * 			cancelCallback ： 增加取消按钮，注册点击取消按钮后的回调函数，传入iframe中的所有元素及当前dialog对象（可用来关闭dialog）
	 * 			其他自定义按钮，使用buttons:{"确认":function(){}}方式注册
	 * 			afterClose: dialog关闭之后执行的函数
	 * 			fitParent: 是否撑开父层窗口高度
	 * 
	 */
	openDialog : function(id, url, title, opts){
		var _this = this;
		opts = opts || {};
		var dialogId = id || "_commonDlg", okCallback = opts.okCallback, cancelCallback = opts.cancelCallback;
		opts.width = opts.width || 750;
		opts.height = opts.height || 500;
		opts.top = opts.top || 40;
//		opts.top = opts.top || ($(document).scrollTop() - opts.height / 2) < 0 ? 40 : ($(document).scrollTop() - opts.height / 2);
		var fitParent = opts.fitParent || false;
		if (fitParent) {
			opts.left = 0, opts.top = 0, opts.maximized = false;
		}
		var realIframeId = "#" + checkModalExists(dialogId);
	    
	    // 操作此dialog的工具方法，返回给使用人员操作
	    var tools = {
	    		/** close the dialog */
	    		close : function(){$("#" + dialogId).dialog("close");},
	    		mergeBtns : function(btnObj) {
	    			var wrapper = $("<div></div>");
	    			var templateCom = "<a class='w2-btn w2-btn-dorg' href='javascript:void(0)'>#{text}</a>";
	    			var templateCancel = "<a class='w2-btn w2-btn-org' href='javascript:void(0)'>#{text}</a>";
	    			for (var key in btnObj) {
	    				if (key == "取消") {
	    					$(templateCancel.replace("#{text}", key)).on("click", btnObj[key]).appendTo(wrapper);
	    				} else {
	    					$(templateCom.replace("#{text}", key)).on("click", btnObj[key]).appendTo(wrapper);
	    				}
	    			}
	    			return wrapper;
	    		},
	    		fitParentInterval : null
	    	};
	    var btns = opts.buttons || {};
	    okCallback && $.isFunction(okCallback) && (btns["确认"] =function(){okCallback($(realIframeId).contents(), $("#" + dialogId), tools);});
	    cancelCallback && $.isFunction(cancelCallback) && (btns["取消"] = function(){cancelCallback($(realIframeId).contents(), $("#" + dialogId), tools);});
	    var dOpts = $.extend(opts, {
		    title : title,
		    modal : true,
		    draggable : true,
		    buttons : _this.mergeBtns(btns),
			maximizable: true,
			collapsible: true,
		    close : tools.flush,
		    onOpen : function(){
		    	var $iframe = $(realIframeId);
			    url = $.walk.genRandomUrl(url);
			    $iframe.attr("src", url);
			    $iframe.load(function(){
			    	if (fitParent) {
			    		tools.fitParentInterval = setInterval(function(){
			    			var iframe$ = $(realIframeId);
			    			var dialogObj = $("#" + dialogId);
			    			if (!dialogObj.is(":visible")) {
			    				return;
			    			}
			    			var lastHeight = dialogObj.height();
			    			var height = $walk.getIframeContentHeight(iframe$);
			    			var minus = height - lastHeight;
			    			//console.log("height :" + height + ", lastHeight:" + lastHeight);
			    			if (minus > 10 || minus < -10) {
			    				var panelHeight = dialogObj.dialog("panel").height();
			    				var contentHeight = lastHeight + minus;
			    				var rHeight = (panelHeight - lastHeight + contentHeight);
			    				//console.log("fit parent to :" + rHeight + ", panelHeight:" + panelHeight + ", orgContentHeight: " + lastHeight + ", minus: " + minus);
			    				dialogObj.dialog("resize", {left: 0, top: 0, width: $("body").width(), height: rHeight});
			    			}
			    		}, 1000);
			    	}
			    });
			},
			onClose : function(){
				try{$.walk.clearFrameCache($(realIframeId).get(0));}catch(e){}
				opts.afterClose && opts.afterClose();
				tools.fitParentInterval && clearInterval(tools.fitParentInterval);
			}
		});
	    $("#" + dialogId).siblings("div.dialog-button").remove();
	    easyloader.load("dialog", function(){
	    	$("#" + dialogId).dialog(dOpts);
	    });
		
		/**
		 * 检查指定ID是否对应到弹出窗口模块
		 * 
		 * @param dialogId
		 * @returns 返回真实模块内iframe ID
		 */
		function checkModalExists(dialogId) {
			var realDialogId = dialogId;
			var realIframeId = "ifm_" + dialogId;
			if($("#"+realDialogId).size() == 0){
				$("body").append('<div id="'+realDialogId+'" style="display: none"><iframe id="'+realIframeId+'" name="'+realIframeId+'" scrolling="auto" frameborder="0" width="100%" height="100%" allowTransparency="true"></iframe></div>');
			}
			
			return realIframeId;
		}
		//返回页面顶部
		this.pageScrollTop();
		return tools;
	},
	/**
	 * 生成
	 * @param url
	 * @returns
	 */
	genRandomUrl : function(url) {
		if (!url) { return url;}
		if (url.indexOf("?") == -1) { url += "?"; }
		
		return url += '&_=' + this.getRandomParam();
	},
	/**
	 * 获取Iframe内容的高度
	 * 
	 * @param jqIframe
	 * @returns
	 */
	getIframeHeight : function(jqIframe) {
		var height = jqIframe.height();
		try{
			var frame = jqIframe.get(0),
		    win = frame.contentWindow,
		    doc = win.document,
		    html = doc.documentElement,
		    body = doc.body;
		    height = Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight );
		}catch(e){}
	    return height;
	},
	/**
	 * 获取Iframe内容的高度
	 * 
	 * @param jqIframe
	 * @returns
	 */
	getIframeContentHeight : function(jqIframe) {
		var height = 0;
		try{
			var ifmContents = jqIframe.contents();
			// 如果有弹出的浮动窗口，此时使用滚动高度，否则使用body的高度
			if (ifmContents.find(".window,.z-float").is(":visible")) {
				height = $.walk.getIframeHeight(jqIframe);
				// console.log("has float things, use iframe height...." + height);
			} else {
				height = ifmContents.find('body').height();
				// console.log("no float things, use body height...." + height);
			}
		}catch(e){}
		return height;
	},
	/**
	 * 监控Iframe高度，跟随内容高度变化而变化
	 * @param frameId
	 * @param interval 扫描频率
	 * @param minHeight 最低高度，可选
	 * @param minus 高度差别在多少以内不需要做iframe高度调整，默认为0
	 */
	monitorIframeHeight : function(frameId, interval, minHeight, minus) {
		var jqIframe = $("#" + frameId);
		var _lastHeight = jqIframe.height();
		minus = minus || 0;
		var initIframeHeight = function() {
			var iframe$ = $("#" + frameId);
			var scrollHeight = $.walk.getIframeContentHeight(iframe$)+100;
			minHeight && minHeight > scrollHeight && (scrollHeight = minHeight);
			var rMinus = scrollHeight - _lastHeight;
			rMinus = rMinus < 0 ? -rMinus : rMinus;
			if (rMinus > minus) {
				//console.log("_lastHeight: " + _lastHeight + ", scrollHeight=" + scrollHeight);
				_lastHeight = scrollHeight;
				iframe$.height(scrollHeight);
			}
		}
		jqIframe.on("load", function(){
			initIframeHeight();
			setTimeout(function(){initIframeHeight();}, 2000);
			$($("#" + frameId).get(0).contentWindow.document).on("mouseup", function(){
				setTimeout(function(){initIframeHeight();}, 1000);
			});
		});
		
		if(interval == -1) return;
		interval = interval || 2000;
		return setInterval(function(){initIframeHeight();}, interval);
	},
	/**
	 * 登出cas-server
	 */
	toCasLogout : function() {
		var location = top.location;
		var hostName = location.protocol + "//" + location.host;
		var casLogout = hostName + "/cas-server/logout?service=" + encodeURIComponent(location);
		top.location.href = casLogout;
	},
	/**
	 * 获取当前窗口所在的dialog，在窗口页内调用
	 * 
	 * @returns 如果未找到则返回null，否则返回dialog对象
	 */
	getCurrentDialog : function() {
		var parent = window.parent;
		var curWin = window;
		var iframeObj = null;
		parent.$("iframe").each(function(){
			if (this.contentWindow == curWin) {
				iframeObj = parent.$(this);
				return false;
			}
		});
		if (null != iframeObj) {
			return iframeObj.closest(".window-body");
		}
		return null;
	},
	/**
	 * 关闭当前窗口，在窗口页内调用
	 */
	closeCurrentDialog : function() {
		var curDialog = this.getCurrentDialog();
		curDialog && curDialog.dialog("close");
	},
	/** 默认的提示消息 */
	tipDefault : {
		height: '200px',
		width: '300px',
		showType: 'slide',
		style: {left:"", top:"",right:0,bottom: 0,position: 'fixed',border: '1px solid #ddd'}
	},
	/**
	 * 显示提示信息，默认右下角，见tipDefault定义
	 * 
	 * @param title
	 * @param msg
	 * @param timeout
	 * @param options 自定义参数
	 */
	showTip : function(title, msg, timeout, options) {
		options = options || {};
		$.extend(options, this.tipDefault, {title: title || '提示', msg: msg, timeout: timeout || 0});
		this.getTopWindow().$.walk.show(options);
	}
};

(function($){
	jQuery.extend({
		  walk: $walk
		});
})(jQuery);