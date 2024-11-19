-- Ensure the database exists
CREATE DATABASE IF NOT EXISTS health_and_fitness_tracker
  /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE health_and_fitness_tracker;

-- Drop tables to avoid conflicts
DROP TABLE IF EXISTS `activity`;
DROP TABLE IF EXISTS `goal`;
DROP TABLE IF EXISTS `nutrition`;
DROP TABLE IF EXISTS `user`;

-- Table structure for table `user`
CREATE TABLE `user` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `Age` int DEFAULT NULL,
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Height` decimal(5,2) DEFAULT NULL,
  `Weight` decimal(5,2) DEFAULT NULL,
  `Email` varchar(100) NOT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  CONSTRAINT `user_chk_1` CHECK ((`Age` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `activity`
CREATE TABLE `activity` (
  `ActivityID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `Type` varchar(50) NOT NULL,
  `duration` int NOT NULL,
  `distance` decimal(5,2) DEFAULT NULL,
  `Caloriesburned` int NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`ActivityID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `activity_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `goal`
CREATE TABLE `goal` (
  `GoalID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `GoalType` enum('Weight Loss','Muscle Gain','Endurance','Flexibility') NOT NULL,
  `TargetValue` decimal(5,2) DEFAULT NULL,
  `Progress` decimal(5,2) DEFAULT NULL,
  `Deadline` date NOT NULL,
  PRIMARY KEY (`GoalID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `goal_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Table structure for table `nutrition`
CREATE TABLE `nutrition` (
  `NutritionID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `MealType` enum('Breakfast','Lunch','Dinner','Snack') NOT NULL,
  `FoodItem` varchar(100) NOT NULL,
  `Quantity` decimal(5,2) DEFAULT NULL,
  `Calories` int NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`NutritionID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `nutrition_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert data into `user`
INSERT INTO `user` VALUES 
(1,'Alice Mwangi',28,'Female',165.00,60.00,'alicemwangi@gmail.com'),
(2,'Evans Okumu',35,'Male',180.00,85.00,'evans@gmail.com'),
(3,'Purity Muthoni',22,'Male',170.00,75.00,'purity@gmail.com'),
(4,'Alfred Mutisya',30,'Male',170.00,76.00,'mutisya@gamil.com'),
(5,'Beatrice Wambua',31,'Female',163.00,65.00,'beatricewambua@gmail.com');

-- Insert data into `activity`
INSERT INTO `activity` VALUES 
(1,1,'Running',30,5.00,300,'2024-10-01'),
(2,1,'Cycling',45,15.00,450,'2024-10-02'),
(3,2,'Swimming',60,2.00,400,'2024-10-01'),
(4,3,'Weightlifting',40,NULL,350,'2024-10-03'),
(5,4,'Yoga',50,NULL,200,'2024-10-04'),
(6,5,'Hiking',120,10.00,600,'2024-10-05'),
(7,2,'Running',25,4.00,250,'2024-10-06'),
(8,3,'Cycling',30,12.00,300,'2024-10-07'),
(9,5,'Pilates',45,NULL,220,'2024-10-08'),
(10,4,'Boxing',50,NULL,400,'2024-10-09');

-- Insert data into `goal`
INSERT INTO `goal` VALUES 
(25,1,'Weight Loss',55.00,60.00,'2024-12-31'),
(26,1,'Endurance',300.00,250.00,'2024-10-31'),
(27,2,'Muscle Gain',90.00,85.00,'2025-01-15'),
(28,3,'Endurance',150.00,120.00,'2024-11-15'),
(29,4,'Weight Loss',70.00,76.00,'2025-02-01'),
(30,5,'Flexibility',100.00,80.00,'2025-03-01');

-- Insert data into `nutrition`
INSERT INTO `nutrition` VALUES 
(11,1,'Breakfast','Oatmeal',100.00,150,'2024-10-01'),
(12,1,'Lunch','Grilled Chicken Salad',250.00,350,'2024-10-01'),
(13,1,'Dinner','Steak and Vegetables',300.00,600,'2024-10-01'),
(14,2,'Breakfast','Pancakes',150.00,400,'2024-10-01'),
(15,2,'Lunch','Smocha',200.00,300,'2024-10-01'),
(16,3,'Snack','Protein bar',50.00,200,'2024-10-03'),
(17,4,'Dinner','Ugali Mayai',250.00,350,'2024-10-04'),
(18,5,'Breakfast','Smoothie',300.00,250,'2024-10-05'),
(19,5,'Lunch','Mashed potatoes and fried chicken',200.00,400,'2024-10-05'),
(20,3,'Dinner','Fruit salad',150.00,100,'2024-10-07');

-- CRUD Operations
-- 1. Create: Add a new user
INSERT INTO `user` (`name`, `Age`, `Gender`, `Height`, `Weight`, `Email`) 
VALUES ('John Hagee', 29, 'Male', 175.00, 70.00, 'johnhagee@gmail.com');

-- 2. Read: Get all activities of a specific user
SELECT * FROM `activity` WHERE `UserID` = 1;

-- 3. Update: Update a user's email
UPDATE `user` SET `Email` = 'mwangialice23@gmail.com' WHERE `UserID` = 1;

-- 4. Delete: Remove an activity
DELETE FROM `activity` WHERE `ActivityID` = 1;

-- 5. Additional Queries
-- Get all users who have Weight Loss goals
SELECT `user`.* 
FROM `user`
INNER JOIN `goal` ON `user`.`UserID` = `goal`.`UserID`
WHERE `goal`.`GoalType` = 'Weight Loss';

-- Calculate total calories burned by a specific user
SELECT SUM(`Caloriesburned`) AS TotalCaloriesBurned
FROM `activity`
WHERE `UserID` = 1;


-- Advanced Query: Users consuming more calories than burning
WITH CaloriesConsumed AS (
  SELECT UserID, SUM(Calories) AS TotalIntake FROM nutrition GROUP BY UserID
),
CaloriesBurned AS (
  SELECT UserID, SUM(Caloriesburned) AS TotalBurned FROM activity GROUP BY UserID
)
SELECT 
  c.UserID, 
  c.TotalIntake, 
  b.TotalBurned 
FROM CaloriesConsumed c
LEFT JOIN CaloriesBurned b ON c.UserID = b.UserID
WHERE c.TotalIntake > b.TotalBurned;


