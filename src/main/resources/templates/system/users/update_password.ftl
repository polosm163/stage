<@html>
    <@head title="">

    </@head>
<body>
<div class="layui-container" style="width:400px;">
    <form action="" class="layui-form" id="passForm">
        <div class="layui-form-item">
            <label class="layui-form-label">旧密码</label>
            <div class="layui-input-block">
                <input type="password" name="oldPwd" class="layui-input" lay-verify="required" />
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">新密码</label>
            <div class="layui-input-block">
                <input type="password" name="newPwd" id="newPwd" class="layui-input" lay-verify="required" />
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">确认密码</label>
            <div class="layui-input-block">
                <input type="password" name="rePass" lay-verify="required|repass" class="layui-input" verify="required" />
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-block">
                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="baseSubmit">保存</button>
            </div>
        </div>

    </form>
</div>
<script src="/layui/layui.all.js"></script>
<script src="/js/util.js"></script>
<script>
    var form = layui.form;
    var layer= layui.layer;
    var $ = jquery = layui.jquery;
    form.verify({
        repass: function(value) {
            var pass = $("#newPwd").val();
            if(pass!=value) {
                return '两次输入的密码不一致';
            }
        }
    })
    form.on('submit(baseSubmit)',function (data) {
        CoreUtil.sendAjax("/sys/user/pwd",JSON.stringify(data.field),function (res) {
            layer.msg("密码已经变更请重新登录!",{
                icon:1,
                time: 3000,
            },function () {
                top.window.location.href=CoreUtil.ctx+"/index/login";
            });
        },"PUT",true);

        return false;
    })
</script>
</body>
</@html>