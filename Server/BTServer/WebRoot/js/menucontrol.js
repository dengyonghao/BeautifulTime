  		function loadLeft(subSysName)
  		{
  			alert("hello");
  			if(subSysName=="administration")
  			{
  				alert(self.parent.document.frames["left"].id);
  				self.parent.document.frames["left"].src="left.jsp";
  			
  				//self.parent.getElementById("left").src="left.jsp";
  			}else if(subSysName=="studentAffair")
  			{
  				alert(self.parent.document.frames["left"].id);
  				
  				self.parent.document.frames["left"].src="left2.jsp";
  			}else if(subSysName=="assessment")
  			{
  				alert(self.parent.document.frames["left"].id);
  				self.parent.document.frames["left"].src="left3.jsp";
  			}
  				
  		}