<@html>
    <@head title="">

    </@head>
<body class="childrenBody">
<div class="panel panel-default operation_role" hidden>
    <div class="panel-heading title"></div>
    <div class="layui-card-body">
        <form class="layui-form " action="" lay-filter="deptInfo" style="width: 700px;margin-top: 10px">
            <input name="id" hidden/>
            <input name="pid" hidden/>

            <div class="layui-form-item">
                <label class="layui-form-label">角色名称</label>
                <div class="layui-input-block">
                    <input type="name" name="name" placeholder="请输入角色名称" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-form-label ">备注</div>
                <div class="layui-input-block">
                    <input type="description" name="description" placeholder="请输入备注信息" autocomplete="off" class="layui-input" >
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="status" lay-skin="switch" lay-filter="switch" lay-text="启用|禁用" checked>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">请选择权限</label>
            </div>
            <div class="layui-form-item">
                <div class="layui-tree">
                    <div id="permissionTree"></div>
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <button type="submit" class="layui-btn" lay-submit="" lay-filter="submit">保存</button>
                    <button  class="layui-btn layui-btn-primary" id="btn_cancel">返回</button>
                </div>
            </div>
        </form>
    </div>
</div>
<div class="role_table_div">
<div id="searchParam"  shiro:hasPermission="sys:role:list">
    <div class="layui-form-item">
        <div class="layui-input-inline">
            <input type="text" id="roleName" class="layui-input"  autocomplete="off" placeholder="请输入角色名称">
        </div>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="createTime" placeholder="创建时间">
        </div>
        <div class="layui-input-inline layui-form">
            <select  id="status"  >
                <option value="">请选择角色状态</option>
                <option value="1">正常</option>
                <option value="0">弃用</option>
            </select>
        </div>
    </div>

</div>
<table class="layui-hide" id="role_table" lay-filter="role_table"></table>
<div id="laypage" class="layui-laypage-btn"></div>
</div>
</body>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group" id="search">
        <button type="button" class="layui-btn" lay-event="search" >
            <i class="layui-icon">&#xe615;</i> 开始检索
        </button>
    </div>
    <div class="layui-btn-group">
        <button type="button" class="layui-btn layui-btn-normal" lay-event="addNewRole" shiro:hasPermission="sys:role:add">
            <i class="layui-icon">&#xe608;</i> 新增角色
        </button>
    </div>
</script>
<script type="text/html" id="tool">
    <a class="layui-btn layui-btn-xs" lay-event="edit" shiro:hasPermission="sys:role:update">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del" shiro:hasPermission="sys:role:deleted">删除</a>
</script>

