<@html>
<@head title="">
    <link rel="stylesheet" href="${ctx}/css/febs.css">
</@head>
<body class="childrenBody">
<div id="searchParam">
    <div class="layui-form-item"  shiro:hasPermission="sys:log:list">
        <div class="layui-input-inline">
            <input type="text" id="username" class="layui-input"  autocomplete="off" placeholder="请输入账号">
        </div>
        <div class="layui-input-inline">
            <input type="text" id="operation" class="layui-input"  autocomplete="off" placeholder="用户操作动作">
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="createTime" placeholder="创建时间">
        </div>
    </div>

</div>
<table class="layui-hide" id="log_table" lay-filter="log_table"></table>
<div id="laypage" class="layui-laypage-btn"></div>
</body>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group" id="search">
        <button type="button" class="layui-btn" lay-event="search" >
            <i class="layui-icon">&#xe615;</i> 开始检索
        </button>
    </div>
    <div class="layui-btn-group">
        <button shiro:hasPermission="sys:log:deleted" type="button" class="layui-btn layui-btn-danger" lay-event="getCheckData">
            <i class="layui-icon">&#xe608;</i> 批量删除
        </button>
    </div>
</script>
<script type="text/html" id="tool">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del" shiro:hasPermission="sys:log:deleted">删除</a>
</script>
<script src="/layui/layui.all.js"></script>
<script src="/js/util.js"></script>
<script type="text/html" id="timeTpl">
    <div>
        {{# if (d.time < 100) { }}
        <span class="layui-badge febs-tag-green">{{d.time}} ms</span>
        {{# } else if (d.time < 200) { }}
        <span class="layui-badge febs-tag-cyan">{{d.time}} ms</span>
        {{# } else if (d.time < 500) { }}
        <span class="layui-badge febs-tag-orange">{{d.time}} ms</span>
        {{# } else if (d.time < 1500) { }}
        <span class="layui-badge febs-tag-volcano">{{d.time}} ms</span>
        {{# } else { }}
        <span class="layui-badge febs-tag-red">{{d.time}} ms</span>
        {{# } }}
    </div>
</script>
<script>
    var table = layui.table;
    var laypage = layui.laypage
    var form = layui.form;
    var layer = layui.layer;
    var $ = jQuery = layui.jquery;
    var laydate = layui.laydate;
    var flag;
    layui.use(['table','laypage', 'layer','laydate'], function(){
        var searchParam= {
            username:null,
            startTime:null,
            operation:null,
            userId:null,
            endTime:null,
            pageNum:1,
            pageSize:10
        };
        CoreUtil.sendAjax("/sys/logs",JSON.stringify(searchParam),function (res) {
            //初始化分页器
            laypageTable(res.data.totalRows,searchParam.pageNum);
            //初始化渲染数据
            if(res.data.list !=null){
                loadTable(res.data.list);
            }
        },"POST",false,function (res) {
            layer.msg("抱歉！您暂无获取操作日志列表的权限");
            var noAuthorityData=[];
            loadTable(noAuthorityData);
        });
        //渲染分页插件
        var laypageTable = function(count,currentPage) {
            laypage.render({
                elem: 'laypage'
                , count: count
                ,limit:searchParam.pageSize
                , layout: ['count', 'prev', 'page', 'next', 'limit', 'refresh', 'skip']
                ,curr: location.hash.replace('#!currentPage=', '') //获取起始页
                ,hash: 'currentPage' //自定义hash值
                , jump: function (obj,first) {
                    if (!first){
                        flag=true;
                        searchParam.pageNum=obj.curr;
                        searchParam.pageSize=obj.limit;
                        CoreUtil.sendAjax("/sys/logs",JSON.stringify(searchParam),function (res) {
                            if(res.data.list !=null){
                                loadTable(res.data.list);

                                laypageTable(res.data.totalRows,searchParam.pageNum);
                            }

                        },"POST",false,function (res) {
                            layer.msg("抱歉！您暂无获取操作日志列表的权限");
                            var noAuthorityData=[];
                            loadTable(noAuthorityData);
                        });
                    }
                }
            });
        };

        //渲染table
        var loadTable=function (data) {
            //展示已知数据
            table.render({
                elem: '#log_table'
                ,cols: [
                    [
                        {type: 'checkbox', fixed: 'left'},
                        {field: 'username', align: 'center',title: '账号', width: 120},
                        {field: 'operation', align: 'center',title: '用户操作', width: 300},
                        {field: 'time', align: 'center',title: '用时',templet: '#timeTpl', width: 120},
                        {field: 'ip', align: 'center',title: 'IP', width: 130},
                        {field: 'location', align: 'center',title: '操作地址'},
                        {field: 'params',align: 'center', title: '请求参数', width: 120},
                        {
                            field: 'createTime',align: 'center', title: '创建时间', minWidth: 170 , templet: function (item) {
                                return CoreUtil.formattime(item.createTime);
                            }
                        },
                        {width:80,align: 'center',toolbar:"#tool",title:'操作'}
                    ]
                ]
                ,data: data
                ,even: true
                ,limit: data.length
                ,limits: [10, 20, 30, 40, 50]
                ,toolbar:'#toolbar'
            });
        };
        //日期范围
        laydate.render({
            elem: '#createTime'
            ,type: 'datetime'
            ,range: '~'
            ,done: function(value, date, endDate){
                if(value !=null && value != undefined && value != ""){
                    searchParam.startTime=value.split("~")[0];
                    searchParam.endTime=value.split("~")[1];
                }else {
                    //清空时间的时候要清空以前选择的日期
                    searchParam.startTime=null;
                    searchParam.endTime=null;
                }

            }
        });

        //表头工具栏事件
        table.on('toolbar(log_table)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            switch(obj.event){
                case 'getCheckData':
                    var data = checkStatus.data;
                    if(data.length==0){
                        layer.msg("请选择要批量删除的日志");
                    }else {
                        var logIds = [];
                        $(data).each(function (index,item) {
                            logIds.push(item.id);
                        });
                        tipDialog(logIds);
                    }
                    break;
                case 'search':
                    searchParam.userId='';
                    searchParam.operation=$("#operation").val();
                    searchParam.username=$("#username").val();
                    searchParam.pageNum=1;
                    CoreUtil.sendAjax("/sys/logs",JSON.stringify(searchParam),function (res) {
                        //初始化分页器
                        laypageTable(res.data.totalRows,searchParam.pageNum);
                        //初始化渲染数据
                        if(res.data.list !=null){
                            loadTable(res.data.list);
                        }
                    },"POST",false,function (res) {
                        layer.msg("抱歉！您暂无获取操作日志列表的权限");
                        var noAuthorityData=[];
                        loadTable(noAuthorityData);
                    });
                    break;
            };
        });
        //操作工具栏事件
        table.on('tool(log_table)',function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'del':
                    var logIds=[];
                    logIds.push(data.id);
                    tipDialog(logIds);
                    break;
            }
        });

        //删除前确认对话框
        var tipDialog=function (logIds) {
            layer.open({
                content: '确定要删除么',
                yes: function(index, layero){
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    CoreUtil.sendAjax("/sys/logs",JSON.stringify(logIds),function (res) {
                        layer.msg(res.msg);
                        $(".layui-laypage-btn").click();
                    },"DELETE",false,function (res) {
                        layer.msg("抱歉！您暂无删除操作日志的权限");
                    });
                }
            });
        }
    });
</script>
</@html>