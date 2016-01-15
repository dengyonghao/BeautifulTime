package com.order.student.service.impl;

import com.order.student.dao.StudentDAO;
import com.order.student.model.Users;
import com.order.student.service.StudentService;

public class StudentServiceImpl implements StudentService {

	StudentDAO studentDAO;
	
	
	
	@Override
	public boolean findBySidPwd(String stu_id, String password) {
		// TODO Auto-generated method stub
		return studentDAO.findBySidPwd(stu_id, password);
	}
	
	
	public StudentDAO getStudentDAO() {
		return studentDAO;
	}
	public void setStudentDAO(StudentDAO studentDAO) {
		this.studentDAO = studentDAO;
	}


	@Override
	public Users findBySid(String stu_id) {
		// TODO Auto-generated method stub
		return studentDAO.findBySid(stu_id);
	}
}
