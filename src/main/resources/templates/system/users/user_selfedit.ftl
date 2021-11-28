<@html>
    <@head title="">

    </@head>
<body>
<div class="layui-container" style="width:600px;">
    <form class="layui-form layui-form-pane" action="" lay-filter="userInfo">
        <input name="id" hidden>
        <div class="layui-form-item">
            <label class="layui-form-label">账号</label>
            <div class="layui-input-block">
                <input th:if="${flagType} eq 'edit'" type="text" name="username" lay-verify="title" disabled="disabled" style="background:#eeeeee!important" autocomplete="off" placeholder="请输入账号" class="layui-input layui-disabled " >
                <input th:if="${flagType} eq 'add'" type="text" name="username" lay-verify="title"  autocomplete="off" placeholder="请输入账号" class="layui-input" >
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">真实姓名</label>
            <div class="layui-input-block">
                <input type="realName" name="realName" placeholder="请输入真实姓名" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">手机号</label>
            <div class="layui-input-block">
                <input type="tel" name="phone" placeholder="请输入手机号" lay-verify="required|phone" autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">邮箱</label>
            <div class="layui-input-block">
                <input type="text" name="email" lay-verify="email" placeholder="请输入邮箱" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">状态</label>
            <div class="layui-input-block">
                <input th:if="${flagType} eq 'add'" type="checkbox" name="status" lay-skin="switch" lay-text="启用|禁止"  lay-filter="switch" checked="checked" >
                <input th:if="${flagType} eq 'edit'" type="checkbox" name="status" lay-skin="switch" lay-text="启用|禁止"  lay-filter="switch" checked="checked" disabled="disabled">
            </div>
        </div>

        <div class="layui-form-item">
            <label class="layui-form-label">单选框</label>
            <div class="layui-input-block">
                <input type="radio" name="sex" value="1" title="男">
                <input type="radio" name="sex" value="2" title="女">
            </div>
        </div>

        <div class="layui-form-item">
            <div class="layui-input-block">
                <button type="submit" class="layui-btn" lay-submit="" lay-filter="submit">保存</button>
            </div>
        </div>
    </form>
</div>
</body>
<script>
    var layer = layui.layer;
    var $ = jQuery = layui.jquery;
    var form = layui.form;
    var element = layui.element;
    $(function () {
        CoreUtil.sendAjax("/sys/user",null,function (res) {
            if(res.data != null){
                $(".layui-container input[name=id]").val(res.data.id);
                $(".layui-container input[name=username]").val(res.data.username);
                $(".layui-container input[name=realName]").val(res.data.realName);
                $(".layui-container input[name=email]").val(res.data.email);
                $(".layui-container input[name=phone]").val(res.data.phone);
                $(".layui-container input[name=sex][value=1]").attr("checked", res.data.sex == 1 ? true : false);
                $(".layui-container input[name=sex][value=2]").attr("checked", res.data.sex == 2 ? true : false);
                if(res.data.status ==1){
                    $(".layui-container input[name=status]").attr('checked', 'checked');
                    $(".layui-container input[name=status]").attr('type', 'hidden').val(1);
                }else {
                    $(".layui-container input[name=status]").attr('type', 'hidden').removeAttr("checked").val(2);
                    var x = document.getElementsByClassName("layui-unselect layui-form-switch layui-form-onswitch");
                    x[0].setAttribute("class", "layui-unselect layui-form-switch");
                    var d = document.getElementsByTagName('em')[0];
                    d.firstChild.nodeValue = '禁用';
                }
                form.render(); //更新全部
            }
        },"GET",false);
        //监听提交
        form.on('submit(submit)', function(data){
            CoreUtil.sendAjax("/sys/user/info",JSON.stringify(data.field),function (res) {
                layer.msg(res.msg);
            },"put",false);
            return false;
        });
        //监听指定开关
        form.on('switch(switch)', function(){
            $(".layui-container input[name=status]").attr('type', 'hidden').val(this.checked ? 1 : 2);
        });
    })
</script>
</@html>