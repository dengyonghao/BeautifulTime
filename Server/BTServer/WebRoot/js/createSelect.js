var arrayEthnic=new Array(  
    '','����','�ɹ���','����','����','��������',    
    '���','������','������','������','ŭ��','������',       
    '���״���','����','׳��','����','����','��ɽ��',       
    '������','Ǽ��','������','���α����','ԣ����','������',      
    '����','������','����','����','������','�¶�������','������',      
    '������','����˹��','����','�Ű���','ά�����','������',    
    '������','������','ˮ��','����','������','������','���¿���',    
    '��������','�����','����','����','������','����','������',     
    '���Ӷ���','ë����','��������','�°���','������','��ŵ��'); 
/** *��������ѡ��� */   
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
	//��ʼ�������б�   ����������� 
	document.getElementById('employedrankname').length = 0;
	//����һ��ֵ   
	document.getElementById('employedrankname').options[0] = new Option('', '');
	for(var i=1;i<=43;i++){
		if(obj.employedRankMap[i].indexOf("��ʦ") > 0 || obj.employedRankMap[i].indexOf("��ʦ") == 0){
			subcat[i] = new Array('��ʦ', obj.employedRankMap[i], i);
			//alert(subcat[i]);
		}else if(obj.employedRankMap[i].indexOf("�̸�") > 0 || obj.employedRankMap[i].indexOf("�̸�") == 0){
		 	subcat[i] = new Array('�̸�', obj.employedRankMap[i], i);
		 	//alert(subcat[i]);
		}else if(obj.employedRankMap[i].indexOf("����") > 0 || obj.employedRankMap[i].indexOf("����") == 0){
			subcat[i] = new Array('����', obj.employedRankMap[i], i);
			//alert(subcat[i]);
		}
	}
	var i;
	if(locationid.indexOf("��ʦ") > 0 || locationid.indexOf("��ʦ") == 0){
		i=1;
	}else if(locationid.indexOf("�̸�") > 0 || locationid.indexOf("�̸�") == 0){
		i=16;
	}else{
	    i=29;
	}
	//alert(i);
    	for (i; i < subcat.length; i++)     
		{
			if (subcat[i][0] == locationid) //[0][1]   ��һ��   �ڶ���       
			{
				document.getElementById('employedrankname').options[document
						.getElementById('employedrankname').length] = new Option(
						subcat[i][1], subcat[i][2]);
			}      
		}
	}
