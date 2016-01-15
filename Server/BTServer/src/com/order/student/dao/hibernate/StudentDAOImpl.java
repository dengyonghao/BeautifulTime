package com.order.student.dao.hibernate;

import java.util.List;

import com.order.student.common.CoaHibernateDaoSupport;
import com.order.student.dao.StudentDAO;
import com.order.student.model.Users;

public class StudentDAOImpl extends CoaHibernateDaoSupport implements StudentDAO {

	@Override
	public boolean findBySidPwd(String stu_id, String password) {
		// TODO Auto-generated method stub
		boolean flag = true;
		String queryString = "From Users where stu_id= ? and password= ?";
		List results = getHibernateTemplate().find(queryString,
				new Object[] { stu_id, password });
		if (results.size() == 0) {
			flag = false;
		}
		return flag;
	}

	@Override
	public Users findBySid(String stu_id) {
		// TODO Auto-generated method stub
		return (Users) getHibernateTemplate().get(Users.class, stu_id);
	}

}
