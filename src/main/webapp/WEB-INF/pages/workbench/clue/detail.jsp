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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});


		$("#remarkDivList").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		});

		$("#remarkDivList").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		});

		$("#remarkDivList").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		});

		$("#remarkDivList").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});



		//  创建备注
		$("#saveCreateClueRemark").click(function () {
			//收集参数
			var noteContent = $.trim($("#remark").val());
			//表单验证
			var clueId = '${clue.id}';
			if (noteContent == ""){
				alert("数据不能为空");
				return;
			}
			$.ajax({
				url : 'workbench/clue/saveClueRemark.do',
				data : {
					clueId : clueId,
					noteContent : noteContent
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					if(data.code == "1"){
						// alert(data.message);
						$("#remark").val("");
						// 导入成功，关闭模态窗口
						//	刷新页面
						var htmlStr = "";
						htmlStr += "<div id=\"div_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">";
						htmlStr += "<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
						htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
						htmlStr += "<h5 id=\"h5_"+data.retData.id+"\">"+data.retData.noteContent +"</h5>";
						htmlStr += "<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\">"+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>";
						htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
						htmlStr += "<a class=\"myHref\" name=\"update\"remarkId=\""+data.retData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
						htmlStr += "<a class=\"myHref\" name=\"delete\"remarkId=\""+data.retData.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
						htmlStr += "</div>";
						htmlStr += "</div>";
						htmlStr += "</div>";
						$("#remarkDiv").before(htmlStr)
						return;
					}else {
						alert(data.message);
					}
				}
			});
		});

	//	给删除按钮添加单机事件
		$("#remarkDivList").on("click","a[name='delete']",function () {
			//收集参数
			var id = $(this).attr("remarkId");
			// 发送请求
			$.ajax({
				url : 'workbench/clue/deleteClueRemarkById.do',
				data : {
					id : id
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					if(data.code == "1"){
						// 删除成功
						//	刷新页面
						$("#div_"+id).remove();
					}else {
						alert(data.message);
						//	模态窗口不关闭
					}
				}
			});
		});

		//	给所有的市场活动备注添加单机事件
		$("#remarkDivList").on("click","a[name='update']",function () {
			//	获取id和备注内容
			var id =$(this).attr("remarkId");
			var noteContent = $("#div_"+id+" h5").text();
			//	把值写到修改备注的模态窗口
			$("#edit-id").val(id);
			$("#noteContent").val(noteContent);
			//	弹出模态窗口
			$("#editRemarkModal").modal("show");
		});

		//	点击模态窗口的更新按钮
		$("#updateRemarkBtn").click(function () {
			//	收集参数
			var id = $("#edit-id").val();
			var noteContent = $.trim($("#noteContent").val());
			//	表单验证
			if (noteContent == ""){
				alert("备注为空！");
				return;
			}

			//	发送请求
			$.ajax({
				url : 'workbench/activity/saveEditClueRemark.do',
				data : {
					noteContent : noteContent,
					id : id
				},
				type : 'post',
				dataType : 'json',
				success : function (data) {
					if(data.code == "1"){
						// 保存成功，关闭模态窗口
						$("#editRemarkModal").modal("hide");
						$("#div_"+data.retData.id+" h5").text(data.retData.noteContent);
						$("#div_"+data.retData.id+" small").text(" "+data.retData.editTime+" 由${sessionScope.sessionUser.name} 修改");
						return;
						//	刷新页面
					}else {
						alert(data.message);
						//	模态窗口不关闭
						$("#editRemarkModal").modal("show");
					}
				}
			});
		});
		//给添加市场活动关联添加单击事件
		$("#saveActivityForClue").click(function () {
			$("#searchActivityText").val("");
			$("tB").html("");
		//	弹出关联市场活动的模态窗口
			$("#bundModal").modal("show");
		});

	//	给搜索框添加键盘弹起事件
		$("#searchActivityText").keyup(function () {
			var activityName = this.value;
			var id ='${clue.id}';
			if (activityName == ""){
				return;
			}
			$.ajax({
				url : 'workbench/clue/queryActivityByNameAndClueId.do',
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
						htmlStr += "<td><input type=\"checkbox\" value='"+obj.id+"'/></td>";
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

	// 选择完了需要关联的市场活动进行关联
		$("#saveBund").click(function () {
			// 获取列表中所有被选中的checbox
			var checkedIds = $("#tB input[type='checkbox']:checked");
			if (checkedIds.size() == 0 ){
				alert("还未选择市场活动");
				return;
			}
			if (window.confirm("确定要关联吗？")) {
				var id = "";
				$.each(checkedIds,function () {
					id += "activityId=" + this.value +"&";
				});
				// 去掉最后一个&
				// id.substring(0,id.length-1);

				id += "clueId=${clue.id}";
				//	发送请求
				$.ajax({
					url : 'workbench/activity/saveBund.do',
					data : id,
					type : 'post',
					dataType : 'json',
					success : function (data){
						if (data.code == "1"){
						//	说明关联成功
						$("#bundModal").modal("hide");
						//	刷新关联列表
						var htmlStr = "";
						$.each(data.retData,function (index,obj) {
							htmlStr += "<tr \"tr_"+obj.id+"\">";
							htmlStr += "<td>"+obj.name+"</td>";
							htmlStr += "<td>"+obj.startDate+"</td>";
							htmlStr += "<td>"+obj.endDate+"</td>";
							htmlStr += "<td>"+obj.owner+"</td>";
							htmlStr += "<td><a activityId=\""+obj.id+"\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
							htmlStr += "</tr>";
						});
							$("#tB2").append(htmlStr);
						}else {
							alert(data.message);
							$("#bundModal").modal("show");
						}
					}
				});
			}
		});

		$("#tB2").on("click","a",function () {
			//收集参数
			var activityId = $(this).attr("activityId");
			var clueId = "${clue.id}"
			// 发送请求
			if (window.confirm("确定要删除吗？")) {
				$.ajax({
					url: 'workbench/clue/deleteClueActivityRelation.do',
					data: {
						clueId: clueId,
						activityId: activityId
					},
					type: 'post',
					dataType: 'json',
					success: function (data) {
						if (data.code == "1") {
							// 删除成功
							//	刷新页面
							$("#tr_" + activityId).remove();
						} else {
							alert(data.message);
							//	模态窗口不关闭
						}
					}
				});
			}
		});



	});
	
</script>

</head>
<body>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改线索备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="searchActivityText" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tB">

							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBund">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.location.href='workbench/clue/index.do?id=${clue.id}'"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/toConvert.do?clueId=${clue.id}'"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editBy}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkDivList" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<C:forEach items="${clueRemarkList}" var="clueRemark">
			<div id=div_${clueRemark.id} class="remarkDiv" style="height: 60px;">
				<img title="${clueRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${clueRemark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${clueRemark.editFlag=='1'?clueRemark.editTime:clueRemark.createTime} 由${clueRemark.editFlag=='1'?clueRemark.editBy:clueRemark.createBy}${clueRemark.editFlag=='1'?'修改':'创建'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="update" remarkId="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="delete" remarkId="${clueRemark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</C:forEach>

		<%--<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueRemark">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tB2">
					<C:forEach items="${activityList}" var="activity">
						<tr id="tr_${activity.id}">
							<td>${activity.name}</td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a activityId="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</C:forEach>
						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" id="saveActivityForClue" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>