-- library_database.sql
-- This script creates the entire Library Management System database schema.

-- 1. Create the Database
DROP DATABASE IF EXISTS library_db;
CREATE DATABASE library_db;
USE library_db;

-- 2. Create the Tables

-- Table for storing author information
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    nationality VARCHAR(100)
);

-- Table for storing book information
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year INT,
    genre VARCHAR(100),
    isbn VARCHAR(20) UNIQUE NOT NULL, -- ISBN must be unique for each book
    author_id INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Table for storing borrower information (library members)
CREATE TABLE borrowers (
    borrower_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL, -- Email must be unique
    date_of_registration DATE DEFAULT (CURRENT_DATE)
);

-- Junction table to handle the Many-to-Many relationship between Books and Borrowers (Loans)
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    borrower_id INT NOT NULL,
    date_borrowed DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    date_returned DATE NULL, -- NULL if the book is not yet returned
    -- Constraints to enforce data integrity
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (borrower_id) REFERENCES borrowers(borrower_id) ON DELETE CASCADE,
    -- A book cannot be loaned out again until it is returned (optional complex constraint)
    CONSTRAINT chk_return_date CHECK (date_returned IS NULL OR date_returned >= date_borrowed)
);

-- 3. (Optional) Insert Sample Data for Testing

INSERT INTO authors (first_name, last_name, date_of_birth, nationality) VALUES
('George', 'Maina', '1903-06-25', 'Kenya'),
('Omondi', 'Joe', '1926-04-28', 'Kenya'),
('Wafula', 'Waingo', '1965-07-31', 'Kenya');

INSERT INTO books (title, publication_year, genre, isbn, author_id) VALUES
('1984', 1949, 'Dystopian', '978-0451524935', 1),
('To Kill a Mockingbird', 1960, 'Fiction', '978-0061120084', 2),
('Harry Potter and the Philosopher''s Stone', 1997, 'Fantasy', '978-0747532699', 3);

INSERT INTO borrowers (first_name, last_name, email, date_of_registration) VALUES
('Alice', 'Smith', 'alice.smith@email.com', '2024-01-15'),
('Bob', 'Jones', 'bob.jones@email.com', '2024-02-01');

INSERT INTO loans (book_id, borrower_id, date_borrowed, due_date, date_returned) VALUES
(1, 1, '2024-09-10', '2024-09-24', NULL), -- Alice has 1984, not returned
(2, 2, '2024-09-05', '2024-09-19', '2024-09-18'); -- Bob had TKAM, returned
