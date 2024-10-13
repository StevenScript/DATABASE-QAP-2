# QAP 2 - University Enrollment & Store Inventory Systems

**Author:** Steven Norris  
**Date:** 10-12-2024 -> 10-13-2024  

This README serves as a both documentation and a study guide for two SQL projects that involve creating and managing databases using pgAdmin4. These projects involve table creation, inserting and retrieving data, updating records, and deleting entries. 
---

## Project 1: University Enrollment System

### Overview:
In this project, we built a database system that simulates university enrollment. We’ll be working with students, professors, courses, and enrollments. The project involves creating four tables and inserting sample data, which can then be queried and updated.

### Key SQL Concepts:
#### `IF NOT EXISTS`
- **Purpose:** Used to ensure that the table is only created if it doesn’t already exist. This prevents errors when trying to create a table that already exists in the database.
- **Example:**
  ```sql
  CREATE TABLE IF NOT EXISTS students (
      id SERIAL PRIMARY KEY,
      first_name VARCHAR(50) NOT NULL,
      last_name VARCHAR(50) NOT NULL,
      email VARCHAR(100) UNIQUE NOT NULL,
      enrollment_date DATE NOT NULL
  );
  ```
- **Usage:** Here, we ensure the `students` table is created only if it doesn’t already exist. This is especially useful when running scripts multiple times(Like after a crash during mid-usage)

#### `NOT NULL`
- **Purpose:** Ensures that a column cannot contain a `NULL` value, meaning that a value must always be provided for this field when inserting data.
- **Example:**
  ```sql
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL
  ```
- **Usage:** The `first_name` and `last_name` columns cannot be left blank. Every student must have a first and last name.

#### `UNIQUE`
- **Purpose:** Ensures that all values in a column are unique across the table, meaning no two rows can have the same value for this column.
- **Example:**
  ```sql
  email VARCHAR(100) UNIQUE NOT NULL
  ```
- **Usage:** Each student must have a unique email address. Two students cannot share the same email in this table.

#### `ON DELETE CASCADE`
- **Purpose:** Automatically deletes records from a related table when a record in the primary table is deleted.
- **Example:**
  ```sql
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
  ```
- **Usage:** If a student is deleted from the `students` table, all their related enrollments in the `enrollments` table are automatically deleted to maintain referential integrity.
- 
- **NOTE** This potentially carries risk if not used correctly:

- Unitended data loss(deleting a customer may delete all orders, which may not be intended)
- Complex Dependencies (e.g., multiple cascading paths) deleting a single row can trigger deletions across many tables. This complexity may make it difficult to predict.
- Difficulty in Debugging, making it challenging to understand why certain records were deleted because the actual operation triggering the deletion may be far removed from the related data

- **Advice on usage **
- Use with care and only when necessary
- Foreign Key Constraints with ON DELETE SET NULL( set the foreign key column to NULL. This preserves the child data while removing the link to the parent.) or ON DELETE RESTRICT ( Prevent deletion of the parent row if related child rows exist. This makes it explicit that the relationship must be manually severed before deletion)
- Soft Delete, add a flag to signify "deletion"; this perserves records for auditing or reference.
- Database Backups

---

### University Enrollment Table Structure:
1. **Students Table:**
   - Columns: `id`, `first_name`, `last_name`, `email`, `enrollment_date`
   - Example:
     ```sql
     CREATE TABLE IF NOT EXISTS students (
         id SERIAL PRIMARY KEY,
         first_name VARCHAR(50) NOT NULL,
         last_name VARCHAR(50) NOT NULL,
         email VARCHAR(100) UNIQUE NOT NULL,
         enrollment_date DATE NOT NULL
     );
     ```

2. **Professors Table:**
   - Columns: `id`, `first_name`, `last_name`, `department`

3. **Courses Table:**
   - Columns: `id`, `course_name`, `course_description`, `professor_id`
   - Relationships: Linked to `professors` through `professor_id` with a `FOREIGN KEY`

4. **Enrollments Table:**
   - Columns: `student_id`, `course_id`, `enrollment_date`
   - Relationships: Linked to `students` and `courses` through `FOREIGN KEYS`

### Key Queries:
- Retrieve students enrolled in "Chemistry 101":
  ```sql
  SELECT s.first_name || ' ' || s.last_name AS full_name
  FROM students s
  JOIN enrollments e ON s.id = e.student_id
  JOIN courses c ON e.course_id = c.id
  WHERE c.course_name = 'Chemistry 101';
  ```

- Retrieve courses along with their respective professors:
  ```sql
  SELECT c.course_name, p.first_name || ' ' || p.last_name AS professor_full_name
  FROM courses c
  JOIN professors p ON c.professor_id = p.id;
  ```

### Data Modification:
- **Updating a Student's Email:**
  ```sql
  UPDATE students
  SET email = 'new.email@domain.com'
  WHERE id = 2;
  ```

- **Deleting an Enrollment Record:**
  ```sql
  DELETE FROM enrollments
  WHERE student_id = 1 AND course_id = 2;
  ```

---

## Project 2: Store Inventory and Orders System

### Overview:
This project involves building a system that tracks products, customers, orders, and order items. Learned how to manage an inventory, place orders, and link customers with their purchases.

### Key SQL Concepts (Review):
#### `ON DELETE CASCADE`
- **Purpose:** Ensures that when a parent record is deleted, all related child records are also deleted automatically.
- **Example:**
  ```sql
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
  ```
- **Usage:** When a customer is deleted, all of their associated orders are also deleted. This prevents orphaned records in the `orders` table.

### Store Inventory Table Structure:
1. **Products Table:**
   - Columns: `id`, `product_name`, `price`, `stock_quantity`
   - Example:
     ```sql
     CREATE TABLE IF NOT EXISTS products (
         id SERIAL PRIMARY KEY,
         product_name VARCHAR(100) NOT NULL,
         price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
         stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
     );
     ```

2. **Customers Table:**
   - Columns: `id`, `first_name`, `last_name`, `email`
   - Unique constraint on `email` to ensure no two customers can share the same email address.

3. **Orders Table:**
   - Columns: `id`, `customer_id`, `order_date`
   - Linked to `customers` via `customer_id`

4. **Order Items Table:**
   - Columns: `order_id`, `product_id`, `quantity`
   - Linked to both `orders` and `products` to manage which products are in each order.

### Key Queries:
- Retrieve product names and stock quantities:
  ```sql
  SELECT product_name, stock_quantity
  FROM products;
  ```

- Retrieve product details for a specific order:
  ```sql
  SELECT p.product_name, oi.quantity
  FROM order_items oi
  JOIN products p ON oi.product_id = p.id
  WHERE oi.order_id = 1;
  ```

### Data Modification:
- **Updating Stock Quantities:**
  After an order, we need to reduce the stock of each product ordered.
  ```sql
  UPDATE products
  SET stock_quantity = stock_quantity - 2
  WHERE id = 1;
  ```

- **Deleting an Order and its Items:**
  ```sql
  DELETE FROM order_items WHERE order_id = 3;
  DELETE FROM orders WHERE id = 3;
  ```

---

### Key Concepts
- **Understand Relationships:** Foreign keys are vital for maintaining relationships between tables. Take note of how `FOREIGN KEYS` help relate students to courses and products to orders.
- **Use `IF NOT EXISTS`:** This is useful for ensuring that tables or other database objects aren’t recreated if they already exist.
- **Practice with `NOT NULL` and `UNIQUE`:** These constraints ensure data integrity and prevent missing or duplicate data.
- **Explore `ON DELETE CASCADE`:** This helps manage related data cleanly by cascading deletions.
