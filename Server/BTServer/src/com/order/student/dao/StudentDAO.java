package com.order.student.dao;

import com.order.student.model.Users;

public interface StudentDAO {
	public Users findBySid(String stu_id);
	public boolean findBySidPwd(String stu_id, String password);
}
