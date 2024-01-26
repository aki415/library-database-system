-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema library_database
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema library_database
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `library_database` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `library_database` ;

-- -----------------------------------------------------
-- Table `library_database`.`books`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books` (
  `ISBN` VARCHAR(20) NOT NULL,
  `Title` VARCHAR(255) NOT NULL,
  `Author` VARCHAR(100) NOT NULL,
  `Genre` VARCHAR(50) NOT NULL,
  `Publisher` VARCHAR(100) NOT NULL,
  `Loaned` TINYINT(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ISBN`),
  INDEX `idx_author` (`Author` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`bookcopies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`bookcopies` (
  `ISBN` VARCHAR(20) NOT NULL,
  `TotalCopies` INT NOT NULL,
  `AvailableCopies` INT NOT NULL,
  PRIMARY KEY (`ISBN`),
  CONSTRAINT `bookcopies_ibfk_1`
    FOREIGN KEY (`ISBN`)
    REFERENCES `library_database`.`books` (`ISBN`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`members`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`members` (
  `MemberID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `ContactInformation` VARCHAR(255) NOT NULL,
  `MembershipType` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`MemberID`))
ENGINE = InnoDB
AUTO_INCREMENT = 1011
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`bookreviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`bookreviews` (
  `ReviewID` INT NOT NULL AUTO_INCREMENT,
  `ISBN` VARCHAR(20) NOT NULL,
  `MemberID` INT NOT NULL,
  `ReviewText` TEXT NULL DEFAULT NULL,
  `NumericRating` INT NULL DEFAULT NULL,
  `ReviewDate` DATE NOT NULL,
  `BookTitle` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`ReviewID`),
  INDEX `ISBN` (`ISBN` ASC) VISIBLE,
  INDEX `MemberID` (`MemberID` ASC) VISIBLE,
  FULLTEXT INDEX `ReviewText` (`ReviewText`) VISIBLE,
  CONSTRAINT `bookreviews_ibfk_1`
    FOREIGN KEY (`ISBN`)
    REFERENCES `library_database`.`books` (`ISBN`),
  CONSTRAINT `bookreviews_ibfk_2`
    FOREIGN KEY (`MemberID`)
    REFERENCES `library_database`.`members` (`MemberID`))
ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`booksimilarities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`booksimilarities` (
  `SimilarityID` INT NOT NULL AUTO_INCREMENT,
  `ISBN1` VARCHAR(20) NULL DEFAULT NULL,
  `ISBN2` VARCHAR(20) NULL DEFAULT NULL,
  `SimilarityType` VARCHAR(255) NULL DEFAULT NULL,
  `Description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`SimilarityID`),
  INDEX `ISBN1` (`ISBN1` ASC) VISIBLE,
  INDEX `ISBN2` (`ISBN2` ASC) VISIBLE,
  CONSTRAINT `booksimilarities_ibfk_1`
    FOREIGN KEY (`ISBN1`)
    REFERENCES `library_database`.`books` (`ISBN`),
  CONSTRAINT `booksimilarities_ibfk_2`
    FOREIGN KEY (`ISBN2`)
    REFERENCES `library_database`.`books` (`ISBN`))
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`librarysettings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`librarysettings` (
  `SettingID` INT NOT NULL AUTO_INCREMENT,
  `SettingName` VARCHAR(255) NOT NULL,
  `SettingValue` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`SettingID`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`loans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`loans` (
  `LoanID` INT NOT NULL AUTO_INCREMENT,
  `BookISBN` VARCHAR(20) NOT NULL,
  `MemberID` INT NOT NULL,
  `LoanDate` DATE NOT NULL,
  `DueDate` DATE NOT NULL,
  `ISBN` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`LoanID`),
  INDEX `BookISBN` (`BookISBN` ASC) VISIBLE,
  INDEX `MemberID` (`MemberID` ASC) VISIBLE,
  CONSTRAINT `loans_ibfk_1`
    FOREIGN KEY (`BookISBN`)
    REFERENCES `library_database`.`books` (`ISBN`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `loans_ibfk_2`
    FOREIGN KEY (`MemberID`)
    REFERENCES `library_database`.`members` (`MemberID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 5018
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`loansbackup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`loansbackup` (
  `LoanID` INT NOT NULL DEFAULT '0',
  `BookISBN` VARCHAR(20) NOT NULL,
  `MemberID` INT NOT NULL,
  `LoanDate` DATE NOT NULL,
  `DueDate` DATE NOT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`reservations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`reservations` (
  `ReservationID` INT NOT NULL AUTO_INCREMENT,
  `ISBN` VARCHAR(20) NOT NULL,
  `MemberID` INT NOT NULL,
  `ReservationDate` DATE NOT NULL,
  `ExpirationDate` DATE NOT NULL,
  `IsActive` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`ReservationID`),
  INDEX `ISBN` (`ISBN` ASC) VISIBLE,
  INDEX `MemberID` (`MemberID` ASC) VISIBLE,
  CONSTRAINT `reservations_ibfk_1`
    FOREIGN KEY (`ISBN`)
    REFERENCES `library_database`.`books` (`ISBN`),
  CONSTRAINT `reservations_ibfk_2`
    FOREIGN KEY (`MemberID`)
    REFERENCES `library_database`.`members` (`MemberID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`returns`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`returns` (
  `ReturnID` INT NOT NULL AUTO_INCREMENT,
  `LoanID` INT NOT NULL,
  `ReturnDate` DATE NOT NULL,
  `LateFees` DECIMAL(5,2) NULL DEFAULT '0.00',
  PRIMARY KEY (`ReturnID`),
  INDEX `LoanID` (`LoanID` ASC) VISIBLE,
  CONSTRAINT `returns_ibfk_1`
    FOREIGN KEY (`LoanID`)
    REFERENCES `library_database`.`loans` (`LoanID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 8003
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`returnsbackup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`returnsbackup` (
  `ReturnID` INT NOT NULL DEFAULT '0',
  `LoanID` INT NOT NULL,
  `ReturnDate` DATE NOT NULL,
  `LateFees` DECIMAL(5,2) NULL DEFAULT '0.00')
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `library_database`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`staff` (
  `StaffID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Role` VARCHAR(100) NOT NULL,
  `ContactInformation` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB
AUTO_INCREMENT = 2011
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `library_database` ;

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`bookpopularitybasedonloanfrequency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`bookpopularitybasedonloanfrequency` (`ISBN` INT, `Title` INT, `LoanFrequency` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_adventure`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_adventure` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_bildungsroman`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_bildungsroman` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_classic`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_classic` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_crime`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_crime` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_dystopian`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_dystopian` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_gothic_novel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_gothic_novel` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_historical`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_historical` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_romance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_romance` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`books_tragedy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`books_tragedy` (`ISBN` INT, `Title` INT, `Author` INT, `Publisher` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`detailedbookreviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`detailedbookreviews` (`ReviewID` INT, `Title` INT, `MemberID` INT, `ReviewText` INT, `NumericRating` INT, `ReviewDate` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`detailedcurrentloans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`detailedcurrentloans` (`MemberName` INT, `BookTitle` INT, `LoanDate` INT, `DueDate` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`overdueloandetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`overdueloandetails` (`LoanID` INT, `MemberID` INT, `MemberName` INT, `ISBN` INT, `BookTitle` INT, `LoanDate` INT, `DueDate` INT, `ReturnDate` INT, `LateFees` INT);

-- -----------------------------------------------------
-- Placeholder table for view `library_database`.`overdueloans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `library_database`.`overdueloans` (`MemberName` INT, `BookTitle` INT, `LoanDate` INT, `DueDate` INT);

-- -----------------------------------------------------
-- procedure GetBookRecommendations
-- -----------------------------------------------------

DELIMITER $$
USE `library_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBookRecommendations`(IN MemberID INT)
BEGIN
    SELECT b.ISBN, b.Title, b.Genre
    FROM Books b
    JOIN (
        SELECT Genre 
        FROM Loans l 
        JOIN Books b ON l.BookISBN = b.ISBN 
        WHERE l.MemberID = MemberID
        GROUP BY Genre
        ORDER BY COUNT(*) DESC
        LIMIT 3
    ) AS TopGenres ON b.Genre = TopGenres.Genre
    LEFT JOIN (
        SELECT BookISBN
        FROM Loans
        WHERE MemberID = MemberID
    ) AS BorrowedBooks ON b.ISBN = BorrowedBooks.BookISBN
    WHERE BorrowedBooks.BookISBN IS NULL
    ORDER BY RAND() -- Randomize the selection of books
    LIMIT 4; -- Limiting to 1 recommendation for diversity
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetSimilarBooks
-- -----------------------------------------------------

DELIMITER $$
USE `library_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetSimilarBooks`(IN inputISBN VARCHAR(20))
BEGIN
    SELECT 
        b2.ISBN AS SimilarBookISBN, 
        b2.Title AS SimilarBookTitle, 
        bs.SimilarityType, 
        bs.Description
    FROM BookSimilarities bs
    JOIN Books b1 ON bs.ISBN1 = b1.ISBN OR bs.ISBN2 = b1.ISBN
    JOIN Books b2 ON b2.ISBN = IF(b1.ISBN = bs.ISBN1, bs.ISBN2, bs.ISBN1)
    WHERE b1.ISBN = inputISBN;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure RecalculateLateFees
-- -----------------------------------------------------

DELIMITER $$
USE `library_database`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `RecalculateLateFees`()
BEGIN
    DECLARE fine_per_day DECIMAL(10, 2);
    SELECT SettingValue INTO fine_per_day FROM LibrarySettings WHERE SettingName = 'FinePerDay';

    UPDATE Returns
    INNER JOIN Loans ON Returns.LoanID = Loans.LoanID
    SET Returns.LateFees = GREATEST(0, DATEDIFF(Returns.ReturnDate, Loans.DueDate) * fine_per_day)
    WHERE Returns.ReturnDate > Loans.DueDate
      AND Returns.ReturnID > 0; -- Assuming ReturnID is a primary key and always > 0
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `library_database`.`bookpopularitybasedonloanfrequency`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`bookpopularitybasedonloanfrequency`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`bookpopularitybasedonloanfrequency` AS select `b`.`ISBN` AS `ISBN`,`b`.`Title` AS `Title`,count(`l`.`LoanID`) AS `LoanFrequency` from (`library_database`.`books` `b` left join `library_database`.`loans` `l` on((`b`.`ISBN` = `l`.`BookISBN`))) group by `b`.`ISBN`,`b`.`Title`;

-- -----------------------------------------------------
-- View `library_database`.`books_adventure`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_adventure`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_adventure` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Adventure');

-- -----------------------------------------------------
-- View `library_database`.`books_bildungsroman`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_bildungsroman`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_bildungsroman` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Bildungsroman');

-- -----------------------------------------------------
-- View `library_database`.`books_classic`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_classic`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_classic` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Classic');

-- -----------------------------------------------------
-- View `library_database`.`books_crime`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_crime`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_crime` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Crime');

-- -----------------------------------------------------
-- View `library_database`.`books_dystopian`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_dystopian`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_dystopian` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Dystopian');

-- -----------------------------------------------------
-- View `library_database`.`books_gothic_novel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_gothic_novel`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_gothic_novel` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Gothic Novel');

-- -----------------------------------------------------
-- View `library_database`.`books_historical`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_historical`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_historical` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Historical');

-- -----------------------------------------------------
-- View `library_database`.`books_romance`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_romance`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_romance` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Romance');

-- -----------------------------------------------------
-- View `library_database`.`books_tragedy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`books_tragedy`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`books_tragedy` AS select `library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `Title`,`library_database`.`books`.`Author` AS `Author`,`library_database`.`books`.`Publisher` AS `Publisher` from `library_database`.`books` where (`library_database`.`books`.`Genre` = 'Tragedy');

-- -----------------------------------------------------
-- View `library_database`.`detailedbookreviews`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`detailedbookreviews`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`detailedbookreviews` AS select `br`.`ReviewID` AS `ReviewID`,`b`.`Title` AS `Title`,`br`.`MemberID` AS `MemberID`,`br`.`ReviewText` AS `ReviewText`,`br`.`NumericRating` AS `NumericRating`,`br`.`ReviewDate` AS `ReviewDate` from (`library_database`.`bookreviews` `br` join `library_database`.`books` `b` on((`br`.`ISBN` = `b`.`ISBN`)));

-- -----------------------------------------------------
-- View `library_database`.`detailedcurrentloans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`detailedcurrentloans`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`detailedcurrentloans` AS select `library_database`.`members`.`Name` AS `MemberName`,`library_database`.`books`.`Title` AS `BookTitle`,`library_database`.`loans`.`LoanDate` AS `LoanDate`,`library_database`.`loans`.`DueDate` AS `DueDate` from ((`library_database`.`loans` join `library_database`.`members` on((`library_database`.`loans`.`MemberID` = `library_database`.`members`.`MemberID`))) join `library_database`.`books` on((`library_database`.`loans`.`BookISBN` = `library_database`.`books`.`ISBN`))) where (`library_database`.`loans`.`DueDate` <= curdate());

-- -----------------------------------------------------
-- View `library_database`.`overdueloandetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`overdueloandetails`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`overdueloandetails` AS select `library_database`.`loans`.`LoanID` AS `LoanID`,`library_database`.`members`.`MemberID` AS `MemberID`,`library_database`.`members`.`Name` AS `MemberName`,`library_database`.`books`.`ISBN` AS `ISBN`,`library_database`.`books`.`Title` AS `BookTitle`,`library_database`.`loans`.`LoanDate` AS `LoanDate`,`library_database`.`loans`.`DueDate` AS `DueDate`,`library_database`.`returns`.`ReturnDate` AS `ReturnDate`,`library_database`.`returns`.`LateFees` AS `LateFees` from (((`library_database`.`loans` join `library_database`.`members` on((`library_database`.`loans`.`MemberID` = `library_database`.`members`.`MemberID`))) join `library_database`.`books` on((`library_database`.`loans`.`BookISBN` = `library_database`.`books`.`ISBN`))) left join `library_database`.`returns` on((`library_database`.`loans`.`LoanID` = `library_database`.`returns`.`LoanID`))) where (`library_database`.`returns`.`ReturnDate` > `library_database`.`loans`.`DueDate`);

-- -----------------------------------------------------
-- View `library_database`.`overdueloans`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `library_database`.`overdueloans`;
USE `library_database`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `library_database`.`overdueloans` AS select `library_database`.`members`.`Name` AS `MemberName`,`library_database`.`books`.`Title` AS `BookTitle`,`library_database`.`loans`.`LoanDate` AS `LoanDate`,`library_database`.`loans`.`DueDate` AS `DueDate` from ((`library_database`.`loans` join `library_database`.`members` on((`library_database`.`loans`.`MemberID` = `library_database`.`members`.`MemberID`))) join `library_database`.`books` on((`library_database`.`loans`.`BookISBN` = `library_database`.`books`.`ISBN`))) where (`library_database`.`loans`.`DueDate` < curdate());
USE `library_database`;

DELIMITER $$
USE `library_database`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `library_database`.`activate_reservation`
AFTER UPDATE ON `library_database`.`bookcopies`
FOR EACH ROW
BEGIN
    IF NEW.AvailableCopies = 0 THEN
        -- Logic to activate a reservation
        -- Example: updating the IsActive column for the earliest reservation
        UPDATE Reservations
        SET IsActive = TRUE
        WHERE ISBN = NEW.ISBN
        AND IsActive = FALSE
        ORDER BY ReservationDate ASC
        LIMIT 1;
    END IF;
END$$

USE `library_database`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `library_database`.`AfterLoanInsert`
AFTER INSERT ON `library_database`.`loans`
FOR EACH ROW
BEGIN
    UPDATE Books SET Loaned = 1 WHERE ISBN = NEW.BookISBN;
END$$

USE `library_database`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `library_database`.`PreventLoanDeletion`
BEFORE DELETE ON `library_database`.`loans`
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM Returns WHERE LoanID = OLD.LoanID) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete loan record with active loan.';
    END IF;
END$$

USE `library_database`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `library_database`.`before_loan_insert`
BEFORE INSERT ON `library_database`.`loans`
FOR EACH ROW
BEGIN
    UPDATE BookCopies 
    SET AvailableCopies = AvailableCopies - 1
    WHERE ISBN = NEW.BookISBN AND AvailableCopies > 0;
END$$

USE `library_database`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `library_database`.`CalculateFine`
BEFORE INSERT ON `library_database`.`returns`
FOR EACH ROW
BEGIN
    DECLARE days_overdue INT;
    DECLARE fine_amount DECIMAL(10, 2);
    DECLARE fine_per_day DECIMAL(10, 2);

    -- Retrieve the fine amount per day from LibrarySettings
    SELECT SettingValue INTO fine_per_day FROM LibrarySettings WHERE SettingName = 'FinePerDay';

    -- Calculate the number of days overdue
    SELECT DATEDIFF(NEW.ReturnDate, DueDate) INTO days_overdue FROM Loans WHERE LoanID = NEW.LoanID;

    -- If the book is returned late, calculate the fine
    IF days_overdue > 0 THEN
        SET fine_amount = days_overdue * fine_per_day;
        -- Update the LateFees for the row being inserted
        SET NEW.LateFees = fine_amount;
    ELSE
        SET NEW.LateFees = 0;
    END IF;
END$$

USE `library_database`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `library_database`.`before_return_insert`
BEFORE INSERT ON `library_database`.`returns`
FOR EACH ROW
BEGIN
    UPDATE BookCopies 
    SET AvailableCopies = AvailableCopies + 1
    WHERE ISBN = (SELECT BookISBN FROM Loans WHERE LoanID = NEW.LoanID);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
