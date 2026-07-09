package com.library.service;

import com.library.repository.BookRepository;

// Service class - handles business logic for books
public class BookService {

    private BookRepository bookRepository;

    // Setter injection (used by Spring XML config)
    public void setBookRepository(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
        System.out.println("[BookService] BookRepository injected successfully.");
    }

    public String getBook(int id) {
        System.out.println("[BookService] Getting book with ID: " + id);
        return bookRepository.getBookById(id);
    }

    public void addBook(String bookName) {
        System.out.println("[BookService] Adding new book: " + bookName);
        bookRepository.saveBook(bookName);
    }

    public void removeBook(int id) {
        System.out.println("[BookService] Removing book with ID: " + id);
        bookRepository.deleteBook(id);
    }
}