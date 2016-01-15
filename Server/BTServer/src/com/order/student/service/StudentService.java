package com.order.student.service;

import com.order.student.model.Users;


public interface StudentService {
	public Users findBySid(String stu_id);
	public boolean findBySidPwd(String stu_id, String password);
}
