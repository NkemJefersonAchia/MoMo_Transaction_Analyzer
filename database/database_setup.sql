-- database/database_setup.sql
-- MoMo SMS Data Processing System - MySQL Database Setup
-- Week 2 Assignment - Task 2: SQL Implementation
-- Based on our ERD

SET FOREIGN_KEY_CHECKS = 0;  -- Temporarily disable to allow clean creation order
DROP TABLE IF EXISTS transaction_labels;
DROP TABLE IF EXISTS system_logs;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- USERS (senders & receivers)
-- =============================================================================
CREATE TABLE users (
    user_id      INT AUTO_INCREMENT PRIMARY KEY,
    phone_number BIGINT       NOT NULL UNIQUE COMMENT 'Phone number (e.g. 2547xxxxxxxx format as integer)',
    full_name    VARCHAR(120) NOT NULL COMMENT 'Customer full name',
    created_at   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation timestamp',

    INDEX idx_phone (phone_number)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  COMMENT 'MoMo users involved in sending or receiving funds';

-- =============================================================================
-- CATEGORIES (transaction types)
-- =============================================================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(80) NOT NULL UNIQUE COMMENT 'e.g. Airtime Top-up, P2P Transfer, Bill Payment',
    created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_name (name)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  COMMENT 'Classification of mobile money transaction types';

-- =============================================================================
-- TRANSACTIONS (core records)
-- =============================================================================
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    tx_ref         VARCHAR(64)      NOT NULL UNIQUE COMMENT 'MoMo provider reference / message ID',
    sender_id      INT              NOT NULL COMMENT 'FK → users (sender)',
    receiver_id    INT              NOT NULL COMMENT 'FK → users (receiver)',
    category_id    INT              NOT NULL COMMENT 'FK → categories',
    amount         DECIMAL(15,2)    NOT NULL COMMENT 'Transaction value in local currency',
    timestamp      DATETIME         NOT NULL COMMENT 'When the transaction took place',
    description    TEXT             NULL     COMMENT 'Optional SMS content or notes',

    created_at     DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When record was inserted',

    CONSTRAINT fk_tx_sender     FOREIGN KEY (sender_id)   REFERENCES users(user_id)   ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_tx_receiver   FOREIGN KEY (receiver_id) REFERENCES users(user_id)   ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_tx_category   FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT chk_amount_positive CHECK (amount >= 0),

    INDEX idx_timestamp     (timestamp),
    INDEX idx_sender        (sender_id),
    INDEX idx_receiver      (receiver_id),
    INDEX idx_tx_ref        (tx_ref),
    INDEX idx_category_time (category_id, timestamp)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  COMMENT 'Main mobile money transaction records from SMS parsing';

-- =============================================================================
-- LABELS (tags / classifications)
-- =============================================================================
CREATE TABLE labels (
    label_id    INT AUTO_INCREMENT PRIMARY KEY,
    label_name  VARCHAR(80) NOT NULL UNIQUE COMMENT 'e.g. Fraud Risk, High Value, Reversal, Normal',
    created_at  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  COMMENT 'Tags/labels that can be applied to transactions';

-- =============================================================================
-- TRANSACTION_LABELS (many-to-many junction)
-- =============================================================================
CREATE TABLE transaction_labels (
    transaction_id INT      NOT NULL,
    label_id       INT      NOT NULL,
    assigned_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (transaction_id, label_id),

    CONSTRAINT fk_txl_tx     FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_txl_label  FOREIGN KEY (label_id)      REFERENCES labels(label_id)      ON DELETE CASCADE ON UPDATE CASCADE,

    INDEX idx_label (label_id)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  COMMENT 'Many-to-many assignment of labels to transactions';

-- =============================================================================
-- SYSTEM_LOGS (processing / audit trail)
-- =============================================================================
CREATE TABLE system_logs (
    log_id         INT AUTO_INCREMENT PRIMARY KEY,
    tx_ref         VARCHAR(64) NULL COMMENT 'References transactions.tx_ref (may be NULL if parse failed)',
    transaction_id INT      NULL COMMENT 'FK to transactions if successfully linked',
    log_level      ENUM('INFO', 'WARNING', 'ERROR', 'DEBUG') NOT NULL DEFAULT 'INFO',
    message        TEXT     NOT NULL,
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_log_tx FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id) ON DELETE SET NULL ON UPDATE CASCADE,

    INDEX idx_log_tx_ref    (tx_ref),
    INDEX idx_log_created   (created_at),
    INDEX idx_log_level     (log_level)
) ENGINE=InnoDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
  COMMENT 'System logs for SMS parsing, errors and processing audit';

-- =============================================================================
-- SAMPLE DATA (≥5 records per main table)
-- =============================================================================

-- Users (7 records)
INSERT INTO users (phone_number, full_name) VALUES
(254712345678, 'Amina Wanjiku'),
(254723456789, 'Brian Ochieng'),
(254734567890, 'Fatuma Hassan'),
(254745678901, 'David Mwangi'),
(254756789012, 'Esther Njeri'),
(254767890123, 'George Kamau'),
(254778901234, 'Halima Said');

-- Categories (6 records)
INSERT INTO categories (name) VALUES
('Airtime Purchase'),
('P2P Transfer'),
('Utility Bill Payment'),
('Merchant POS Payment'),
('International Remittance'),
('Cash Out / Withdrawal');

-- Labels (6 records)
INSERT INTO labels (label_name) VALUES
('Normal'),
('High Value'),
('Potential Fraud'),
('Promo Transaction'),
('Reversal Requested'),
('Family Support');

-- Transactions (7 records)
INSERT INTO transactions (tx_ref, sender_id, receiver_id, category_id, amount, timestamp, description) VALUES
('MOMO20260124001', 1, 2, 2, 2500.00,  '2026-01-24 09:15:22', 'Sent to friend'),
('MOMO20260124002', 3, 1, 1, 100.00,   '2026-01-24 10:40:11', 'Airtime top up'),
('MOMO20260123003', 4, 5, 3, 6850.50,  '2026-01-23 17:22:45', 'Electricity bill'),
('MOMO20260124004', 2, 6, 4, 18000.00, '2026-01-24 13:05:59', 'Shop payment'),
('MOMO20260125005', 5, 3, 2, 4500.75,  '2026-01-25 08:17:33', 'Support transfer'),
('MOMO20260122006', 1, 7, 5, 32000.00, '2026-01-22 14:50:10', 'Remittance received'),
('MOMO20260125007', 6, 4, 6, 2000.00,  '2026-01-25 11:30:00', 'Agent cash out');

-- Transaction Labels (some examples)
INSERT INTO transaction_labels (transaction_id, label_id) VALUES
(1, 1), (1, 2),
(3, 1), (3, 3),
(4, 1), (4, 2),
(5, 1), (5, 6),
(6, 4),
(7, 1);

-- System Logs (6 records)
INSERT INTO system_logs (tx_ref, transaction_id, log_level, message) VALUES
('MOMO20260124001', 1, 'INFO',    'Transaction parsed and inserted'),
('XYZ-invalid-01',  NULL, 'ERROR', 'Malformed phone number in SMS'),
('MOMO20260124002', 2, 'INFO',    'Airtime transaction recorded'),
('MOMO20260124008', NULL, 'WARNING','Duplicate reference detected'),
('MOMO20260123003', 3, 'INFO',    'Bill payment processed'),
('MOMO20260125005', 5, 'INFO',    'Transfer completed successfully');

-- End of script
