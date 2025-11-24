-- Fix teacher passwords with correct SHA-256 hash
-- Password: teacher123
-- Correct Hash: cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416

USE ptit_learning;

UPDATE users 
SET password_hash = 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416' 
WHERE email LIKE 'teacher%@ptit.edu.vn';

-- Verify the update
SELECT email, password_hash, fullname 
FROM users 
WHERE email LIKE 'teacher%@ptit.edu.vn';
