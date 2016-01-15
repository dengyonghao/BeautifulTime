package com.order.student.dao;

import java.util.List;

import com.order.student.model.Books;

public interface BookDAO {
	public List<Books> findAllBooks();
	public List<Books> findAllBooks(int pageNumber, int pageSize);
	public Books findById(String book_id);
}
