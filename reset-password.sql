-- Reset password for test@ptit.edu.vn back to 123456
USE ptit_learning;

UPDATE users 
SET password_hash = '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92' 
WHERE email = 'test@ptit.edu.vn';

-- Verify the update
SELECT email, password_hash, fullname 
FROM users 
WHERE email = 'test@ptit.edu.vn';
