/*
1.  How many copies of the book titled "A" and published by "B" are owned
    by the library branch whose address is "C"?
*/

WITH bookID AS (
    SELECT Books.book_id AS ID1
    FROM Books
    WHERE Books.publisher = 'Katherine Tegen Books'
      AND Books.book_id IN (
        SELECT Books.book_id
        FROM Authors,
             Books,
             BooksAuthors
        WHERE Authors.author_id = BooksAuthors.author_id
          AND BooksAuthors.book_id = Books.book_id
    )
),
     branchID AS (
         SELECT Branches.branch_id AS bID
         FROM Branches
         WHERE Branches.address = 'Great Harbor (Portus Magnus)'
     )

SELECT BranchesBooks.total AS count
FROM bookID, Branches, BranchesBooks, branchID
WHERE BranchesBooks.book_id IN (bookID.ID1)
  AND Branches.branch_id = BranchesBooks.branch_id
  AND Branches.branch_id IN (branchID.bID)
;


/*
2.  How many copies of the book titled "A" are owned by each library branch?
*/

SELECT Branches.name,
       Books.title,
       BranchesBooks.total
FROM BranchesBooks
         JOIN Branches ON Branches.branch_id = BranchesBooks.branch_id
         JOIN Books
              ON Books.book_id = BranchesBooks.book_id
                  AND Books.title = 'Good Omens';


/*
3.  Retrieve the names of all borrowers who borrowed the book titled "A" for each library branch.
*/

SELECT Borrowers.name, Branches.name, Branches.address
FROM Borrowers,
     Branches,
     Loans,
     Books
WHERE Borrowers.borrower_id = Loans.borrower_id
  AND Loans.branch_id = Branches.branch_id
  AND Books.book_id = Loans.book_id
  AND Books.title LIKE 'Divergent';


/*
4.  For each book that is loaned out from the branch "A" and whose due date is today,
    retrieve the book title, the borrower's name(s), and the borrower's address(es).
*/

SELECT Books.title, Borrowers.name, Borrowers.address
FROM Books,
     Borrowers,
     Loans
WHERE Books.book_id = Loans.book_id
  AND Borrowers.borrower_id = Loans.borrower_id
  AND Loans.due_date = date();


/*
5.  For each branch, retrieve the branch name and the total number of books loaded out from that branch.
*/

SELECT Branches.name, Branches.address, COUNT(*) AS CurrentLoans
FROM Branches,
     Loans
WHERE Branches.branch_id = Loans.branch_id
GROUP BY Branches.branch_id;