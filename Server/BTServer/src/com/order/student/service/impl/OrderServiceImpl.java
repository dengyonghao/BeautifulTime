package com.order.student.service.impl;

import java.util.List;

import com.order.student.dao.OrderDAO;
import com.order.student.model.Orders;
import com.order.student.service.OrderService;

public class OrderServiceImpl implements OrderService {
	
	OrderDAO orderDAO;

	public OrderDAO getOrderDAO() {
		return orderDAO;
	}

	public void setOrderDAO(OrderDAO orderDAO) {
		this.orderDAO = orderDAO;
	}

	@Override
	public int saveOrder(Orders orser) {
		// TODO Auto-generated method stub
		return orderDAO.saveOrder(orser);
	}

	@Override
	public void deleteOrder(Orders orser) {
		// TODO Auto-generated method stub
		orderDAO.deleteOrder(orser);
	}

	@Override
	public void updateOrder(Orders orser) {
		// TODO Auto-generated method stub
		orderDAO.updateOrder(orser);
	}

	@Override
	public Orders findById(int oreads_id) {
		// TODO Auto-generated method stub
		return orderDAO.findById(oreads_id);
	}

	@Override
	public List<Orders> findBySid(String stu_id) {
		// TODO Auto-generated method stub
		return orderDAO.findBySid(stu_id);
	}
	

	
}
