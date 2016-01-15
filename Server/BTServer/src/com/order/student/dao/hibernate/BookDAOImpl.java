package com.order.student.dao.hibernate;


import java.util.List;

import com.order.student.common.CoaHibernateDaoSupport;
import com.order.student.dao.BookDAO;
import com.order.student.model.Books;
import com.order.student.model.Orders;
import com.order.student.model.Users;

public class BookDAOImpl extends CoaHibernateDaoSupport implements BookDAO {

	@Override
	public List<Books> findAllBooks() {
		// TODO Auto-generated method stub
		String hql = "from Books as b";
		List<Books> bList = (List<Books>) getHibernateTemplate().find(hql);
		return bList;
	}

	@Override
	public List<Books> findAllBooks(int pageNumber, int pageSize) {
		// TODO Auto-generated method stub
		String hql = "from Books as b";
		List<Books> bList = (List<Books>) findByPage(hql,
				((pageNumber - 1) * pageSize), pageSize);
		return bList;
	}

	@Override
	public Books findById(String book_id) {
		// TODO Auto-generated method stub
		return (Books) getHibernateTemplate().get(Books.class, book_id);
	}

	
}
