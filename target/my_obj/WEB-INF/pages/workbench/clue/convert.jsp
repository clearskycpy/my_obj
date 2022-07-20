<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
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


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$("#getActivity").click(function () {
			$("#searchActivityText").val("");
			$("#tB").html("");
			//	弹出关联市场活动的模态窗口
			$("#searchActivityModal").modal("show");
		});

		//	给搜索框添加键盘弹起事件
		$("#searchActivityText").keyup(function () {

			var activityName = this.value;
			var id ='${clue.id}';
			/*
			这里为了用户方便使用就不为空不查。可以呈现给用户看
			if (activityName == ""){
				return;
			}*/
			$.ajax({
				url : 'workbench/clue/queryActivityByNameAndClueIdExcuse.do',
				data : {
					id : id,
					activityName : activityName
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					// 遍历data（activityList） 遍历json类型的集合
					var htmlStr = "";
					$.each(data,function (index,obj) {
						htmlStr += "<tr>";
						htmlStr += "<td><input type=\"radio\" value='"+obj.id+"' activityName='"+obj.name+"'/></td>";
						htmlStr += "<td>"+obj.name+"</td>";
						htmlStr += "<td>"+obj.startDate+"</td>";
						htmlStr += "<td>"+obj.endDate+"</td>";
						htmlStr += "<td>"+obj.owner+"</td>";
						htmlStr += "</tr>";
					});
					$("#tB").html(htmlStr);
				}
			});
		});

	//	给市场活动的选择按钮添加单击事件,选择完了市场活动之后就把数据绑定到显示的input标签里面
		$("#tB").on("click","input[type='radio']",function () {
		//	获取被选择的按钮的市场活动和name
			var id = this.value;
			var activityName = $(this).attr("activityName");
			$("#activityName").val(activityName);
			$("#activityId").val(id);
		});

	//	给取消按钮添加单机事件
		$("#returnClue").click(function () {
			window.location.href="workbench/clue/detailClue.do?id=${clue.id}";
		});

		$("#convertBtn").click(function () {
			var clueId = '${clue.id}';
			var money = $.trim($("#amountOfMoney").val());
			var name = $.trim($("#tradeName").val());
			var stage = $("#stage").val();
			var activityId = $("#activityId").val();
			var isCreateTran = $("#isCreateTransaction").prop("checked");
			var expectedDate = $("#expectedClosingDate").val();

		//	表单验证
			var ints = /^(([1-9]\d*)|0)$/;
			if (!ints.test(money)){
				alert("金额不是非负整数");
				return;
			}
		//	发送请求

			$.ajax({
				url: 'workbench/clue/convertClue.do',
				data: {
					clueId: clueId,
					money: money,
					name: name,
					stage: stage,
					activityId: activityId,
					isCreateTran: isCreateTran,
					expectedDate: expectedDate
				},
				type: 'post',
				dataType: 'json',
				success : function (data) {
					if (data.code == "1"){
					//	跳转线索主页面
						window.location.href='workbench/clue/index.do'
					}else {
						alert(data.message);
					}

				}
			});


		});
		$("#expectedClosingDate").datetimepicker({
			language : 'zh-CN',   //选择的语言
			format : 'yyyy-mm-dd',  // 日期的格式
			minView : 'month',  // 精确选择到哪一位
			initialDate : new Date(),  // 默认选择的日期
			autoclose : true, // 选完了之后自动关闭
			todayBtn : true,  // 存在今天选项
			clearBtn : true  // 存在清空选项
		});
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivityText" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tB">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control" id="expectedClosingDate" readonly>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<C:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</C:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityName">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" id="getActivity" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="hidden" id="activityId">
		    <input type="text" class="form-control" id="activityName" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convertBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消" id="returnClue">
	</div>
</body>
</html>