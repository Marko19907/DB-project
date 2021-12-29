/*
    Delete the tables and triggers if they already exist
*/

DROP TABLE IF EXISTS Authors;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS BooksAuthors;
DROP TABLE IF EXISTS Branches;
DROP TABLE IF EXISTS BranchesBooks;
DROP TABLE IF EXISTS Borrowers;
DROP TABLE IF EXISTS Loans;

DROP TRIGGER IF EXISTS decrease_available;
DROP TRIGGER IF EXISTS increase_available;


/*
    This table stores names of all book authors
*/
CREATE TABLE Authors
(
    author_id INT PRIMARY KEY,
    name      VARCHAR(255) NOT NULL
);

INSERT
INTO Authors(author_id, name)
VALUES (1, 'Veronica Roth'),
       (2, 'J. K. Rowling'),
       (3, 'J. R. R. Tolkien'),
       (4, 'Neil Gaiman'),
       (5, 'Terry Pratchett'),
       (6, 'Adam Grant'),
       (7, 'Thomas Erikson'),
       (8, 'Francois Baranger'),
       (9, 'H.P. Lovecraft'),
       (10, 'Adam Jones'),
       (11, 'Adam Ashton'),
       (12, 'Michelle Rial');

/*
    This table stores the barcodes, titles and publishers of books
*/
CREATE TABLE Books
(
    book_id   INT PRIMARY KEY,
    barcode   CHAR(13)     NOT NULL,
    title     VARCHAR(255) NOT NULL,
    publisher VARCHAR(255) NOT NULL
);

INSERT
INTO Books(book_id, barcode, publisher, title)
VALUES (1, '9780007538065', 'Katherine Tegen Books', 'Divergent'),
       (2, '9780060853983', 'Workman', 'Good Omens'),
       (3, '0020626716048', 'Vivendi Universal', 'The Fellowship of the Ring'),
       (4, '9875748930947', 'Bloomsbury', 'Harry Potter: Philosopher`s Stone'),
       (5, '9780753553893', 'Ebury Publishing', 'Think again'),
       (6, '9781785042188', 'Ebury Publishing', 'Surrounded by Idiots'),
       (7, '9781624650086', 'Design Studio Press', 'At the Mountain of Madness Vol.1'),
       (8, '9780645133806', 'What will you learn', 'The Sh*t They Never Taught You : What You Can Learn From Books'),
       (9, '9781452175867', 'Chronicle Books', 'Am I Overthinking This?');

/*
    This table represents a relationship between Books and Authors
*/
CREATE TABLE BooksAuthors
(
    book_id   INT,
    author_id INT,
    FOREIGN KEY (book_id) REFERENCES Books (book_id),
    FOREIGN KEY (author_id) REFERENCES Authors (author_id)
);

INSERT
INTO BooksAuthors(book_id, author_id)
VALUES (1, 1),
       (2, 4),
       (2, 5),
       (3, 3),
       (4, 2),
       (5, 6),
       (6, 7),
       (7, 8),
       (7, 9),
       (8, 10),
       (8, 11),
       (9, 12);

/*
    This table stores names and addresses of library branches
*/
CREATE TABLE Branches
(
    branch_id INT PRIMARY KEY,
    name      VARCHAR(255) NOT NULL,
    address   VARCHAR(255) NOT NULL
);

INSERT
INTO Branches(branch_id, name, address)
VALUES (1, 'New York Library', '5th Willow Avenue'),
       (2, 'New York Library', '2nd Something Avenue'),
       (3, 'Library of Alexandria', 'Great Harbor (Portus Magnus)');

/*
    This table represents a relationship between Branches and Books. It also stores information about
    available and total amount of books for a branch
*/
CREATE TABLE BranchesBooks
(
    branch_id INT,
    book_id   INT,
    available INT NOT NULL, -- Available to loan out in the library
    total     INT NOT NULL, -- Total books in the library
    CHECK (available <= total),
    CHECK (total >= 0),
    FOREIGN KEY (branch_id) REFERENCES Branches (branch_id),
    FOREIGN KEY (book_id) REFERENCES Books (book_id)
);

