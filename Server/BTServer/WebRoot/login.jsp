<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>系统登录</title>
    <meta http-equiv="X-UA-Compatible" content="IE=7,IE=8,IE=9" />
    <link rel="stylesheet" href="css/login1.css" type="text/css"></link>
  </head>
  
  <body>
	<div id="login_bg">  	
    </div>
    <div id="login_bg1">  
    	<s:actionerror cssStyle="color:red; margin-bottom:0px; list-style:none;position:absolute; left:50%; top:42%;"/>
    	<div id="login_content">
 		<form style="height:120px;" name="form" method="post" action="loginAction">			
				<ul>
					<li>
						<label id="loginTxt" class="loginTxt">学　号：</label>
						<s:textfield id="stu_id" name="stu_id" cssClass="inputTxt"/>						
					 </li>    
					 <li>
						<label class="loginTxt">密　码：</label>
						<s:password id="password" name="password" cssClass="inputTxt"/>						
					 </li>
					 <li class="loginBtn">
					 <input class="submit" type="submit" value=""/>
					 <input class="reset" type="reset" value="" />
					 </li> 
				</ul>
			</form>
        </div>
    </div>
</body>

</html>
