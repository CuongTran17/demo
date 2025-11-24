-- Add order_note column to orders table for VietQR payment reference
USE ptit_learning;

ALTER TABLE orders 
ADD COLUMN order_note VARCHAR(255) DEFAULT NULL AFTER status;

-- Show updated table structure
DESCRIBE orders;
