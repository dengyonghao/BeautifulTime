package com.order.student.model;

public class Books {
	private String book_id;
	private String book_name;
	private String price;
	public Books() {
		super();
	}
	public Books(String book_id, String book_name, String price) {
		super();
		this.book_id = book_id;
		this.book_name = book_name;
		this.price = price;
	}
	public String getBook_id() {
		return book_id;
	}
	public void setBook_id(String book_id) {
		this.book_id = book_id;
	}
	public String getBook_name() {
		return book_name;
	}
	public void setBook_name(String book_name) {
		this.book_name = book_name;
	}
	public String getPrice() {
		return price;
	}
	public void setPrice(String price) {
		this.price = price;
	}
}
