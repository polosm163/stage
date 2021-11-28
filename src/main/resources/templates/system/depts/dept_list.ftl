<@html>
    <@head title="">

    </@head>
<body class="childrenBody">

<div class="panel panel-default operation_dept" hidden>
    <div class="panel-heading title"></div>
    <div class="layui-card-body">
        <form class="layui-form layui-form-pane" action="" lay-filter="deptInfo" style="width: 700px;margin-top: 10px">
            <input name="id" hidden/>
            <input name="pid" hidden/>
            <div class="layui-form-item">
                <label class="layui-form-label">部门名称</label>
                <div class="layui-input-block">
                    <input type="name" name="name" lay-verify="required" placeholder="请输入部门名称" autocomplete="off" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-form-label ">所属部门</div>
                <div class="layui-input-block">
                    <input type="pidName" name="pidName" placeholder="请选择所属部门" autocomplete="off" class="layui-input" readonly="readonly" style="background:#eeeeee!important">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label ">部门经理名称</label>
                <div class="layui-input-block">
                    <input type="managerName" lay-verify="required" name="managerName" placeholder="请输入部门经理名称" autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-form-label">部门经理手机号</div>
                <div class="layui-input-block">
                    <input type="phone" name="phone" lay-verify="required|phone" placeholder="请输入部门经理手机号" autocomplete="off" class="layui-input">
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
<div class="dept-table">
    <table class="layui-table" id="deptTable" lay-filter="deptTable" ></table>
</div>
<div id="deptTree" style="display: none"></div>
<script type="text/html" id="toolbar">
    <div class="layui-btn-group">
        <button  shiro:hasPermission="sys:dept:add" type="button" class="layui-btn layui-btn-normal" lay-event="addDept">
            <i class="layui-icon">&#xe608;</i> 添加部门
        </button>
    </div>

