-- 03-physical-schema.sql
-- Owner role: Backend Lead
-- Status: Ready v1.0
-- Last updated: 2026-03-30
-- Related docs: ./02-logical-schema.md, ./04-migrations-plan.md, ../testing/03-feature-to-test-matrix.md
-- Target: PostgreSQL 15+

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================
-- Common helper: updated_at trigger
-- =====================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================
-- Core tables
-- =====================================
CREATE TABLE tenant (
  tenant_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(64) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'active' CHECK (status IN ('active','suspended','archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL
);

CREATE TABLE workspace (
  workspace_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tenant_id UUID NOT NULL REFERENCES tenant(tenant_id) ON DELETE RESTRICT,
  code VARCHAR(64) NOT NULL,
  name VARCHAR(255) NOT NULL,
  timezone VARCHAR(64) NOT NULL DEFAULT 'UTC',
  status VARCHAR(32) NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive','archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL,
  UNIQUE (tenant_id, code)
);

CREATE TABLE "user" (
  user_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  email VARCHAR(255) NOT NULL,
  display_name VARCHAR(255) NOT NULL,
  password_hash TEXT NOT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'active' CHECK (status IN ('active','locked','disabled')),
  last_login_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL,
  UNIQUE (workspace_id, email)
);

CREATE TABLE role_policy (
  role_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE CASCADE,
  role_name VARCHAR(64) NOT NULL,
  permissions_json JSONB NOT NULL DEFAULT '{}'::jsonb,
  status VARCHAR(32) NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (workspace_id, role_name)
);

CREATE TABLE zalo_account (
  account_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  owner_user_id UUID NULL REFERENCES "user"(user_id) ON DELETE SET NULL,
  external_uid VARCHAR(128) NULL,
  display_name VARCHAR(255) NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'active' CHECK (status IN ('active','paused','blocked','archived')),
  health_state VARCHAR(32) NOT NULL DEFAULT 'unknown' CHECK (health_state IN ('unknown','healthy','warning','blocked')),
  consent_flags JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL,
  UNIQUE (workspace_id, external_uid)
);

CREATE TABLE proxy_profile (
  proxy_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  proxy_host VARCHAR(255) NOT NULL,
  proxy_port INTEGER NOT NULL CHECK (proxy_port BETWEEN 1 AND 65535),
  proxy_user VARCHAR(255) NULL,
  proxy_secret_ref VARCHAR(255) NULL,
  quality_score NUMERIC(5,2) NOT NULL DEFAULT 0,
  status VARCHAR(32) NOT NULL DEFAULT 'active' CHECK (status IN ('active','quarantined','disabled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL,
  UNIQUE (workspace_id, proxy_host, proxy_port, COALESCE(proxy_user,''))
);

CREATE TABLE browser_profile (
  profile_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  account_id UUID NOT NULL UNIQUE REFERENCES zalo_account(account_id) ON DELETE CASCADE,
  agent_profile_ref VARCHAR(128) NOT NULL,
  proxy_id UUID NULL REFERENCES proxy_profile(proxy_id) ON DELETE SET NULL,
  profile_state VARCHAR(32) NOT NULL DEFAULT 'stopped' CHECK (profile_state IN ('starting','running','stopped','error')),
  last_seen_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE customer (
  customer_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  external_uid VARCHAR(128) NULL,
  phone VARCHAR(32) NULL,
  display_name VARCHAR(255) NULL,
  tags_json JSONB NOT NULL DEFAULT '[]'::jsonb,
  owner_user_id UUID NULL REFERENCES "user"(user_id) ON DELETE SET NULL,
  consent_status VARCHAR(32) NOT NULL DEFAULT 'unknown' CHECK (consent_status IN ('unknown','granted','revoked')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL,
  UNIQUE (workspace_id, external_uid),
  UNIQUE (workspace_id, phone)
);

CREATE TABLE conversation (
  conversation_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  account_id UUID NOT NULL REFERENCES zalo_account(account_id) ON DELETE RESTRICT,
  customer_id UUID NOT NULL REFERENCES customer(customer_id) ON DELETE RESTRICT,
  channel_type VARCHAR(32) NOT NULL DEFAULT 'zalo' CHECK (channel_type IN ('zalo','oa','zns')),
  state VARCHAR(32) NOT NULL DEFAULT 'open' CHECK (state IN ('open','pending','resolved','closed')),
  last_message_at TIMESTAMPTZ NULL,
  assignee_user_id UUID NULL REFERENCES "user"(user_id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (workspace_id, account_id, customer_id, channel_type)
);

CREATE TABLE message (
  message_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id UUID NOT NULL REFERENCES conversation(conversation_id) ON DELETE CASCADE,
  account_id UUID NOT NULL REFERENCES zalo_account(account_id) ON DELETE RESTRICT,
  direction VARCHAR(16) NOT NULL CHECK (direction IN ('inbound','outbound')),
  sender_ref VARCHAR(128) NULL,
  content_text TEXT NULL,
  status VARCHAR(32) NOT NULL DEFAULT 'queued' CHECK (status IN ('draft','queued','sending','sent','delivered','read','failed')),
  agent_request_id VARCHAR(128) NULL,
  agent_job_id BIGINT NULL,
  sent_at TIMESTAMPTZ NULL,
  delivered_at TIMESTAMPTZ NULL,
  read_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE campaign (
  campaign_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  campaign_code VARCHAR(64) NULL,
  created_by UUID NULL REFERENCES "user"(user_id) ON DELETE SET NULL,
  name VARCHAR(255) NOT NULL,
  objective VARCHAR(64) NOT NULL DEFAULT 'broadcast',
  segment_query JSONB NOT NULL DEFAULT '{}'::jsonb,
  schedule_at TIMESTAMPTZ NULL,
  state VARCHAR(32) NOT NULL DEFAULT 'draft' CHECK (state IN ('draft','scheduled','running','paused','completed','failed','cancelled')),
  throttle_per_min INTEGER NOT NULL DEFAULT 30,
  template_ref VARCHAR(255) NULL,
  started_at TIMESTAMPTZ NULL,
  ended_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at TIMESTAMPTZ NULL,
  UNIQUE (workspace_id, campaign_code)
);

CREATE TABLE delivery_attempt (
  attempt_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  campaign_id UUID NOT NULL REFERENCES campaign(campaign_id) ON DELETE CASCADE,
  recipient_id VARCHAR(128) NOT NULL,
  step_no INTEGER NOT NULL DEFAULT 1,
  idempotency_key VARCHAR(255) NOT NULL,
  state VARCHAR(32) NOT NULL DEFAULT 'queued' CHECK (state IN ('queued','running','sent','delivered','read','failed','cancelled')),
  error_type VARCHAR(64) NULL,
  error_message TEXT NULL,
  agent_request_id VARCHAR(128) NULL,
  agent_job_id BIGINT NULL,
  retry_count INTEGER NOT NULL DEFAULT 0,
  last_attempt_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (campaign_id, recipient_id, step_no),
  UNIQUE (idempotency_key)
);

CREATE TABLE job_run (
  job_id BIGSERIAL PRIMARY KEY,
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  job_type VARCHAR(64) NOT NULL,
  source_ref VARCHAR(255) NULL,
  state VARCHAR(32) NOT NULL CHECK (state IN ('queued','running','completed','failed','cancelled')),
  request_id VARCHAR(128) NOT NULL,
  correlation_id VARCHAR(128) NULL,
  payload_hash VARCHAR(128) NULL,
  result_json JSONB NULL,
  error_json JSONB NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (request_id)
);

CREATE TABLE callback_event (
  event_id UUID PRIMARY KEY,
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  event_type VARCHAR(64) NOT NULL,
  source VARCHAR(64) NOT NULL,
  trace_id VARCHAR(128) NULL,
  agent_job_id BIGINT NULL,
  status VARCHAR(32) NOT NULL CHECK (status IN ('received','verified','processed','rejected','dead_letter','archived')),
  signature_valid BOOLEAN NOT NULL DEFAULT FALSE,
  raw_payload_json JSONB NOT NULL,
  received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE audit_log (
  audit_id BIGSERIAL PRIMARY KEY,
  workspace_id UUID NOT NULL REFERENCES workspace(workspace_id) ON DELETE RESTRICT,
  actor_id UUID NULL REFERENCES "user"(user_id) ON DELETE SET NULL,
  action VARCHAR(128) NOT NULL,
  target_type VARCHAR(128) NULL,
  target_id VARCHAR(128) NULL,
  request_id VARCHAR(128) NULL,
  correlation_id VARCHAR(128) NULL,
  ip_address VARCHAR(64) NULL,
  user_agent TEXT NULL,
  result VARCHAR(16) NOT NULL CHECK (result IN ('success','failure')),
  metadata_json JSONB NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================
-- Indexes
-- =====================================
CREATE INDEX idx_workspace_tenant ON workspace(tenant_id);
CREATE INDEX idx_user_workspace ON "user"(workspace_id);
CREATE INDEX idx_account_workspace ON zalo_account(workspace_id);
CREATE INDEX idx_customer_workspace ON customer(workspace_id);
CREATE INDEX idx_conversation_scope ON conversation(workspace_id, account_id, customer_id);
CREATE INDEX idx_message_conversation_created ON message(conversation_id, created_at DESC);
CREATE INDEX idx_campaign_workspace_state ON campaign(workspace_id, state);
CREATE INDEX idx_attempt_campaign_state ON delivery_attempt(campaign_id, state);
CREATE INDEX idx_job_state_updated ON job_run(state, updated_at DESC);
CREATE INDEX idx_callback_status_received ON callback_event(status, received_at DESC);
CREATE INDEX idx_audit_workspace_created ON audit_log(workspace_id, created_at DESC);
CREATE INDEX idx_audit_request ON audit_log(request_id);

-- =====================================
-- Triggers
-- =====================================
CREATE TRIGGER trg_tenant_updated_at BEFORE UPDATE ON tenant FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_workspace_updated_at BEFORE UPDATE ON workspace FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_user_updated_at BEFORE UPDATE ON "user" FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_role_updated_at BEFORE UPDATE ON role_policy FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_account_updated_at BEFORE UPDATE ON zalo_account FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_proxy_updated_at BEFORE UPDATE ON proxy_profile FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_profile_updated_at BEFORE UPDATE ON browser_profile FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_customer_updated_at BEFORE UPDATE ON customer FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_conversation_updated_at BEFORE UPDATE ON conversation FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_message_updated_at BEFORE UPDATE ON message FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_campaign_updated_at BEFORE UPDATE ON campaign FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_attempt_updated_at BEFORE UPDATE ON delivery_attempt FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER trg_job_updated_at BEFORE UPDATE ON job_run FOR EACH ROW EXECUTE FUNCTION set_updated_at();
