<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sx" uri="/struts-dojo-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="/order/css/infoList.css" type="text/css"></link>
		<link rel="stylesheet" href="/order/css/weebox.css" type="text/css"></link>
		<script type="text/javascript" src="/order/js/jquery.js"></script>
		<script type="text/javascript" src="/order/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="/order/js/weebox.js"></script>
		<script type="text/javascript" src="/order/js/bgiframe.js"></script>
		<script type="text/javascript" src="/order/js/common.js"
			charset="gb2312"></script>
		<sx:head debug="true" extraLocales="en-us,nl-nl,de-de" />
		<script type="text/javascript">
			$(function() {
				/*var curPage = $("#currentPage").val();
				var pageTotal = $("#pageTotal").val();
				$("#firstBtn")
						.click(
								function() {
									location.href = "candidateListAction.action?currentPage=1";
								});
				$("#preBtn").click(
						function() {
							curPage--;
							location.href = "candidateListAction.action?currentPage=" + curPage;
						});
				$("#nextBtn").click(
						function() {
							curPage++;
							location.href = "candidateListAction.action?currentPage=" + curPage;
						});
				$("#lastBtn").click(
						function() {
								location.href = "candidateListAction.action?currentPage=" + pageTotal;
								
						});*/
						
				//添加按钮点击事件
				$("#doAdd").click(function() {
				
					var arr=document.getElementsByName("indexed");
					var s="";
					for(i=0;i<arr.length;i++){
 						if(arr[i].checked){
   							var a = arr[i].value;
   								s += a + ",";
  						}
					}
					location.href = "bookListAction.action";
				});
				
				//退出按钮点击事件
				$("#doOut").click(function() {
				
					location.href = "loginoutAction.action";
				});
			});
			
		
	</script>
	<style type="text/css">
	.STYLE11 { font-size: 20px; }
	</style>
	</head>
	<body>
		<div id="rightStyle">
			<input type="hidden" id="currentPage" name="currentPage"
				value="<s:property value="%{#session.currentPage}" />" />
			<input type="hidden" id="countTotal" name="countTotal" />
			<input type="hidden" id="pageSize" name="pageSize" value="10" />
			<input type="hidden" id="pageTotal" name="pageTotal"
				value="<s:property value="%{#session.pageTotal}" />" />
			<ul class="tableFrameBtn">
				<li style="width: 65%;">
					<font size="4px">欢迎你:<s:property value="%{#session.longinUser.stu_name}"></s:property>,以下为你所以订购教材的清单,如有错误,请返回修改.</font>
				</li>
			</ul>
			<ul class="tableFrameBtn">
			
			<li style="width: 33.5%; text-align: right;">
			
			<input type="button" class="inputBtn" id="doAdd" name="addBtn"
							value="返回修改" />
			<input type="button" class="inputBtn" id="doOut" name="update2Btn"
							value="退出系统" />
			
			</li>
			</ul>
			<div id="tableFrame">
				<ul id="tableFrameTitle">
					<li class="tableChoice" style="width: 4%;">
						
					</li>
					<li style="width: 30%;">
						教材编号
					</li>
					<li style="width: 32%;">
						教材名称
					</li>
					<li style="width: 32%;">
						教材价格
					</li>
					
				</ul>
				<div id="tblCase">
					<s:iterator value="%{#session.ownBook}">
						<ul ondblclick="doEdit('<s:property value="book_id"/>')">
							<li class="tableChoice">
								<input type="checkbox" id="indexed" name="indexed"
									value='<s:property value="book_id"/>' />
							</li>
							<li style="width: 30%">
								<s:property value="book_id"></s:property>
							</li>
							<li style="width: 32%">
								<s:property value="book_name"></s:property>
							</li>
							<li style="width: 32%">
								<s:property value="price"></s:property>
							</li>
						</ul>
					</s:iterator>
						
				</div>
				
				<ul class="tableFrameBtn">
					<li style="width: 58.5%; text-align: right;">
					</li>
					<li style="width: 41.5%; text-align: right;">
						第
						<s:property value="%{#session.currentPage}" />
						页/共
						<s:property value="%{#session.pageTotal}" />
						页
						<input type="button" class="pageBtn" id="firstBtn" value="首 页" />
						<input type="button" class="pageBtn" id="preBtn" value="上一页" />
						<input type="button" class="pageBtn" id="nextBtn" value="下一页" />
						<input type="button" class="pageBtn" id="lastBtn" value="尾 页" />
					</li>
				</ul>
			</div>
		</div>
	</body>
</html>