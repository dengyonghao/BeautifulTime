//检查email邮箱
function isEmail(str) {
	var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
	
}

//检查是否为中文
function isChn(str) {
	var reg = /(^[\u4e00-\u9fa5]*$)/; 
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}

//检查是否为整数
function isInteger(str){
	var reg = /^[-]{0,1}[0-9]{1,}$/;
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}

//验证字符串是否为空
function isNull( str ){
	if ( str == "" ) return true;
	var regu = "^[ ]+$";
	var re = new RegExp(regu);
	if (re.test(str)) {
		return true;
	}else{
		return false;
	}
}

//限制输入的只能是数字
function isNumber(str){
	 if(!str) return false;
	  var strP=/^\d+(\.\d+)?$/;
	  if(!strP.test(str))
		  return false;
	  if(str<0||str>100) return false;
	  try{
		  if(parseFloat(str)!=str) return false;
	  }catch(ex){
		  return false;
	 }  
	 return true; 
}

//地址验证
function isAddress(str){
	var reg = /(^[\u4e00-\u9fa5]*[0-9a-zA-Z]*([\u4e00-\u9fa5]|[0-9a-zA-Z])*$)/; 
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}
//money验证
function isMoney(str){
	var reg =/^-?\d+(\.\d{0,2})?$/; 
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}
//校验普通电话、传真号码：可以“+”开头，除数字外，可含有“-”
function isFax(str)
{
//国家代码(2到3位)-区号(2到3位)-电话号码(7到8位)-分机号(3位)"
 var reg =/^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
 //var pattern =/(^[0-9]{3,4}\-[0-9]{7,8}$)|(^[0-9]{7,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/; 
 if (reg.test(str)) {
		return true;
 }else{
		return false;
 }
}