<@html>
    <@head title="">
        <script src="${ctx}/js/iconPicker.js"></script>
    </@head>
<body class="childrenBody">
<div class="panel panel-default operation_menu" hidden>
    <div class="panel-heading title"></div>
    <div class="layui-card-body">
        <form class="layui-form " action="" lay-filter="deptInfo" style="width: 700px;margin-top: 10px">
            <input name="id" hidden/>
            <input name="pid" hidden/>
            <div class="layui-form-item">
                <label class="layui-form-label">类型</label>
                <div class="layui-input-block">
                    <input type="radio" name="type" value="1" title="目录" checked="" lay-filter="radio-type">
                    <input type="radio" name="type" value="2" title="菜单" lay-filter="radio-type">
                    <input type="radio" name="type" value="3" title="按钮" lay-filter="radio-type">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">菜单名称</label>
                <div class="layui-input-block">
                    <input type="name" name="name" placeholder="请输入菜单名称" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-form-label ">所属菜单</div>
                <div class="layui-input-block">
                    <input type="pidName" name="pidName" placeholder="请选择所属菜单" autocomplete="off" class="layui-input" readonly="readonly" style="background:#eeeeee!important">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label ">接口URL</label>
                <div class="layui-input-block">
                    <input type="text" name="url" placeholder="请输入接口URL" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item menu-icon">
                <label class="layui-form-label">图标</label>
                <div class="layui-input-block">
                    <input type="text" id="iconPicker" lay-filter="iconPicker" class="layui-input"
                           placeholder="请填写图标代码" name="icon">
                </div>
            </div>
            <div class="layui-form-item menu-perms" hidden>
                <div class="layui-form-label">授权标识</div>
                <div class="layui-input-block">
                    <input type="perms" name="perms" placeholder="请输入授权标识,如果 sys:user:list" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item menu-method" hidden>
                <div class="layui-form-label">请求方式</div>
                <div class="layui-input-block">
                    <input type="method" name="method" placeholder="请输入请求方式，如 GET、POST" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item menu-btn" hidden>
                <div class="layui-form-label">按钮标识</div>
                <div class="layui-input-block">
                    <input type="code" name="code" placeholder="请输入前后端分离按钮控制标识,如果 btn-permission-list" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-form-label">排序码</div>
                <div class="layui-input-block">
                    <input type="text" name="orderNum" lay-verify="number" onkeyup="value=zhzs(this.value)" placeholder="请输入排序码" autocomplete="off" class="layui-input" >
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">状态</label>
                <div class="layui-input-block">
                    <input type="checkbox" name="status" lay-skin="switch" lay-filter="switch" lay-text="启用|禁用" checked>
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
<div class="menu-table">
    <table class="layui-table" id="menuTable" lay-filter="menuTable"></table>
</div>
<div id="menuTree" style="display: none"></div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button type="button" class="layui-btn layui-btn-normal" lay-event="addMenu" shiro:hasPermission="sys:permission:add">
            <i class="layui-icon">&#xe608;</i> 添加菜单
        </button>
    </div>
</script>
<script type="text/html" id="tool">
    <a class="layui-btn layui-btn-xs" lay-event="edit" shiro:hasPermission="sys:permission:update">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del" shiro:hasPermission="sys:permission:deleted">删除</a>
</script>