INSERT
INTO BranchesBooks(branch_id, book_id, available, total)
VALUES (1, 1, 4, 4),
       (1, 2, 4, 4),
       (1, 3, 1, 1),
       (1, 4, 2, 2),
       (1, 5, 4, 4),
       (1, 6, 4, 4),
       (1, 7, 4, 4),
       (1, 8, 4, 4),
       (1, 9, 4, 4),
       (2, 1, 2, 2),
       (2, 2, 4, 4),
       (2, 3, 3, 3),
       (2, 4, 1, 1),
       (2, 5, 2, 2),
       (2, 6, 2, 2),
       (2, 7, 2, 2),
       (2, 8, 2, 2),
       (2, 9, 2, 2),
       (3, 1, 5, 5),
       (3, 2, 3, 3),
       (3, 3, 4, 4),
       (3, 4, 2, 2),
       (3, 5, 4, 4),
       (3, 6, 4, 4),
       (3, 7, 4, 4),
       (3, 8, 4, 4),
       (3, 9, 4, 4);

/*
    This table stores names, addresses and contact information of borrowers
*/
CREATE TABLE Borrowers
(
    borrower_id  INT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    address      VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255) NOT NULL
);

INSERT
INTO Borrowers(borrower_id, name, address, contact_info)
VALUES (1, 'Neil K Vaccaro', '2457 Goff Avenue, TX', '269-586-8202'),
       (2, 'Sarah A Mosley', '4277 Stark Hollow Road, CA', 'SarahM6l@mail.net'),
       (3, 'Richard L Kahn', '4049 Sherman Street, NY', '785-207-5492'),
       (4, 'John Doe', '7643 Willow Avenue, OH', 'JD1961@mail.net'),
       (5, 'Thomas T. Nelson', '1348 Coffman Alley, KY', 'ThomasTNelson@teleworm.us'),
       (6, 'Ellyn Shipman', '2420 Hinkle Lake Road, Cambridge, MA', '617-505-8626'),
       (7, 'Robert Flatt', '2290 Lilac Lane, Savannah, GA', 'RobertKFlatt@armyspy.com'),
       (8, 'James Johnson', '1744 Hewes Avenue Baltimore, MD', 'JamesRJohnson@rhyta.com'),
       (9, 'Sara Weddle', '1538 Spring Haven Trail, Paterson, NJ', '973-742-3323'),
       (10, 'Julie Mize', '4598 Clifford Street, Fremont, CA', 'JulieJMize@rhyta.com');

/*
    This table stores borrower, book and branch ids as well as the due dates of the loans
*/
CREATE TABLE Loans
(
    borrower_id INT,
    book_id     INT,
    branch_id   INT,
    due_date    DATE,
    UNIQUE (borrower_id, book_id),
    FOREIGN KEY (borrower_id) REFERENCES Borrowers (borrower_id),
    FOREIGN KEY (book_id) REFERENCES Books (book_id),
    FOREIGN KEY (branch_id) REFERENCES Branches (branch_id)
);

INSERT
INTO Loans(borrower_id, book_id, branch_id, due_date)
VALUES (1, 1, 1, '2021-12-23'),
       (1, 4, 1, '2021-12-23'),
       (2, 2, 2, '2021-12-19'),
       (3, 2, 2, '2021-12-25'),
       (5, 3, 2, '2021-12-29'),
       (5, 4, 2, '2021-12-24'),
       (6, 2, 2, '2021-12-21'),
       (6, 1, 2, '2021-12-28'),
       (7, 2, 2, '2021-12-18'),
       (8, 2, 2, '2021-12-17');


/*
    Triggers
*/

-- This trigger decreases the available books from BranchesBooks when a new Loan is created
CREATE TRIGGER decrease_available
    AFTER INSERT
    ON Loans
BEGIN
    UPDATE BranchesBooks
    SET available = available - 1
    WHERE (BranchesBooks.book_id, BranchesBooks.branch_id) = (NEW.book_id, NEW.branch_id);
END;

-- This trigger increases the available books from BranchesBooks when a Loan is deleted
CREATE TRIGGER increase_available
    AFTER DELETE
    ON Loans
BEGIN
    UPDATE BranchesBooks
    SET available = available + 1
    WHERE (BranchesBooks.book_id, BranchesBooks.branch_id) = (OLD.book_id, OLD.branch_id);
END;
