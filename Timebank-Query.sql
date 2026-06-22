@ -0,0 +1,85 @@
-- Initialize Extensions for Security
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS PROFILE TABLE
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    location TEXT, -- e.g., "Porsgrunn, Norway"
    skills TEXT[], -- Array of strings for tag sorting
    fiat_balance NUMERIC(10, 2) DEFAULT 0.00,
    time_credit_balance NUMERIC(6, 2) DEFAULT 0.00 CHECK (time_credit_balance >= -10.00 AND time_credit_balance <= 100.00), 
    -- ^ The Anti-Abuse Cap: Members cannot exploit more than 10 hours of negative credit without contributing back!
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 2. FIAT COMMERCIAL ESCROW MARKETPLACE (95/5% System)
CREATE TABLE fiat_contracts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    client_id UUID REFERENCES profiles(id) NOT NULL,
    worker_id UUID REFERENCES profiles(id) NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    gross_amount NUMERIC(10, 2) NOT NULL CHECK (gross_amount > 0),
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'escrowed', 'completed', 'disputed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Automated Function to split the 95/5 fee upon completion
CREATE OR REPLACE FUNCTION complete_fiat_contract(contract_id UUID)
RETURNS VOID AS $$
DECLARE
    v_worker_id UUID;
    v_gross NUMERIC(10,2);
    v_worker_share NUMERIC(10,2);
    v_solidarity_share NUMERIC(10,2);
BEGIN
    SELECT worker_id, gross_amount INTO v_worker_id, v_gross FROM fiat_contracts WHERE id = contract_id AND status = 'escrowed';
    
    v_worker_share := v_gross * 0.95;       -- 95% straight to the worker's pocket
    v_solidarity_share := v_gross * 0.05;   -- 5% straight to our Non-Custodial Solidarity Fund
    
    -- Update worker's wallet
    UPDATE profiles SET fiat_balance = fiat_balance + v_worker_share WHERE id = v_worker_id;
    -- Note: System Solidarity Wallet logic will collect the 5% buffer here.

    UPDATE fiat_contracts SET status = 'completed' WHERE id = contract_id;
END;
$$ LANGUAGE plpgsql;

-- 3. THE TIMEBANK LEDGER (Zero-Cash Double-Entry System)
CREATE TABLE timebank_ledger (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    sender_id UUID REFERENCES profiles(id) NOT NULL,    -- The person paying with hours (e.g., getting a logo)
    receiver_id UUID REFERENCES profiles(id) NOT NULL,  -- The person performing labor (e.g., coding)
    hours_contributed NUMERIC(4, 2) NOT NULL CHECK (hours_contributed > 0),
    task_description TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Automated Function to process double-entry transaction safely
CREATE OR REPLACE FUNCTION process_timebank_transaction()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if sender will drop below the negative abuse cap
    IF (SELECT time_credit_balance - NEW.hours_contributed FROM profiles WHERE id = NEW.sender_id) < -10.00 THEN
        RAISE EXCEPTION 'Transaction denied: Sender has exceeded the maximum negative labor limit (-10 hours).';
    END IF;

    -- Debit the sender (Time spent)
    UPDATE profiles 
    SET time_credit_balance = time_credit_balance - NEW.hours_contributed 
    WHERE id = NEW.sender_id;

    -- Credit the receiver (Time earned)
    UPDATE profiles 
    SET time_credit_balance = time_credit_balance + NEW.hours_contributed 
    WHERE id = NEW.receiver_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_timebank_transaction
BEFORE INSERT ON timebank_ledger
FOR EACH ROW EXECUTE FUNCTION process_timebank_transaction();