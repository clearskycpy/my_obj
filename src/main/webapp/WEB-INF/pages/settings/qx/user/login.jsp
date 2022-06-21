<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function () {
		// 给整个窗口加上键盘按下的事件
		$(window).keydown(function (e){
			// js  如果按的是回车键 提交登录请求
			if(e.keyCode == 13){
				// 发送请求
				$("#loginBtn").click();
			}
		});
		// 给登录按钮添加单击事件
		$("#loginBtn").click(function () {
		//	收集参数
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			var idRemPwd = $("#idRemPwd").prop("checked");
		//	表单验证
			if (loginAct == "" ){
				alert("用户名不能为空");
				return;
			}
			if(loginPwd == ""){
				alert("密码不能为空");
				return;
			}
			// 显示正在验证

		//	发送请求
			$.ajax({
				// 这里是单独拼接 没有用到页面上定义的basePath 所以需要加上 crm
				url: '/crm/settings/qx/user/login.do',
				data: {
					loginAct: loginAct,
					loginPwd: loginPwd,
					idRemPwd: idRemPwd
				},
				type: 'POST',
				dataType: 'json',
				success: function (data) {
					if (data.code == '1') {
						// 跳转业务主页面  不能直接跳转
						window.location.href = "workbench/index.do"; //
					} else {
						$("#msg").html(data.message);
					}
				},
				beforeSend:function () {
					// 在ajax发送请求之前会执行这个函数 如果发送了请求就返回true 没发送就返回false
					$("#msg").html("验证...");
					return true;
				}
			});

		});
	});
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2022&nbsp;cpy</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input type="checkbox" id="idRemPwd" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct and empty cookie.loginPwd}">
								<input type="checkbox" id="idRemPwd">
							</c:if>
							 十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg" style="border: 1px solid pink;"></span>
					</div>
<%--					改变成button 可以发送异步请求 如果 密码错误当前页面不发生变化--%>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;color: pink">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>