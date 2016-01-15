package com.order.student.model;

public class Orders {
	private long orders_id;
	private String stu_id;
	private String book_id;
	
	public long getOrders_id() {
		return orders_id;
	}
	public void setOrders_id(long orders_id) {
		this.orders_id = orders_id;
	}
	public Orders() {
		super();
	}
	public Orders(String stu_id, String book_id) {
		super();
		this.stu_id = stu_id;
		this.book_id = book_id;
	}
	public String getStu_id() {
		return stu_id;
	}
	public void setStu_id(String stu_id) {
		this.stu_id = stu_id;
	}
	public String getBook_id() {
		return book_id;
	}
	public void setBook_id(String book_id) {
		this.book_id = book_id;
	}
}
