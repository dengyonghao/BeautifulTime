// ���б�ɫ
window.onload = function() {
	changeColor('tblCase');
}
function changeColor(id) {
	var arrayli = document.getElementById(id).getElementsByTagName('ul');
	var bool = true; // ������Ϊtrue
	var oldStyle; // ����ԭ����ʽ
	for (var i = 0; i < arrayli.length; i++) {
		// ���б�ɫ
		if (bool === true) {
			arrayli[i].id = "tableCase";
			arrayli[i].onmouseover = function() {
				this.setAttribute("id", "hoverColor");
			}
			arrayli[i].onmouseout = function() {
				this.setAttribute("id", "tableCase");
			}
			bool = false;
		} else {
			arrayli[i].id = "change";
			arrayli[i].onmouseover = function() {
				this.setAttribute("id", "hoverColor");
			}
			arrayli[i].onmouseout = function() {
				this.setAttribute("id", "change");
			}
			bool = true;
		}
	}
}

// ��ȡ�����б�ѡ�����ֵ
function getSelectedValue() {
	var allIndexed = document.all.indexed;
	for (var i = 0; i < allIndexed.length; i++) {
		// �ж������ѡ��
		if (allIndexed[i].checked == true) {
			// ���ѡ�е�checkbox��ֵ
			var obj = allIndexed[i].value;
			return obj;
		}
	}

}

function doCheckBox(iType) {
	// 1:ȫѡ;2:ȫ��ѡ;3:��ѡ;
	for (iIndex = 0; iIndex < document.all.length; iIndex++) {
		if (document.all(iIndex).type == "checkbox") {
			switch (iType) {
				case 1 :
					document.all(iIndex).checked = true;
					break;
				case 2 :
					document.all(iIndex).checked = false;
					break;
				case 3 : {
					if (document.all(iIndex).checked == true) {
						document.all(iIndex).checked = false;
					} else {
						document.all(iIndex).checked = true;
					}
				}
					break;
			}
		}
	}
}

// ҳ��һ�
function doChange() {
	var inputAll = document.getElementsByTagName('input');
	for (i = 0; i < inputAll.length; i++) {
		if(inputAll[i].type=="text"||inputAll[i].type=="file"){
			if (inputAll[i].disabled == true)
				inputAll[i].disabled = false;
			else if (inputAll[i].disabled == false)
				inputAll[i].disabled = true;
		}
	}
	//zzj-���
	var sex = document.getElementsByName("teacher.sex");
	for(i = 0; i <sex.length; i++){
		if(sex[i].disabled==true)
			sex[i].disabled=false;
		else if(rad[i].disabled==false)
			sex[i].disabled=true;
	}
	
	var uploadBtn = document.getElementsByName('uploadBtn');
	var resetBtn = document.getElementsByName('resetBtn');
	if (uploadBtn[0].disabled==true) {
		uploadBtn[0].disabled=false;
	}else  {
		
		uploadBtn[0].disabled=true;
	}
	if (resetBtn[0].disabled==true) {
		resetBtn[0].disabled=false;
	}else  {
		resetBtn[0].disabled=true;
	}
	
	var selectAll = document.getElementsByTagName('select');
	for (i = 0; i < selectAll.length; i++) {
		if (selectAll[i].disabled == true){
			selectAll[i].disabled = false;
		}else if (selectAll[i].disabled == false){
			selectAll[i].disabled = true;
		}
	}
//		var fileAll =document.getElementsByTagName('file');
//		for ( var int = 0; int < fileAll.length; int++) {
//			if (fileAll[i].disabled==true) {
//				fileAll[i].disabled=false;
//			}else if (fileAll[i].disabled==false) {
//				fileAll[i].disabled=true;
//			}
//		}
		
		var textarea = document.getElementsByTagName('');
		if (textarea[0].disabled==true) {
			textarea[0].disabled=false;
		}else if(textarea[0].disabled=false) {
			textarea[0].disabled=true;
		}
}

// ȡ���޸�
function doCancelChange(tid) {
	var result = confirm("ȷ��ȡ����ǰ��Ϣ���޸ģ�");
	if (result == true) {
		window.location.reload();
		//location=document.referrer;
		//window.location.href = "editTeacherAction.action?tid=" + tid + "";
	}
}