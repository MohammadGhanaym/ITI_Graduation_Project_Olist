USE olist_db
CREATE TABLE customer_auth (
    customer_id NVARCHAR(255) PRIMARY KEY,
    password_hash NVARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME,
    reset_token NVARCHAR(255),
    reset_token_expiry DATETIME,
    is_active BIT DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

CREATE INDEX idx_customer_auth_customer_id ON customer_auth(customer_id);