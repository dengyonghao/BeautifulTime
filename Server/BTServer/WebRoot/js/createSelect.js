var arrayEthnic=new Array(  
    '','汉族','蒙古族','彝族','侗族','哈萨克族',    
    '畲族','纳西族','仫佬族','仡佬族','怒族','保安族',       
    '鄂伦春族','回族','壮族','瑶族','傣族','高山族',       
    '景颇族','羌族','锡伯族','乌孜别克族','裕固族','赫哲族',      
    '藏族','布依族','白族','黎族','拉祜族','柯尔克孜族','布朗族',      
    '阿昌族','俄罗斯族','京族','门巴族','维吾尔族','朝鲜族',    
    '土家族','傈僳族','水族','土族','撒拉族','普米族','鄂温克族',    
    '塔塔尔族','珞巴族','苗族','满族','哈尼族','佤族','东乡族',     
    '达斡尔族','毛南族','塔吉克族','德昂族','独龙族','基诺族'); 
/** *创建民族选择框 */   
function createEthnicSelect(name,str) {   
    document.write("<select class='inputTxt' id='ethnic' disabled='true'></select>");   
    var select=document.getElementById("ethnic");   
    for(var i=0;i<arrayEthnic.length;i=i+1) {    
        select.name=name;    
        var opt=document.createElement("option");    
        opt.value=arrayEthnic[i];    
        opt.innerText=arrayEthnic[i];    
        if(arrayEthnic[i]==str)   {    
            opt.selected="selected";    
        }     
        select.appendChild(opt);  
   }  
 }

function changeSelect(locationid) {
	var subcat = new Array();
	var employedRankMap0 = document.getElementById("employedRankMap").value;
	var obj = eval("(" + employedRankMap0 + ")");
	//初始化下拉列表   清空下拉数据 
	document.getElementById('employedrankname').length = 0;
	//给第一个值   
	document.getElementById('employedrankname').options[0] = new Option('', '');
	for(var i=1;i<=43;i++){
		if(obj.employedRankMap[i].indexOf("教师") > 0 || obj.employedRankMap[i].indexOf("教师") == 0){
			subcat[i] = new Array('教师', obj.employedRankMap[i], i);
			//alert(subcat[i]);
		}else if(obj.employedRankMap[i].indexOf("教辅") > 0 || obj.employedRankMap[i].indexOf("教辅") == 0){
		 	subcat[i] = new Array('教辅', obj.employedRankMap[i], i);
		 	//alert(subcat[i]);
		}else if(obj.employedRankMap[i].indexOf("管理") > 0 || obj.employedRankMap[i].indexOf("管理") == 0){
			subcat[i] = new Array('行政', obj.employedRankMap[i], i);
			//alert(subcat[i]);
		}
	}
	var i;
	if(locationid.indexOf("教师") > 0 || locationid.indexOf("教师") == 0){
		i=1;
	}else if(locationid.indexOf("教辅") > 0 || locationid.indexOf("教辅") == 0){
		i=16;
	}else{
	    i=29;
	}
	//alert(i);
    	for (i; i < subcat.length; i++)     
		{
			if (subcat[i][0] == locationid) //[0][1]   第一列   第二列       
			{
				document.getElementById('employedrankname').options[document
						.getElementById('employedrankname').length] = new Option(
						subcat[i][1], subcat[i][2]);
			}      
		}
	}
