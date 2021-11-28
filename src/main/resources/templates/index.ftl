<#assign ctx = springMacroRequestContext.contextPath/>
<!DOCTYPE html>
<html lang="zh">
<head>
    <base id="base" href="${ctx}" content="${ctx}" version="${version}">
	<title>登录</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

    <meta id="pageContext" staffId="" contextName="${ctx}" version="${version}"/>

	<link rel="icon" type="image/png" href="${ctx}/login/images/icons/favicon.ico"/>
	<link rel="stylesheet"  href="${ctx}/login/vendor/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet"  href="${ctx}/login/fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<link rel="stylesheet"  href="${ctx}/login/fonts/iconic/css/material-design-iconic-font.min.css">
	<link rel="stylesheet"  href="${ctx}/login/vendor/animate/animate.css">
	<link rel="stylesheet"  href="${ctx}/layui/css/layui.css">
	<link rel="stylesheet"  href="${ctx}/login/vendor/css-hamburgers/hamburgers.min.css">
	<link rel="stylesheet"  href="${ctx}/login/vendor/animsition/css/animsition.min.css">
	<link rel="stylesheet"  href="${ctx}/login/vendor/select2/select2.min.css">
	<link rel="stylesheet"  href="${ctx}/login/vendor/daterangepicker/daterangepicker.css">
	<link rel="stylesheet"  href="${ctx}/login/css/util.css">
	<link rel="stylesheet"  href="${ctx}/login/css/main.css">
	<link rel="stylesheet"  href="${ctx}/css/drag.css">
    <link rel="stylesheet"  href="${ctx}/core/toastr/toastr.min.css?v=${version}">

	<script src="${ctx}/login/js/jq-slideVerify.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/login/vendor/jquery/jquery-3.2.1.min.js"></script>
	<script src="${ctx}/login/vendor/animsition/js/animsition.min.js"></script>
	<script src="${ctx}/login/vendor/bootstrap/js/popper.js"></script>
	<script src="${ctx}/login/vendor/bootstrap/js/bootstrap.min.js"></script>
	<script src="${ctx}/login/vendor/select2/select2.min.js"></script>
	<script src="${ctx}/login/vendor/daterangepicker/moment.min.js"></script>
	<script src="${ctx}/login/vendor/daterangepicker/daterangepicker.js"></script>
	<script src="${ctx}/login/vendor/countdowntime/countdowntime.js"></script>
    <script src="${ctx}/core/toastr/toastr.min.js?v=${version}"></script>

	<script src="${ctx}/login/js/main.js"></script>
	<script src="${ctx}/login/js/login.util.js"></script>
	<script src="${ctx}/layui/layui.all.js"></script>



</head>
<body>

<div class="limiter">
	<div class="container-login100">
		<div class="wrap-login100 p-t-85 p-b-20 m-b-30">
			<form class="login100-form validate-form" id = "myform">

				<span class="login100-form-avatar">
					<img src="${ctx}/login/images/14.png" alt="AVATAR">
				</span>
				<input name="type"  type="hidden" value="1">
				<div class="wrap-input100 validate-input m-t-75 m-b-25" data-validate = "请输入用户名">
					<input class="input100" type="text" name="username" id = "username" autocomplete="off">
					<span class="focus-input100" data-placeholder="请输入用户名"></span>
				</div>
				<div class="wrap-input100 validate-input m-b-55" data-validate="请输入密码">
					<input class="input100" type="password" name="password" autocomplete="off">
					<span class="focus-input100" data-placeholder="请输入密码"></span>
				</div>
				<div class="verify-wrap" id="verify-wrap">
					<div class="drag-progress dragProgress"></div>
					<span class="drag-btn dragBtn"></span>
					<span class="fix-tips fixTips slidetounlock">请按住滑块，拖动到最右边</span>
					<span class="verify-msg sucMsg">验证通过</span>
				</div>
				<div class="container-login100-form-btn">
					<button class="login100-form-btn" type="submit" id="submit">
						登  录
					</button>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>