<script>
    var table = layui.table;
    var laypage = layui.laypage
    var form = layui.form;
    var layer = layui.layer;
    var $ = jQuery = layui.jquery;
    var laydate = layui.laydate;
    var tree=layui.tree;
    layui.use(['table','laypage', 'layer','laydate','tree'], function(){
        var searchParam= {
            roleId:null,
            roleName:null,
            status:null,
            startTime:null,
            endTime:null,
            pageNum:1,
            pageSize:10
        }
        CoreUtil.sendAjax("/sys/roles",JSON.stringify(searchParam),function (res) {
            laypageTable(res.data.totalRows,searchParam.pageNum);
            if(res.data.list !=null){
                loadTable(res.data.list);
            }
        },"POST",false,function (res) {
            layer.msg("抱歉！您暂无获取角色列表的权限");
            var noAuthorityData=[];
            loadTable(noAuthorityData);
        });
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
                        searchParam.pageNum=obj.curr;
                        searchParam.pageSize=obj.limit;
                        CoreUtil.sendAjax("/sys/roles",JSON.stringify(searchParam),function (res) {
                            if(res.data.list !=null){
                                loadTable(res.data.list);
                                laypageTable(res.data.totalRows,searchParam.pageNum);
                            }

                        },"POST",false);
                    }
                }
            });
        };
        var loadTable=function (data) {
            table.render({
                elem: '#role_table'
                ,cols: [
                    [
                        {field: 'name',align: 'center', title: '角色名称', width: 150},
                        {
                            field: 'createTime',align: 'center', title: '创建时间', minWidth: 170 , templet: function (item) {
                                return CoreUtil.formattime(item.createTime);
                            }
                        },
                        {
                            field: 'updateTime', align: 'center',title: '更新时间', minWidth: 170,templet: function (item) {
                                return CoreUtil.formattime(item.updateTime);
                            }
                        },
                        {
                            field: 'status',align: 'center', title: '状态', width: 100,templet: function (item) {
                                if(item.status === 1){
                                    return  '  <input type="checkbox" lay-skin="switch" lay-text="正常|弃用" checked disabled>';
                                }
                                if(item.status === 0){
                                    return  '  <input type="checkbox" lay-skin="switch" lay-text="正常|弃用" disabled>';
                                }
                            }
                        },
                        {field: 'description',align: 'center', title: '描述'},
                        {title:'操作',align: 'center',toolbar:'#tool'}
                    ]
                ]
                ,data: data
                ,even: true
                ,limit: data.length
                ,limits: [10, 20, 30, 40, 50]
                ,toolbar:'#toolbar'

            });
        };
        laydate.render({
            elem: '#createTime'
            ,type: 'datetime'
            ,range: '~'
            ,done: function(value, date, endDate){
                if(value !=null && value != undefined && value != ""){
                    searchParam.startTime=value.split("~")[0];
                    searchParam.endTime=value.split("~")[1];
                }else {
                    searchParam.startTime=null;
                    searchParam.endTime=null;
                }

            }
        });
        table.on('toolbar(role_table)',function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'addNewRole':
                    //隐藏表格
                    $(".role_table_div").hide();
                    //显示编辑窗口
                    $(".operation_role").show();
                    $(".title").html("新增角色");
                    $(".operation_role input[name=id]").val("");
                    $(".operation_role input[name=pid]").val("");
                    $(".operation_role input[name=name]").val("");
                    $(".operation_role input[name=description]").val("");
                    $(".operation_role input[name=status]").attr('checked', 'checked');
                    $(".operation_role input[name=status]").attr('type', 'hidden').val(1);
                    var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                    x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                    var d = document.getElementsByTagName('em')[0];
                    d.firstChild.nodeValue = '启用';
                    form.render(); //更新全部
                    initTree();
                    break;
                case 'search':
                    searchParam.roleId=$("#roleId").val();
                    searchParam.status=$("#status").val();
                    searchParam.roleName=$("#roleName").val();
                    searchParam.pageNum=1;
                    CoreUtil.sendAjax("/sys/roles",JSON.stringify(searchParam),function (res) {
                        laypageTable(res.data.totalRows,searchParam.pageNum);
                        if(res.data.list !=null){
                            loadTable(res.data.list);
                        }
                    },"POST",false);
                    break;
            }
        });
        table.on('tool(role_table)',function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'del':
                    tipDialog(data.id);
                    break;
                case 'edit':
                    $(".role_table_div").hide();
                    //显示编辑窗口
                    $(".operation_role").show();
                    $(".title").html("编辑角色");
                    getRoleDetail(data.id);
                    break;
            }
        });
        var getRoleDetail=function(id){
            CoreUtil.sendAjax("/sys/role/"+id,null,function (res) {
                $(".operation_role input[name=id]").val(res.data.id);
                $(".operation_role input[name=pid]").val(res.data.pid);
                $(".operation_role input[name=name]").val(res.data.name);
                $(".operation_role input[name=description]").val(res.data.description);
                if(res.data.status ==1){
                    $(".operation_role input[name=status]").attr('checked', 'checked');
                    $(".operation_role input[name=status]").attr('type', 'hidden').val(1);
                    var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                    x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                    var d = document.getElementsByTagName('em')[0];
                    d.firstChild.nodeValue = '启用';
                }else {
                    $(".operation_role input[name=status]").attr('type', 'hidden').removeAttr("checked").val(0);
                    var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                    x[0].setAttribute("class", "layui-unselect layui-form-switch");
                    var d = document.getElementsByTagName('em')[0];
                    d.firstChild.nodeValue = '禁用';
                }
                loadPermissionTree(res.data.permissionRespNodes);
                form.render(); //更新全部

            },"GET",false);
        }
        var initTree=function () {
            CoreUtil.sendAjax("/sys/permission/tree/all",null,function (res) {
                loadPermissionTree(res.data);
            },"GET",false);
        };
        var loadPermissionTree=function (data) {
            tree.render({
                elem: '#permissionTree'
                ,data: data
                ,onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
                ,showCheckbox: true  //是否显示复选框
                ,id: 'permissionIds'
                , accordion: false
                ,click: function(obj){
                    selectNode=obj;
                    layer.msg(JSON.stringify(selectNode.data.title));
                }
            });


        };
        form.on('switch(switch)', function(){
            $(".operation_role input[name=status]").attr('type', 'hidden').val(this.checked ? 1 : 0);

        });
        $("#btn_cancel").click(function() {
            $(".role_table_div").show();
            $(".operation_role").hide();
            return false;
        });
        //监听提交
        form.on('submit(submit)', function(data){
            var permissionIds=[];
            var brchArrays = tree.getChecked('permissionIds');
            var params={
                id:data.field.id,
                name:data.field.name,
                description:data.field.description,
                status:data.field.status,
                permissions:getPermissionIds(brchArrays,permissionIds)
            }
            if(data.field.id===undefined || data.field.id===null || data.field.id===""){
                CoreUtil.sendAjax("/sys/role",JSON.stringify(params),function (res) {
                    $(".role_table_div").show();
                    $(".operation_role").hide();
                    $(".layui-laypage-btn").click();
                },"POST",false);
            }else {
                CoreUtil.sendAjax("/sys/role",JSON.stringify(params),function (res) {
                    //显示表格
                    $(".role_table_div").show();
                    //隐藏编辑窗口
                    $(".operation_role").hide();
                    $(".layui-laypage-btn").click();
                },"PUT",false);
            }

            return false;
        });
        var tipDialog=function (id) {
            layer.open({
                content: '确定要删除么',
                yes: function(index, layero){
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    CoreUtil.sendAjax("/sys/role/"+id,null,function (res) {
                        layer.msg(res.msg);
                        $(".layui-laypage-btn").click();
                    },"DELETE",false);
                }
            });
        }
    });
    function getPermissionIds(jsonObj,permissionIds) {
        if(jsonObj==undefined||jsonObj==null||!jsonObj instanceof Object){
            return null;
        }
        for(var i=0;i<jsonObj.length;i++){
            permissionIds.push(jsonObj[i].id);
            getPermissionIds(jsonObj[i].children,permissionIds);
        }
        return permissionIds;
    }
</script>
</@html>