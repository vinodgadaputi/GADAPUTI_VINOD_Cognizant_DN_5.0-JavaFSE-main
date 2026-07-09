import java.util.Arrays;
import java.util.Comparator;
import java.util.Scanner;

// Defining the product class
class Product {
    int productId;
    String productName;
    String category;

    // Constructor
    public Product(int productId, String productName, String category) {
        this.productId = productId;
        this.productName = productName;
        this.category = category;
    }

    @Override
    public String toString() {
        return "Product ID: " + productId + ", Name: " + productName + ", Category: " + category;
    }
}

public class ProductSearch {

    // Using Linear search method
    public static Product linearSearch(Product[] products, int productId) {
        for (Product product : products) {
            if (product.productId == productId) {
                return product;
            }
        }
        return null;
    }

    // Using Binary search method
    public static Product binarySearch(Product[] products, int productId) {
        int left = 0;
        int right = products.length - 1;

        while (left <= right) {
            int mid = left + (right - left) / 2;

            if (products[mid].productId == productId) {
                return products[mid];
            }

            if (products[mid].productId < productId) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // User input for many products
        System.out.print("Enter the number of products: ");
        int numberOfProducts = scanner.nextInt();
        scanner.nextLine(); // Consumes newline

        Product[] products = new Product[numberOfProducts];

        // User input about product details
        for (int i = 0; i < numberOfProducts; i++) {
            System.out.println("\n--- Product " + (i + 1) + " ---");
            System.out.print("Enter product ID: ");
            int productId = scanner.nextInt();
            scanner.nextLine(); // Consumes newline

            System.out.print("Enter product name: ");
            String productName = scanner.nextLine();

            System.out.print("Enter category: ");
            String category = scanner.nextLine();

            products[i] = new Product(productId, productName, category);
        }

        // FIX: Clean, bug-free way to sort using built-in Integer comparison
        Arrays.sort(products, Comparator.comparingInt(p -> p.productId));

        // User input for productId to search the product
        System.out.print("\nEnter the product ID to search: ");
        int searchId = scanner.nextInt();

        // With Linear Search
        Product foundProductLinear = linearSearch(products, searchId);
        if (foundProductLinear != null) {
            System.out.println("Product found using Linear Search: " + foundProductLinear);
        } else {
            System.out.println("Product not found using Linear Search.");
        }

        // With Binary Search
        Product foundProductBinary = binarySearch(products, searchId);
        if (foundProductBinary != null) {
            System.out.println("Product found using Binary Search: " + foundProductBinary);
        } else {
            System.out.println("Product not found using Binary Search.");
        }

        scanner.close();
    }
}