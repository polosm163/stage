<@html>
<@head title="用户编辑">
<#--自定义引入文件-->
</@head>
<body>


<div class="layui-container">

                    <#--<div class="layui-fluid">-->
                        <#--<div class="layui-card">-->
                            <#--<div class="layui-card-header">表单组合</div>-->
                            <#--<div class="layui-card-body">-->


                            <#--</div>-->
                        <#--</div>-->
                    <#--</div>-->


                    <div class="operation_user">
                    <form class="layui-form layui-form-pane" action="" lay-filter="userInfo">  <#--注意样式 layui-form-pane-->

                                <input name="id" hidden/>
                                <input name="deptId" hidden/>

                                <div class="layui-form-item">
                                    <label class="layui-form-label">账号</label>
                                    <div class="layui-input-block">
                                        <input type="username" name="username" placeholder="请输入账号" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="layui-form-label ">密码</div>
                                    <div class="layui-input-inline"> <#-- 此处样式注意，和下面不一样 -->
                                        <input type="password" name="password"  placeholder="请输入密码" autocomplete="off" class="layui-input">
                                    </div>
                                    <div class="layui-form-mid layui-word-aux">建议强密码(辅助文字演示)</div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="layui-form-label ">手机号</div>
                                    <div class="layui-input-block"><!--lay-verify="required|phone" -->
                                        <input type="phone"  name="phone" placeholder="请输入手机号" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="layui-form-label ">邮箱</div>
                                    <div class="layui-input-block">  <!--lay-verify="email" -->
                                        <input type="text"  name="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="layui-form-label ">性别</div>
                                    <div class="layui-input-block">
                                        <div class="layui-input-inline layui-form"> <!-- 注意这个样式-->
                                            <select name="sex">
                                                <option value="">请选择性别</option>
                                                <option value="1">男</option>
                                                <option value="2">女</option>
                                                <option value="3">保密</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                    <#--演示 开始--->
                                <div class="layui-form-item">
                                    <label class="layui-form-label">演示-选择框</label>
                                    <div class="layui-input-block">
                                        <select name="city" lay-verify="required">
                                            <option value=""></option>
                                            <option value="0">北京</option>
                                            <option value="1">上海</option>
                                            <option value="2">广州</option>
                                            <option value="3">深圳</option>
                                            <option value="4">杭州</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="layui-form-item">
                                    <label class="layui-form-label">演示-复选框</label>
                                    <div class="layui-input-block">
                                        <input type="checkbox" name="like[write]" title="写作">
                                        <input type="checkbox" name="like[read]" title="阅读" checked>
                                        <input type="checkbox" name="like[dai]" title="发呆">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <label class="layui-form-label">演示-单选框</label>
                                    <div class="layui-input-block">
                                        <input type="radio" name="sex-1" value="男" title="男">
                                        <input type="radio" name="sex-1" value="女" title="女" checked>
                                    </div>
                                </div>
                    <#--演示 结束--->

                                <div class="layui-form-item">
                                    <div class="layui-form-label ">真实姓名</div>
                                    <div class="layui-input-block">
                                        <input type="text" lay-verify="required" name="realName" placeholder="请输入真实姓名" autocomplete="off" class="layui-input">
                                    </div>
                                </div>
                                <div class="layui-form-item">
                                    <div class="layui-form-label ">所属部门</div>
                                    <div class="layui-input-block">
                                        <input type="deptName" name="deptName" placeholder="请选择所属部门" autocomplete="off" class="layui-input"
                                               readonly="readonly" style="background:#eeeeee!important">
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
                                        <input type="button" class="layui-btn" value="保存" id="saveUser" lay-filter="saveUser" style="display: none"/>
                                        <button type="submit"  class="layui-btn" lay-submit="" lay-filter="addUser">保存</button>
                                        <button type="reset"   class="layui-btn layui-btn-primary">重置</button>
                                    </div>
                                </div>


                    </form>
                    </div>




</div>

<div id="deptTree" style="display: none"></div>

</body>
<script>


    var $ = jQuery = layui.jquery;


    layui.use(['table', 'laypage', 'layer', 'laydate', 'tree', 'transfer'], function () {
        var form = layui.form;
        var tree = layui.tree;


        form.render();


        form.on('submit(addUser)', function (data) {

            debugger;
            if (data.field.id === undefined || data.field.id === null || data.field.id === "") {
                CoreUtil.sendAjax("/sys/user", JSON.stringify(data.field), function (res) {

                    parent.layer.msg("编辑成功!",{time:1000},function(){
                        parent.location.reload();//刷新父页面
                    });

                }, "POST", false, function (res) {
                    layer.msg("抱歉！您暂无新增用户的权限"+res.message);
                });
            } else {

                CoreUtil.sendAjax("/sys/user", JSON.stringify(data.field), function (res) {

                }, "PUT", false, function (res) {
                    layer.msg("抱歉！您暂无编辑用户的权限"+res.message);
                });
            }

            //这行代码是用来控制跳页面的 跳转提交
            return false;
        });



        var initTree = function (id) {
            var param = {deptId: id}
            CoreUtil.sendAjax("/sys/dept/tree", param, function (res) {
                loadDeptTree(res.data);
            }, "GET", false, function (res) {
                layer.msg("抱歉！您暂无获取部门树的权限");
                var noAuthorityData = [];
                loadDeptTree(noAuthorityData);
            });
        };

        var loadDeptTree = function (data) {
            tree.render({
                elem: '#deptTree'
                , data: data
                , onlyIconControl: true  //是否仅允许节点左侧图标控制展开收缩
                , click: function (obj) {
                    selectNode = obj;
                    layer.msg(JSON.stringify(selectNode.data.title));
                }
            });
        };


        initTree();


        $(".layui-container input[name=deptName]").click(function () {

            layer.open({
                type: 1,
                offset: '0px',
                skin: 'layui-layer-molv',
                title: "选择部门",
                area: ['500px', '550px'],
                shade: 0,
                shadeClose: false,
                content: jQuery("#deptTree"),
                btn: ['确定', '取消'],
                yes: function (index) {
                    if (selectNode.data != null) {
                        //选中回显
                        $(".layui-container input[name=deptId]").val(selectNode.data.id);
                        $(".layui-container input[name=deptName]").val(selectNode.data.title);
                    }

                    layer.close(index);
                }
            });
        });


        $("#saveUser").on("click",function() {
            var flag = $("input[name='status']").prop("checked");
            $("input[name='status']").prop("checked" , !flag);
            form.render("checkbox");
            var flag2 = $("input[name='status']").prop("checked");
            toastr.info(flag +" "+ flag2);


        });






    });




</script>
</@html>