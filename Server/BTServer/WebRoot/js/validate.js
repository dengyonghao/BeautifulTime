//���email����
function isEmail(str) {
	var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
	
}

//����Ƿ�Ϊ����
function isChn(str) {
	var reg = /(^[\u4e00-\u9fa5]*$)/; 
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}

//����Ƿ�Ϊ����
function isInteger(str){
	var reg = /^[-]{0,1}[0-9]{1,}$/;
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}

//��֤�ַ����Ƿ�Ϊ��
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

//���������ֻ��������
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

//��ַ��֤
function isAddress(str){
	var reg = /(^[\u4e00-\u9fa5]*[0-9a-zA-Z]*([\u4e00-\u9fa5]|[0-9a-zA-Z])*$)/; 
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}
//money��֤
function isMoney(str){
	var reg =/^-?\d+(\.\d{0,2})?$/; 
	if (reg.test(str)) {
		return true;
	}else{
		return false;
	}
}
//У����ͨ�绰��������룺���ԡ�+����ͷ���������⣬�ɺ��С�-��
function isFax(str)
{
//���Ҵ���(2��3λ)-����(2��3λ)-�绰����(7��8λ)-�ֻ���(3λ)"
 var reg =/^(([0\+]\d{2,3}-)?(0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
 //var pattern =/(^[0-9]{3,4}\-[0-9]{7,8}$)|(^[0-9]{7,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/; 
 if (reg.test(str)) {
		return true;
 }else{
		return false;
 }
}