</script>
<script type="text/html" id="tool">
    <a shiro:hasPermission="sys:dept:update"  class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a shiro:hasPermission="sys:dept:deleted" class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script  th:inline="none">
    var layer = layui.layer;
    var $ = jQuery = layui.jquery;
    var form = layui.form;
    var element = layui.element;
    var treetable;
    var selectNode={};
    layui.config({
        base:  CoreUtil.ctx+'/treetable-lay/'
    }).extend({
        treetable: 'treetable'
    }).use([ 'treetable','table','tree'], function () {
        var reloadTreeTable = function () {
            CoreUtil.sendAjax("/sys/depts",null,function (res) {
                renderTable(res.data);
            },"GET",false,function (res) {
                layer.msg("抱歉！您暂无获取部门列表的权限");
                var noAuthorityData=[];
                renderTable(noAuthorityData);
            });
        };
        reloadTreeTable();
        treetable = layui.treetable;
        var table = layui.table;
        var tree=layui.tree;
        var renderTable = function(data) {
            treetable.render({
                // 渲染表格
                data: data,
                treeColIndex: 1, // 树形图标显示在第几列
                treeSpid: 0, // 最上级的父级id
                treeIdName: 'deptNo', // id字段的名称
                treePidName: 'pid', // pid字段的名称
                treeDefaultClose: false, // 是否默认折叠
                treeLinkage: true, // 父级展开时是否自动展开所有子级
                elem: '#deptTable', // 表格id
                page: false, // 树形表格一般是没有分页的
                toolbar:'#toolbar',
                cols: [
                    [
                        {type: 'numbers'},
                        // {field: 'id', title: 'ID'},
                        {field: 'deptNo', title: '部门编码'},
                        {field: 'name',align: 'center', title: '部门名称',},
                        {
                            field: 'pidName', align: 'center',title: '上级部门',templet: function (item) {
                                if(item.pidName === null||item.pidName===undefined){
                                    return  "";
                                }else {
                                    return item.pidName;
                                }
                            }
                        },
                        {field: 'managerName', align: 'center',title: '部门主管'},
                        {field: 'phone',align: 'center', title: '联系电话'},
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
                        {
                            field: 'createTime', align: 'center',title: '创建时间', minWidth: 170 , templet: function (item) {
                                return CoreUtil.formattime(item.createTime);
                            }
                        },
                        {title:'操作',width:120,align: 'center',toolbar:'#tool'}
                    ]
                ]
            });

        };
        //操作项事件
        table.on('tool(deptTable)',function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'del':
                    deletedDept(data.id,data.name);
                    break;
                case 'edit':
                    selectNode=null;
                    $(".dept-table").hide();
                    $(".operation_dept").show();
                    $(".title").html("编辑部门");
                    $(".operation_dept input[name=id]").val(data.id);
                    $(".operation_dept input[name=pid]").val(data.pid);
                    $(".operation_dept input[name=name]").val(data.name);
                    $(".operation_dept input[name=pidName]").val(data.pidName);
                    $(".operation_dept input[name=managerName]").val(data.managerName);
                    $(".operation_dept input[name=phone]").val(data.phone);
                    if(data.status ==1){
                        $(".operation_dept input[name=status]").attr('checked', 'checked');
                        $(".operation_dept input[name=status]").attr('type', 'hidden').val(1);
                        var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                        x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                        var d = document.getElementsByTagName('em')[0];
                        d.firstChild.nodeValue = '启用';
                    }else {
                        $(".operation_dept input[name=status]").attr('type', 'hidden').removeAttr("checked").val(0);
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
        table.on('toolbar(deptTable)',function (obj) {
            switch (obj.event) {
                case 'addDept':
                    selectNode=null;
                    $(".dept-table").hide();
                    $(".operation_dept").show();
                    $(".title").html("新增部门");
                    $(".operation_dept input[name=id]").val("");
                    $(".operation_dept input[name=pid]").val("");
                    $(".operation_dept input[name=name]").val("");
                    $(".operation_dept input[name=pidName]").val("");
                    $(".operation_dept input[name=managerName]").val("");
                    $(".operation_dept input[name=phone]").val("");
                    $(".operation_dept input[name=status]").attr('checked', 'checked');
                    $(".operation_dept input[name=status]").attr('type', 'hidden').val(1);
                    var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                    x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                    var d = document.getElementsByTagName('em')[0];
                    d.firstChild.nodeValue = '启用';
                    form.render(); //更新全部
                    initTree("");
                    break;
            }
        });
        var deletedDept=function(deptId,menuName){
            layer.open({
                content: '确定要删除'+menuName+"?",
                yes: function(index, layero){
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    CoreUtil.sendAjax("/sys/dept/"+deptId,null,function (res) {
                        layer.msg(res.msg);
                        reloadTreeTable();
                    },"DELETE",false,function (res) {
                        layer.msg("抱歉！您暂无删除部门数据的权限");
                    });
                }
            });
        };
        $("#btn_cancel").click(function() {
            $(".dept-table").show();
            $(".operation_dept").hide();
            return false;
        });
        var loadDeptTree=function (data) {
            tree.render({
                elem: '#deptTree'
                ,data: data
                ,onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
                ,click: function(obj){
                    selectNode=obj;
                    layer.msg(JSON.stringify(selectNode.data.title));
                }
            });
        };
        $(".operation_dept input[name=pidName]").click(function () {
            layer.open({
                type: 1,
                offset: '0px',
                skin: 'layui-layer-molv',
                title: "选择部门",
                area: ['400px', '550px'],
                shade: 0,
                shadeClose: false,
                content: jQuery("#deptTree"),
                btn: ['确定', '取消'],
                yes: function (index) {
                    if(selectNode.data!=null){
                        //选中回显
                        $(".operation_dept input[name=pid]").val(selectNode.data.id);
                        $(".operation_dept input[name=pidName]").val(selectNode.data.title);
                    }

                    layer.close(index);
                }
            });
        });
        form.on('switch(switch)', function(){
            $(".operation_dept input[name=status]").attr('type', 'hidden').val(this.checked ? 1 : 0);

        });
        form.on('submit(submit)', function(data){
            if(data.field.id===undefined || data.field.id===null || data.field.id===""){
                CoreUtil.sendAjax("/sys/dept",JSON.stringify(data.field),function (res) {
                    reloadTreeTable();
                    $(".dept-table").show();
                    $(".operation_dept").hide();
                },"POST",false,function (res) {
                    layer.msg("抱歉！您暂无新增部门的权限");
                });
            }else {
                CoreUtil.sendAjax("/sys/dept",JSON.stringify(data.field),function (res) {
                    reloadTreeTable();
                    $(".dept-table").show();
                    $(".operation_dept").hide();
                },"PUT",false,function (res) {
                    layer.msg("抱歉！您暂无编辑部门的权限");
                });
            }

            return false;
        });
        var initTree=function (id) {
            var param={deptId:id}
            CoreUtil.sendAjax("/sys/dept/tree",param,function (res) {
                loadDeptTree(res.data);
            },"GET",false,function (res) {
                layer.msg("抱歉！您暂无获取部门树的权限");
                var noAuthorityData=[];
                loadDeptTree(noAuthorityData);
            });
        };

    });
</script>
</body>
</@html>