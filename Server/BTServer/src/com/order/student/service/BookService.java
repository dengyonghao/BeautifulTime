package com.order.student.service;

import java.util.List;

import com.order.student.model.Books;


public interface BookService {
	public List<Books> findAllBooks();
	public List<Books> findAllBooks(int pageNumber, int pageSize);
	public Books findById(String book_id);
}
