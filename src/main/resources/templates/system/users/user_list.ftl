<@html>
<@head title="用户信息">

</@head>
<body class="childrenBody">


<fieldset class="layui-elem-field">
    <legend>用户检索</legend>
    <div class="layui-field-box">
        <div id="searchParam" shiro:hasPermission="sys:user:list">


            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-inline">
                    <input type="text" id="username" class="layui-input" autocomplete="off" placeholder="请输入用户名">
                </div>
                <label class="layui-form-label">真实名称</label>
                <div class="layui-input-inline">
                    <input type="text" id="realName" class="layui-input" autocomplete="off" placeholder="请输真实名称">
                </div>
                <label class="layui-form-label">性别</label>
                <div class="layui-input-inline layui-form">
                    <select id="sex">
                        <option value="">请选择性别</option>
                        <option value="1">男</option>
                        <option value="2">女</option>
                        <option value="3">保密</option>
                    </select>
                </div>
            </div>
            <#--第二行-->
            <div class="layui-form-item">
                <label class="layui-form-label">来源</label>
                <div class="layui-input-inline layui-form">
                    <select class="" id="createWhere">
                        <option value="">请选择来源</option>
                        <option value="1">Web</option>
                        <option value="2">Android</option>
                        <option value="3">Ios</option>
                    </select>
                </div>
                <label class="layui-form-label">账号状态</label>
                <div class="layui-input-inline layui-form">
                    <select class="" id="status">
                        <option value="">请选择账号状态</option>
                        <option value="1">正常</option>
                        <option value="2">被锁定</option>
                    </select>
                </div>
                <label class="layui-form-label">时间区间</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="createTime" placeholder="选择创建时间区间" style="width: 290px">
                </div>
            </div>

        </div>
    </div>
</fieldset>

    <table class="layui-hide" id="user_table" lay-filter="user_table"></table>
    <div id="laypage" class= "$(" .layui-laypage-btn").click();">

</div>
<div id="deptTree" style="display: none"></div>
<div id="roles" class="demo-transfer" style="display: none"></div>
</body>





<script type="text/html" id="toolbar">
    <div class="layui-btn-group" id="search">
        <button type="button" class="layui-btn" lay-event="search" >
            <i class="layui-icon">&#xe615;</i> 开始检索
        </button>
    </div>
    <div class="layui-btn-group">
        <button type="button" class="layui-btn layui-btn-danger" lay-event="batchDeleted"
                shiro:hasPermission="sys:user:deleted">
            <i class="layui-icon">&#xe608;</i> 批量删除
        </button>
    </div>
    <div class="layui-btn-group">
        <button type="button" class="layui-btn layui-btn-normal" lay-event="addNewUser"
                shiro:hasPermission="sys:user:add">
            <i class="layui-icon">&#xe608;</i> 新增用户
        </button>
    </div>
</script>

<script type="text/html" id="tool">
    <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="operationRole" shiro:hasPermission="sys:user:role:detail">授权</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit" shiro:hasPermission="sys:user:update">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del" shiro:hasPermission="sys:user:deleted">删除</a>
</script>

