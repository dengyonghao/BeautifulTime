package com.order.student.dao.hibernate;


import java.util.List;

import com.order.student.common.CoaHibernateDaoSupport;
import com.order.student.dao.OrderDAO;
import com.order.student.model.Orders;

public class OrderDAOImpl extends CoaHibernateDaoSupport implements OrderDAO {

	@Override
	public int saveOrder(Orders orser) {
		// TODO Auto-generated method stub
		int i = 0;
		try {
			this.getHibernateTemplate().save(orser);
			i = 1;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return i;
	}

	@Override
	public void deleteOrder(Orders orser) {
		// TODO Auto-generated method stub
		getHibernateTemplate().delete(orser);
	}

	@Override
	public void updateOrder(Orders orser) {
		// TODO Auto-generated method stub
		getHibernateTemplate().update(orser);
	}

	@Override
	public Orders findById(int oreads_id) {
		// TODO Auto-generated method stub
		return (Orders) getHibernateTemplate().get(Orders.class, oreads_id);
	}

	@Override
	public List<Orders> findBySid(String stu_id) {
		// TODO Auto-generated method stub
		String hql = "from Orders as o where stu_id = '" + stu_id + "'";
		List<Orders> cList = (List<Orders>) getHibernateTemplate().find(hql);
		return cList;
	}
	
	
}
