package com.order.student.service.impl;

import java.util.List;

import com.order.student.dao.BookDAO;
import com.order.student.model.Books;
import com.order.student.service.BookService;

public class BookServiceImpl implements BookService {
	
	BookDAO bookDAO;

	

	@Override
	public List<Books> findAllBooks() {
		// TODO Auto-generated method stub
		return bookDAO.findAllBooks();
	}

	@Override
	public List<Books> findAllBooks(int pageNumber, int pageSize) {
		// TODO Auto-generated method stub
		return bookDAO.findAllBooks(pageNumber, pageSize);
	}
	
	public BookDAO getBookDAO() {
		return bookDAO;
	}

	public void setBookDAO(BookDAO bookDAO) {
		this.bookDAO = bookDAO;
	}

	@Override
	public Books findById(String book_id) {
		// TODO Auto-generated method stub
		return bookDAO.findById(book_id);
	}

	
}
