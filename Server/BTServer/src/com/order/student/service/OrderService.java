package com.order.student.service;

import java.util.List;

import com.order.student.model.Books;
import com.order.student.model.Orders;


public interface OrderService {
	public int saveOrder(Orders orser);
	public void deleteOrder(Orders orser);
	public void updateOrder(Orders orser);
	public Orders findById(int oreads_id);
	public List<Orders> findBySid(String stu_id);
}
