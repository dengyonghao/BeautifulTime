package com.order.student.control;


import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;
import org.apache.struts2.dispatcher.ServletActionRedirectResult;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.order.student.model.Books;
import com.order.student.model.Orders;
import com.order.student.model.Users;
import com.order.student.service.BookService;
import com.order.student.service.OrderService;
import com.order.student.service.StudentService;
import com.sun.org.apache.xerces.internal.util.URI;

@SuppressWarnings("serial")
public class StudentAction extends ActionSupport {
	
	
	private StudentService studentService;
	private BookService bookService;
	private OrderService orderService;
	private String result;
	private String file;
	
	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public OrderService getOrderService() {
		return orderService;
	}

	public void setOrderService(OrderService orderService) {
		this.orderService = orderService;
	}

	private Users users;
	private Books books;

	public Books getBooks() {
		return books;
	}

	public void setBooks(Books books) {
		this.books = books;
	}

	private String stu_id;
	private String password;
	private String sids;
	


	public String getSids() {
		return sids;
	}

	public void setSids(String sids) {
		this.sids = sids;
	}

	public String login(){
		
		Map<String, Object> session = ActionContext.getContext().getSession();
		//发送信息
//		HttpServletResponse response = ServletActionContext.getResponse();
//		response.setContentType("text/html");
//        try {
//			PrintWriter out = response.getWriter();
//			out.println("<?xml version='1.0' encoding='utf-8'?>"+"<name>888888888</name>");
//	        out.flush();
//	        out.close();
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		//下载文件
//		try {
//            // path是指欲下载的文件的路径。
//			String path = ServletActionContext.getServletContext().getRealPath("/") + "4.ai";
//            File file = new File(path);
//            // 取得文件名。
//            String filename = file.getName();
//            // 取得文件的后缀名。
//            String ext = filename.substring(filename.lastIndexOf(".") + 1).toUpperCase();
//
//            // 以流的形式下载文件。
//            InputStream fis = new BufferedInputStream(new FileInputStream(path));
//            byte[] buffer = new byte[(int) file.length()];
//            System.out.println("-------------" + buffer.length);
//            fis.read(buffer);
//            fis.close();
//            // 清空response
//            HttpServletResponse response = ServletActionContext.getResponse();
//            response.reset();
//            // 设置response的Header
//            response.addHeader("Content-Disposition", "attachment;filename=" + new String(filename.getBytes()));
//            response.addHeader("Content-Length", "" + file.length());
//            OutputStream toClient = new BufferedOutputStream(response.getOutputStream());
//            response.setContentType("application/octet-stream");
//            toClient.write(buffer);
//            toClient.flush();
//            toClient.close();
//        } catch (IOException ex) {
//            ex.printStackTrace();
//        }
		
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("image/png");
		ActionContext.getContext();
		System.out.println("++++++++++++" + ActionContext.getContext());
        PrintWriter writer;
		try {
		writer = response.getWriter(); 
//        HttpServletRequest request = ServletActionContext.getRequest();
        HttpServletRequest request = (HttpServletRequest)
        		ActionContext.getContext().get(org.apache.struts2.StrutsStatics.HTTP_REQUEST);
        
      //获取请求文本字节长度
        int formDataLength = request.getContentLength();
        //取得ServletInputStream输入流对象
        DataInputStream dataStream = new DataInputStream(request.getInputStream());
        byte body[] = new byte[formDataLength];
        int totalBytes = 0;
        while (totalBytes < formDataLength) {
            int bytes = dataStream.read(body, totalBytes, formDataLength);
            totalBytes += bytes;
        }
        String textBody = new String(body, "ISO-8859-1");
        System.out.println("||||||||||||-------" + textBody);
        
        
        InputStream in = request.getInputStream();
        System.out.println("******************" + request.getContentLength());
        String path = ServletActionContext.getServletContext().getRealPath("/");
        File f = new File(path + "file.png");

        FileOutputStream fout = new FileOutputStream(f);
        byte[] b=new byte[1024];
        System.out.println("-------------" + in.read(b));
        int n = 0;
        while ((n = in.read(b)) != -1){
            fout.write(b,0,n);
        }
        fout.close();
        in.close();
        System.out.println("@@@@@@@@@@@@@@@@@@@@@@@@@@@" + getFile());
        result = SUCCESS;
        System.out.println("Finished uploading files!");
        writer.println("Finished uploading files!");
        writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(studentService.findBySidPwd(getStu_id(), getPassword())){
			session.put("longinUser", studentService.findBySid(getStu_id()));
			return SUCCESS;
		}else{
			return "input";
		}
	}
	
	
	public String loginout(){
		
		Map<String, Object> session = ActionContext.getContext().getSession();
		session.clear();
		
		return SUCCESS;
	}
	
	public String bookList(){
		
		Map<String, Object> session = ActionContext.getContext().getSession();
		
		List<Books> bList = bookService.findAllBooks();
		
		session.put("bookList", bList);
		return SUCCESS;
	}
	
	public String addorder(){
		
		Map<String, Object> session = ActionContext.getContext().getSession();
		Users stu = (Users)session.get("longinUser");
		
		List<Orders> oList = orderService.findBySid(stu.getStu_id());
		for(Orders o : oList){
			orderService.deleteOrder(o);
		}
		List<Books> ownBook = new ArrayList<Books>();
		
		String[] ss = getSids().split(",") ;
	    for (int i = 0; i < ss.length; i++) {
	    	Orders order = new Orders();
	        order.setBook_id(ss[i]);
	        order.setStu_id(stu.getStu_id());
	        ownBook.add(bookService.findById(ss[i]));
	        orderService.saveOrder(order);
	    }
	    
	    session.put("ownBook", ownBook);
		return SUCCESS;
	}
	
	public String vieworder(){
		
		Map<String, Object> session = ActionContext.getContext().getSession();
		Users stu = (Users)session.get("longinUser");
		
	
		List<Orders> ownOrder = orderService.findBySid(stu.getStu_id());
		List<Books> ownBook = new ArrayList<Books>();
		
		for(Orders o : ownOrder){
			Books book = new Books();
			book = bookService.findById(o.getBook_id());
			ownBook.add(book);
		}
	    
	    session.put("ownBook", ownBook);
		return SUCCESS;
	}
	
	public Users getUsers() {
		return users;
	}
	public void setUsers(Users users) {
		this.users = users;
	}
	
	public StudentService getStudentService() {
		return studentService;
	}


	public void setStudentService(StudentService studentService) {
		this.studentService = studentService;
	}
	
	public String getStu_id() {
		return stu_id;
	}


	public void setStu_id(String stu_id) {
		this.stu_id = stu_id;
	}

	public String getPassword() {
		return password;
	}


	public void setPassword(String password) {
		this.password = password;
	}

	public BookService getBookService() {
		return bookService;
	}

	public void setBookService(BookService bookService) {
		this.bookService = bookService;
	}


	
}
