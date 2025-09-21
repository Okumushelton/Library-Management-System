# Library-Management-System

# Library Management System Database

A relational database schema for managing a library's operations, including books, authors, borrowers, and loans.

## Schema Description

The database consists of four main tables:

1.  **`authors`**: Stores information about the authors of the books.
2.  **`books`**: Stores information about each book copy. Each book is linked to an author.
3.  **`borrowers`**: Stores information about library members.
4.  **`loans`**: A junction table that records the borrowing transactions (which borrower has which book and when).

## Relationships

-   `authors` **(1)** to **(*)** `books`: One author can write many books.
-   `books` **(*)** to **(*)** `borrowers`: This Many-to-Many relationship is resolved by the `loans` table.
    -   `loans.book_id` is a Foreign Key referencing `books.book_id`
    -   `loans.borrower_id` is a Foreign Key referencing `borrowers.borrower_id`

## How to Run

1.  Ensure you have MySQL installed and running on your system.
2.  Clone this repository.
3.  Log in to your MySQL server as a root user or user with sudo previllages:
    ```bash
    mysql -u root -p
    ```
4.  Execute the SQL script to create the database, tables, and sample data:
    ```sql
    source /path/to/your/cloned/repository/library_database.sql
    ```
5.  The database `library_db` is now ready for use.

## Sample Queries

Here are a few sample queries to get you started. You can add them to a `sample_queries.sql` file.

**Find all books by a specific author:**
```sql
SELECT title, publication_year
FROM books
JOIN authors ON books.author_id = authors.author_id
WHERE authors.last_name = 'Orwell';
```

**List all books currently on loan (not returned):**
```sql
SELECT books.title, borrowers.first_name, borrowers.last_name, loans.due_date
FROM loans
JOIN books ON loans.book_id = books.book_id
JOIN borrowers ON loans.borrower_id = borrowers.borrower_id
WHERE loans.date_returned IS NULL;
```