<script type="text/html" id="sexTpl">
    {{#  if(d.sex == 2){ }}
    <span style="color: #fe5395;">女</span>
    {{#  } else if(d.sex == 1){ }}
    <span style="color: #48c202;">男</span>
    {{#  } else{ }}
    <span style="color: #17a2b8;">保密</span>
    {{#  } }}
</script>

<script type="text/html" id="sourceTpl">
    {{#  if(d.createWhere == 1){ }}
    <span style="color: #0053c6;">Web</span>
    {{#  } else if(d.createWhere == 2){ }}
    <span style="color: #00d394;">Android</span>
    {{#  } else if(d.createWhere == 3){ }}
    <span style="color: #dde52d;">Ios</span>
    {{#  } else{ }}
    <span style="color: #c40b53;">其他</span>
    {{#  } }}
</script>

<script>
    var table = layui.table;
    var laypage = layui.laypage
    var form = layui.form;
    var layer = layui.layer;
    var $ = jQuery = layui.jquery;
    var laydate = layui.laydate;
    var tree = layui.tree;
    var transfer = layui.transfer;


    layui.use(['table', 'laypage', 'layer', 'laydate', 'tree', 'transfer'], function () {
        form.render();
        var searchParam = {
            userId: null,
            username: null,
            realName:null,
            sex:null,
            createWhere:null,
            status: null,
            startTime: null,
            endTime: null,
            nickName: null,
            pageNum: 1,
            pageSize: 5
        }

        CoreUtil.sendAjax("/sys/users", JSON.stringify(searchParam), function (res) {
            laypageTable(res.data.totalRows, searchParam.pageNum);
            if (res.data.list != null) {
                loadTable(res.data.list);
            }
        }, "POST", false, function (res) {
            layer.msg("抱歉！您暂无获取用户列表的权限");
            var noAuthorityData = [];
            loadTable(noAuthorityData);
        });
        var laypageTable = function (count, currentPage) {
            laypage.render({
                elem: 'laypage'
                , count: count
                , limit: searchParam.pageSize
                , layout: ['count', 'prev', 'page', 'next', 'limit', 'refresh', 'skip']
                , curr: location.hash.replace('#!currentPage=', '') //获取起始页
                , hash: 'currentPage' //自定义hash值
                , jump: function (obj, first) {
                    if (!first) {
                        searchParam.pageNum = obj.curr;
                        searchParam.pageSize = obj.limit;
                        CoreUtil.sendAjax("/sys/users", JSON.stringify(searchParam), function (res) {
                            if (res.data.list != null) {
                                loadTable(res.data.list);
                                laypageTable(res.data.totalRows, searchParam.pageNum);
                            }
                        }, "POST", false, function (res) {
                            layer.msg("抱歉！您暂无获取用户列表的权限");
                            var noAuthorityData = [];
                            loadTable(noAuthorityData);
                        });
                    }
                }
            });
        };
        //渲染table
        var loadTable = function (data) {
            table.render({
                elem: '#user_table'
                , cols: [
                    [
                        {type: 'checkbox', fixed: 'left'},
                        {field: 'username', align: 'center', title: '用户名', width: 110},
                        {field: 'realName', align: 'center', title: '真实名称', width: 90},
                        {field: 'deptName', align: 'center', title: '所属部门', width: 120},
                        {field: 'createWhere', align: 'center', title: '来源', width: 80, templet: '#sourceTpl'},
                        {field: 'phone', align: 'center', title: '手机号', width: 120},
                        {field: 'email', align: 'center', title: '邮箱'},

                        {field: 'sex', title: '性别', align: 'center', width: 60, templet: '#sexTpl'},
                        {
                            field: 'createTime', align: 'center', title: '创建时间', width: 170, templet: function (item) {
                                return CoreUtil.formattime(item.createTime);
                            }
                        },
                        {
                            field: 'status', align: 'center', title: '状态', width: 100, templet: function (item) {
                                if (item.status === 1) {
                                    return '  <input type="checkbox" lay-skin="switch" lay-text="正常|禁用" checked disabled>';
                                }
                                if (item.status === 2) {
                                    return '  <input type="checkbox" lay-skin="switch" lay-text="正常|禁用" disabled>';
                                }
                            }
                        },

                        {width: 180, align: 'center', toolbar: "#tool", title: '操作',fixed: 'right'}
                    ]
                ]
                , data: data
                , even: true
                , limit: data.length
                , limits: [10,  50, 100]
                , toolbar: '#toolbar'
            });
        };
        laydate.render({
            elem: '#createTime'
            , type: 'datetime'
            , range: '~'
            , done: function (value, date, endDate) {
                if (value != null && value != undefined && value != "") {
                    searchParam.startTime = value.split("~")[0];
                    searchParam.endTime = value.split("~")[1];
                } else {
                    searchParam.startTime = null;
                    searchParam.endTime = null;
                }
            }
        });


        table.on('toolbar(user_table)', function (obj) {

            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'batchDeleted':
                    var checkStatus = table.checkStatus(obj.config.id);
                    var data = checkStatus.data;
                    if (data.length == 0) {
                        layer.msg("请选择要批量删除的用户");
                    } else {
                        var userIds = [];
                        $(data).each(function (index, item) {
                            userIds.push(item.id);
                        });
                        tipDialog(userIds, "选中的");
                    }
                    break;
                case 'addNewUser':


                    addUser();

                    form.render(); //更新全部
                    // //initTree("");
                    break;
                case 'search':


                    searchParam.userId = $("#userId").val();
                    searchParam.realName = $("#realName").val();
                    searchParam.sex = $("#sex").val();
                    searchParam.createWhere = $("#createWhere").val();
                    searchParam.status = $("#status").val();
                    searchParam.username = $("#username").val();
                    searchParam.nickName = $("#nickName").val();
                    searchParam.pageNum = 1;
                    CoreUtil.sendAjax("/sys/users", JSON.stringify(searchParam), function (res) {
                        laypageTable(res.data.totalRows, searchParam.pageNum);
                        if (res.data.list != null) {
                            loadTable(res.data.list);
                        }
                    }, "POST", false, function (res) {
                        layer.msg("抱歉！您暂无获取用户列表的权限");
                        var noAuthorityData = [];
                        loadTable(noAuthorityData);
                    });
                    break;
            }
            ;
        });
        table.on('tool(user_table)', function (obj) {
            var data = obj.data;
            switch (obj.event) {
                case 'del':
                    var userIds = [];
                    userIds.push(data.id);
                    tipDialog(userIds, data.username);
                    break;
                case 'edit':


                    editUser(data);

                    form.render(); //更新全部

                    //initTree("");
                    break;
                case 'operationRole':
                    CoreUtil.sendAjax("/sys/user/roles/" + data.id, null, function (res) {
                        initTransfer(res.data);
                        layer.open({
                            type: 1,
                            offset: '50px',
                            skin: 'layui-layer-molv',
                            title: "赋予角色",
                            area: ['500px', '500px'],
                            shade: 0,
                            shadeClose: false,
                            content: jQuery("#roles"),
                            btn: ['确定', '取消'],
                            yes: function (index) {
                                //获得右侧数据
                                var roleIds = [];
                                var getData = transfer.getData('ownData');
                                if (getData.length == 0) {
                                    layer.msg("请选择要赋予用户的角色");
                                } else {

                                    $(getData).each(function (index, item) {
                                        roleIds.push(item.value);
                                    });
                                }
                                CoreUtil.sendAjax("/sys/user/roles/" + data.id, JSON.stringify(roleIds), function (res) {
                                    layer.msg(res.msg);
                                    $(".layui-laypage-btn").click();
                                }, "PUT", false, function (res) {
                                    layer.msg("抱歉！您暂无赋予用户角色的权限");
                                });

                                layer.close(index);
                            }
                        });
                    }, "GET", false, function (res) {
                        layer.msg("抱歉！您暂无查询用户所拥有角色列表的权限");
                    });

                    break;
            }
        });


        var tipDialog = function (userIds, username) {
            if(username=="admin"){
                layer.msg('不可删除管理员',{icon: 5,time:1000});
                return;
            }
            layer.open({
                content: '确定要删除' + username + "用户么?",
                yes: function (index, layero) {
                    layer.close(index); //如果设定了yes回调，需进行手工关闭
                    CoreUtil.sendAjax("/sys/user", JSON.stringify(userIds), function (res) {
                        layer.msg(res.msg);
                        $(".layui-laypage-btn").click();
                    }, "DELETE", false, function (res) {
                        layer.msg("抱歉！您暂无删除用户的权限");
                    });
                }
            });
        };


        form.on('switch(switch)', function () {
            $(".operation_user input[name=status]").attr('type', 'hidden').val(this.checked ? 1 : 2);

        });


        var addUser = function(){
            var addIndex = layer.open({
                title : "添加用户",
                type : 2, //0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
                content : "${ctx}/index/users/edit",
                success : function(layero, addIndex){
                    setTimeout(function(){
                        layer.tips('点击此处返回上一列表', '.layui-layer-setwin .layui-layer-close', { tips: 3 });
                        //
                    },500);
                }
            });
            //改变窗口大小时，重置弹窗的高度，防止超出可视区域（如F12调出debug的操作）
            $(window).resize(function(){
                layer.full(addIndex);
            });
            layer.full(addIndex);


        }

        var editUser = function(data){


            var addIndex = layer.open({
                title : "编辑用户",
                type : 2, //0（信息框，默认）1（页面层）2（iframe层）3（加载层）4（tips层）
                content : "${ctx}/index/users/edit",
                success : function(layero, index){

                    setTimeout(function(){
                        layer.tips('点击此处返回上一列表', '.layui-layer-setwin .layui-layer-close', { tips: 3 });
                        //
                    },500);


                    var body = layer.getChildFrame('body',index);//少了这个是不能从父页面向子页面传值的
                    //获取子页面的元素，进行数据渲染

                    body.contents().find(".operation_user input[name=id]").val(data.id);
                    body.contents().find(".operation_user input[name=deptId]").val(data.deptId);
                    body.contents().find(".operation_user input[name=username]").val(data.username);
                    body.contents().find(".operation_user input[name=email]").val(data.email);
                    body.contents().find(".operation_user input[name=realName]").val(data.realName);
                    body.contents().find(".operation_user input[name=sex]").val(data.sex);
                    body.contents().find(".operation_user input[name=password]").val("");
                    body.contents().find(".operation_user input[name=phone]").val(data.phone);
                    body.contents().find(".operation_user input[name=deptName]").val(data.deptName);

                    // body.contents().find(id).prop("checked", true);//这是子页面的单选按钮，让其选中
                    if (data.status == 1) {
                        body.contents().find(".operation_user input[name=status]").attr('checked', 'checked');//
                        body.contents().find(".operation_user input[name=status]").val(1);

                        //var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                        //x[0].setAttribute("class", "layui-unselect layui-form-switch layui-form-onswitch");
                        //var d = document.getElementsByTagName('em')[0];
                       // d.firstChild.nodeValue = '启用';
                    } else {
                        body.contents().find(".operation_user input[name=status]").removeAttr("checked")
                        body.contents().find(".operation_user input[name=status]").val(2);


                        //body.contents().find(".operation_user input[name=status]").attr('type', 'hidden').removeAttr("checked").val(2);
                        //var x = document.getElementsByClassName("layui-unselect layui-form-switch");
                        //x[0].setAttribute("class", "layui-unselect layui-form-switch");
                        //var d = document.getElementsByTagName('em')[0];
                        //d.firstChild.nodeValue = '禁用';
                    }

                    //
                    // var iframeWin = window[layero.find('iframe')[0]['name']]; //得到iframe页的窗口对象，执行iframe页的方法：iframeWin.method();
                    var iframeWin = layero.find('iframe')[0].contentWindow;
                    // 重新渲染checkbox,select同理
                    iframeWin.layui.form.render('checkbox');



                }
            });
            //改变窗口大小时，重置弹窗的高度，防止超出可视区域（如F12调出debug的操作）
            $(window).resize(function(){
                layer.full(addIndex);
            });
            layer.full(addIndex);

            //重新给指定层设定width、top等 因为它们的小屏幕电脑的弹出层会出现滚动条，所以才用这个方法给加一个overflow: 'visible',属性
            // layer.style(lay, {
            //     overflow: 'visible',
            // });


        }

        // var loadDeptTree = function (data) {
        //     tree.render({
        //         elem: '#deptTree'
        //         , data: data
        //         , onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
        //         , click: function (obj) {
        //             selectNode = obj;
        //             layer.msg(JSON.stringify(selectNode.data.title));
        //         }
        //     });
        // };
        $(".operation_user input[name=deptName]").click(function () {
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
                    if (selectNode.data != null) {
                        //选中回显
                        $(".operation_user input[name=deptId]").val(selectNode.data.id);
                        $(".operation_user input[name=deptName]").val(selectNode.data.title);
                    }

                    layer.close(index);
                }
            });
        });
        // var initTree = function (id) {
        //     var param = {deptId: id}
        //     CoreUtil.sendAjax("/sys/dept/tree", param, function (res) {
        //         loadDeptTree(res.data);
        //     }, "GET", false, function (res) {
        //         layer.msg("抱歉！您暂无获取部门树的权限");
        //         var noAuthorityData = [];
        //         loadDeptTree(noAuthorityData);
        //     });
        // };

        var initTransfer = function (data) {
            transfer.render({
                elem: '#roles'
                , data: data.allRole
                , title: ['赋予角色', '拥有角色']
                , showSearch: true
                , value: data.ownRoles
                , id: 'ownData'
                , parseData: function (res) {
                    return {
                        "value": res.id //数据值
                        , "title": res.name //数据标题
                    }
                }
            })
        }
    });
</script>
</@html>