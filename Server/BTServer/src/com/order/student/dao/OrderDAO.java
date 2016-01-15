package com.order.student.dao;

import java.util.List;

import com.order.student.model.Orders;


public interface OrderDAO {
	public int saveOrder(Orders orser);
	public void deleteOrder(Orders orser);
	public void updateOrder(Orders orser);
	public Orders findById(int oreads_id);
	public List<Orders> findBySid(String stu_id);
}
