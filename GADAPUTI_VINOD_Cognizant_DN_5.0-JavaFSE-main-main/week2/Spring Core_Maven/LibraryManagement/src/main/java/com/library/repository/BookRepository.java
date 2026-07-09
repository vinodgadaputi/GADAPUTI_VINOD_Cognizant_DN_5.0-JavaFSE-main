package com.library.repository;

// Repository class - handles data access for books
public class BookRepository {

    public String getBookById(int id) {
        System.out.println("[BookRepository] Fetching book with ID: " + id);
        // Simulated data
        if (id == 1) return "The Great Gatsby";
        if (id == 2) return "To Kill a Mockingbird";
        if (id == 3) return "1984 by George Orwell";
        return "Book not found";
    }

    public void saveBook(String bookName) {
        System.out.println("[BookRepository] Saving book: " + bookName);
    }

    public void deleteBook(int id) {
        System.out.println("[BookRepository] Deleting book with ID: " + id);
    }
}