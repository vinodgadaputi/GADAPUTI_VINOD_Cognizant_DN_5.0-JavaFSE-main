package com.library;

import com.library.service.BookService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

// Step 4: Main class to load Spring context and test configuration
public class LibraryManagementApp {

    public static void main(String[] args) {

        System.out.println("=================================================");
        System.out.println("   Library Management - Spring Application");
        System.out.println("=================================================\n");

        // Load Spring Application Context from XML
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        System.out.println("\n[Spring] Application context loaded successfully!\n");

        // Get BookService bean from Spring context
        BookService bookService = (BookService) context.getBean("bookService");

        System.out.println("-------------------------------------------------");

        // Test: Get books
        System.out.println("\n--- Fetching Books ---");
        String book1 = bookService.getBook(1);
        System.out.println("Result: " + book1);

        String book2 = bookService.getBook(2);
        System.out.println("Result: " + book2);

        // Test: Add a book
        System.out.println("\n--- Adding a Book ---");
        bookService.addBook("Clean Code by Robert Martin");

        // Test: Remove a book
        System.out.println("\n--- Removing a Book ---");
        bookService.removeBook(3);

        System.out.println("\n=================================================");
        System.out.println("   Application ran successfully!");
        System.out.println("=================================================");

        // Close context
        ((ClassPathXmlApplicationContext) context).close();
    }
}