<!--<script type="text/html" id="iconTpl">-->
    <!--{{#  if(d.icon === null){ }}-->
    <!--{{#  } else{ }}-->
    <!--&lt;!&ndash;<i class="layui-icon">{{ d.icon }}</i>&ndash;&gt;-->
    <!--return '<i class="layui-icon "'-->
    <!--{{#  } }}-->
<!--</script>-->
<script  th:inline="none">
    var layer = layui.layer;
    var $ = jQuery = layui.jquery;
    var form = layui.form;
    var element = layui.element;
    var treetable;
    var iconPicker = layui.iconPicker;
    var selectNode=null;
    layui.config({
        base:  CoreUtil.ctx+'/treetable-lay/'
    }).extend({
        treetable: 'treetable'
    }).use([ 'treetable','table','tree'], function () {

        var reloadTreeTable=function(){
            CoreUtil.sendAjax("/sys/permissions",null,function (res) {
                renderTable(res.data);
            },"GET",false,function (res) {
                layer.msg("抱歉！您暂无获取菜单权限列表的权限");
                var noAuthorityData=[];
                renderTable(noAuthorityData);
            });
        };
        reloadTreeTable();
        treetable = layui.treetable;
        var table = layui.table;

        var tree=layui.tree;
        iconPicker.render({
            // 选择器，推荐使用input
            elem: '#iconPicker',
            // 数据类型：fontClass/unicode，推荐使用fontClass
            type: 'fontClass',
            // 是否开启搜索：true/false
            search: true,
            // 是否开启分页
            page: true,
            // 每页显示数量，默认12
            limit: 100,
            // 点击回调
            click: function (data) {
            }
        });
        var renderTable = function(data) {
            treetable.render({
                // 渲染表格
                data: data,
                treeColIndex: 1, // 树形图标显示在第几列
                treeSpid: 0, // 最上级的父级id
                treeIdName: 'id', // id字段的名称
                treePidName: 'pid', // pid字段的名称
                treeDefaultClose: false, // 是否默认折叠
                treeLinkage: false, // 父级展开时是否自动展开所有子级
                elem: '#menuTable', // 表格id
                page: false, // 树形表格一般是没有分页的
                toolbar:'#toolbar',
                cols: [
                    [
                        {type: 'numbers'},
                        {field: 'name', align: 'center',width: 170,  title: '菜单名称'},
                        {field: 'icon', align: 'center',width: 60, title: '图标',templet:function (item) {
                                if(item.icon == null){
                                    return ''
                                }else {
                                    return '<i class="layui-icon '+item.icon+'"'
                                }
                            }},
                        {field: 'url',align: 'center',  title: 'url'},
                        {field: 'method', align: 'center', title: '请求方式'},
                        {
                            field: 'type',align: 'center', width: 70,  title: '类型', templet: function(item){
                                if(item.type === 1){
                                    return '  <a class="layui-btn layui-btn-xs" >目录</a>';
                                }
                                if(item.type === 2){
                                    return '<a class="layui-btn layui-btn-xs layui-btn-normal" >菜单</a>';
                                }
                                if(item.type === 3){
                                    return '<a class="layui-btn layui-btn-xs layui-btn-warm " >按钮</a>';
                                }
                            }
                        },
                        {field: 'pidName', align: 'center', title: '父级名称'},
                        {field: 'perms',align: 'center',  title: '权限标识'},
                        {
                            field: 'createTime', title: '创建时间', minWidth: 170 , templet: function (item) {
                                return CoreUtil.formattime(item.createTime);
                            }
                        },
                        {
                            field: 'status', align: 'center', width: 100, title: '状态',templet: function (item) {
                                if(item.status === 1){
                                    return  '  <input type="checkbox" lay-skin="switch" lay-text="启用|禁用" checked disabled>';
                                }
                                if(item.status === 0){
                                    return  '  <input type="checkbox" lay-skin="switch" lay-text="启用|禁用" disabled>';
                                }
                            }
                        },
                        {title:'操作',width:120,align: 'center', toolbar:'#tool'}
                    ]
                ]
            });

        };
        table.on('toolbar(menuTable)',function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'addMenu':
                    selectNode=null;
                    $(".menu-table").hide();
                    $(".operation_menu").show();
                    $(".title").html("新增菜单权限");
                    initRadio(1);
                    $(".menu-method").hide();
                    $(".menu-btn").hide();
                    $(".menu-perms").hide();
                    $(".operation_menu input[name=id]").val("");
                    $(".operation_menu input[name=pid]").val("");
                    $(".operation_menu input[name=name]").val("");
                    $(".operation_menu input[name=pidName]").val("");
                    $(".operation_menu input[name=url]").val("");
                    $(".operation_menu input[name=perms]").val("");
                    $(".operation_menu input[name=orderNum]").val("");
                    $(".operation_menu input[name=method]").val("");
                    $(".operation_menu input[name=code]").val("");
                    $(".operation_menu input[name=status]").attr('checked', 'checked');
                    $(".operation_menu input[name=status]").attr('type', 'hidden').val(1);
                    var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                    x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                    var d = document.getElementsByTagName('em')[0];
                    d.firstChild.nodeValue = '启用';
                    form.render(); //更新全部
                    initTree("");
                    break;
            }
        });

        table.on('tool(menuTable)',function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'del':
                    deletedMenu(data.id,data.name);
                    break;
                case 'edit':
                    selectNode=null;
                    $(".menu-table").hide();
                    $(".operation_menu").show();
                    $(".title").html("编辑菜单权限");
                    initRadio(data.type);
                    iconPicker.checkIcon('iconPicker', data.icon);
                    $(".operation_menu input[name=id]").val(data.id);
                    $(".operation_menu input[name=pid]").val(data.pid);
                    $(".operation_menu input[name=name]").val(data.name);
                    $(".operation_menu input[name=pidName]").val(data.pidName);
                    $(".operation_menu input[name=url]").val(data.url);
                    $(".operation_menu input[name=perms]").val(data.perms);
                    $(".operation_menu input[name=orderNum]").val(data.orderNum);
                    $(".operation_menu input[name=method]").val(data.method);
                    $(".operation_menu input[name=code]").val(data.code);
                    if(data.status ==1){
                        $(".operation_menu input[name=status]").attr('checked', 'checked');
                        $(".operation_menu input[name=status]").attr('type', 'hidden').val(1);
                        var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                        x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                        var d = document.getElementsByTagName('em')[0];
                        d.firstChild.nodeValue = '启用';
                    }else {
                        $(".operation_menu input[name=status]").attr('type', 'hidden').removeAttr("checked").val(0);
                        var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                        x[0].setAttribute("class", "layui-unselect layui-form-switch");
                        var d = document.getElementsByTagName('em')[0];
                        d.firstChild.nodeValue = '禁用';
                    }
                    form.render(); //更新全部
                    initTree(data.id);
                    break;
            }
        });
        var deletedMenu=function(menuId,menuName){
            layer.open({
                content: '确定要删除'+menuName+"?",
                yes: function(index, layero){
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    CoreUtil.sendAjax("/sys/permission/"+menuId,null,function (res) {
                        layer.msg(res.msg);
                        reloadTreeTable();
                    },"DELETE",false,function (res) {
                        layer.msg("抱歉！您暂无删除菜单权限的权限");
                    });
                }
            });
        };
        var initTree=function (id) {
            var param={permissionId:id}
            CoreUtil.sendAjax("/sys/permission/tree",param,function (res) {
                loadDeptTree(res.data);
            },"GET",false,function (res) {
                layer.msg("抱歉！您暂无获取菜单权限树的权限");
                var noAuthorityData=[];
                loadDeptTree(noAuthorityData);
            });
        };
        var loadDeptTree=function (data) {
            tree.render({
                elem: '#menuTree'
                ,data: data
                ,onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
                ,click: function(obj){
                    selectNode=obj;
                    layer.msg(JSON.stringify(selectNode.data.title));
                }
            });
        };
        form.on('switch(switch)', function(){
            $(".operation_menu input[name=status]").attr('type', 'hidden').val(this.checked ? 1 : 0);

        });

        var initRadio=function(value){
            var radio = document.getElementsByName("type");
            var radioLength = radio.length;
            for (var i = 0; i < radioLength; i++) {
                if(value == radio[i].value){
                    $(radio[i]).next().click();
                }

            }
        };
        $("#btn_cancel").click(function() {
            $(".menu-table").show();
            $(".operation_menu").hide();
            return false;
        });

        $(".operation_menu input[name=pidName]").click(function () {
            layer.open({
                type: 1,
                offset: '0px',
                skin: 'layui-layer-molv',
                title: "选择部门",
                area: ['400px', '550px'],
                shade: 0,
                shadeClose: false,
                content: jQuery("#menuTree"),
                btn: ['确定', '取消'],
                yes: function (index) {
                    if(selectNode.data!=null){
                        $(".operation_menu input[name=pid]").val(selectNode.data.id);
                        $(".operation_menu input[name=pidName]").val(selectNode.data.title);
                    }

                    layer.close(index);
                }
            });
        });

        form.on('submit(submit)', function(data){
            if(data.field.id===undefined || data.field.id===null || data.field.id===""){
                CoreUtil.sendAjax("/sys/permission",JSON.stringify(data.field),function (res) {
                    reloadTreeTable();
                    $(".menu-table").show();
                    $(".operation_menu").hide();
                },"POST",false,function (res) {
                    layer.msg("抱歉！您暂无新增菜单权限的权限");
                });
            }else {
                CoreUtil.sendAjax("/sys/permission",JSON.stringify(data.field),function (res) {
                    reloadTreeTable();
                    $(".menu-table").show();
                    $(".operation_menu").hide();
                },"PUT",false,function (res) {
                    layer.msg("抱歉！您暂无编辑菜单权限的权限");
                });
            }
            return false;
        });
        form.on('radio(radio-type)', function(data){
            if(data.value == '1'){
                $(".menu-method").hide();
                $(".menu-btn").hide();
                $(".menu-perms").hide();
                $(".menu-icon").show();
            } else if(data.value == '2' || data.value == '3') {
                $(".menu-icon").show();
                if(data.value == '3'){
                    $(".menu-icon").hide();
                }
                $(".menu-method").show();
                $(".menu-perms").show();
                $(".menu-btn").show();
            }
        });
    });

    function zhzs(value){

        value = value.replace(/[^\d]/g,'');
        if(''!=value){
            value = parseInt(value);
        }
        return value;
    }


</script>
</body>
</@html>