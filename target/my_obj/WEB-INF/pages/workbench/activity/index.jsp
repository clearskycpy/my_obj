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
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />


<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<%--	分页插件js--%>
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
	//	创建按钮添加单击事件
		$("#createActivity").click(function () {
			// 清空表单
			$("#createActivityFrom").get(0).reset();

		//   弹出模态窗口
			$("#createActivityModal").modal("show");

		});

	// 给保存按钮添加单击事件
		$("#saveActivityBtn").click(function () {
			//  收集参数
			var marketActivityOwner = $("#create-marketActivityOwner").val();
			var name = $.trim($("#create-marketActivityName").val());
			var startDate =  $("#create-startTime").val();
			var endDate = $("#create-endTime").val();
			var cost = $("#create-cost").val();
			var description = $.trim($("#create-description").val());
		//	表单验证
			if(marketActivityOwner == ""){
				alert("所有者不能为空");
				return;
			}
			if (name == ""){
				alert("市场活动名称不能为空");
				return;
			}
			if (startDate != "" && endDate != ""){
			//	比较时间日期大小
				if( endDate < startDate ){ // 使用HashCode比较大小
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			/*正则表达式
			* 判断是否为正整数*/
		    var ints = /^(([1-9]\d*)|0)$/;
			if (!ints.test(cost)){
				alert("成本不是非负整数");
				return;
			}
		//	说明符合
			$.ajax({
				url : "workbench/activity/saveCreateActivity.do",
				data : {
					owner : marketActivityOwner,
					name : name,
					startDate : startDate,
					endDate : endDate,
					cost : cost,
					description : description
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					if(data.code == "1"){
						// 保存成功，关闭模态窗口
						$("#createActivityModal").modal("hide");
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
					//	刷新页面

					}else {
						alert(data.message);
					//	模态窗口不关闭
						$("#createActivityModal").modal("show");
					}
				}
			});
		});

	//	调用工具函数
		$(".myDate").datetimepicker({
			language : 'zh-CN',   //选择的语言
			format : 'yyyy-mm-dd',  // 日期的格式
			minView : 'month',  // 精确选择到哪一位
			initialDate : new Date(),  // 默认选择的日期
			autoclose : true, // 选完了之后自动关闭
			todayBtn : true,  // 存在今天选项
			clearBtn : true  // 存在清空选项
		});

	//	当市场活动页面加载完成，查询所有数据的第一页以及总记录条数,默认每页显示十条
		queryActivityByConditionForPage(1,5);

	//	给查询按钮添单击事件
		$("#selectBut").click(function () {
		//	查询符合条件的条件的记录总条数
			queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));//rowsPerPage
		});

	//	给全选按钮添加单击事件
		$("#cheAll").click(function () {
			/*if(this.checked()){
				$("#tB input[type='checkbox']").prop("checked",true);
			}else {
				$("#tB input[type='checkbox']").prop("checked",false);
			}*/
			$("#tB input[type='checkbox']").prop("checked",this.checked);
		});

		/*$("#tB input[type='checkbox']").click(function () {
			//如果列表中的checkbox都选中了，那么就让全选按钮也选中
			if($("#tB input[type='checkbox']").size() == $("#tB input[type='checkbox']:checked").size()){
				$("#cheAll").prop("checked",true);
			}else {
				$("#cheAll").prop("checked",false);
			}
		});*/
	//给变化的元素添加事件，因为这个列表是Ajax 返回过来的所以是变化的
		$("#tB").on("click","input[type='checkbox']",function () {
			if($("#tB input[type='checkbox']").size() == $("#tB input[type='checkbox']:checked").size()){
				$("#cheAll").prop("checked",true);
			}else {
				$("#cheAll").prop("checked",false);
			}
		});

	// 给删除按钮添加单击事件
		$("#deleteActivityByIdsBut").click(function () {
			var checkedIds = $("#tB input[type='checkbox']:checked");
			if (checkedIds.size() == 0 ){
				alert("还未选择市场活动");
				return;
			}
			if (window.confirm("确定要删除吗？")) {
				var id = "";
				$.each(checkedIds,function () {
					id += "id=" + this.value +"&";
				});
				// 去掉最后一个&
				id.substring(0,id.length-1);
				//	发送请求
				$.ajax({
					url : 'workbench/activity/deleteActivityByIds.do',
					data : id,
					type : 'post',
					dataType : 'json',
					success : function (data){
						if (data.code == "1"){
							alert("删除成功")
							queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
						}else {
							alert(data.message);
						}
					}
				});
			}
		});

	// 给修改按钮添加单击事件
		$("#editActivityBtn").click(function () {
		//	收集参数
			var checkedIds = $("#tB input[type='checkbox']:checked");
			if(checkedIds.size() == 0){
				alert("还未选择")
				return;
			}
			if (checkedIds.size() > 1){
				alert("不能同时选中多个");
				return;
			}
			// 收集id
			var id = checkedIds[0].value;
		//	发送请求
			$.ajax({
				url : 'workbench/activity/queryActivityById.do',
				data : {
					id : id
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					$("#edit-id").val(data.id);
					// 把信息添加到模态窗口上
					$("#edit-marketActivityOwner").val(data.owner);

					$("#edit-marketActivityName").val(data.name);

					$("#edit-startTime").val(data.startDate);

					$("#edit-endTime").val(data.endDate);

					$("#edit-cost").val(data.cost);

					$("#edit-description").val(data.description);

				//	弹出模态窗口
					$("#editActivityModal").modal("show");

					$("#edit-startTime").datetimepicker({
						language : 'zh-CN',   //选择的语言
						format : 'yyyy-mm-dd',  // 日期的格式
						minView : 'month',  // 精确选择到哪一位
						initialDate : new Date(),  // 默认选择的日期
						autoclose : true, // 选完了之后自动关闭
						todayBtn : true,  // 存在今天选项
						clearBtn : true  // 存在清空选项
					});
					$("#edit-endTime").datetimepicker({
						language : 'zh-CN',   //选择的语言
						format : 'yyyy-mm-dd',  // 日期的格式
						minView : 'month',  // 精确选择到哪一位
						initialDate : new Date(),  // 默认选择的日期
						autoclose : true, // 选完了之后自动关闭
						todayBtn : true,  // 存在今天选项
						clearBtn : true  // 存在清空选项
					});
				}
			});
		});

	//	修改提交按钮添加单击事件
		$("#updateActivity").click(function () {
			// 收集参数   。。。。 还未修改id属性
			var marketActivityOwner = $("#edit-marketActivityOwner").val();
			var name = $.trim($("#edit-marketActivityName").val());
			var startDate =  $("#edit-startTime").val();
			var endDate = $("#edit-endTime").val();
			var cost = $("#edit-cost").val();
			var description = $.trim($("#edit-description").val());
		//	id
			var id = $("#edit-id").val();

			//	表单验证
			if(marketActivityOwner == ""){
				alert("所有者不能为空");
				return;
			}
			if (name == ""){
				alert("市场活动名称不能为空");
				return;
			}
			if (startDate != "" && endDate != ""){
				//	比较时间日期大小
				if( endDate < startDate ){ // 使用HashCode比较大小
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			/*正则表达式
			* 判断是否为正整数*/
			var ints = /^(([1-9]\d*)|0)$/;
			if (!ints.test(cost)){
				alert("成本不是非负整数");
				return;
			}

		//	发送异步请求
			$.ajax({
				url : 'workbench/activity/updateActivityById.do',
				data : {
					owner : marketActivityOwner,
					name : name,
					startDate : startDate,
					endDate : endDate,
					cost : cost,
					description : description,
					id : id
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					if(data.code == "1"){
						// 保存成功，关闭模态窗口
						$("#editActivityModal").modal("hide");
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption','currentPage'),$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
						return;
						//	刷新页面

					}else {
						alert(data.message);
						//	模态窗口不关闭
						$("#editActivityModal").modal("show");
					}
				}
			});
		});

	//	导出数据,添加单击事件
		$("#exportActivityAllBtn").click(function () {
			// 发送同步请求
			window.location.href="workbench/activity/exportAllActivities.do";
		});
	//	选择导出市场活动
		$("#exportActivityXzBtn").click(function () {
			var checkedIds = $("#tB input[type='checkbox']:checked");
			if (checkedIds.size() == 0 ){
				alert("还未选择市场活动");
				return;
			}
				var id = "workbench/activity/exportActivitiesByIds.do?";
				$.each(checkedIds,function () {
					id += "id=" + this.value +"&";
				});
				id = id.substr(0,id.length-1);

				//	发送请求
			window.location.href=id
		});

		$("#importActivityBtn").click(function () {
		//	判断文件是否合法
			var fileName = $("#activityFile").val(); // 获取文件名
		//	验证是否是Excel文件
			var fileNext = fileName.substring(fileName.lastIndexOf("."),fileName.length);

			if (fileNext != ".xls"){
				alert("只支持Excel文件(.xls)")
				return;
			}
			var file = $("#activityFile")[0].files[0];
		//	验证文件大小
			if (file.size > 1024*1024*5){
				alert("文件不能超过5MB");
				return;
			}
		//	完成验证，发送请求
			var formData = new FormData();
			formData.append("activityFile",file);
			$.ajax({
				url : 'workbench/activity/activityFileUpload.do',
				data : formData,
				processData : false, // 设置Ajax是否提交参数之前，把参数同意转换为字符串发送给后端（ 因为是文件，所以不能转）
				contentType : false, // 设置Ajax提交参数之前是否将参数统一按照urlencoded的编码格式 true是 false 不是
				type : 'post',
				dataType : 'json',
				success : function (data) {
					if(data.code == "1"){
						alert(data.message);
						// 导入成功，关闭模态窗口
						$("#importActivityModal").modal("hide");
						//	刷新页面
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption','currentPage'),$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
						return;

					}else {
						alert(data.message);
						//	模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});
		});

	});
	function queryActivityByConditionForPage(pageNo,pageSize) {
		//	收集参数
		//	收集参数
		var name = $("#query-name").val();
		var owner = $("#query-owner").val();
		var startDate = $("#query-startDate").val();
		var endDate = $("#query-endDate").val();
		// var  = 1;
		// var  = 10;
		$.ajax({
			url : "workbench/activity/queryActivityByConditionForPage.do",
			data : {
				name: name,
				owner: owner,
				startDate: startDate,
				endDate: endDate,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: 'post',
			dataType: 'json',
			success:function (data){
				// 将查询出来的记录的总条数显示到页面上
				//$("#totalRows").text(data.totalRows)
				//	遍历list
				var htmlStr = "";
				$.each(data.activityList,function (index,obj){
					htmlStr += "<tr class=\"active\">";
					htmlStr += "<td><input type=\"checkbox\" value='"+obj.id+"'/></td>";
					htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"';\">"+obj.name+"</a></td>";
					htmlStr += "<td>"+obj.owner+"</td>";
					htmlStr += "<td>"+obj.startDate+"</td>";
					htmlStr += "<td>"+obj.endDate+"</td>";
					htmlStr += "</tr>";
				});
				$("#tB").html(htmlStr);

				// 调用工具函数
				$("#tB").prop("checked",false);
				var totalPages = 1;
				if(data.totalRows%pageSize == 0){
					totalPages = data.totalRows/pageSize;
				}else {
					totalPages = parseInt(data.totalRows/pageSize)+1;
				}

				$("#demo_pag1").bs_pagination({
					currentPage:pageNo, // 当前页号，相当于pageNo
					rowsPerPage:pageSize, //每页显示条数，相当于
					totalRows:data.totalRows,  // 最大条数
					totalPages:totalPages,  // 总页数

					visiblePageLinks: 5, // 最多可以显示的卡片数量
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					onChangePage: function (event,pageObj) {
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				})
			}
		});
	}
	
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityFrom" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
								  <C:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </C:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本(万元)</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveActivityBtn" >保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<C:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</C:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="1976-10-10" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateActivity">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="selectBut">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" id="createActivity"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityByIdsBut"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="cheAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tB"></tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>



			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows">50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>