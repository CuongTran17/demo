-- Update thumbnail paths for all 36 courses to match actual image files
SET NAMES utf8mb4;
USE ptit_learning;

-- ============================================
-- PYTHON COURSES (6 courses)
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/courses-python/python-procedural.png' WHERE course_id = 'python-procedural';
UPDATE courses SET thumbnail = 'assets/img/courses-python/python-basics.png' WHERE course_id = 'python-basics';
UPDATE courses SET thumbnail = 'assets/img/courses-python/python-complete.png' WHERE course_id = 'python-complete';
UPDATE courses SET thumbnail = 'assets/img/courses-python/python-excel.png' WHERE course_id = 'python-excel';
UPDATE courses SET thumbnail = 'assets/img/courses-python/selenium-python.png' WHERE course_id = 'selenium-python';
UPDATE courses SET thumbnail = 'assets/img/courses-python/python-oop.png' WHERE course_id = 'python-oop';

-- ============================================
-- FINANCE COURSES (6 courses)
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/courses-finance/finance-basic.png' WHERE course_id = 'finance-basic';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/investment.png' WHERE course_id = 'investment';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/banking.png' WHERE course_id = 'banking';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/personal-finance.png' WHERE course_id = 'personal-finance';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Forex.png' WHERE course_id = 'forex';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/financial-analysis.png' WHERE course_id = 'financial-analysis';

-- ============================================
-- DATA ANALYST COURSES (6 courses)
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/courses-data/data-basic.png' WHERE course_id = 'data-basic';
UPDATE courses SET thumbnail = 'assets/img/courses-data/excel-data.png' WHERE course_id = 'excel-data';
UPDATE courses SET thumbnail = 'assets/img/courses-data/sql-data.png' WHERE course_id = 'sql-data';
UPDATE courses SET thumbnail = 'assets/img/courses-data/power-bi.png' WHERE course_id = 'power-bi';
UPDATE courses SET thumbnail = 'assets/img/courses-data/python-data.png' WHERE course_id = 'python-data';
UPDATE courses SET thumbnail = 'assets/img/courses-data/Tableau.png' WHERE course_id = 'tableau';

-- ============================================
-- BLOCKCHAIN COURSES (6 courses)
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/blockchain-basic.png' WHERE course_id = 'blockchain-basic';
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/smart-contract.png' WHERE course_id = 'smart-contract';
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/DeFi.png' WHERE course_id = 'defi';
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/NFT.png' WHERE course_id = 'nft';
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/Web3.png' WHERE course_id = 'web3';
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/crypto-trading.png' WHERE course_id = 'crypto-trading';

-- ============================================
-- ACCOUNTING COURSES (6 courses)
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/accounting-basic.png' WHERE course_id = 'accounting-basic';
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/accounting-misa.png' WHERE course_id = 'accounting-misa';
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/tax-accounting.png' WHERE course_id = 'tax-accounting';
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/cost-accounting.png' WHERE course_id = 'cost-accounting';
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/excel-accounting.png' WHERE course_id = 'excel-accounting';
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/financial-statements.png' WHERE course_id = 'financial-statements';

-- ============================================
-- MARKETING COURSES (6 courses)
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/digital-marketing.png' WHERE course_id = 'digital-marketing';
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/facebook-ads.png' WHERE course_id = 'facebook-ads';
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/google-ads.png' WHERE course_id = 'google-ads';
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/content-marketing.png' WHERE course_id = 'content-marketing';
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/social-media.png' WHERE course_id = 'social-media';
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/email-marketing.png' WHERE course_id = 'email-marketing';

-- Verification
SELECT 'Thumbnails updated successfully!' as message;
SELECT category, COUNT(*) as course_count FROM courses GROUP BY category;
SELECT course_id, course_name, thumbnail FROM courses ORDER BY category, course_id;
